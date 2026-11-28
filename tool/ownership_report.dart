// Generates an HTML page that says who owns each file of the repository and what
// each file is for.
//
//   dart run tool/ownership_report.dart                  # → build/ownership_report.html
//   dart run tool/ownership_report.dart lib/features     # only some paths
//   dart run tool/ownership_report.dart --out docs/ownership.html
//   dart run tool/ownership_report.dart lib/features/alerts --out build/alerts.json
//
// An --out file ending in `.json` gets the same data as JSON (people, folders and
// files with their description, role, owner and shares), for scripts and agents:
// the `explain-code` skill reads it.
//
// Ownership is measured at HEAD from git:
// * lines: `git blame -w -M` gives the current lines each person wrote last
//   (whitespace-only changes and moved lines keep their original author);
// * commits: `git log --no-merges` gives the commits each person made to the file.
// Score = 70 % share of lines + 30 % share of commits. The highest score owns the
// file; under 50 % the file is marked as shared. Identities are merged by `.mailmap`.
//
// The description comes from the file itself: the doc comment of the main Dart
// declaration, the header comment of SQL files and scripts, the first paragraph of
// Markdown. A file without one falls back to the subject of the commit that added it.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

const _usage = '''
Generates an HTML page with the owner and a short description of every file.

Usage: dart run tool/ownership_report.dart [options] [paths...]

  paths            Only report these files or folders (git pathspecs).
  -o, --out FILE   Where to write the page (default: build/ownership_report.html).
                   A FILE ending in .json gets the data as JSON instead.
      --all        Also include platform folders, assets, generated and vendored files.
  -h, --help       Show this help.''';

const _defaultOut = 'build/ownership_report.html';

/// Weight of the share of current lines in the ownership score.
const _lineWeight = 0.7;

/// Weight of the share of commits in the ownership score.
const _commitWeight = 0.3;

/// Below this score the owner holds less than half the file: it is shared.
const _sharedBelow = 0.5;

/// `flutter create` boilerplate, binary assets, vendored agent skills and tooling.
const _excludedPrefixes = [
  'android/',
  'ios/',
  'web/',
  'windows/',
  'macos/',
  'linux/',
  'assets/',
  'build/',
  '.agents/skills/',
  '.claude/',
  '.vscode/',
];

/// Generated code, lock files and binaries.
const _excludedSuffixes = [
  '.g.dart',
  '.freezed.dart',
  '.lock',
  '.pdf',
  '.svg',
  '.png',
  '.jpg',
  '.ico',
  '.gitkeep',
];

const _excludedFiles = {'.metadata', 'skills-lock.json'};

/// Files whose purpose cannot be read from a header comment.
const _knownFiles = {
  'pubspec.yaml':
      'Package manifest: SDK constraint, dependencies, dev '
      'dependencies and assets of the app.',
  'analysis_options.yaml':
      'Analyzer and lint rules that `flutter analyze` '
      'enforces, plus the riverpod_lint plugin.',
  '.gitignore':
      'Paths git must not track: build output, tooling caches and '
      'local secrets such as `env.json`.',
  '.mcp.json': 'MCP servers available to coding agents in this repository.',
  'CLAUDE.md': 'Entry point for Claude Code: includes `AGENTS.md`.',
  'supabase/config.toml':
      'Supabase CLI configuration of the local stack '
      '(ports, auth, realtime, seed).',
};

/// Categorical colours, assigned to contributors by current lines.
const _paletteSize = 8;

Future<void> main(List<String> args) async {
  final _Options options;
  try {
    options = _Options.parse(args);
  } on FormatException catch (error) {
    stderr
      ..writeln(error.message)
      ..writeln()
      ..writeln(_usage);
    exitCode = 64;
    return;
  }
  if (options.help) {
    stdout.writeln(_usage);
    return;
  }

  try {
    await _run(options);
  } on ProcessException catch (error) {
    stderr.writeln('git ${error.arguments.join(' ')} failed: ${error.message}');
    exitCode = 1;
  }
}

Future<void> _run(_Options options) async {
  final root = (await _git(['rev-parse', '--show-toplevel'])).trim();
  final head = (await _git(['rev-parse', '--short', 'HEAD'], dir: root)).trim();
  final branch = (await _git([
    'rev-parse',
    '--abbrev-ref',
    'HEAD',
  ], dir: root)).trim();
  final ignoreRevs = File('$root/.git-blame-ignore-revs').existsSync()
      ? ['--ignore-revs-file', '.git-blame-ignore-revs']
      : const <String>[];

  final paths = await _listFiles(root, options);
  if (paths.isEmpty) {
    stderr.writeln('No files to report.');
    exitCode = 1;
    return;
  }

  final authors = _Authors();
  stdout.writeln('Reading history…');
  final history = await _readHistory(root, authors);

  stdout.writeln('Blaming ${paths.length} files…');
  final workers = math.max(2, math.min(8, Platform.numberOfProcessors));
  final files = await _pool(paths, workers, (path) async {
    final fileHistory = history.files[path];
    final binary = fileHistory?.binary ?? false;
    final lines = binary
        ? const <String, int>{}
        : await _blame(root, path, ignoreRevs, authors);
    final text = binary ? null : _readText('$root/$path');
    return _FileReport.build(
      path: path,
      description: _describe(root, path, text, fileHistory),
      lines: lines,
      history: fileHistory,
    );
  });

  final report = _Report(
    repository: root.split('/').last,
    branch: branch,
    head: head,
    generatedAt: DateTime.now(),
    files: files,
    authors: authors,
    repoCommits: history.commitsByAuthor,
  );

  final out = File(options.out);
  out.parent.createSync(recursive: true);
  out.writeAsStringSync(
    out.path.toLowerCase().endsWith('.json')
        ? _renderJson(report)
        : _renderHtml(report),
  );

  stdout.writeln();
  for (final person in report.people) {
    stdout.writeln(
      '  ${person.name.padRight(32)} owns ${'${person.filesOwned}'.padLeft(4)} files, '
      '${_formatInt(person.lines).padLeft(7)} lines',
    );
  }
  stdout.writeln('\nWrote ${out.absolute.path}');
}

// ---------------------------------------------------------------------------
// Options
// ---------------------------------------------------------------------------

class _Options {
  _Options({
    required this.out,
    required this.all,
    required this.help,
    required this.paths,
  });

  factory _Options.parse(List<String> args) {
    var out = _defaultOut;
    var all = false;
    var help = false;
    final paths = <String>[];
    for (var i = 0; i < args.length; i++) {
      final arg = args[i];
      switch (arg) {
        case '-h' || '--help':
          help = true;
        case '--all':
          all = true;
        case '-o' || '--out':
          if (i + 1 >= args.length) {
            throw const FormatException('--out needs a file path.');
          }
          out = args[++i];
        default:
          if (arg.startsWith('--out=')) {
            out = arg.substring('--out='.length);
          } else if (arg.startsWith('-')) {
            throw FormatException('Unknown option: $arg');
          } else {
            paths.add(arg);
          }
      }
    }
    return _Options(out: out, all: all, help: help, paths: paths);
  }

  final String out;
  final bool all;
  final bool help;
  final List<String> paths;
}

// ---------------------------------------------------------------------------
// Git
// ---------------------------------------------------------------------------

Future<String> _git(List<String> args, {String? dir}) async {
  final result = await Process.run(
    'git',
    ['-c', 'core.quotepath=off', ...args],
    workingDirectory: dir,
    stdoutEncoding: utf8,
    stderrEncoding: utf8,
  );
  if (result.exitCode != 0) {
    throw ProcessException(
      'git',
      args,
      (result.stderr as String).trim(),
      result.exitCode,
    );
  }
  return result.stdout as String;
}

