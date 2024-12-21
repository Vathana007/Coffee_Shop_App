import 'package:flutter/material.dart';
import '../data/product_data.dart';
import 'package:coffee_shop_app/model/product_stock.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoriesController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  int _rating = 3;

  void _addProduct() {
    if (_formKey.currentState!.validate()) {
      final newProduct = Product(
        id: DateTime.now().toString(),
        name: _nameController.text,
        category: _categoriesController.text,
        price: double.parse(_priceController.text),
        imageUrl: _imageUrlController.text,
        rating: _rating.toDouble(),
        description: _descriptionController.text,
      );

      setState(() {
        products.add(newProduct);
      });
      Navigator.of(context).pop();
    }
  }

  Widget _buildImagePreview(String imageUrl) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400, width: 1),
        image: imageUrl.isNotEmpty
            ? DecorationImage(
                image: imageUrl.startsWith('http')
                    ? NetworkImage(imageUrl)
                    : AssetImage(imageUrl) as ImageProvider,
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: imageUrl.isEmpty
          ? const Center(
              child:
                  Text('Image Preview', style: TextStyle(color: Colors.grey)),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Product',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 150, 148, 148),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card Section for Input Fields
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildTextField(
                          label: 'Product Name',
                          controller: _nameController,
                          icon: Icons.label,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          label: 'Product Category',
                          controller: _categoriesController,
                          icon: Icons.category,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          label: 'Product Price',
                          controller: _priceController,
                          icon: Icons.attach_money,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          label: 'Product Description',
                          controller: _descriptionController,
                          icon: Icons.description,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          label: 'Image URL / Asset Path',
                          controller: _imageUrlController,
                          icon: Icons.image,
                        ),
                        const SizedBox(height: 12),
                        _buildImagePreview(_imageUrlController.text),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                // Rating Section
                const Text(
                  'Product Rating',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Slider(
                  value: _rating.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: _rating.toString(),
                  activeColor: const Color.fromARGB(255, 150, 148, 148),
                  inactiveColor: Colors.grey.shade300,
                  onChanged: (value) {
                    setState(() {
                      _rating = value.toInt();
                    });
                  },
                ),
                const SizedBox(height: 24),
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addProduct,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      backgroundColor: const Color.fromARGB(255, 150, 148, 148),
                    ),
                    child: const Text(
                      'Add Product',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 186, 186, 186)),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
      onChanged: (value) => setState(() {}),
    );
  }
}
