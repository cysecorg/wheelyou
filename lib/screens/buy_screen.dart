import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'purchase_confirm.dart'; // Import your confirmation screen

class BuyScreen extends StatefulWidget {
  final int vehicleId;
  final String vehicleTitle;

  BuyScreen({required this.vehicleId, required this.vehicleTitle});

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  bool _submitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.30.10:8081/api/confirm-purchase'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "name": _nameCtrl.text.trim(),
          "email": _emailCtrl.text.trim(),
          "phone": _phoneCtrl.text.trim(),
          "address": _addressCtrl.text.trim(),
          "vehicle_id": widget.vehicleId,
          "price": null // optional, backend will use the real price
        }),
      );

      final res = json.decode(response.body);
      setState(() => _submitting = false);

      if (response.statusCode == 200 && res['status']?.toString().contains('confirmed') == true) {
        // Go to the Purchase Confirmation Screen!
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PurchaseConfirmationScreen(
              vehicleTitle: widget.vehicleTitle,
              customerName: _nameCtrl.text.trim(),
              customerEmail: _emailCtrl.text.trim(),
              price: res['price'] is int ? res['price'] : 0,
            ),
          ),
        );
      } else {
        setState(() {
          _errorMessage = res['error'] ?? res['message'] ?? "Purchase failed. Try again.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Network or server error. Please try again.";
        _submitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buy ${widget.vehicleTitle}"),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Vehicle: ${widget.vehicleTitle}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 14),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: InputDecoration(
                        labelText: "Full Name", prefixIcon: Icon(Icons.person)),
                    validator: (val) =>
                        val == null || val.trim().isEmpty ? "Please enter your name" : null,
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneCtrl,
                    decoration: InputDecoration(
                        labelText: "Phone Number", prefixIcon: Icon(Icons.phone)),
                    keyboardType: TextInputType.phone,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "Please enter your phone";
                      }
                      if (!RegExp(r'^\d{10,}$').hasMatch(val)) {
                        return "Enter a valid phone";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: InputDecoration(
                        labelText: "Email Address", prefixIcon: Icon(Icons.email)),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "Please enter your email";
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
                        return "Enter a valid email address";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _addressCtrl,
                    decoration: InputDecoration(
                        labelText: "Delivery Address (optional)",
                        prefixIcon: Icon(Icons.location_on)),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton.icon(
                    icon: Icon(Icons.shopping_cart_checkout_rounded),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        _submitting ? "Processing..." : "Confirm & Submit",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    onPressed: _submitting ? null : _submit,
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
