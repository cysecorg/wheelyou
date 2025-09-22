import 'package:flutter/material.dart';

class PurchaseConfirmationScreen extends StatelessWidget {
  const PurchaseConfirmationScreen({
    super.key,
    required this.vehicleTitle,
    required this.customerName,
    required this.customerEmail,
    required this.price,
  });

  final String vehicleTitle;
  final String customerName;
  final String customerEmail;
  final int price;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Purchase Confirmed"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 34),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_rounded, size: 70, color: Colors.green),
                  const SizedBox(height: 18),
                  Text(
                    "Thank you, $customerName!",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Your purchase of \"$vehicleTitle\" is confirmed.",
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "A receipt has been sent to:\n$customerEmail",
                    style: TextStyle(color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Total Amount: ₹ $price",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blue),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.home_rounded),
                    label: const Text("Back to Home"),
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
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