/// Files tracked at HEAD, relative to the repository root.
Future<List<String>> _listFiles(String root, _Options options) async {
  // Pathspecs are relative to where the command runs; without them list everything.
  final output = await _git([
    'ls-tree',
    '-r',
    '-z',
    '--name-only',
    '--full-name',
    'HEAD',
    if (options.paths.isNotEmpty) ...['--', ...options.paths],
  ], dir: options.paths.isEmpty ? root : null);
  final paths = output.split('\x00').where((path) => path.isNotEmpty);
  return [
    for (final path in paths)
      if (options.all || !_isExcluded(path)) path,
  ]..sort();
}

bool _isExcluded(String path) =>
    _excludedPrefixes.any(path.startsWith) ||
    _excludedSuffixes.any(path.endsWith) ||
    _excludedFiles.contains(path);

/// Contributors, keyed by e-mail after `.mailmap`.
class _Authors {
  final _names = <String, String>{};

  /// Registers an author and returns its key.
  String key(String email, String name) {
    final key = email.trim().toLowerCase();
    _names.putIfAbsent(key, () => name.trim().isEmpty ? key : name.trim());
    return key;
  }

  String name(String key) => _names[key] ?? key;
}

class _FileHistory {
  /// Index of every commit (in log order) that touched the file, per author.
  /// Ids rather than counts, so a folder counts a commit to several files once.
  final commitIdsByAuthor = <String, Set<int>>{};
  bool binary = false;
  String? lastDate;
  String? lastAuthor;

  /// Subject of the oldest commit, the one that added the file.
  String? addedIn;
}

class _History {
  _History(this.files, this.commitsByAuthor);

  final Map<String, _FileHistory> files;
  final Map<String, int> commitsByAuthor;
}

/// One `git log` pass for every file: commits per author, last change, origin.
Future<_History> _readHistory(String root, _Authors authors) async {
  final output = await _git([
    'log',
    '--no-merges',
    '--no-renames',
    '--numstat',
    '--format=%x1e%aN%x1f%aE%x1f%aI%x1f%s',
    'HEAD',
  ], dir: root);
  final files = <String, _FileHistory>{};
  final commitsByAuthor = <String, int>{};
  var commit = 0;
  for (final entry in output.split('\x1e')) {
    final lines = LineSplitter.split(entry).toList();
    if (lines.isEmpty) continue;
    final header = lines.first.split('\x1f');
    if (header.length < 4) continue;
    commit++;
    final author = authors.key(header[1], header[0]);
    final date = header[2];
    final subject = header.sublist(3).join(' ');
    commitsByAuthor.update(author, (n) => n + 1, ifAbsent: () => 1);

    for (final line in lines.skip(1)) {
      final stat = line.split('\t');
      if (stat.length != 3) continue;
      final file = files.putIfAbsent(stat[2], _FileHistory.new);
      file.commitIdsByAuthor.putIfAbsent(author, () => <int>{}).add(commit);
      file.lastDate ??= date;
      file.lastAuthor ??= author;
      file.addedIn = subject; // The log runs newest first: the last one wins.
      if (stat[0] == '-') file.binary = true;
    }
  }
  return _History(files, commitsByAuthor);
}

/// Current lines per author.
Future<Map<String, int>> _blame(
  String root,
  String path,
  List<String> ignoreRevs,
  _Authors authors,
) async {
  final String output;
  try {
    output = await _git([
      'blame',
      '--line-porcelain',
      '-w',
      '-M',
      ...ignoreRevs,
      'HEAD',
      '--',
      path,
    ], dir: root);
  } on ProcessException {
    return const {};
  }
  final lines = <String, int>{};
  var name = '';
  // Source lines start with a tab, so they never look like these headers.
  for (final line in LineSplitter.split(output)) {
    if (line.startsWith('author ')) {
      name = line.substring('author '.length);
    } else if (line.startsWith('author-mail ')) {
      final email = line
          .substring('author-mail '.length)
          .replaceAll(RegExp('[<>]'), '');
      lines.update(authors.key(email, name), (n) => n + 1, ifAbsent: () => 1);
    }
  }
  return lines;
}

String? _readText(String path) {
  try {
    return utf8.decode(File(path).readAsBytesSync(), allowMalformed: true);
  } on FileSystemException {
    return null;
  }
}

/// Runs [task] over [items] with at most [workers] in flight, keeping the order.
Future<List<R>> _pool<T, R>(
  List<T> items,
  int workers,
  Future<R> Function(T item) task,
) async {
  final results = <int, R>{};
  var next = 0;
  Future<void> worker() async {
    while (next < items.length) {
      final index = next++;
      results[index] = await task(items[index]);
    }
  }

  await Future.wait([for (var i = 0; i < workers; i++) worker()]);
  return [for (var i = 0; i < items.length; i++) results[i] as R];
}

// ---------------------------------------------------------------------------
// Descriptions
// ---------------------------------------------------------------------------

class _Description {
  const _Description({
    required this.role,
    required this.summary,
    this.declares = const [],
    this.fromCommit = false,
  });

  /// What kind of file it is: Widget, Repository, Migration…
  final String role;
  final String summary;

  /// Main names the file declares (classes, providers, tables…).
  final List<String> declares;

  /// The summary is the subject of the commit that added the file.
  final bool fromCommit;
}

_Description _describe(
  String root,
  String path,
  String? text,
  _FileHistory? history,
) {
  final role = _role(path);
  var summary = _knownFiles[path] ?? '';
  var declares = const <String>[];

  if (summary.isEmpty && text != null) {
    switch (_extension(path)) {
      case 'dart':
        final dart = _describeDart(path, text);
        summary = path.endsWith('_test.dart')
            ? _describeTest(path, text, dart.summary, root)
            : dart.summary;
        declares = dart.declares;
      case 'sql':
        summary = _leadingComment(text, '--');
        declares = _sqlObjects(text);
      case 'md':
        summary = _describeMarkdown(text);
      case 'puml':
        summary = _leadingComment(text, "'");
      case 'sh' ||
          'ps1' ||
          'yaml' ||
          'yml' ||
          'toml' ||
          'gitignore' ||
          'mailmap':
        summary = _leadingComment(text, '#');
    }
  }

  var fromCommit = false;
  final addedIn = history?.addedIn;
  if (summary.isEmpty && addedIn != null) {
    summary = 'Added in “$addedIn”.';
    fromCommit = true;
  }
  return _Description(
    role: role,
    summary: _truncate(_cleanMarkdown(summary), 320),
    declares: declares,
    fromCommit: fromCommit,
  );
}

String _extension(String path) {
  final name = path.split('/').last;
  final dot = name.lastIndexOf('.');
  return dot < 0 ? '' : name.substring(dot + 1).toLowerCase();
}

String _role(String path) {
  final name = path.split('/').last;
  final ext = _extension(path);
  if (name.endsWith('_test.dart')) return 'Test';
  if (path.startsWith('test/')) {
    return name.startsWith('fake') ? 'Test fake' : 'Test helper';
  }
  if (path.startsWith('supabase/migrations/')) return 'Migration';
  if (path.startsWith('supabase/tests/')) return 'Database test';
  if (path.startsWith('supabase/seed/') && ext == 'sql') return 'Seed';
  if (ext == 'md') return 'Documentation';
  if (ext == 'dart') return _dartRole(path, name);
  if (const {'sh', 'ps1', 'bat'}.contains(ext)) return 'Script';
  if (ext == 'puml') return 'Diagram';
  if (const {
    'yaml',
    'yml',
    'json',
    'toml',
    'gitignore',
    'mailmap',
  }.contains(ext)) {
    return 'Config';
  }
  return ext.isEmpty ? 'File' : ext.toUpperCase();
}

