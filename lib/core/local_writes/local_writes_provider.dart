import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'local_writes_store.dart';

/// The session's prototype writes. Kept alive: they must outlive every screen.
final localWritesStoreProvider = Provider<LocalWritesStore>(
  (ref) => LocalWritesStore(),
  name: 'localWritesStoreProvider',
);
