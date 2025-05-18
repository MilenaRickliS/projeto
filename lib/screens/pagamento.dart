import 'package:flutter/material.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  PaymentMethodScreenState createState() => PaymentMethodScreenState();
}

class PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String? _selectedPaymentMethod = 'Cartão';

  final List<Map<String, dynamic>> _paymentOptions = [
    {
      'label': 'Cartão',
      'icon': Icons.credit_card,
    },
    {
      'label': 'Boleto',
      'icon': Icons.receipt_long,
    },
    {
      'label': 'Pix',
      'icon': Icons.qr_code_2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forma de Pagamento'),
        backgroundColor: Color.fromARGB(255, 1, 88, 10),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Escolha sua forma de pagamento:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            ..._paymentOptions.map((option) {
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: _selectedPaymentMethod == option['label']
                        ? Color.fromARGB(255, 0, 160, 16)
                        : Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
                child: ListTile(
                  leading: Icon(option['icon'], color: Color.fromARGB(255, 0, 160, 16)),
                  title: Text(option['label']),
                  trailing: Radio<String>(
                    value: option['label'],
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                    activeColor: Color.fromARGB(255, 0, 160, 16),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedPaymentMethod = option['label'];
                    });
                  },
                ),
              );
            }),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Color.fromARGB(255, 1, 88, 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/confirm-order',
                    arguments: _selectedPaymentMethod,
                  );
                },
                child: const Text('Confirmar', style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
