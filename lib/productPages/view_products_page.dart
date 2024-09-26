import 'package:bachelor_project/main.dart';
import 'package:bachelor_project/recipePages/view_recipes_page.dart';
import 'package:bachelor_project/shoppingListPages/view_shoppingList_page.dart';
import 'package:flutter/material.dart';
import 'product_list.dart';
import '../model/Product.dart';
import '../database/database_repository.dart';
import 'delete_product_page.dart';
import '../productPages/add_product_page.dart';
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
        title: const Text("View Groceries"),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) 
          {
            return const CircularProgressIndicator();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToAddProductPage();
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home"),
            BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: "Groceries"),
            BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: "Recipes"),
            BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: "Shopping List"),
        ],
        currentIndex: 1,
        selectedItemColor: const Color.fromARGB(255, 243, 158, 79),
        unselectedItemColor: Colors.blue,
        onTap: (index){
          switch(index){
            case 0:

              Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage(title: "Kitchen Assist")));
              break;
            case 1:
              break;
            case 2: 

              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewRecipesPage()));
              break;
            case 3:

              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewShoppingListPage()));
              break;
            case 4:
               break;
          }
        }
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
        builder: (context) => DeleteProductPage(
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