// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../auth/login_screen.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Profile")),
//       body: Consumer<AuthProvider>(
//         builder: (context, auth, child) {
//           final user = auth.user;
          
//           if (user == null) {
//               return const Center(child: Text("Not logged in"));
//           }

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 CircleAvatar(
//                   radius: 50,
//                   backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
//                   child: Text(
//                     user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?',
//                     style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(user.fullName, style: Theme.of(context).textTheme.headlineSmall),
//                 Text(user.email, style: const TextStyle(color: Colors.grey)),
//                 const SizedBox(height: 32),
                
//                 _ProfileItem(title: "Mobile", value: user.mobile ?? 'N/A', icon: Icons.phone),
//                 _ProfileItem(title: "Language", value: user.language ?? 'N/A', icon: Icons.language),
//                 _ProfileItem(title: "Literacy Level", value: user.literacyLevel ?? 'N/A', icon: Icons.school),
                
//                 const SizedBox(height: 48),
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     auth.logout();
//                     Navigator.of(context).pushAndRemoveUntil(
//                       MaterialPageRoute(builder: (_) => const LoginScreen()),
//                       (route) => false,
//                     );
//                   },
//                   icon: const Icon(Icons.logout),
//                   label: const Text("Logout"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red[50],
//                     foregroundColor: Colors.red,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class _ProfileItem extends StatelessWidget {
//   final String title;
//   final String value;
//   final IconData icon;

//   const _ProfileItem({required this.title, required this.value, required this.icon});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: ListTile(
//         leading: Icon(icon, color: Theme.of(context).primaryColor),
//         title: Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
//         subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//       ),
//     );
//   }
// }
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;

// // Assuming these exist based on your provided code
// import '../../providers/auth_provider.dart';
// import '../auth/login_screen.dart';
// // You might need to import your User model here to update it properly
// // import '../../models/user_model.dart'; 

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AuthProvider>(
//       builder: (context, auth, child) {
//         final user = auth.user;

//         if (user == null) {
//           return const Scaffold(body: Center(child: Text("Not logged in")));
//         }

//         return Scaffold(
//           appBar: AppBar(
//             title: const Text("Profile"),
//             actions: [
//               // 1. Edit Profile Icon
//               IconButton(
//                 icon: const Icon(Icons.edit),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       // Pass the current user and provider context
//                       builder: (_) => EditProfileScreen(authProvider: auth),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//           body: SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 CircleAvatar(
//                   radius: 50,
//                   backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
//                   child: Text(
//                     user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?',
//                     style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(user.fullName, style: Theme.of(context).textTheme.headlineSmall),
//                 Text(user.email, style: const TextStyle(color: Colors.grey)),
//                 const SizedBox(height: 32),
                
//                 // Added checks to ensure data isn't null
//                 _ProfileItem(title: "Mobile", value: user.mobile ?? 'N/A', icon: Icons.phone),
//                 _ProfileItem(title: "Language", value: user.language ?? 'N/A', icon: Icons.language),
//                 _ProfileItem(title: "Literacy Level", value: user.literacyLevel ?? 'N/A', icon: Icons.school),
                
//                 const SizedBox(height: 48),
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     auth.logout();
//                     Navigator.of(context).pushAndRemoveUntil(
//                       MaterialPageRoute(builder: (_) => const LoginScreen()),
//                       (route) => false,
//                     );
//                   },
//                   icon: const Icon(Icons.logout),
//                   label: const Text("Logout"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red[50],
//                     foregroundColor: Colors.red,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class _ProfileItem extends StatelessWidget {
//   final String title;
//   final String value;
//   final IconData icon;

//   const _ProfileItem({required this.title, required this.value, required this.icon});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: ListTile(
//         leading: Icon(icon, color: Theme.of(context).primaryColor),
//         title: Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
//         subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//       ),
//     );
//   }
// }

// // ---------------------------------------------------------------------------
// // 2. New Edit Profile Screen
// // ---------------------------------------------------------------------------

// class EditProfileScreen extends StatefulWidget {
//   final AuthProvider authProvider;

//   const EditProfileScreen({super.key, required this.authProvider});

//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
  
//   // Controllers
//   late TextEditingController _nameController;
//   late TextEditingController _emailController;
//   late TextEditingController _mobileController;
//   late TextEditingController _languageController;
//   late TextEditingController _literacyController;
  
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     final user = widget.authProvider.user!;
    
//     // Initialize controllers with existing data
//     _nameController = TextEditingController(text: user.fullName);
//     _emailController = TextEditingController(text: user.email);
//     _mobileController = TextEditingController(text: user.mobile ?? "");
//     _languageController = TextEditingController(text: user.language ?? "");
//     _literacyController = TextEditingController(text: user.literacyLevel ?? "");
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _mobileController.dispose();
//     _languageController.dispose();
//     _literacyController.dispose();
//     super.dispose();
//   }

//   Future<void> _updateProfile() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     // 1. Get User ID dynamically
//     // Assuming your User model has an 'id' or '_id' field.
//     // If your user model uses '_id', change user.id to user._id
//     final userId = widget.authProvider.user!.id; 
    
//     final url = Uri.parse("https://sarathi-ai-8hk8.onrender.com/api/users/update/$userId");

//     try {
//       // 2. Create Request Body
//       final body = jsonEncode({
//         "fullName": _nameController.text.trim(),
//         "email": _emailController.text.trim(),
//         "mobile": _mobileController.text.trim(),
//         "language": _languageController.text.trim(),
//         "literacyLevel": _literacyController.text.trim(),
//       });

//       // 3. Call API
//       final response = await http.put(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: body,
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         print(data);
//         // 4. Update Local State (Provider)
//         // We assume your AuthProvider has a method to update the user manually.
//         // If not, you might need to create one: `void setUser(User user) { ... }`
//         // Or re-parse the User object from data['user']
        
//         // Example logic to update provider:
//         // User updatedUser = User.fromJson(data['user']);
//         // widget.authProvider.updateUser(updatedUser); 

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Profile updated successfully")),
//         );
        
//         // Return to Profile Screen
//         Navigator.pop(context); 
//       } else {
//         throw Exception("Failed to update: ${response.body}");
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
//       );
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Edit Profile")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: "Full Name", border: OutlineInputBorder()),
//                 validator: (val) => val!.isEmpty ? "Name is required" : null,
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
//                 validator: (val) => val!.isEmpty ? "Email is required" : null,
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _mobileController,
//                 decoration: const InputDecoration(labelText: "Mobile", border: OutlineInputBorder()),
//                 keyboardType: TextInputType.phone,
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _languageController,
//                 decoration: const InputDecoration(labelText: "Language", border: OutlineInputBorder()),
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _literacyController,
//                 decoration: const InputDecoration(labelText: "Literacy Level", border: OutlineInputBorder()),
//               ),
//               const SizedBox(height: 32),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : _updateProfile,
//                   child: _isLoading 
//                     ? const CircularProgressIndicator(color: Colors.white) 
//                     : const Text("Save Changes"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';
// IMPORT YOUR MODEL HERE
import '../../models/user_model.dart'; 

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        final user = auth.user;

        if (user == null) {
          return const Scaffold(body: Center(child: Text("Not logged in")));
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("Profile"),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfileScreen(authProvider: auth),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Text(
                    user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?',
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                Text(user.fullName, style: Theme.of(context).textTheme.headlineSmall),
                Text(user.email, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 32),
                
                _ProfileItem(title: "Mobile", value: user.mobile ?? 'N/A', icon: Icons.phone),
                _ProfileItem(title: "Language", value: user.language ?? 'N/A', icon: Icons.language),
                _ProfileItem(title: "Literacy Level", value: user.literacyLevel ?? 'N/A', icon: Icons.school),
                
                const SizedBox(height: 48),
                ElevatedButton.icon(
                  onPressed: () {
                    auth.logout();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[50],
                    foregroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _ProfileItem({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Edit Profile Screen (Updated)
// ---------------------------------------------------------------------------

class EditProfileScreen extends StatefulWidget {
  final AuthProvider authProvider;

  const EditProfileScreen({super.key, required this.authProvider});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileController;
  late TextEditingController _languageController;
  late TextEditingController _literacyController;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = widget.authProvider.user!;
    _nameController = TextEditingController(text: user.fullName);
    _emailController = TextEditingController(text: user.email);
    _mobileController = TextEditingController(text: user.mobile ?? "");
    _languageController = TextEditingController(text: user.language ?? "");
    _literacyController = TextEditingController(text: user.literacyLevel ?? "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _languageController.dispose();
    _literacyController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final userId = widget.authProvider.user!.id; 
    
    // Dynamic URL based on ID
    final url = Uri.parse("https://sarathi-ai-8hk8.onrender.com/api/users/update/$userId");

    try {
      final body = jsonEncode({
        "fullName": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "mobile": _mobileController.text.trim(),
        "language": _languageController.text.trim(),
        "literacyLevel": _literacyController.text.trim(),
      });

      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // 1. Check if 'user' key exists in response
        if (data['user'] != null) {
           // 2. Convert JSON to User object
           // Make sure your User model handles the '_id' field coming from backend
           User updatedUser = User.fromJson(data['user']);
           
           // 3. Update Provider (This triggers the refresh on the previous page)
           widget.authProvider.fetchUserProfile(updatedUser.id!);
           
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text("Profile updated successfully")),
           );
           
           // 4. Return to previous screen (which is now refreshed)
           Navigator.pop(context);
        } else {
           throw Exception("User data missing in response");
        }

      } else {
        throw Exception("Failed to update: ${response.body}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Full Name", border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? "Name is required" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? "Email is required" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _mobileController,
                decoration: const InputDecoration(labelText: "Mobile", border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _languageController,
                decoration: const InputDecoration(labelText: "Language", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _literacyController,
                decoration: const InputDecoration(labelText: "Literacy Level", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateProfile,
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text("Save Changes"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}