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
import '../../widgets/glass_scaffold.dart';
import '../../widgets/glass_container.dart';
 

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        final user = auth.user;

        if (user == null) {
          return const Scaffold(
            backgroundColor: Colors.transparent, 
            body: Center(child: Text("Not logged in", style: TextStyle(color: Colors.white)))
          );
        }

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text("Profile", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
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
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white.withOpacity(0.1),
                    child: Text(
                      user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?',
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(user.fullName, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white)),
                Text(user.email, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 32),
                
                GlassContainer(
                   padding: const EdgeInsets.symmetric(vertical: 8),
                   child: Column(
                     children: [
                        _ProfileItem(title: "Mobile", value: user.mobile ?? 'N/A', icon: Icons.phone),
                        _ProfileItem(title: "Language", value: user.language ?? 'N/A', icon: Icons.language),
                        _ProfileItem(title: "Literacy Level", value: user.literacyLevel ?? 'N/A', icon: Icons.school),
                     ]
                   )
                ),
                
                const SizedBox(height: 48),
                SizedBox(
                  width: 100,
                  child: ElevatedButton.icon(
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
                      backgroundColor: Colors.red.withOpacity(0.2),
                      foregroundColor: Colors.red[100],
                      elevation: 0,
                      side: BorderSide(color: Colors.red.withOpacity(0.5)),
                    ),
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
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(fontSize: 14, color: Colors.white60)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
    );
  }
}

// ---------------------------------------------------------------------------
// Edit Profile Screen (Updated)
// ---------------------------------------------------------------------------

// class EditProfileScreen extends StatefulWidget {
//   final AuthProvider authProvider;

//   const EditProfileScreen({super.key, required this.authProvider});

//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
  
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

//     final userId = widget.authProvider.user!.id; 
    
//     // Dynamic URL based on ID
//     final url = Uri.parse("https://sarathi-ai-8hk8.onrender.com/api/users/update/$userId");

//     try {
//       final body = jsonEncode({
//         "fullName": _nameController.text.trim(),
//         "email": _emailController.text.trim(),
//         "mobile": _mobileController.text.trim(),
//         "language": _languageController.text.trim(),
//         "literacyLevel": _literacyController.text.trim(),
//       });

//       final response = await http.put(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: body,
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
        
//         // 1. Check if 'user' key exists in response
//         if (data['user'] != null) {
//            // 2. Convert JSON to User object
//            // Make sure your User model handles the '_id' field coming from backend
//            User updatedUser = User.fromJson(data['user']);
           
//            // 3. Update Provider (This triggers the refresh on the previous page)
//            widget.authProvider.fetchUserProfile(updatedUser.id!);
           
//            ScaffoldMessenger.of(context).showSnackBar(
//              const SnackBar(content: Text("Profile updated successfully")),
//            );
           
