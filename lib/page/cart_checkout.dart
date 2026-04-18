import 'package:flutter/material.dart';

class CartCheckoutModel extends ChangeNotifier {
  void initState(BuildContext context) {}

  @override
  void dispose() {
    super.dispose();
  }
}

class CartCheckoutWidget extends StatefulWidget {
  const CartCheckoutWidget({super.key});

  static String routeName = 'CartCheckout';
  static String routePath = '/cartCheckout';

  @override
  State<CartCheckoutWidget> createState() => _CartCheckoutWidgetState();
}

class _CartCheckoutWidgetState extends State<CartCheckoutWidget> {
  late final CartCheckoutModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<_CartItem> _items = const [
    _CartItem(
      name: 'Air Max',
      description: 'Men\'s Sleeveless Fitness T-Shirt...',
      size: '12',
      price: 124.00,
      quantity: 1,
      imageUrl:
          'https://static.nike.com/a/images/t_prod_ss/w_640,c_limit,f_auto/95c8dcbe-3d3f-46a9-9887-43161ef949c5/sleepers-of-the-week-release-date.jpg',
    ),
    _CartItem(
      name: 'Air Max',
      description: 'Men\'s Sleeveless Fitness T-Shirt...',
      size: '12',
      price: 124.00,
      quantity: 1,
      imageUrl:
          'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/zwxes8uud05rkuei1mpt/air-max-90-mens-shoes-6n3vKB.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _model = CartCheckoutModel();
    _model.initState(context);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  double get _basePrice =>
      _items.fold<double>(0.0, (sum, item) => sum + item.price * item.quantity);

  double get _taxes => 24.20;
  double get _cleaningFee => 40.00;

  double get _total => _basePrice + _taxes + _cleaningFee;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isWide = MediaQuery.sizeOf(context).width > 900;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                SizedBox(
                  width: isWide ? 720 : double.infinity,
                  child: _buildCartPanel(context),
                ),
                SizedBox(
                  width: isWide ? 420 : double.infinity,
                  child: _buildSummaryPanel(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartPanel(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Cart',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Below is the list of items in your cart.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _items[index];
                return _CartItemTile(
                  item: item,
                  onRemove: () {},
                  onDecrease: () {},
                  onIncrease: () {},
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryPanel(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Below is a list of your items.',
              style: theme.textTheme.bodyMedium,
            ),
            const Divider(height: 32, thickness: 2),
            Text(
              'Price Breakdown',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _summaryRow('Base Price', _basePrice),
            const SizedBox(height: 8),
            _summaryRow('Taxes', _taxes),
            const SizedBox(height: 8),
            _summaryRow('Cleaning Fee', _cleaningFee),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Total',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.info_outlined,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                Text(
                  _formatMoney(_total),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: () {},
                child: const Text('Continue to Checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          _formatMoney(value),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  String _formatMoney(double value) => '\$${value.toStringAsFixed(2)}';
}

class _CartItem {
  const _CartItem({
    required this.name,
    required this.description,
    required this.size,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  final String name;
  final String description;
  final String size;
  final double price;
  final int quantity;
  final String imageUrl;
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({
    required this.item,
    required this.onRemove,
    required this.onDecrease,
    required this.onIncrease,
  });

  final _CartItem item;
  final VoidCallback onRemove;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.imageUrl,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Size: ${item.size}',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        onPressed: onDecrease,
                        icon: const Icon(Icons.remove),
                        style: IconButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          minimumSize: const Size(32, 32),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '${item.quantity}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: onIncrease,
                        icon: const Icon(Icons.add),
                        style: IconButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          minimumSize: const Size(32, 32),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(item.description, style: theme.textTheme.bodyMedium),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: onRemove,
              icon: Icon(Icons.delete_outline, color: colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
