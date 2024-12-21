import 'package:flutter/material.dart';
import 'package:coffee_shop_app/screens/order_summary.dart';
import 'package:coffee_shop_app/screens/order_product.dart';
import 'package:coffee_shop_app/screens/product_stock_screen.dart';
import 'package:coffee_shop_app/data/product_data.dart';
import 'package:coffee_shop_app/model/product_stock.dart';
import 'package:coffee_shop_app/widget/navbar_bottom.dart';
import 'package:coffee_shop_app/data/order_history.dart';

class CoffeeDashboard extends StatefulWidget {
  const CoffeeDashboard({super.key});

  @override
  State<CoffeeDashboard> createState() => _CoffeeDashboardState();
}

class _CoffeeDashboardState extends State<CoffeeDashboard> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedCategoryIndex = 0;
  int _currentIndex = 0;

  final List<String> _categories = ['All Drinks', 'Coffee', 'Matcha', 'Others'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const StockProduct()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderSummary(orders: OrderHistory().orders),
          ),
        );
        break;
    }
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
              'Guest, Phnom Penh',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontFamily: 'PlusJakartaSans',
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 16),
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildPromoBanner(),
            const SizedBox(height: 16),
            _buildCategoryChips(),
            const SizedBox(height: 10),
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
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        labelText: 'Search Coffee',
        labelStyle: const TextStyle(
            color: Color.fromARGB(255, 194, 191, 191), fontSize: 20),
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
    );
  }
  
  //Banner
  Widget _buildPromoBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF57C00), Color(0xFFFF9800), Color(0xFFFFC107)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.local_offer_rounded,
              color: Color(0xFFF57C00),
              size: 28,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Special Promotion!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Buy one coffee and get another absolutely FREE!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Type Drink
  Widget _buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.asMap().entries.map((entry) {
          int index = entry.key;
          String category = entry.value;
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

  //Card Product
  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OrderProduct(product: product),
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
                                Icons.add,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        OrderProduct(product: product),
                                  ),
                                );
                              },
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