String _dartRole(String path, String name) {
  final folders = path.split('/');
  if (RegExp(r'^lib/main\w*\.dart$').hasMatch(path)) return 'Entry point';
  if (name.startsWith('fake_')) {
    return name.contains('repository') ? 'Fake repository' : 'Fake data';
  }
  if (name.endsWith('_repository.dart')) return 'Repository';
  if (name.endsWith('_controller.dart')) return 'Controller';
  if (name.endsWith('_provider.dart') || name.endsWith('_providers.dart')) {
    return 'Providers';
  }
  if (name.endsWith('_screen.dart') || name.endsWith('_page.dart')) {
    return 'Screen';
  }
  if (name.contains('router')) return 'Routing';
  if (folders.contains('widgets')) return 'Widget';
  if (path.startsWith('lib/core/ui/')) return 'UI kit';
  if (path.startsWith('lib/core/theme/')) return 'Theme';
  if (path.startsWith('lib/dev/')) return 'Dev tool';
  if (folders.contains('domain')) return 'Domain';
  if (folders.contains('data')) return 'Data';
  if (folders.contains('presentation')) return 'Presentation';
  return 'Dart';
}

final _dartType = RegExp(
  r'^(?:(?:abstract|sealed|base|final|interface|mixin)\s+)*'
  r'(?:class|enum|mixin|extension type|extension|typedef)\s+(\w+)',
);
final _dartVariable = RegExp(
  r'^(?:final|const|late final)\s+(?:[\w<>?, ]+\s+)?(\w+)\s*=',
);
final _dartFunction = RegExp(r'^(?:[\w<>?,]+\s+)+(\w+)\s*[(<]');

String? _dartDeclaration(String line) {
  final name =
      (_dartType.firstMatch(line) ??
              _dartVariable.firstMatch(line) ??
              _dartFunction.firstMatch(line))
          ?.group(1);
  return name == 'on' ? null : name; // `extension on Foo` has no name.
}

({String summary, List<String> declares}) _describeDart(
  String path,
  String text,
) {
  // Top-level doc comments (column 0) and the declaration each one documents.
  final blocks = <({List<String> doc, String? name})>[];
  final declares = <String>[];
  var doc = <String>[];
  for (final line in LineSplitter.split(text)) {
    if (line.startsWith('///')) {
      doc.add(line.substring(3).trim());
      continue;
    }
    if (line.startsWith('@')) continue; // Annotations sit between doc and code.
    final topLevel = line.isNotEmpty && !line.startsWith(RegExp(r'[\s/}\])]'));
    final name = topLevel ? _dartDeclaration(line) : null;
    if (name != null && !name.startsWith('_') && !declares.contains(name)) {
      declares.add(name);
    }
    if (doc.isNotEmpty) blocks.add((doc: doc, name: name));
    doc = [];
  }

  final base = path.split('/').last.replaceAll(RegExp(r'(_test)?\.dart$'), '');
  final pascal = base.split('_').map(_capitalize).join();
  final best =
      blocks.where((block) => block.name == pascal).firstOrNull ??
      blocks
          .where(
            (b) =>
                b.name?.toLowerCase().contains(pascal.toLowerCase()) ?? false,
          )
          .firstOrNull ??
      blocks.where((block) => block.name == null).firstOrNull ?? // library doc
      blocks.where((b) => !(b.name?.startsWith('_') ?? true)).firstOrNull ??
      blocks.firstOrNull;
  final summary = best == null ? '' : _firstParagraph(best.doc);

  return (summary: summary, declares: declares.take(8).toList());
}

final _testCall = RegExp(
  r'''\b(group|test|testWidgets)\(\s*(?:'((?:[^'\\]|\\.)*)'|"((?:[^"\\]|\\.)*)")''',
);

