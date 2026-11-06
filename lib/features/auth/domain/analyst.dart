/// The signed-in analyst (HU-01). Every user of the app is an analyst.
///
/// A plain value class: it has three fields and no JSON yet. When the Supabase
/// repository arrives (S4) it can become a `@freezed` model with `fromJson`.
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
