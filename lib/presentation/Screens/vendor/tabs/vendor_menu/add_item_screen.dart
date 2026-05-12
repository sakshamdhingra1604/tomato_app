// screens/vendor/menu/add_item_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../core/services/firebase_menu_service.dart';
import '../../../../../core/services/storage_service.dart';

class AddItemScreen extends StatefulWidget {
  final Map<String, dynamic>? editData;
  final String? docId;

  const AddItemScreen({super.key, this.editData, this.docId});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _prepController;
  late TextEditingController _specialPriceController;
  late TextEditingController _descController; // New

  String _selectedCategory = 'Snacks';
  File? _image;
  String? _existingImageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _existingImageUrl = widget.editData?['imageUrl'];
    _nameController = TextEditingController(text: widget.editData?['itemName']);
    _priceController = TextEditingController(text: widget.editData?['price']?.toString());
    _prepController = TextEditingController(text: widget.editData?['prepTime']?.toString());
    _specialPriceController = TextEditingController(text: widget.editData?['specialPrice']?.toString());
    _descController = TextEditingController(text: widget.editData?['description']); // New
    _selectedCategory = widget.editData?['category'] ?? 'Snacks';
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 1000,
    );
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  void _saveItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      String? vId = await StorageService.getVendorId();
      if (vId == null) throw "Vendor ID not found!";

      if (widget.editData != null) {
        await FirebaseMenuService().updateItem(
          docId: widget.docId!,
          vendorId: vId,
          itemName: _nameController.text.trim(),
          price: int.parse(_priceController.text),
          specialPrice: int.tryParse(_specialPriceController.text),
          prepTime: int.parse(_prepController.text),
          category: _selectedCategory,
          description: _descController.text.trim(), // Added
          imageFile: _image,
          oldImageUrl: _existingImageUrl,
        );
      } else {
        await FirebaseMenuService().addItem(
          vendorId: vId,
          itemName: _nameController.text.trim(),
          price: int.parse(_priceController.text),
          specialPrice: int.tryParse(_specialPriceController.text),
          prepTime: int.parse(_prepController.text),
          category: _selectedCategory,
          description: _descController.text.trim(), // Added
          imageFile: _image,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Success! Menu Updated.")));
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.editData != null;
    // Theme Adaptation
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white, // Theme check
      appBar: AppBar(
        title: Text(isEdit ? "Edit Item" : "Add New Item"),
        backgroundColor: isDark ? Colors.black : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.redAccent))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180, width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[900] : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey.shade300),
                  ),
                  child: _image != null
                      ? ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.file(_image!, fit: BoxFit.cover))
                      : (_existingImageUrl != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: _existingImageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    ),
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 40, color: isDark ? Colors.grey[600] : Colors.grey),
                      const Text("Add Food Photo", style: TextStyle(color: Colors.grey))
                    ],
                  )),
                ),
              ),
              const SizedBox(height: 25),
              _buildTextField(_nameController, "Item Name*", Icons.fastfood, isDark, validator: (v) => v!.isEmpty ? "Enter item name" : null),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(_priceController, "Price (₹)*", Icons.currency_rupee, isDark, keyboardType: TextInputType.number,
                        validator: (v) => (v == null || int.tryParse(v) == null) ? "Invalid price" : null),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTextField(_specialPriceController, "Offer Price (₹)", Icons.local_offer, isDark, keyboardType: TextInputType.number),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _buildTextField(_prepController, "Prep Time (mins)*", Icons.timer, isDark, keyboardType: TextInputType.number,
                  validator: (v) => (v == null || int.tryParse(v) == null) ? "Enter time" : null),
              const SizedBox(height: 15),
              // NEW: OPTIONAL DESCRIPTION FIELD
              _buildTextField(_descController, "Item Description (Optional)", Icons.description, isDark, maxLines: 3),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(isEdit ? "UPDATE ITEM" : "SAVE ITEM", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Adaptive Field Builder
  Widget _buildTextField(TextEditingController controller, String label, IconData icon, bool isDark, {TextInputType keyboardType = TextInputType.text, int maxLines = 1, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.redAccent, size: 20),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.redAccent)),
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }
}