/// "Tests `lib/…/file.dart`: group or case names (N test cases)."
String _describeTest(String path, String text, String docSummary, String root) {
  final groups = <String>[];
  final cases = <String>[];
  for (final match in _testCall.allMatches(text)) {
    final name = (match.group(2) ?? match.group(3) ?? '').replaceAll(r'\', '');
    (match.group(1) == 'group' ? groups : cases).add(name);
  }
  final subject = path
      .replaceFirst(RegExp('^test/'), 'lib/')
      .replaceFirst(RegExp(r'_test\.dart$'), '.dart');
  final hasSubject = File('$root/$subject').existsSync();
  final count = '${cases.length} test case${cases.length == 1 ? '' : 's'}';

  if (docSummary.isNotEmpty) return '$docSummary ($count.)';
  final topics = (groups.isNotEmpty ? groups : cases).take(3).join(' · ');
  final lead = hasSubject ? 'Tests `$subject`' : 'Covers';
  if (topics.isEmpty) return hasSubject ? '$lead ($count).' : '$count.';
  return '$lead: $topics ($count).';
}

String _firstParagraph(List<String> lines) {
  final paragraph = <String>[];
  for (final line in lines) {
    if (line.isEmpty || line.startsWith('```')) {
      if (paragraph.isNotEmpty) break;
      continue;
    }
    paragraph.add(line);
  }
  return paragraph.join(' ');
}

/// First paragraph of the comment the file starts with (after a shebang).
String _leadingComment(String text, String marker) {
  final lines = <String>[];
  for (final raw in LineSplitter.split(text)) {
    final line = raw.trim();
    // Skip blank lines, a shebang and PlantUML's `@startuml` before the comment.
    if (lines.isEmpty && RegExp(r'^$|^#!|^@start').hasMatch(line)) continue;
    if (!line.startsWith(marker)) break;
    final body = line.substring(marker.length).trim();
    if (RegExp(r'^[-=*#]*$').hasMatch(body)) {
      // Blank comment line or ruler: ends the first paragraph.
      if (lines.isNotEmpty) break;
      continue;
    }
    lines.add(body);
  }
  return lines.join(' ');
}

final _sqlCreate = RegExp(
  r'create\s+(?:or\s+replace\s+)?(?:unique\s+)?'
  r'(table|materialized\s+view|view|function|type|trigger|policy|index|schema)\s+'
  r'(?:if\s+not\s+exists\s+)?("[^"]+"|[\w.]+)',
  caseSensitive: false,
);

/// Objects a SQL file creates; policies and indexes are only counted.
List<String> _sqlObjects(String text) {
  final objects = <String>[];
  var policies = 0;
  var indexes = 0;
  for (final match in _sqlCreate.allMatches(text)) {
    final kind = match.group(1)!.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    final name = match
        .group(2)!
        .replaceAll('"', '')
        .replaceFirst('public.', '');
    if (kind == 'policy') {
      policies++;
    } else if (kind == 'index') {
      indexes++;
    } else if (!objects.contains('$kind $name')) {
      objects.add('$kind $name');
    }
  }
  return [
    ...objects.take(8),
    if (objects.length > 8) '+${objects.length - 8} more',
    if (policies > 0) '$policies polic${policies == 1 ? 'y' : 'ies'}',
    if (indexes > 0) '$indexes index${indexes == 1 ? '' : 'es'}',
  ];
}

/// "Title — first paragraph" of a Markdown file.
String _describeMarkdown(String text) {
  String? title;
  final paragraph = <String>[];
  var inCode = false;
  for (final raw in LineSplitter.split(text)) {
    final line = raw.trim();
    if (line.startsWith('```')) {
      inCode = !inCode;
      continue;
    }
    if (inCode) continue;
    if (line.startsWith('#')) {
      if (paragraph.isNotEmpty) break;
      title ??= line.replaceFirst(RegExp(r'^#+\s*'), '');
      continue;
    }
    if (line.isEmpty || RegExp(r'^[|>!<\-*+]|^\d+\.|^---').hasMatch(line)) {
      if (paragraph.isNotEmpty) break;
      continue;
    }
    paragraph.add(line);
  }
  final body = paragraph.join(' ');
  if (title == null) return body;
  return body.isEmpty ? title : '$title — $body';
}

/// Drops Markdown link syntax and Dart doc references, keeps `code`.
String _cleanMarkdown(String text) => text
    .replaceAllMapped(RegExp(r'\[([^\]]+)\]\([^)]*\)'), (m) => m.group(1)!)
    .replaceAllMapped(RegExp(r'\[([\w.<>]+)\]'), (m) => m.group(1)!)
    .replaceAll(RegExp(r'\*\*|__'), '')
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim();

String _truncate(String text, int max) {
  if (text.length <= max) return text;
  final cut = text.lastIndexOf(' ', max);
  return '${text.substring(0, cut > max ~/ 2 ? cut : max)}…';
}

String _capitalize(String word) =>
    word.isEmpty ? word : word[0].toUpperCase() + word.substring(1);

// ---------------------------------------------------------------------------
// Ownership
// ---------------------------------------------------------------------------

class _Share {
  _Share({
    required this.author,
    required this.lines,
    required this.commits,
    required this.score,
  });

  final String author;
  final int lines;
  final int commits;

  /// 0..1; the shares of one file add up to 1.
  final double score;
}

/// Ownership of a file or folder, most owned first.
List<_Share> _shares(Map<String, int> lines, Map<String, int> commits) {
  final totalLines = lines.values.fold(0, (a, b) => a + b);
  final totalCommits = commits.values.fold(0, (a, b) => a + b);
  // A file without lines (or without history) is owned by the other measure only.
  final lineWeight = totalCommits == 0
      ? 1.0
      : (totalLines == 0 ? 0.0 : _lineWeight);
  final commitWeight = totalLines == 0
      ? 1.0
      : (totalCommits == 0 ? 0.0 : _commitWeight);

  return [
    for (final author in {...lines.keys, ...commits.keys})
      _Share(
        author: author,
        lines: lines[author] ?? 0,
        commits: commits[author] ?? 0,
        score:
            (totalLines == 0
                ? 0
                : lineWeight * (lines[author] ?? 0) / totalLines) +
            (totalCommits == 0
                ? 0
                : commitWeight * (commits[author] ?? 0) / totalCommits),
      ),
  ]..sort((a, b) {
    final byScore = b.score.compareTo(a.score);
    return byScore != 0 ? byScore : b.lines.compareTo(a.lines);
  });
}

class _FileReport {
  _FileReport({
    required this.path,
    required this.area,
    required this.description,
    required this.shares,
    required this.commitIds,
    required this.lines,
    required this.commits,
    required this.binary,
    this.lastDate,
    this.lastAuthor,
  });

  factory _FileReport.build({
    required String path,
    required _Description description,
    required Map<String, int> lines,
    required _FileHistory? history,
  }) {
    final commitIds = history?.commitIdsByAuthor ?? const <String, Set<int>>{};
    return _FileReport(
      path: path,
      area: _area(path),
      description: description,
      shares: _shares(lines, {
        for (final entry in commitIds.entries) entry.key: entry.value.length,
      }),
      commitIds: commitIds,
      lines: lines.values.fold(0, (a, b) => a + b),
      commits: commitIds.values.fold(0, (sum, ids) => sum + ids.length),
      binary: history?.binary ?? false,
      lastDate: history?.lastDate,
      lastAuthor: history?.lastAuthor,
    );
  }

  final String path;
  final String area;
  final _Description description;

  /// Most owned first.
  final List<_Share> shares;
  final Map<String, Set<int>> commitIds;
  final int lines;
  final int commits;
  final bool binary;
  final String? lastDate;
  final String? lastAuthor;

  _Share? get owner => shares.firstOrNull;
  bool get shared => (owner?.score ?? 1) < _sharedBelow;
  String get folder => _parentOf(path);
  String get name => path.split('/').last;
}

/// A folder of the tree view: the totals of every file below it.
class _FolderReport {
  _FolderReport(this.path);

  final String path;
  int files = 0;
  int lines = 0;
  final linesByAuthor = <String, int>{};
  final commitIdsByAuthor = <String, Set<int>>{};
  String? lastDate;
  String? lastAuthor;

  /// First paragraph of the folder's README.md, if it has one.
  String summary = '';
  List<_Share> shares = const [];

  String get name => path.split('/').last;
  String get parent => _parentOf(path);
  int get depth => '/'.allMatches(path).length;
  int get commits =>
      commitIdsByAuthor.values.expand((ids) => ids).toSet().length;
  bool get shared => (shares.firstOrNull?.score ?? 1) < _sharedBelow;

  void add(_FileReport file) {
    files++;
    lines += file.lines;
    for (final share in file.shares) {
      linesByAuthor.update(
        share.author,
        (n) => n + share.lines,
        ifAbsent: () => share.lines,
      );
    }
    for (final entry in file.commitIds.entries) {
      commitIdsByAuthor
          .putIfAbsent(entry.key, () => <int>{})
          .addAll(entry.value);
    }
    final date = file.lastDate;
    if (date != null &&
        (lastDate == null ||
            DateTime.parse(date).isAfter(DateTime.parse(lastDate!)))) {
      lastDate = date;
      lastAuthor = file.lastAuthor;
    }
  }
}

String _parentOf(String path) {
  final slash = path.lastIndexOf('/');
  return slash < 0 ? '' : path.substring(0, slash);
}

/// The folder a file is grouped under: a feature, a core module, a Supabase folder…
String _area(String path) {
  final parts = path.split('/');
  if (parts.length == 1) return '(root)';
  final top = parts.first;
  if ((top == 'lib' || top == 'test') &&
      parts.length > 3 &&
      (parts[1] == 'features' || parts[1] == 'core')) {
    return parts.take(3).join('/');
  }
  if ((top == 'lib' || top == 'test' || top == 'supabase') &&
      parts.length > 2) {
    return parts.take(2).join('/');
  }
  return top;
}

class _Person {
  _Person(this.key, this.name);

  final String key;
  final String name;
  int filesOwned = 0;
  int filesTouched = 0;
  int lines = 0;
  int commits = 0;
}

class _AreaReport {
  _AreaReport(this.name);

  final String name;
  int files = 0;
  int lines = 0;
  final linesByAuthor = <String, int>{};
  final commitsByAuthor = <String, int>{};

  /// Authors by lines (then commits), most first.
  List<String> get ranking =>
      {...linesByAuthor.keys, ...commitsByAuthor.keys}.toList()..sort((a, b) {
        final byLines = (linesByAuthor[b] ?? 0).compareTo(
          linesByAuthor[a] ?? 0,
        );
        return byLines != 0
            ? byLines
            : (commitsByAuthor[b] ?? 0).compareTo(commitsByAuthor[a] ?? 0);
      });
}

class _Report {
  _Report({
    required this.repository,
    required this.branch,
    required this.head,
    required this.generatedAt,
    required this.files,
    required this.authors,
    required Map<String, int> repoCommits,
  }) {
    final byKey = <String, _Person>{};
    _Person person(String key) =>
        byKey.putIfAbsent(key, () => _Person(key, authors.name(key)));

    for (final file in files) {
      final owner = file.owner;
      if (owner != null) person(owner.author).filesOwned++;
      final area = areas.putIfAbsent(file.area, () => _AreaReport(file.area));
      area
        ..files += 1
        ..lines += file.lines;
      for (final share in file.shares) {
        person(share.author)
          ..filesTouched += 1
          ..lines += share.lines;
        area.linesByAuthor.update(
          share.author,
          (n) => n + share.lines,
          ifAbsent: () => share.lines,
        );
        area.commitsByAuthor.update(
          share.author,
          (n) => n + share.commits,
          ifAbsent: () => share.commits,
        );
      }
    }
    for (final entry in repoCommits.entries) {
      person(entry.key).commits = entry.value;
    }

    final readmes = {
      for (final file in files)
        if (file.name == 'README.md') file.folder: file.description.summary,
    };
    for (final file in files) {
      for (var dir = file.folder; dir.isNotEmpty; dir = _parentOf(dir)) {
        folders.putIfAbsent(dir, () => _FolderReport(dir)).add(file);
      }
    }
    for (final folder in folders.values) {
      folder
        ..summary = readmes[folder.path] ?? ''
        ..shares = _shares(folder.linesByAuthor, {
          for (final entry in folder.commitIdsByAuthor.entries)
            entry.key: entry.value.length,
        });
    }
    // Repository-wide commits must not list people with no file in this report.
    people = byKey.values.where((p) => p.filesTouched > 0).toList()
      ..sort((a, b) {
        final byLines = b.lines.compareTo(a.lines);
        return byLines != 0 ? byLines : b.commits.compareTo(a.commits);
      });
    for (var i = 0; i < people.length; i++) {
      _colors[people[i].key] = i < _paletteSize
          ? 'var(--c$i)'
          : 'var(--c-other)';
    }
  }

  final String repository;
  final String branch;
  final String head;
  final DateTime generatedAt;
  final List<_FileReport> files;
  final _Authors authors;
  final areas = <String, _AreaReport>{};
  final folders = <String, _FolderReport>{};
  late final List<_Person> people;
  final _colors = <String, String>{};

  int get totalLines => files.fold(0, (sum, file) => sum + file.lines);
  String color(String author) => _colors[author] ?? 'var(--c-other)';
  String name(String author) => authors.name(author);
}

// ---------------------------------------------------------------------------
// JSON
// ---------------------------------------------------------------------------

String _renderJson(_Report report) {
  List<Map<String, Object?>> shares(List<_Share> shares) => [
    for (final share in shares)
      {
        'name': report.name(share.author),
        'score': double.parse(share.score.toStringAsFixed(3)),
        'lines': share.lines,
        'commits': share.commits,
      },
  ];
  String? name(String? author) => author == null ? null : report.name(author);

  final folders = report.folders.values.toList()
    ..sort((a, b) => a.path.compareTo(b.path));
  final data = {
    'repository': report.repository,
    'branch': report.branch,
    'head': report.head,
    'generatedAt': report.generatedAt.toIso8601String(),
    'scoring': {
      'lineWeight': _lineWeight,
      'commitWeight': _commitWeight,
      'sharedBelow': _sharedBelow,
    },
    'people': [
      for (final person in report.people)
        {
          'name': person.name,
          'filesOwned': person.filesOwned,
          'filesTouched': person.filesTouched,
          'lines': person.lines,
          'repoCommits': person.commits,
        },
    ],
    'folders': [
      for (final folder in folders)
        {
          'path': folder.path,
          'files': folder.files,
          'lines': folder.lines,
          'commits': folder.commits,
          'summary': folder.summary,
          'owner': name(folder.shares.firstOrNull?.author),
          'shared': folder.shared,
          'shares': shares(folder.shares),
          'lastChange': folder.lastDate,
          'lastAuthor': name(folder.lastAuthor),
        },
    ],
    'files': [
      for (final file in report.files)
        {
          'path': file.path,
          'area': file.area,
          'role': file.description.role,
          'summary': file.description.summary,
          'summaryFromCommit': file.description.fromCommit,
          'declares': file.description.declares,
          'lines': file.lines,
          'commits': file.commits,
          'binary': file.binary,
          'owner': name(file.owner?.author),
          'shared': file.shared,
          'shares': shares(file.shares),
          'lastChange': file.lastDate,
          'lastAuthor': name(file.lastAuthor),
        },
    ],
  };
  return '${const JsonEncoder.withIndent('  ').convert(data)}\n';
}

// ---------------------------------------------------------------------------
// HTML
// ---------------------------------------------------------------------------

String _esc(String text) => text
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');

/// Escaped text with `code` spans.
String _rich(String text) => _esc(text)
    .replaceAllMapped(RegExp('`([^`]+)`'), (m) => '<code>${m.group(1)}</code>');

String _percent(double share) => '${(share * 100).round()} %';

String _formatInt(int value) =>
    value.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+$)'), (_) => ',');

