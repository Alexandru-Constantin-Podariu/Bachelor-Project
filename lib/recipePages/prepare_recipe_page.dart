import 'package:flutter/material.dart';
import '../model/Recipe.dart';


class PrepareRecipePage extends StatelessWidget {
  final Recipe recipe;
  final Function(Recipe) onPrepareRecipe;

  PrepareRecipePage({required this.recipe, required this.onPrepareRecipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prepare Recipe'),
      ),

      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${recipe.name}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              '${recipe.ingredients}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              '${recipe.instructions}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                      onPrepareRecipe(recipe);
                      Navigator.pop(context, true);
                  },
                  child: Text('Prepare Recipe'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}