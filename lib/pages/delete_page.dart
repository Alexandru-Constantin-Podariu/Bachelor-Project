import 'package:flutter/material.dart';
import '../model/Product.dart';


class DeletePage extends StatelessWidget {
  final Product product;
  final Function(Product) onDeleteProduct;

  DeletePage({required this.product, required this.onDeleteProduct});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Product'),
      ),

      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Are you sure you want to delete the product "${product.name}"?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                      onDeleteProduct(product);
                      Navigator.pop(context, true);
                  },
                  child: Text('Yes'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('No'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}