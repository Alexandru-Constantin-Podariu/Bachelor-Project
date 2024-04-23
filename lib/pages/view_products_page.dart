import 'package:flutter/material.dart';
import 'product_list.dart';
import '../model/Product.dart';
import '../database/database_repository.dart';
import 'delete_product_page.dart';
import 'add_product_page.dart';
import 'edit_product_page.dart';

 
class ViewProductsPage extends StatefulWidget {
  @override
  State<ViewProductsPage> createState() => _ViewProductsPageState();
}

class _ViewProductsPageState extends State<ViewProductsPage> {
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
        title: Text("View Pantry"),
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
            
            return ProductList(
              products: products,
              onEditProductClick: navigateToEditProductPage,
              onAddProductClick: navigateToAddProductPage,
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
              dbrepo.addProduct(newProduct);
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
              dbrepo.editProduct(editedProduct);
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
              dbrepo.deleteProduct(deletedProduct.id!);
              productsFuture = getProductsFromFuture();
            });
          },
        ),
      ),
    );
  }

  
}