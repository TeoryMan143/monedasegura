/// The signed-in analyst (HU-01). Every user of the app is an analyst.
///
/// A plain value class with three fields, built by the auth repository from the
/// Supabase user and `analysts.full_name`.
class Analyst {
  const Analyst({
    required this.id,
    required this.email,
    required this.fullName,
  });

  final String id;
  final String email;

  /// Name shown in the top bar and the user menu, e.g. «Laura Gómez».
  final String fullName;

  /// «laura.gomez@monedasegura.co» → «Laura Gomez». Falls back to «Analista».
  static String nameFromEmail(String email) {
    final local = email.split('@').first;
    final words = local
        .split(RegExp('[._-]+'))
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .toList();
    return words.isEmpty ? 'Analista' : words.join(' ');
  }

  @override
  bool operator ==(Object other) =>
      other is Analyst &&
      other.id == id &&
      other.email == email &&
      other.fullName == fullName;

  @override
  int get hashCode => Object.hash(id, email, fullName);

  @override
  String toString() => 'Analyst($id, $email)';
}
