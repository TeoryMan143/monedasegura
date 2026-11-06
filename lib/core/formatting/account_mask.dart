/// Hides an account number except its last four characters: `•••• 4417`.
///
/// Also accepts `accounts.last4` directly. Spaces and dashes in [number] are ignored.
String maskAccount(String number) {
  final compact = number.replaceAll(RegExp(r'[\s-]'), '');
  final start = compact.length > 4 ? compact.length - 4 : 0;
  return '•••• ${compact.substring(start)}';
}
