import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_screen.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';

class AppColors {
  static const Color background = Color(0xFF0D1B2A);
  static const Color container = Color(0xFF1B263B);
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color textLight = Color(0xFFDEE2E6);
  static const Color subtitle = Color(0xFF9BA9B4);
}

class ProfileScreen extends StatefulWidget {
  final int userId;
  ProfileScreen({required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _profile;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  void fetchProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final url = Uri.parse('http://16.171.62.76:8081/api/profile/${widget.userId}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        setState(() {
          _profile = jsonBody;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = json.decode(response.body)['error'] ?? "Unknown error occurred.";
          _profile = {};
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Network error: $e';
        _profile = {};
        _isLoading = false;
      });
    }
  }

  Widget _profileView() {
    if (_profile == null) return SizedBox.shrink();

    final username = (_profile!['username'] ?? 'Not available').toString();
    final email = (_profile!['email'] ?? 'Not available').toString();
    final address = (_profile!['address'] ?? 'Not available').toString();
    final phone = (_profile!['phone'] ?? 'Not available').toString();

    const titleStyle = TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold);
    const subtitleStyle = TextStyle(color: AppColors.subtitle);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(Icons.person, color: AppColors.primaryBlue),
          title: Text("Username", style: titleStyle),
          subtitle: Text(username, style: subtitleStyle),
        ),
        ListTile(
          leading: Icon(Icons.email, color: AppColors.primaryBlue),
          title: Text("Email", style: titleStyle),
          subtitle: Text(email, style: subtitleStyle),
        ),
        ListTile(
          leading: Icon(Icons.home, color: AppColors.primaryBlue),
          title: Text("Address", style: titleStyle),
          subtitle: Text(address, style: subtitleStyle),
        ),
        ListTile(
          leading: Icon(Icons.phone, color: AppColors.primaryBlue),
          title: Text("Phone", style: titleStyle),
          subtitle: Text(phone, style: subtitleStyle),
        ),
        const SizedBox(height: 24),
        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePasswordScreen(userId: widget.userId),
                ),
              );
            },
            icon: const Icon(Icons.lock),
            label: const Text("Change Password"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.container,
        title: const Text('Your Profile'),
        foregroundColor: AppColors.textLight,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Profile',
            onPressed: (_profile == null || _isLoading)
                ? null
                : () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(
                          username: (_profile?['username'] ?? '').toString(),
                          userId: widget.userId,
                          address: (_profile?['address'] ?? '').toString(),
                          phone: (_profile?['phone'] ?? '').toString(),
                        ),
                      ),
                    );
                    if (updated == true) fetchProfile();
                  },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.container,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue))
                  : (_error != null
                      ? Text(
                          _error!,
                          style: const TextStyle(color: Colors.redAccent, fontSize: 18),
                          textAlign: TextAlign.center,
                        )
                      : _profileView()),
            ),
          ),
        ),
      ),
    );
  }
}
