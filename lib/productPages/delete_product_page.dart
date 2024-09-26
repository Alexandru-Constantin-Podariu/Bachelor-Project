import 'package:flutter/material.dart';
import '../model/Product.dart';


class DeleteProductPage extends StatelessWidget {
  final Product product;
  final Function(Product) onDeleteProduct;

  DeleteProductPage({required this.product, required this.onDeleteProduct});

  String getMessage()
  {
    if(product.sgr == 1)
    {
      return "This bottle has a SGR Warranty. Make sure you return the bottle to a store to get the Warranty back!";
    }
    else
    {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Product'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Are you sure you want to delete the product "${product.name}"?',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 50),
            Text(
              getMessage(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                      onDeleteProduct(product);
                      Navigator.pop(context, true);
                  },
                  child: const Text('Yes'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('No'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}