String _date(DateTime time) =>
    '${time.year}-${_two(time.month)}-${_two(time.day)} '
    '${_two(time.hour)}:${_two(time.minute)}';

String _two(int n) => n.toString().padLeft(2, '0');

String _dot(_Report report, String author) =>
    '<span class="dot" style="background:${report.color(author)}"></span>';

String _bar(_Report report, Iterable<(String, double)> parts) {
  final spans = [
    for (final (author, share) in parts)
      if (share > 0)
        '<span style="width:${(share * 100).toStringAsFixed(2)}%;'
            'background:${report.color(author)}"></span>',
  ];
  return '<div class="bar" aria-hidden="true">${spans.join()}</div>';
}

String _renderHtml(_Report report) {
  final html = StringBuffer()
    ..writeln('<!doctype html>')
    ..writeln('<html lang="en">')
    ..writeln('<head>')
    ..writeln('<meta charset="utf-8">')
    ..writeln(
      '<meta name="viewport" content="width=device-width, initial-scale=1">',
    )
    ..writeln('<title>Code ownership · ${_esc(report.repository)}</title>')
    ..writeln('<style>$_css</style>')
    ..writeln('</head>')
    ..writeln('<body>')
    ..writeln('<main>');

  _renderHeader(html, report);
  _renderPeople(html, report);
  _renderAreas(html, report);
  _renderFiles(html, report);

  html
    ..writeln('</main>')
    ..writeln('<script>$_js</script>')
    ..writeln('</body>')
    ..writeln('</html>');
  return html.toString();
}

void _renderHeader(StringBuffer html, _Report report) {
  final shared = report.files.where((file) => file.shared).length;
  String stat(String label, String value) =>
      '<div class="stat"><div class="stat-value">$value</div>'
      '<div class="stat-label">$label</div></div>';

  html
    ..writeln('<header>')
    ..writeln('<h1>Code ownership</h1>')
    ..writeln(
      '<p class="meta">${_esc(report.repository)} · ${_esc(report.branch)} @ '
      '<code>${_esc(report.head)}</code> · generated ${_date(report.generatedAt)}</p>',
    )
    ..writeln('<div class="stats">')
    ..writeln(stat('files', _formatInt(report.files.length)))
    ..writeln(stat('current lines', _formatInt(report.totalLines)))
    ..writeln(stat('contributors', '${report.people.length}'))
    ..writeln(stat('shared files', '$shared'))
    ..writeln('</div>')
    ..writeln(
      '<details class="method"><summary>How ownership is measured</summary>',
    )
    ..writeln(
      '<p>For every file tracked at HEAD, <code>git blame -w -M</code> gives the current '
      'lines each person wrote last (whitespace-only edits and moved lines keep their '
      'author) and <code>git log --no-merges</code> gives the commits each person made '
      'to it. The ownership score is <b>${(_lineWeight * 100).round()} % share of lines + '
      '${(_commitWeight * 100).round()} % share of commits</b>; the highest score owns '
      'the file. Files whose owner scores under ${_percent(_sharedBelow)} are marked '
      '<b>shared</b>. Identities are merged with <code>.mailmap</code>.</p>'
      '<p>Descriptions are read from each file: the doc comment of its main Dart '
      'declaration, the header comment of SQL files and scripts, or the first '
      'paragraph of Markdown. <i>Italic</i> descriptions have no such comment and show '
      'the commit that added the file instead.</p>',
    )
    ..writeln('</details>')
    ..writeln('</header>');
}

