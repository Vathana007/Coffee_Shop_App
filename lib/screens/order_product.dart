import 'package:flutter/material.dart';
import 'package:coffee_shop_app/model/product_stock.dart';
import '../model/order_product.dart';
import '../screens/order_summary.dart';
import '../data/order_history.dart';

// A global list to store order history
List<Order> orderHistory = [];

class OrderProduct extends StatefulWidget {
  final Product product;

  const OrderProduct({super.key, required this.product});

  @override
  State<OrderProduct> createState() => _OrderProductState();
}

class _OrderProductState extends State<OrderProduct> {
  int _selectedSizeIndex = 1;
  int quantity = 1;
  bool _showFullDescription = false;
  bool _isButtonPressed = false;

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    product.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PlusJakartaSans',
                ),
              ),

              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    '${product.rating}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'PlusJakartaSans',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Text(
                _showFullDescription
                    ? product.description
                    : product.description.length > 100
                        ? '${product.description.substring(0, 100)}...'
                        : product.description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontFamily: 'PlusJakartaSans',
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _showFullDescription = !_showFullDescription;
                  });
                },
                child: Text(
                  _showFullDescription ? 'Read Less' : 'Read More',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Size Selection
              _buildSizeSelector(),
              const SizedBox(height: 16),

              // Quantity Selection
              _buildQuantitySelector(),
              const SizedBox(height: 16),

              // Buy Now Button
              _buildBuyButton(),
            ],
          ),
        ),
      ),
    );
  }

  // AppBar
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        'Detail',
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'PlusJakartaSans',
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  // Size Selector
  Widget _buildSizeSelector() {
    const sizes = ['S', 'M', 'L'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Size",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'PlusJakartaSans',
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(sizes.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ChoiceChip(
                label: Text(
                  sizes[index],
                  style: TextStyle(
                    color: _selectedSizeIndex == index
                        ? Colors.white
                        : Colors.black,
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 24,
                  ),
                ),
                selected: _selectedSizeIndex == index,
                selectedColor: const Color.fromARGB(255, 177, 175, 175),
                onSelected: (selected) {
                  setState(() {
                    _selectedSizeIndex = index;
                  });
                },
                checkmarkColor: Colors.white,
              ),
            );
          }),
        ),
      ],
    );
  }

  // Quantity Selector
  Widget _buildQuantitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quantity:',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'PlusJakartaSans'),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 194, 191, 191),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Decrement Button
              Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 232, 232, 232), 
                borderRadius: BorderRadius.circular(24),
              ),
              child: IconButton(
                onPressed: _decrementQuantity,
                icon: const Icon(Icons.remove),
                color: Colors.black,
              ),
            ),

              // Quantity Display
              Text(
                '$quantity',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              // Increment Button
              Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 232, 232, 232), 
                borderRadius: BorderRadius.circular(24),
              ),
              child: IconButton(
                onPressed: _incrementQuantity,
                icon: const Icon(Icons.add),
                color: Colors.black,
              ),
            ),
            ],
          ),
        ),
      ],
    );
  }

  // Buy Now Button
  Widget _buildBuyButton() {
    const sizes = ['S', 'M', 'L'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Product Price
        Text(
          "Price: \$${(widget.product.price * quantity).toStringAsFixed(2)}",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'PlusJakartaSans',
          ),
        ),

        MouseRegion(
          onEnter: (_) {
            setState(() {
              _isButtonPressed = true;
            });
          },
          onExit: (_) {
            setState(() {
              _isButtonPressed = false;
            });
          },
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _isButtonPressed
                  ? const Color(0xFFFF0000)
                  : const Color.fromARGB(255, 194, 191, 191),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
            ),
            onPressed: () {
              // Create an order
              final newOrder = Order(
                id: UniqueKey().toString(),
                product: widget.product,
                size: sizes[_selectedSizeIndex],
                quantity: quantity,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'You have ordered ${widget.product.name} x $quantity!',
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: const Color(0xFFFF0000),
                ),
              );

              // Add to order history
              OrderHistory().addOrder(newOrder);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      OrderSummary(orders: OrderHistory().orders),
                ),
              );

              // Optionally reset color after a delay
              Future.delayed(const Duration(milliseconds: 200), () {
                setState(() {
                  _isButtonPressed = false;
                });
              });
            },
            child: const Text(
              'Buy Now',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontFamily: 'PlusJakartaSans',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
