import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'buy_screen.dart';

class VehicleDetailScreen extends StatefulWidget {
  final int vehicleId;

  VehicleDetailScreen({required this.vehicleId});

  @override
  _VehicleDetailScreenState createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  Map<String, dynamic>? vehicle;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVehicleDetail();
  }

  void fetchVehicleDetail() async {
    final url = Uri.parse('http://192.168.30.10:8081/api/vehicle/${widget.vehicleId}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        vehicle = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load vehicle details')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final darkBg = Theme.of(context).scaffoldBackgroundColor;

    if (isLoading) {
      return Scaffold(
        backgroundColor: darkBg,
        appBar: AppBar(title: Text('Loading...')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (vehicle == null) {
      return Scaffold(
        backgroundColor: darkBg,
        appBar: AppBar(title: Text('Vehicle Not Found')),
        body: Center(
          child: Text(
            'Vehicle data could not be loaded.',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        title: Text(vehicle!['title'] ?? 'Vehicle Details'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Information Card
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF1B263B),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicle!['title'] ?? '',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "₹ ${vehicle!['price'] ?? '--'}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          vehicle!['description'] ?? "No description available.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Image Section (Centered, Not Cropped)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        color: Colors.black12,
                        child: Image.asset(
                          'assets/${vehicle!['image'] ?? 'placeholder.png'}',
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 240,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            minimum: const EdgeInsets.fromLTRB(18, 8, 18, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  minimumSize: Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(Icons.shopping_cart_outlined),
                label: Text(
                  "Buy Now",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BuyScreen(
                        vehicleId: widget.vehicleId,
                        vehicleTitle: (vehicle!['title'] ?? 'Unknown').toString(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
