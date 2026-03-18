import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  String _selectedLanguage = 'English';
  final List<String> _languages = ['English', 'Malayalam', 'Hindi', 'Tamil'];
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Added dispose method to prevent memory leaks
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    
    final newUser = User(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      mobile: _mobileController.text.trim(),
      language: _selectedLanguage,
    );

    try {
      await authProvider.register(newUser, _passwordController.text.trim());

      if (!mounted) return;
      
      // Auto login or navigate to login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration successful! Please login.")),
      );
      Navigator.of(context).pop(); // Go back to login

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            margin: const EdgeInsets.all(0),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.black87),
                      decoration: const InputDecoration(
                        labelText: "Full Name",
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.black87),
                      decoration: const InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (v) => v!.contains('@') ? null : 'Invalid email',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: Colors.black87),
                      decoration: const InputDecoration(
                        labelText: "Mobile Number",
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      validator: (v) => v!.length >= 10 ? null : 'Invalid mobile',
                    ),
                    const SizedBox(height: 16),
                    // FIXED: Re-added the DropdownButtonFormField wrapper
                    DropdownButtonFormField<String>(
                      value: _selectedLanguage,
                      style: const TextStyle(color: Colors.black87),
                      decoration: const InputDecoration(
                        labelText: "Preferred Language",
                        prefixIcon: Icon(Icons.language),
                      ),
                      items: _languages.map((l) => DropdownMenuItem(
                        value: l, 
                        child: Text(l, style: const TextStyle(color: Colors.black87))
                      )).toList(),
                      onChanged: (v) => setState(() => _selectedLanguage = v!),
                    ),
                    const SizedBox(height: 16),
                    // DropdownButtonFormField<String>(
                    //   value: _selectedLiteracy,
                    //   dropdownColor: const Color(0xFF1A1A5E),
                    //   style: const TextStyle(color: Colors.white),
                    //   decoration: const InputDecoration(
                    //     labelText: "Literacy Level",
                    //     prefixIcon: Icon(Icons.school_outlined, color: Colors.white70),
                    //   ),
                    //   items: _literacyLevels.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                    //   onChanged: (v) => setState(() => _selectedLiteracy = v!),
                    // ),
                    // const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      style: const TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                        ),
                      ),
                      validator: (v) => v!.length >= 6 ? null : 'Min 6 chars',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      style: const TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                        ),
                      ),
                      validator: (v) => v!.isNotEmpty ? null : 'Required',
                    ),
                    const SizedBox(height: 32),
                    Consumer<AuthProvider>(
                      builder: (context, auth, child) {
                        return ElevatedButton(
                          onPressed: auth.isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: auth.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.white),
                                )
                              : const Text("REGISTER"),
                        );
                      },
                    ),
                  ], // FIXED: Added missing closing bracket for the Column's children
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}