void _renderPeople(StringBuffer html, _Report report) {
  final total = math.max(1, report.totalLines);
  html
    ..writeln('<section><h2>Contributors</h2><div class="scroll">')
    ..writeln(
      '<table><thead><tr><th>Contributor</th><th class="num">Files owned</th>'
      '<th class="num">Files touched</th><th class="num">Current lines</th>'
      '<th>Share of lines</th><th class="num">Commits</th></tr></thead><tbody>',
    );
  for (final person in report.people) {
    final share = person.lines / total;
    final name = _esc(person.name);
    html.writeln(
      '<tr><td><button class="who link" data-person="$name" data-mode="owner" '
      'title="Show the files $name owns">'
      '${_dot(report, person.key)}$name</button></td>'
      '<td class="num"><button class="link" data-person="$name" data-mode="owner" '
      'title="Show the files $name owns">${person.filesOwned}</button></td>'
      '<td class="num"><button class="link" data-person="$name" data-mode="any" '
      'title="Show every file $name contributed to">${person.filesTouched}</button></td>'
      '<td class="num">${_formatInt(person.lines)}</td>'
      '<td class="share-cell">${_bar(report, [(person.key, share)])}'
      '<span class="split">${_percent(share)}</span></td>'
      '<td class="num">${person.commits}</td></tr>',
    );
  }
  html.writeln(
    '</tbody></table></div>'
    '<p class="note">Commits count every non-merge commit in the repository; '
    'lines and files only count the files in this report.</p></section>',
  );
}

void _renderAreas(StringBuffer html, _Report report) {
  final areas = report.areas.values.toList()
    ..sort((a, b) => a.name.compareTo(b.name));
  html
    ..writeln('<section><h2>Areas</h2><div class="scroll">')
    ..writeln(
      '<table data-sortable><thead><tr>'
      '<th data-sort="area">Area</th>'
      '<th class="num" data-sort="files" data-type="num">Files</th>'
      '<th class="num" data-sort="lines" data-type="num">Lines</th>'
      '<th data-sort="owner">Owner</th><th>Split by lines</th></tr></thead><tbody>',
    );
  for (final area in areas) {
    final ranking = area.ranking;
    final owner = ranking.first;
    final total = math.max(1, area.lines);
    final split = ranking
        .where((author) => (area.linesByAuthor[author] ?? 0) > 0)
        .map((author) => (author, (area.linesByAuthor[author] ?? 0) / total))
        .toList();
    final ownerShare = split.firstOrNull?.$2 ?? 0;
    html.writeln(
      '<tr data-area="${_esc(area.name)}" data-files="${area.files}" '
      'data-lines="${area.lines}" data-owner="${_esc(report.name(owner))}">'
      '<td><button class="link path" data-area-filter="${_esc(area.name)}" '
      'title="Show the files of this area">${_esc(area.name)}</button></td>'
      '<td class="num">${area.files}</td>'
      '<td class="num">${_formatInt(area.lines)}</td>'
      '<td><span class="who">${_dot(report, owner)}${_esc(report.name(owner))}</span>'
      '${area.lines > 0 ? '<span class="split">${_percent(ownerShare)} of lines</span>' : ''}</td>'
      '<td class="share-cell">${_bar(report, split)}<span class="split">'
      '${split.where((s) => s.$2 >= 0.005).take(4).map((s) => '${_esc(report.name(s.$1))} ${_percent(s.$2)}').join(' · ')}'
      '</span></td></tr>',
    );
  }
  html.writeln('</tbody></table></div></section>');
}

void _renderFiles(StringBuffer html, _Report report) {
  final areas = report.areas.keys.toList()..sort();
  final people = report.people
      .map((p) => '<option>${_esc(p.name)}</option>')
      .join();
  html
    ..writeln('<section><h2>Files</h2>')
    ..writeln('<div class="toolbar">')
    ..writeln(
      '<div class="segmented" role="group" aria-label="View">'
      '<button type="button" data-view="list" aria-pressed="true">☰ List</button>'
      '<button type="button" data-view="tree" aria-pressed="false">▤ Tree</button>'
      '</div>',
    )
    ..writeln(
      '<input id="q" type="search" placeholder="Search path, description, name…" '
      'aria-label="Search files">',
    )
    ..writeln(
      '<span class="field"><select id="person" aria-label="Contributor">'
      '<option value="">Any contributor</option>$people</select>'
      '<select id="mode" aria-label="How they contributed" disabled>'
      '<option value="owner">as owner</option>'
      '<option value="any">with any contribution</option></select></span>',
    )
    ..writeln(
      '<select id="area" aria-label="Area"><option value="">All areas</option>'
      '${areas.map((a) => '<option>${_esc(a)}</option>').join()}</select>',
    )
    ..writeln(
      '<label class="check"><input id="shared" type="checkbox"> Shared only</label>',
    )
    ..writeln(
      '<span class="tree-only"><button type="button" class="ghost" id="expand">'
      'Expand all</button><button type="button" class="ghost" id="collapse">'
      'Collapse all</button></span>',
    )
    ..writeln('<span id="count" class="count" aria-live="polite"></span>')
    ..writeln('</div><div class="scroll">')
    ..writeln(
      '<table id="files" data-sortable><thead><tr>'
      '<th data-sort="path">File</th><th>Description</th>'
      '<th data-sort="owner">Owner</th>'
      '<th class="num" data-sort="lines" data-type="num">Lines</th>'
      '<th class="num" data-sort="commits" data-type="num">Commits</th>'
      '<th data-sort="date">Last change</th></tr></thead><tbody>',
    );

  // Rows in tree order (folders first, then files); the list view hides folders.
  final subfolders = <String, List<String>>{};
  for (final folder in report.folders.keys) {
    subfolders.putIfAbsent(_parentOf(folder), () => []).add(folder);
  }
  final filesIn = <String, List<_FileReport>>{};
  for (final file in report.files) {
    filesIn.putIfAbsent(file.folder, () => []).add(file);
  }
  var order = 0;
  void emit(String folder) {
    for (final path in (subfolders[folder] ?? <String>[])..sort()) {
      _renderFolderRow(html, report, report.folders[path]!, order++);
      emit(path);
    }
    for (final file
        in (filesIn[folder] ?? <_FileReport>[])
          ..sort((a, b) => a.name.compareTo(b.name))) {
      _renderFileRow(html, report, file, order++);
    }
  }

  emit('');
  html.writeln('</tbody></table></div></section>');
}

void _renderFolderRow(
  StringBuffer html,
  _Report report,
  _FolderReport folder,
  int order,
) {
  final path = _esc(folder.path);
  html.writeln(
    '<tr class="folder" data-kind="dir" data-path="$path" '
    'data-parent="${_esc(folder.parent)}" data-order="$order" hidden>'
    '<td class="file" style="--depth:${folder.depth}">'
    '<div class="folder-name"><button type="button" class="twisty" '
    'aria-expanded="false" aria-label="Open $path">▸</button>'
    '<span class="path">${_esc(folder.name)}/</span></div>'
    '<span class="role">${folder.files} file${folder.files == 1 ? '' : 's'}</span></td>'
    '<td class="desc"><div class="fallback-plain">${_rich(folder.summary)}</div></td>'
    '<td class="owner" title="${_esc(_tooltip(report, folder.shares))}">'
    '${_ownerCell(report, folder.shares, shared: folder.shared)}</td>'
    '<td class="num">${_formatInt(folder.lines)}</td>'
    '<td class="num">${folder.commits}</td>'
    '${_lastCell(report, folder.lastDate, folder.lastAuthor)}</tr>',
  );
}

