import 'package:bachelor_project/model/PossibleRecipes.dart';
import 'package:flutter/material.dart';
import '../model/Recipe.dart';

class CheckRecipePage extends StatelessWidget {
  final Recipe recipe;
  final Function(Recipe) onCheckRecipe;

  CheckRecipePage({required this.recipe, required this.onCheckRecipe});
  String check = "";

  Future<List<String>> checkAvailability() async {
    List<String> missingIngredients = await isRecipePossible(recipe);
    if (missingIngredients.isEmpty) {
      check = ("Is Possible");
      return (missingIngredients);
    }
    check = ("Is Not Possible");
    return (missingIngredients);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'The Recipe ${recipe.name}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            FutureBuilder<List<String>>(
              future: checkAvailability(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<String> ingredients = snapshot.data as List<String>;
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        check,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                      Expanded(
                        child: Container(                       
                          height: 200, 
                          child: ListView.builder(
                            itemCount: ingredients.length,
                            itemBuilder: (context, index) {
                              return Text(
                                ingredients[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
