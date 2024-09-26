//import 'dart:ffi';

import 'package:bachelor_project/database/database_repository.dart';
import 'package:bachelor_project/model/Recipe.dart';
import 'package:bachelor_project/model/RecipeFunctions.dart';
import 'package:bachelor_project/productPages/view_products_page.dart';
import 'package:bachelor_project/recipePages/view_recipes_page.dart';
import 'package:bachelor_project/shoppingListPages/view_shoppingList_page.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kitchen Assist',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 228, 174, 103),
            brightness: Brightness.light),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 228, 174, 103),
            brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Kitchen Assist'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseRepository dbrepo = DatabaseRepository.Instance;
  int productsInDB = 0,
      recipesInDB = 0,
      itemsInSL = 0,
      expiredInDB = 0,
      freshInDB = 0,
      expiringInDB = 0,
      sgrInDB = 0,
      available = 0,
      missing = 0,
      unavailable = 0;

  Future<int> getCurrentStatus() async {
    productsInDB = await dbrepo.getTotalNumberOfProductsInDB();
    recipesInDB = await dbrepo.getTotalNumberOfRecipesInDB();
    itemsInSL = await dbrepo.getTotalNumberOfItemsInSL();
    freshInDB = await dbrepo.getTotalNumberOfFreshProductsInDB();
    expiredInDB = await dbrepo.getTotalNumberOfExpiredProductsInDB();
    expiringInDB = productsInDB - expiredInDB - freshInDB;
    sgrInDB = await dbrepo.getTotalNumberOfSGRProductsInDB();

    List<Recipe> recipes = await dbrepo.getRecipes();
    
    for (Recipe recipe in recipes) {
      String status = await recipeStatus(recipe);
      if (status == "Possible") {
        available++;
      } else if (status == "NoneAreAvailable") {
        unavailable++;
      }
      else{
        missing++;
      }
    }
    return 1;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(widget.title, textAlign: TextAlign.center),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 100),
          const Text("Welcome to your Kitchen Assistant",
              style: TextStyle(
                fontSize: 30,
              ),
              textAlign: TextAlign.center),
          const SizedBox(height: 80),
          const Text("Dashboard",
              style: TextStyle(
                fontSize: 25,
              ),
              textAlign: TextAlign.left),
          FutureBuilder<int>(
            future: getCurrentStatus(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Expanded(
                  child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          const TabBar(
                            tabs: [
                              Tab(text: 'Groceries'),
                              Tab(text: 'Recipes'),
                            ],
                          ),
                          Expanded(
                              child: TabBarView(
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Table(
                                    border: const TableBorder(
                                        horizontalInside:
                                            BorderSide(width: 0.5),
                                        verticalInside: BorderSide(width: 0.5),
                                        top: BorderSide(width: 0.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                    columnWidths: const {
                                      0: FlexColumnWidth(3),
                                      1: FlexColumnWidth(1),
                                    },
                                    children: [
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                            color: const Color.fromARGB(
                                                255, 188, 248, 133),
                                            padding: const EdgeInsets.all(2.0),
                                            child: const Text(
                                              "Fresh",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            color: const Color.fromARGB(
                                                255, 188, 248, 133),
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              "$freshInDB",
                                              textAlign: TextAlign.center,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                            color: const Color.fromARGB(
                                                255, 252, 248, 123),
                                            padding: const EdgeInsets.all(2.0),
                                            child: const Text(
                                              "Expiring this week",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            color: const Color.fromARGB(
                                                255, 252, 248, 123),
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              "$expiringInDB",
                                              textAlign: TextAlign.center,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                            color: const Color.fromARGB(
                                                255, 227, 107, 107),
                                            padding: const EdgeInsets.all(2.0),
                                            child: const Text(
                                              "Expired",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            color: const Color.fromARGB(
                                                255, 227, 107, 107),
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              "$expiredInDB",
                                              textAlign: TextAlign.center,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                            color: const Color.fromARGB(
                                                255, 140, 174, 249),
                                            padding: const EdgeInsets.all(2.0),
                                            child: const Text(
                                              "Total Groceries",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            color: const Color.fromARGB(
                                                255, 140, 174, 249),
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              "$productsInDB",
                                              textAlign: TextAlign.center,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                            color: const Color.fromARGB(
                                                255, 243, 158, 79),
                                            padding: const EdgeInsets.all(2.0),
                                            child: const Text(
                                              "Shopping List Items",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            color: const Color.fromARGB(
                                                255, 243, 158, 79),
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              "$itemsInSL",
                                              textAlign: TextAlign.center,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                            color: const Color.fromARGB(
                                                255, 162, 247, 210),
                                            padding: const EdgeInsets.all(2.0),
                                            child: const Text(
                                              "Bottles With SGR",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            color: const Color.fromARGB(
                                                255, 162, 247, 210),
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              "$sgrInDB",
                                              textAlign: TextAlign.center,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ])
                                    ],
                                  )),
                              Container(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Table(
                                    border: const TableBorder(
                                        horizontalInside:
                                            BorderSide(width: 0.5),
                                        verticalInside: BorderSide(width: 0.5)),
                                    columnWidths: const {
                                      0: FlexColumnWidth(3),
                                      1: FlexColumnWidth(1),
                                    },
                                    children: [
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                            color: const Color.fromARGB(
                                                255, 188, 248, 133),
                                            padding: const EdgeInsets.all(2.0),
                                            child: const Text(
                                              "Available",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            color: const Color.fromARGB(
                                                255, 188, 248, 133),
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              "$available",
                                              textAlign: TextAlign.center,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                            color: const Color.fromARGB(
                                                255, 252, 248, 123),
                                            padding: const EdgeInsets.all(2.0),
                                            child: const Text(
                                              "Missing Ingredients",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            color: const Color.fromARGB(
                                                255, 252, 248, 123),
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              "$missing",
                                              textAlign: TextAlign.center,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                            color: const Color.fromARGB(
                                                255, 227, 107, 107),
                                            padding: const EdgeInsets.all(2.0),
                                            child: const Text(
                                              "Unavailable",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            color: const Color.fromARGB(
                                                255, 227, 107, 107),
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              "$unavailable",
                                              textAlign: TextAlign.center,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                            color: const Color.fromARGB(
                                                255, 140, 174, 249),
                                            padding: const EdgeInsets.all(2.0),
                                            child: const Text(
                                              "Total Recipes",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            color: const Color.fromARGB(
                                                255, 140, 174, 249),
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              "$recipesInDB",
                                              textAlign: TextAlign.center,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ],
                                  )),
                            ],
                          ))
                        ],
                      )),
                );
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.food_bank), label: "Groceries"),
            BottomNavigationBarItem(
                icon: Icon(Icons.receipt), label: "Recipes"),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_basket), label: "Shopping List"),
          ],
          currentIndex: 0,
          selectedItemColor: const Color.fromARGB(255, 243, 158, 79),
          unselectedItemColor: Colors.blue,
          onTap: (index) {
            switch (index) {
              case 1:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewProductsPage()));
                break;
              case 2:
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ViewRecipesPage()));
                break;
              case 3:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewShoppingListPage()));
                break;
              case 4:
                break;
            }
          }),
    );
  }
}
