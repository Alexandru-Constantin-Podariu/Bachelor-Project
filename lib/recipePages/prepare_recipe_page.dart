import 'package:bachelor_project/model/RecipeFunctions.dart';
import 'package:flutter/material.dart';
import '../model/Recipe.dart';

class PrepareRecipePage extends StatelessWidget {
  final Recipe recipe;
  final Function(Recipe, List<String>, int) onPrepareRecipe;

  PrepareRecipePage({required this.recipe, required this.onPrepareRecipe});

  int status = 1;
  String textToPrint = "Prepare recipe";

  Future<List<String>> checkAvailability() async {
    List<String> ingredientsList = await ingredientsStatus(recipe);
    status = 1;
    for (String ingredient in ingredientsList) {
      if (ingredient.contains("Not Available") || ingredient.contains("Missing")) {
        status = 0;
        textToPrint = "Add to Shoppinglist";
      }
    }
    return ingredientsList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prepare Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              recipe.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'Preparation time: ${recipe.time} minutes',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'Number of Servings ${recipe.servings}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            
            const SizedBox(height: 50),
            FutureBuilder<List<String>>(
              future: checkAvailability(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<String> ingredients = snapshot.data as List<String>;
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 200,
                          child: ListView.builder(
                            itemCount: ingredients.length,
                            itemBuilder: (context, index) {
                              return Text(
                                ingredients[index],
                                textAlign: TextAlign.left,
                                style: const TextStyle(fontSize: 20),
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
            Expanded(
                child: SizedBox(
              height: 200,
              child: Text(
                recipe.instructions,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
            )),
            const SizedBox(height: 50),
            FutureBuilder<List<String>>(
              future: checkAvailability(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<String> ingredients = snapshot.data as List<String>;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          onPrepareRecipe(recipe, ingredients, status);
                          Navigator.pop(context, true);
                        },
                        child: Text(textToPrint),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
