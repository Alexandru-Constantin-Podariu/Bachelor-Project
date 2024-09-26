import 'package:bachelor_project/main.dart';
import 'package:bachelor_project/model/ShoppingList.dart';
import 'package:bachelor_project/productPages/view_products_page.dart';
import 'package:bachelor_project/recipePages/view_recipes_page.dart';
import 'package:bachelor_project/shoppingListPages/add_Item_page.dart';
import 'package:flutter/material.dart';
import 'shopping_list.dart';
import '../database/database_repository.dart';
import 'delete_item_page.dart';
import 'edit_item_page.dart';

 
class ViewShoppingListPage extends StatefulWidget {
  @override
  State<ViewShoppingListPage> createState() => _ViewShoppingListPageState();
}

class _ViewShoppingListPageState extends State<ViewShoppingListPage> {
  DatabaseRepository dbrepo = DatabaseRepository.Instance;
  late Future<List<ShoppingList>> shoppingListFuture;

  Future<List<ShoppingList>> getShoppingListFromFuture() async {
    List<ShoppingList> items = await dbrepo.getShoppingList();
    return items;
  }

  @override
  void initState() {
    super.initState();
    shoppingListFuture = getShoppingListFromFuture();
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("View Shopping List"),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: shoppingListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) 
          {
            return const CircularProgressIndicator();
          }
           else if (snapshot.hasError)
         {
            return Text('Error: ${snapshot.error}');
          } else {
            List<ShoppingList> items = snapshot.data as List<ShoppingList>;
            
            return ShoppingListItems(
              items: items,
              onEditItemClick: navigateToEditItemPage,
              onAddItemClick: navigateToAddItemPage,
              onDeleteItemClick: navigateToDeleteItemPage,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToAddItemPage();
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
        currentIndex: 3,
        selectedItemColor: const Color.fromARGB(255, 243, 158, 79),
        unselectedItemColor: Colors.blue,
        onTap: (index){
          switch(index){
            case 0:
              
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage(title: "Kitchen Assist")));
              break;
            case 1:
            
              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewProductsPage()));
              break;
            case 2: 
       
              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewRecipesPage()));
              break;
            case 3:
               break;
            case 4:
               break;
          }
        }
        ),          
    );
  }

  void navigateToAddItemPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddItemPage(
          onAddItem: (ShoppingList newItem) {
            setState(() {
              dbrepo.addShoppingListItem(newItem);
              shoppingListFuture = getShoppingListFromFuture();
            });
          },
        ),
      ),
    );

  }

  void navigateToEditItemPage(ShoppingList item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditItemPage(
          item: item,
          onEditItem: (ShoppingList editedItem) {
            setState(() {
              editedItem.id = item.id;
              dbrepo.editShoppingListItem(editedItem);
              shoppingListFuture = getShoppingListFromFuture();
            });
          },
        ),
      ),
    );
  }

  void navigateToDeleteItemPage(ShoppingList item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeleteItemPage(
          item: item,
          onDeleteItem: (ShoppingList deletedItem) {
            setState(() {
              dbrepo.deleteShoppingListItem(deletedItem.id!);
              shoppingListFuture = getShoppingListFromFuture();
            });
          },
        ),
      ),
    );
  }

  
}