import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        backgroundColor: Colors.pinkAccent,
      ),
      body: LayoutBuilder(
        builder: (ctx, constraints) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Hero(
                  tag: widget.product.imageLink,
                  child: Image.network(
                    widget.product.imageLink,
                    height: screenHeight * 0.4,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.product.brand,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'R\$ ${widget.product.price.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 24, color: Colors.pink, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.all(16),
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.pink[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      height: _expanded ? constraints.maxHeight * 0.4 : 100,
                      child: SingleChildScrollView(
                        physics: _expanded ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
                        child: Text(
                          widget.product.description.isNotEmpty
                              ? widget.product.description
                              : "Sem descrição disponível.",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