void _renderFileRow(
  StringBuffer html,
  _Report report,
  _FileReport file,
  int order,
) {
  final description = file.description;
  final owner = file.owner;
  final dir = file.folder.isEmpty ? '' : '${file.folder}/';
  final contributors = file.shares.map((s) => report.name(s.author));
  final search = [
    file.path,
    description.summary,
    description.role,
    ...description.declares,
    ...contributors,
  ].join(' ').toLowerCase();
  final chips = description.declares.isEmpty
      ? ''
      : '<div class="chips">${description.declares.map((d) => '<span class="chip">${_esc(d)}</span>').join()}</div>';

  html.writeln(
    '<tr data-kind="file" data-path="${_esc(file.path)}" '
    'data-parent="${_esc(file.folder)}" data-order="$order" '
    'data-owner="${_esc(owner == null ? '' : report.name(owner.author))}" '
    'data-contributors="${_esc(contributors.join('|'))}" '
    'data-area="${_esc(file.area)}" data-shared="${file.shared ? 1 : 0}" '
    'data-lines="${file.lines}" data-commits="${file.commits}" '
    'data-date="${_esc(file.lastDate ?? '')}" data-search="${_esc(search)}">'
    '<td class="file" style="--depth:${'/'.allMatches(file.path).length}">'
    '<div class="path"><span class="dir">${_esc(dir)}</span>${_esc(file.name)}</div>'
    '<span class="role">${_esc(description.role)}</span></td>'
    '<td class="desc"><div${description.fromCommit ? ' class="fallback"' : ''}>'
    '${_rich(description.summary)}</div>$chips</td>'
    '<td class="owner" title="${_esc(_tooltip(report, file.shares))}">'
    '${_ownerCell(report, file.shares, shared: file.shared)}</td>'
    '<td class="num">${file.binary ? 'binary' : _formatInt(file.lines)}</td>'
    '<td class="num">${file.commits}</td>'
    '${_lastCell(report, file.lastDate, file.lastAuthor)}</tr>',
  );
}

String _tooltip(_Report report, List<_Share> shares) => shares
    .map(
      (s) =>
          '${report.name(s.author)}: ${_percent(s.score)} · '
          '${s.lines} lines · ${s.commits} commits',
    )
    .join('\n');

String _ownerCell(_Report report, List<_Share> shares, {required bool shared}) {
  final owner = shares.firstOrNull;
  if (owner == null) return '<span class="split">No history</span>';
  final others = shares.skip(1).where((s) => s.score >= 0.01).take(3);
  return '<div class="who">${_dot(report, owner.author)}'
      '${_esc(report.name(owner.author))}'
      '<span class="pct">${_percent(owner.score)}</span>'
      '${shared ? '<span class="tag">◐ Shared</span>' : ''}</div>'
      '${_bar(report, shares.map((s) => (s.author, s.score)))}'
      '${others.isEmpty ? '' : '<div class="split">also ${others.map((s) => '${_esc(report.name(s.author))} ${_percent(s.score)}').join(' · ')}</div>'}';
}

String _lastCell(_Report report, String? date, String? author) =>
    '<td class="last">${_esc((date ?? '').split('T').first)}'
    '${author == null ? '' : '<div class="split">${_esc(report.name(author))}</div>'}'
    '</td>';

const _css = r'''
:root{
  --bg:#f6f6f3;--surface:#fff;--text:#1d1d1b;--muted:#68675f;--border:#e2e1dc;--soft:#efeee9;
  --focus:#2563eb;--warn:#b45309;
  --c0:#2563eb;--c1:#d97706;--c2:#059669;--c3:#db2777;--c4:#7c3aed;--c5:#0891b2;--c6:#dc2626;--c7:#65a30d;--c-other:#a1a1aa;
  color-scheme:light;
}
@media (prefers-color-scheme:dark){
  :root{
    --bg:#131312;--surface:#1c1c1a;--text:#ecebe6;--muted:#a09f97;--border:#33322e;--soft:#272724;
    --focus:#60a5fa;--warn:#fbbf24;
    --c0:#60a5fa;--c1:#fbbf24;--c2:#34d399;--c3:#f472b6;--c4:#a78bfa;--c5:#22d3ee;--c6:#f87171;--c7:#a3e635;--c-other:#71717a;
    color-scheme:dark;
  }
}
*{box-sizing:border-box}
body{margin:0;background:var(--bg);color:var(--text);font:14px/1.5 system-ui,-apple-system,"Segoe UI",Roboto,sans-serif}
main{max-width:1440px;margin:0 auto;padding:32px 16px 64px}
h1{font-size:26px;line-height:1.2;margin:0 0 4px}
h2{font-size:16px;margin:0 0 12px}
code,.path,.chip{font-family:ui-monospace,SFMono-Regular,Consolas,"Liberation Mono",monospace}
code{font-size:.9em;background:var(--soft);padding:0 4px;border-radius:4px}
.meta,.note{color:var(--muted);margin:0}
.note{font-size:12px;margin-top:10px}
.stats{display:flex;flex-wrap:wrap;gap:12px;margin:20px 0 4px}
.stat{background:var(--surface);border:1px solid var(--border);border-radius:10px;padding:10px 16px;min-width:130px}
.stat-value{font-size:22px;font-weight:650;font-variant-numeric:tabular-nums}
.stat-label{color:var(--muted);font-size:12px}
details.method{margin-top:12px;color:var(--muted);max-width:900px}
details.method summary{cursor:pointer;color:var(--text)}
section{background:var(--surface);border:1px solid var(--border);border-radius:12px;padding:20px;margin-top:20px}
.scroll{overflow-x:auto}
table{width:100%;border-collapse:collapse}
th,td{text-align:left;padding:9px 10px;border-bottom:1px solid var(--border);vertical-align:top}
tbody tr:last-child td{border-bottom:0}
tbody tr:hover{background:var(--soft)}
th{font-size:11.5px;font-weight:600;color:var(--muted);text-transform:uppercase;letter-spacing:.04em;white-space:nowrap}
th[data-sort]{cursor:pointer;user-select:none}
th[data-sort]:hover{color:var(--text)}
th[aria-sort=ascending]::after{content:" ↑"}
th[aria-sort=descending]::after{content:" ↓"}
.num{text-align:right;font-variant-numeric:tabular-nums;white-space:nowrap}
.file{min-width:240px;max-width:360px}
.path{font-size:12.5px;word-break:break-all}
.path .dir{color:var(--muted)}
.role{display:inline-block;margin-top:4px;font-size:11px;padding:1px 7px;border-radius:999px;background:var(--soft);color:var(--muted)}
.desc{min-width:280px;max-width:560px}
.fallback{color:var(--muted);font-style:italic}
.chips{display:flex;flex-wrap:wrap;gap:4px;margin-top:6px}
.chip{font-size:11px;padding:0 6px;border:1px solid var(--border);border-radius:4px;color:var(--muted)}
.owner{min-width:200px}
.who{display:inline-flex;align-items:center;gap:7px;font-weight:600;white-space:nowrap}
.dot{width:10px;height:10px;border-radius:50%;flex:none}
.pct{font-weight:400;color:var(--muted);font-variant-numeric:tabular-nums}
.tag{font-size:11px;font-weight:600;color:var(--warn);border:1px solid currentColor;border-radius:4px;padding:0 5px}
.bar{display:flex;height:6px;border-radius:3px;overflow:hidden;background:var(--soft);margin-top:6px;min-width:140px;gap:1px}
.share-cell{min-width:180px}
.split{display:block;font-size:12px;color:var(--muted);margin-top:3px}
.last{white-space:nowrap}
.toolbar{display:flex;flex-wrap:wrap;gap:8px;align-items:center;margin-bottom:12px}
input[type=search],select{font:inherit;padding:7px 10px;border:1px solid var(--border);border-radius:8px;background:var(--bg);color:var(--text)}
input[type=search]{flex:1 1 260px;min-width:0}
.check{display:inline-flex;gap:6px;align-items:center;color:var(--muted)}
.count{margin-left:auto;color:var(--muted);font-size:13px}
.segmented{display:inline-flex;border:1px solid var(--border);border-radius:8px;overflow:hidden}
.segmented button{font:inherit;border:0;background:var(--bg);color:var(--muted);padding:7px 12px;cursor:pointer}
.segmented button+button{border-left:1px solid var(--border)}
.segmented button[aria-pressed=true]{background:var(--text);color:var(--surface)}
.field{display:inline-flex;gap:4px;flex-wrap:wrap}
select:disabled{opacity:.5}
button.ghost{font:inherit;font-size:13px;border:1px solid var(--border);background:none;color:var(--text);border-radius:8px;padding:6px 10px;cursor:pointer}
button.ghost:hover{background:var(--soft)}
.tree-only{display:none;gap:6px}
.is-tree .tree-only{display:inline-flex}
#files.tree td.file{padding-left:calc(10px + var(--depth) * 20px)}
#files.tree .path .dir{display:none}
tr.folder{cursor:pointer}
tr.folder td{background:color-mix(in srgb,var(--soft) 55%,transparent)}
.folder-name{display:flex;align-items:center;gap:4px;font-weight:600}
.folder-name .path{word-break:normal}
.twisty{width:24px;height:24px;flex:none;margin-left:-6px;border:0;border-radius:4px;background:none;color:var(--muted);cursor:pointer;font-size:17px;line-height:1;transition:transform .15s}
.twisty:hover{background:var(--soft);color:var(--text)}
tr.folder.open .twisty{transform:rotate(90deg)}
.fallback-plain{color:var(--muted)}
button.link{font:inherit;color:inherit;background:none;border:0;padding:0;cursor:pointer;text-align:left}
button.link:hover{text-decoration:underline}
:focus-visible{outline:2px solid var(--focus);outline-offset:2px}
@media (max-width:640px){main{padding-top:20px}section{padding:14px}.count{margin-left:0;width:100%}}
''';

