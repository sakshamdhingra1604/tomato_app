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

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Item" : "Add New Item")),
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
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: _image != null
                      ? ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.file(
                    _image!,
                    fit: BoxFit.cover,
                  ),)
                      : (_existingImageUrl != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: _existingImageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    ),
                  )
                      : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.add_a_photo, size: 40, color: Colors.grey), Text("Add Food Photo")],
                  )),
                ),
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Item Name*", border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? "Enter item name" : null,
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: "Regular Price (₹)*", border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (v) => (v == null || int.tryParse(v) == null) ? "Invalid price" : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _specialPriceController,
                      decoration: const InputDecoration(labelText: "Offer Price (₹)", border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _prepController,
                decoration: const InputDecoration(labelText: "Prep Time (mins)*", border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || int.tryParse(v) == null) ? "Enter time" : null,
              ),
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
}