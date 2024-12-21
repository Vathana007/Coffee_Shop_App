import 'package:flutter/material.dart';

class OrderSummary extends StatelessWidget {
  final List orders;

  // Constructor to pass orders directly
  const OrderSummary({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order History',
          style: TextStyle(fontFamily: 'PlusJakartaSans-Bold'),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: orders.isEmpty
          ? const Center(
              child: Text('No orders yet.',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontFamily: 'PlusJakartaSans')),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          order.product.imageUrl,
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(order.product.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'PlusJakartaSans',
                                )),
                            const SizedBox(height: 8),
                            Text(
                              "Price: \$${(order.product.price * order.quantity).toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontFamily: 'PlusJakartaSans'),
                            ),
                            Text(
                              'Size: ${order.size}',
                              style: const TextStyle(
                                  fontFamily: 'PlusJakartaSans'),
                            ),
                            Text(
                              'Quantity: ${order.quantity}',
                              style: const TextStyle(
                                  fontFamily: 'PlusJakartaSans'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
