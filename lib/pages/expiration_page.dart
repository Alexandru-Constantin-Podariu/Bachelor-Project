import 'package:flutter/material.dart';
import 'expired_list.dart';
import '../model/Product.dart';
import '../database/database_repository.dart';
import 'delete_page.dart';
import 'add_page.dart';
import 'edit_page.dart';

 
class ExpirationPage extends StatefulWidget {
  @override
  State<ExpirationPage> createState() => _ExpirationPageState();
}

class _ExpirationPageState extends State<ExpirationPage> {
  DatabaseRepository dbrepo = DatabaseRepository.Instance;
  late Future<List<Product>> productsFuture;
  String path = '';

  Future<List<Product>> getProductsFromFuture() async {
    List<Product> products = await dbrepo.getProducts();
    path = await dbrepo.getDatabasePath();
    return products;
  }

  @override
  void initState() {
    super.initState();
    productsFuture = getProductsFromFuture();
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text("View Expired Products"),
      ),
      body: FutureBuilder(
        future: productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) 
          {
            return CircularProgressIndicator();
          }
           else if (snapshot.hasError)
         {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Product> products = snapshot.data as List<Product>;
            
            return ExpiredList(
              products: products,
              onEditProductClick: navigateToEditProductPage,
              onDeleteProductClick: navigateToDeleteProductPage,
            );
          }
        },
      ),
    );
  }

  void navigateToAddProductPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductPage(
          onAddProduct: (Product newProduct) {
            setState(() {
              dbrepo.add(newProduct);
              productsFuture = getProductsFromFuture();
            });
          },
        ),
      ),
    );

  }

  void navigateToEditProductPage(Product product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductPage(
          product: product,
          onEditProduct: (Product editedProduct) {
            setState(() {
              editedProduct.id = product.id;
              dbrepo.edit(editedProduct);
              productsFuture = getProductsFromFuture();
            });
          },
        ),
      ),
    );
  }

  void navigateToDeleteProductPage(Product product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeletePage(
          product: product,
          onDeleteProduct: (Product deletedProduct) {
            setState(() {
              dbrepo.delete(deletedProduct.id!);
              productsFuture = getProductsFromFuture();
            });
          },
        ),
      ),
    );
  }

  
}