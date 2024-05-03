//import 'dart:ffi';

import 'package:bachelor_project/recipePages/meal_recommendation_page.dart';
import 'package:bachelor_project/productPages/view_products_page.dart';
import 'package:bachelor_project/productPages/expiration_page.dart';
import 'package:bachelor_project/recipePages/view_recipes_page.dart';
import 'package:flutter/cupertino.dart';
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
      title: 'Digital Pantry',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(255, 228, 174, 103),
            // primary:Color.fromARGB(255, 255, 255, 255) ,
            // onPrimary: Color.fromARGB(255, 255, 255, 255),
            // background: Color.fromARGB(255, 236, 189, 88),

            brightness: Brightness.light),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
       colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(255, 228, 174, 103),
            // primary:Color.fromARGB(255, 0, 0, 0),
            // onPrimary: Color.fromARGB(255, 0, 0, 0),
            // background: Color.fromARGB(161, 67, 31, 4),
            brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Digital Pantry'),
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
  @override
  void initState() {
    super.initState();
  }

  void manageProduceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Manage your Produce'),
        );
      },
    );
  }
  void manageRecipesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Manage your Recipes'),
        );
      },
    );
  }
  void expiredProduceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('See expired or close to expired Produce'),
        );
      },
    );
  }
  void shoppingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('See your Shopping List'),
        );
      },
    );
  }
   void mealDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Get meal Recommendations'),
        );
      },
    );
  }
  void settingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Modify settings'),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(widget.title, textAlign: TextAlign.center),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("images/pic.jpeg"),
        //     fit: BoxFit.cover
        //   ),
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Welcome to your Pantry Management Application",
                style: TextStyle(
                  fontSize: 25,
                ),
                textAlign: TextAlign.center),
            const SizedBox(height: 100),
            SizedBox(
                width: 290,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ViewProductsPage()));
                    },
                    onLongPress: (){
                      manageProduceDialog();
                    },
                   
                   child: const Text('Manage Pantry',
                        style: TextStyle(
                          fontSize: 20,
                        )))),
            const SizedBox(height: 10),
            SizedBox(
                width: 290,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewRecipesPage()));
                  },
                  onLongPress: (){
                      manageRecipesDialog();
                    },
                  child: const Text('Manage Recipes',
                      style: TextStyle(                  
                        fontSize: 20,
                      )),
                )),
            const SizedBox(height: 10),
            SizedBox(
                width: 290,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ExpirationPage()));
                  },
                  onLongPress: (){
                      expiredProduceDialog();
                    },
                  child: const Text('Expiration Dates',
                      style: TextStyle(
                        fontSize: 20,
                      )),
                )),
            const SizedBox(height: 10),
            SizedBox(
                width: 290,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MealRecommendationPage()));
                  },
                  onLongPress: (){
                      shoppingDialog();
                    },
                  child: const Text('Meal Recommendations',
                      style: TextStyle(
                        fontSize: 20,
                      )),
                )),
            const SizedBox(height: 10),
            SizedBox(
                width: 290,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPage()));
                  },
                  onLongPress: (){
                      settingsDialog();
                    },
                  child: const Text('Settings',
                      style: TextStyle(
                        fontSize: 20,
                      )),
                )),
          ],
        ),
      ),
    );
  }
}
