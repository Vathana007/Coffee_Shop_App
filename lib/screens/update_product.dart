import 'package:flutter/material.dart';
import '../model/product_stock.dart';

class UpdateProduct extends StatefulWidget {
  final Product product;

  const UpdateProduct({super.key, required this.product});

  @override
  State<UpdateProduct> createState() => _UpdateProductstate();
}

class _UpdateProductstate extends State<UpdateProduct> {
  late TextEditingController _nameController;
  late TextEditingController _categoriesController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;
  late int _rating;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with product details
    _nameController = TextEditingController(text: widget.product.name);
    _categoriesController =
        TextEditingController(text: widget.product.category);
    _priceController =
        TextEditingController(text: widget.product.price.toString());
    _descriptionController =
        TextEditingController(text: widget.product.description);
    _imageUrlController = TextEditingController(text: widget.product.imageUrl);
    _rating = widget.product.rating.toInt();
  }

  void _updateProduct() {
    if (_nameController.text.isEmpty ||
        _categoriesController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _imageUrlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      widget.product.name = _nameController.text;
      widget.product.category = _categoriesController.text;
      widget.product.price = double.parse(_priceController.text);
      widget.product.description = widget.product.description;
      widget.product.imageUrl = _imageUrlController.text;
      widget.product.rating = _rating.toDouble();
    });

    Navigator.of(context).pop(true);
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
        prefixIcon: Icon(icon, color: Colors.grey),
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
    );
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
          'Product Update',
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
          padding: const EdgeInsets.all(16),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card Section
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
                //Rating
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
                    }),
                const SizedBox(height: 24),
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updateProduct,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      backgroundColor: const Color.fromARGB(255, 150, 148, 148),
                    ),
                    child: const Text(
                      'Update Product',
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
}