//            // 4. Return to previous screen (which is now refreshed)
//            Navigator.pop(context);
//         } else {
//            throw Exception("User data missing in response");
//         }

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
//     return GlassScaffold(
//       appBar: AppBar(
//         title: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: GlassContainer(
//           padding: const EdgeInsets.all(16),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: _nameController,
//                   style: const TextStyle(color: Colors.white),
//                   decoration: const InputDecoration(
//                     labelText: "Full Name",
//                     labelStyle: TextStyle(color: Colors.white70),
//                     enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
//                     focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
//                   ),
//                   validator: (val) => val!.isEmpty ? "Name is required" : null,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _emailController,
//                   style: const TextStyle(color: Colors.white),
//                   decoration: const InputDecoration(
//                     labelText: "Email",
//                     labelStyle: TextStyle(color: Colors.white70),
//                     enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
//                     focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
//                   ),
//                   validator: (val) => val!.isEmpty ? "Email is required" : null,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _mobileController,
//                   keyboardType: TextInputType.phone,
//                   style: const TextStyle(color: Colors.white),
//                   decoration: const InputDecoration(
//                     labelText: "Mobile",
//                     labelStyle: TextStyle(color: Colors.white70),
//                     enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
//                     focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _languageController,
//                   style: const TextStyle(color: Colors.white),
//                   decoration: const InputDecoration(
//                     labelText: "Language",
//                     labelStyle: TextStyle(color: Colors.white70),
//                     enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
//                     focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _literacyController,
//                   style: const TextStyle(color: Colors.white),
//                   decoration: const InputDecoration(
//                     labelText: "Literacy Level",
//                     labelStyle: TextStyle(color: Colors.white70),
//                     enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
//                     focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
//                   ),
//                 ),
//                 const SizedBox(height: 32),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: _isLoading ? null : _updateProfile,
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         foregroundColor: Theme.of(context).primaryColor,
//                     ),
//                     child: _isLoading 
//                       ? SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(strokeWidth: 2, color: Theme.of(context).primaryColor)
//                         ) 
//                       : const Text("Save Changes"),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
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
  
  // -- Dropdown Data --
  final List<String> _languages = ['English', 'Malayalam', 'Hindi', 'Tamil'];
  final List<String> _literacyLevels = ['Beginner', 'Intermediate', 'Advanced'];
  
  // -- Dropdown Selection State --
  late String _selectedLanguage;
  late String _selectedLiteracy;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = widget.authProvider.user!;
    _nameController = TextEditingController(text: user.fullName);
    _emailController = TextEditingController(text: user.email);
    _mobileController = TextEditingController(text: user.mobile ?? "");

    // Initialize Language Dropdown
    // If user has a language set and it exists in our list, use it. Otherwise default to first item.
    if (user.language != null && _languages.contains(user.language)) {
      _selectedLanguage = user.language!;
    } else {
      _selectedLanguage = _languages[0]; 
    }

    // Initialize Literacy Dropdown
    if (user.literacyLevel != null && _literacyLevels.contains(user.literacyLevel)) {
      _selectedLiteracy = user.literacyLevel!;
    } else {
      _selectedLiteracy = _literacyLevels[0];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    // No need to dispose strings
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final userId = widget.authProvider.user!.id; 
    
    final url = Uri.parse("https://sarathi-ai-8hk8.onrender.com/api/users/update/$userId");

    try {
      final body = jsonEncode({
        "fullName": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "mobile": _mobileController.text.trim(),
        "language": _selectedLanguage, // Use selected dropdown value
        "literacyLevel": _selectedLiteracy, // Use selected dropdown value
      });

      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['user'] != null) {
           User updatedUser = User.fromJson(data['user']);
           
           // Update Provider
           // Note: You might need to make sure fetchUserProfile doesn't overwrite 
           // local state immediately if async issues arise, but usually this is fine.
           await widget.authProvider.fetchUserProfile(updatedUser.id!);
           
           if (!mounted) return;

           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text("Profile updated successfully")),
           );
           
           Navigator.pop(context);
        } else {
           throw Exception("User data missing in response");
        }

      } else {
        throw Exception("Failed to update: ${response.body}");
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Helper widget to style the Dropdowns consistently
  InputDecoration _glassInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      appBar: AppBar(
        title: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: GlassContainer(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Full Name
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _glassInputDecoration("Full Name"),
                  validator: (val) => val!.isEmpty ? "Name is required" : null,
                ),
                const SizedBox(height: 16),
                
                // Email
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _glassInputDecoration("Email"),
                  validator: (val) => val!.isEmpty ? "Email is required" : null,
                ),
                const SizedBox(height: 16),
                
                // Mobile
                TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.white),
                  decoration: _glassInputDecoration("Mobile"),
                ),
                const SizedBox(height: 16),
                
                // Language Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedLanguage,
                  dropdownColor: Colors.black87, // Dark background for the menu popup
                  style: const TextStyle(color: Colors.white), // White text for selected item
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  decoration: _glassInputDecoration("Language"),
                  items: _languages.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedLanguage = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                
                // Literacy Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedLiteracy,
                  dropdownColor: Colors.black87, // Dark background for the menu popup
                  style: const TextStyle(color: Colors.white),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  decoration: _glassInputDecoration("Literacy Level"),
                  items: _literacyLevels.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedLiteracy = newValue!;
                    });
                  },
                ),

                const SizedBox(height: 32),
                
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updateProfile,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Theme.of(context).primaryColor,
                    ),
                    child: _isLoading 
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Theme.of(context).primaryColor)
                        ) 
                      : const Text("Save Changes"),
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