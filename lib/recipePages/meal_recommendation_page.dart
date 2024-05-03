import 'package:bachelor_project/model/PossibleRecipes.dart';
import 'package:bachelor_project/recipePages/prepare_recipe_page.dart';
import 'package:flutter/material.dart';
import 'possible_recipes.dart';
import '../model/Recipe.dart';
import '../database/database_repository.dart';

class MealRecommendationPage extends StatefulWidget {
  @override
  State<MealRecommendationPage> createState() => _MealRecommendationPageState();
}

class _MealRecommendationPageState extends State<MealRecommendationPage> {
  DatabaseRepository dbrepo = DatabaseRepository.Instance;
  late Future<List<Recipe>> recipesFuture;
  String path = '';

  Future<List<Recipe>> getRecipesFromFuture() async {
    List<Recipe> recipes = await dbrepo.getRecipes();
    List<Recipe> possibleRecipes = [];

    for(Recipe recipe in recipes) 
    {
       List<String> missingIngredients = await isRecipePossible(recipe);
       if(missingIngredients.isEmpty)
       {
         possibleRecipes.add(recipe);
       }
    }

    return possibleRecipes;
  }

  @override
  void initState() {
    super.initState();
    recipesFuture = getRecipesFromFuture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("Meal Recommendations"),
      ),
      body: FutureBuilder(
        future: recipesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Recipe> recipes = snapshot.data as List<Recipe>;

            return PossibleRecipes(
              recipes: recipes,
              onPrepareRecipeClick: navigateToPrepareRecipePage,
            );
          }
        },
      ),
    );
  }
  void navigateToPrepareRecipePage(Recipe recipe) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrepareRecipePage(
          recipe: recipe,
          onPrepareRecipe: (Recipe preparedRecipe) {
            setState(() {
              updateInventory(preparedRecipe);
              recipesFuture = getRecipesFromFuture();
            });
          },
        ),
      ),
    );
  }
  
}
