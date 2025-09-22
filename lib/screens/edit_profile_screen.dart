import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfileScreen extends StatefulWidget {
  final int userId;
  final String username;
  final String address;
  final String phone;

  EditProfileScreen({
    required this.userId,
    required this.username,
    required this.address,
    required this.phone,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _addrController;
  late TextEditingController _phoneController;
  bool _isLoading = false;
  String? _apiMessage;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.username);
    _addrController = TextEditingController(text: widget.address);
    _phoneController = TextEditingController(text: widget.phone);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _addrController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _apiMessage = null;
    });

    final url = Uri.parse('http://192.168.30.10:8081/api/profile/${widget.userId}');
    final resp = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "username": _usernameController.text,
        "address": _addrController.text,
        "phone": _phoneController.text,
      }),
    );

    setState(() => _isLoading = false);
    if (resp.statusCode == 200) {
      Navigator.pop(context, true); // Signal profile was updated
    } else {
      setState(() {
        _apiMessage = "Failed to update profile.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: "Username"),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Username can't be empty" : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _addrController,
                    decoration: InputDecoration(labelText: "Address"),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: "Phone"),
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _save,
                    child: _isLoading
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text("Save Changes"),
                  ),
                  if (_apiMessage != null)
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text(
                        _apiMessage!,
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
