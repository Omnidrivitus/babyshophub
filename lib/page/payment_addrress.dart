import 'package:flutter/material.dart';

class PaymentAddressPage extends StatefulWidget {
  const PaymentAddressPage({super.key});

  static const String routePath = '/payment-address';

  @override
  State<PaymentAddressPage> createState() => _PaymentAddressPageState();
}

class _PaymentAddressPageState extends State<PaymentAddressPage> {
  
  final _formKey = GlobalKey<FormState>();
  
  // Address Controllers
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();

  // Payment Controllers
  final _cardNameController = TextEditingController();
  final _cardNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment & Address', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text("Shipping Address", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            TextFormField(
              controller: _streetController,
              decoration: const InputDecoration(labelText: 'Street Address', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(labelText: 'City', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _zipController,
                    decoration: const InputDecoration(labelText: 'Zip Code', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 20),
            const Text("Payment Method", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            TextFormField(
              controller: _cardNameController,
              decoration: const InputDecoration(labelText: 'Cardholder Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _cardNumberController,
              decoration: const InputDecoration(
                labelText: 'Card Number', 
                hintText: 'XXXX XXXX XXXX XXXX',
                border: OutlineInputBorder()
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 68, 87, 227),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Information Saved!')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Details', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}