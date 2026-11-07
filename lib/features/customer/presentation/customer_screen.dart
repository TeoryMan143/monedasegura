import 'package:flutter/material.dart';

import '../../../core/ui/placeholder_view.dart';

/// A-02 · Customer view (HU-03). [transactionId] (`?tx=`) is the transaction to open in
/// the N-02 panel.
///
/// Placeholder until HU-03 is built: the A-01 rows already open this route.
class CustomerScreen extends StatelessWidget {
  const CustomerScreen({
    required this.customerId,
    this.transactionId,
    super.key,
  });

  final String customerId;
  final String? transactionId;

  @override
  Widget build(BuildContext context) =>
      const PlaceholderView(title: 'Vista de cliente', story: 'HU-03');
}