const _js = r'''
const table = document.getElementById('files');
const body = table.tBodies[0];
const rows = [...body.rows];
const files = rows.filter((row) => row.dataset.kind === 'file');
const folders = rows.filter((row) => row.dataset.kind === 'dir');
const parentOf = new Map(folders.map((row) => [row.dataset.path, row.dataset.parent]));
const q = document.getElementById('q');
const person = document.getElementById('person');
const mode = document.getElementById('mode');
const area = document.getElementById('area');
const shared = document.getElementById('shared');
const count = document.getElementById('count');
const viewButtons = document.querySelectorAll('[data-view]');
const expanded = new Set();
let view = 'list';
try { if (localStorage.getItem('ownership.view') === 'tree') view = 'tree'; } catch (e) {}

function filtering() {
  return Boolean(q.value.trim() || person.value || area.value || shared.checked);
}
function matches(row) {
  const text = q.value.trim().toLowerCase();
  if (text && !row.dataset.search.includes(text)) return false;
  if (person.value) {
    const hit = mode.value === 'owner'
      ? row.dataset.owner === person.value
      : row.dataset.contributors.split('|').includes(person.value);
    if (!hit) return false;
  }
  if (area.value && row.dataset.area !== area.value) return false;
  if (shared.checked && row.dataset.shared !== '1') return false;
  return true;
}
// A row shows in the tree when every folder above it is open.
function isOpen(folder) {
  for (let path = folder; path; path = parentOf.get(path) || '') {
    if (!expanded.has(path)) return false;
  }
  return true;
}
// reveal: open the folders that hold a match (after a filter change).
function apply(reveal) {
  mode.disabled = !person.value;
  const hits = new Set(files.filter(matches));
  const live = new Set();
  for (const row of hits) {
    for (let path = row.dataset.parent; path; path = parentOf.get(path) || '') live.add(path);
  }
  if (reveal && view === 'tree' && filtering()) live.forEach((path) => expanded.add(path));
  const tree = view === 'tree';
  table.classList.toggle('tree', tree);
  document.body.classList.toggle('is-tree', tree);
  for (const row of files) row.hidden = !hits.has(row) || (tree && !isOpen(row.dataset.parent));
  for (const row of folders) {
    const open = expanded.has(row.dataset.path);
    row.hidden = !tree || !live.has(row.dataset.path) || !isOpen(row.dataset.parent);
    row.classList.toggle('open', open);
    const twisty = row.querySelector('.twisty');
    twisty.setAttribute('aria-expanded', String(open));
    twisty.setAttribute('aria-label', `${open ? 'Close' : 'Open'} ${row.dataset.path}`);
  }
  count.textContent = hits.size === files.length
    ? `${files.length} files`
    : `${hits.size} of ${files.length} files match`;
}
function setView(next) {
  view = next;
  try { localStorage.setItem('ownership.view', next); } catch (e) {}
  viewButtons.forEach((btn) => btn.setAttribute('aria-pressed', String(btn.dataset.view === next)));
  if (next === 'tree') {
    table.querySelectorAll('th[aria-sort]').forEach((th) => th.removeAttribute('aria-sort'));
    rows.slice()
      .sort((a, b) => Number(a.dataset.order) - Number(b.dataset.order))
      .forEach((row) => body.appendChild(row));
  }
  apply(true);
}
viewButtons.forEach((btn) => btn.addEventListener('click', () => setView(btn.dataset.view)));
[q, person, mode, area, shared].forEach((el) => el.addEventListener('input', () => apply(true)));
body.addEventListener('click', (event) => {
  const row = event.target.closest('tr.folder');
  if (!row) return;
  const path = row.dataset.path;
  if (expanded.has(path)) expanded.delete(path); else expanded.add(path);
  apply(false);
});
document.getElementById('expand').addEventListener('click', () => {
  folders.forEach((row) => expanded.add(row.dataset.path));
  apply(false);
});
document.getElementById('collapse').addEventListener('click', () => {
  expanded.clear();
  apply(false);
});
function showFiles(set) {
  set();
  apply(true);
  table.scrollIntoView({behavior: 'smooth'});
}
document.querySelectorAll('[data-person]').forEach((btn) =>
  btn.addEventListener('click', () => showFiles(() => {
    person.value = btn.dataset.person;
    mode.value = btn.dataset.mode;
  })));
document.querySelectorAll('[data-area-filter]').forEach((btn) =>
  btn.addEventListener('click', () => showFiles(() => { area.value = btn.dataset.areaFilter; })));
document.querySelectorAll('table[data-sortable]').forEach((sortable) => {
  const heads = sortable.querySelectorAll('th[data-sort]');
  heads.forEach((th) => th.addEventListener('click', () => {
    // Sorting mixes folders, so it always shows the flat list.
    if (sortable === table && view === 'tree') setView('list');
    const key = th.dataset.sort;
    const numeric = th.dataset.type === 'num';
    const dir = th.getAttribute('aria-sort') === 'ascending' ? -1 : 1;
    heads.forEach((other) => other.removeAttribute('aria-sort'));
    th.setAttribute('aria-sort', dir === 1 ? 'ascending' : 'descending');
    const tbody = sortable.tBodies[0];
    [...tbody.rows]
      .sort((a, b) => {
        const x = a.dataset[key] || '';
        const y = b.dataset[key] || '';
        return dir * (numeric ? Number(x) - Number(y) : x.localeCompare(y));
      })
      .forEach((row) => tbody.appendChild(row));
  }));
});
setView(view);
''';
