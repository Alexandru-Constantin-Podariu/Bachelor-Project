//import 'dart:ffi';

import 'package:bachelor_project/pages/view_page.dart';
import 'package:bachelor_project/pages/expiration_page.dart';
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
            seedColor: Color.fromARGB(255, 242, 215, 10),
            // primary:Color.fromARGB(255, 242, 215, 10) ,
            // onPrimary: Color.fromARGB(255, 242, 215, 10),
            // background: Color.fromARGB(255, 185, 83, 5),
            brightness: Brightness.light),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
       colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(255, 238, 213, 20),
            // primary:Color.fromARGB(255, 88, 78, 4),
            // onPrimary: Color.fromARGB(255, 88, 78, 4),
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
                  color: Colors.orange,
                  fontSize: 25,
                ),
                textAlign: TextAlign.center),
            const SizedBox(height: 100),
            SizedBox(
                width: 230,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ViewPage()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary),
                    child: const Text('View Pantry',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                        )))),
            const SizedBox(height: 10),
            SizedBox(
                width: 230,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExpirationPage()));
                  },
                  style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary),
                  child: const Text('Expiration Dates',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                      )),
                )),
            const SizedBox(height: 10),
            SizedBox(
                width: 230,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPage()));
                  },
                  style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary),
                  child: const Text('Meal Suggestions',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                      )),
                )),
            const SizedBox(height: 10),
            SizedBox(
                width: 230,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPage()));
                  },
                  style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary),
                  child: const Text('Shopping List',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                      )),
                )),
            const SizedBox(height: 10),
            SizedBox(
                width: 230,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPage()));
                  },
                  style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary),
                  child: const Text('Settings',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                      )),
                )),
          ],
        ),
      ),
    );
  }
}
