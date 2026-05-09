import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../domain/entities/user_model.dart';
import '../../../injection.dart';


class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthRepository _authRepo = getIt<AuthRepository>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  // Selections
  String? selectedCollege;
  String? selectedDegree;
  String? selectedBlock;
  String selectedGender = "Male";
  bool isHosteller = false;
  bool isLoading = false;

  // Data Lists
  final List<String> colleges = ["Panipat Institute of Engineering and Technology (PIET)"];
  final List<String> blocks = ["Block A", "Block B", "Block C", "Block D", "Block E", "Block G", "Academics"];
  final List<String> degrees = [
    "B.Tech CSE", "B.Tech CSE AIML", "B.Tech CSE AIDS", "B.Tech ECE",
    "B.Tech Cyber Security", "B.Tech Mechanical", "B.Tech Textile", "B.Tech Civil",
    "Pharmacy", "BBA", "BCA", "MBA", "MCA", "BFAD", "BA"
  ];

  @override
  Widget build(BuildContext context) {
    bool isCollegeSelected = selectedCollege != null;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Setup Your Profile"), backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Pehle apna college chuno bhai,", style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 10),

              // 1. College Dropdown
              _buildDropdown("Select College", colleges, (val) => setState(() => selectedCollege = val)),

              const SizedBox(height: 20),
              const Divider(color: Colors.white10),
              const SizedBox(height: 10),

              // Rest of the fields (Opacity used to show they are locked)
              Opacity(
                opacity: isCollegeSelected ? 1.0 : 0.4,
                child: AbsorbPointer(
                  absorbing: !isCollegeSelected,
                  child: Column(
                    children: [
                      _buildTextField("Full Name", _nameController, Icons.person),
                      const SizedBox(height: 15),
                      _buildTextField("Roll Number", _rollController, Icons.numbers, isNumeric: true),
                      const SizedBox(height: 15),
                      _buildDropdown("Degree / Department", degrees, (val) => setState(() => selectedDegree = val)),
                      const SizedBox(height: 15),
                      _buildDropdown("Current Block", blocks, (val) => setState(() => selectedBlock = val)),
                      const SizedBox(height: 15),

                      // Age and Gender Row
                      Row(
                        children: [
                          Expanded(child: _buildTextField("Age", _ageController, Icons.cake, isNumeric: true)),
                          const SizedBox(width: 15),
                          Expanded(child: _buildDropdown("Gender", ["Male", "Female", "Other"], (val) => setState(() => selectedGender = val!))),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Hosteller Switch
                      SwitchListTile(
                        title: const Text("Are you a Hosteller?", style: TextStyle(color: Colors.white)),
                        value: isHosteller,
                        activeColor: AppColors.primaryYellow,
                        onChanged: (val) => setState(() => isHosteller = val),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Finish Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryYellow),
                  onPressed: (isCollegeSelected && !isLoading) ? _saveProfile : null,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text("FINISH SETUP", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---
  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool isNumeric = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.primaryYellow),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (v) => v!.isEmpty ? "Required" : null,
    );
  }

  Widget _buildDropdown(String hint, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      dropdownColor: Colors.grey[900],
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      hint: Text(hint, style: const TextStyle(color: Colors.white60)),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? "Required" : null,
    );
  }

  // --- Save Logic ---
  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        final user = FirebaseAuth.instance.currentUser;
        final userModel = UserModel(
          uid: user!.uid,
          name: _nameController.text.trim(),
          email: user.email!,
          college: selectedCollege!,
          degree: selectedDegree!,
          rollNumber: _rollController.text.trim(),
          year: "2026", // Isse tum dynamic bhi kar sakte ho
          block: selectedBlock!,
          isHosteller: isHosteller,
          gender: selectedGender,

        );

        await _authRepo.finalizeUserProfile(userModel);
        if (mounted) Navigator.pushReplacementNamed(context, '/main'); // MainScreen par bhejo
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      } finally {
        setState(() => isLoading = false);
      }
    }
  }
}