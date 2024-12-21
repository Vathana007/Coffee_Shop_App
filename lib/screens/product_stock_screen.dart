import 'package:flutter/material.dart';
import 'package:coffee_shop_app/model/product_stock.dart';
import '../data/product_data.dart';
import 'add_product.dart';
import 'update_product.dart';
import 'coffee_dashboard.dart';
import 'package:coffee_shop_app/widget/navbar_bottom.dart';
import 'package:coffee_shop_app/screens/order_summary.dart';
import 'package:coffee_shop_app/data/order_history.dart';

class StockProduct extends StatefulWidget {
  const StockProduct({super.key});

  @override
  State<StockProduct> createState() => _StockProductState();
}

class _StockProductState extends State<StockProduct> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedCategoryIndex = 0;
  int _currentIndex = 1;

  final List<String> _categories = ['All Drinks', 'Coffee', 'Matcha', 'Others'];

  // BottomNavbar taps
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 0) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const CoffeeDashboard()),
        );
      } else if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderSummary(orders: OrderHistory().orders),
          ),
        );
      } else {
        setState(() {
          _currentIndex = index;
        });
      }
    });
  }

  // Delete Product
  void _deleteProduct(String id) {
    setState(() {
      products.removeWhere((product) => product.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        color: const Color.fromARGB(255, 58, 56, 56),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 50),
            const Text(
              'Product Stocks',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontFamily: 'PlusJakartaSans',
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildCategoryChips(),
            const SizedBox(height: 16),
            Expanded(child: _buildProductGrid()),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  //Search Bar
  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search Coffee',
              labelStyle: const TextStyle(
                  color: Color.fromARGB(255, 194, 191, 191),
                  fontSize: 20,
                  fontFamily: 'PlusJakartaSans'),
              prefixIcon: const Icon(Icons.search,
                  color: Color.fromARGB(255, 194, 191, 191), size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              fillColor: const Color.fromARGB(255, 121, 120, 120),
              filled: true,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            backgroundColor: const Color.fromARGB(255, 186, 186, 186),
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddProduct()),
            );
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ],
    );
  }

  //Type Drink
  Widget _buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.map((category) {
          int index = _categories.indexOf(category);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(
                category,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  color: _selectedCategoryIndex == index
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              selected: _selectedCategoryIndex == index,
              onSelected: (selected) {
                setState(() {
                  _selectedCategoryIndex = index;
                });
              },
              selectedColor: const Color.fromARGB(255, 121, 120, 120),
              backgroundColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              checkmarkColor: Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }

  //Check Drink
  Widget _buildProductGrid() {
    List<Product> filteredProducts = products.where((product) {
      if (_searchQuery.isNotEmpty &&
          !product.name.toLowerCase().contains(_searchQuery)) {
        return false;
      }

      if (_selectedCategoryIndex != 0) {
        final selectedCategory = _categories[_selectedCategoryIndex];
        if (selectedCategory == 'Others') {
          return product.category != 'Coffee' && product.category != 'Matcha';
        } else {
          return product.category == selectedCategory;
        }
      }
      return true;
    }).toList();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.6,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return _buildProductCard(product);
      },
    );
  }

  //Card Drink
  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => UpdateProduct(product: product),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150,
                  ),
                ),

                // Product Info
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.category,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 134, 133, 133),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 16,
                              icon: const Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                              onPressed: () => _deleteProduct(product.id),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),

            // Star Rating
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      product.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
