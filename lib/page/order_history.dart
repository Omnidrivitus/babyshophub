import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  static const String routePath = '/order-history';
  static const String routeName = 'Order History';

  @override
  State<StatefulWidget> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: colorScheme.surfaceContainerLowest,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colorScheme.onSurface),
          onPressed: () => context.go('/homeNav'),
        ),
        title: const Text(OrderHistoryPage.routeName),
      ),
    );
  }
}
