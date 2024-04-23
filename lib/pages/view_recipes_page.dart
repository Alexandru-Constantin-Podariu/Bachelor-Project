import 'package:flutter/material.dart';
import 'recipe_list.dart';
import '../model/Recipe.dart';
import '../database/database_repository.dart';
import 'delete_recipe_page.dart';
import 'add_recipe_page.dart';
import 'edit_recipe_page.dart';

 
class ViewRecipesPage extends StatefulWidget {
  @override
  State<ViewRecipesPage> createState() => _ViewRecipesPageState();
}

class _ViewRecipesPageState extends State<ViewRecipesPage> {
  DatabaseRepository dbrepo = DatabaseRepository.Instance;
  late Future<List<Recipe>> recipesFuture;
  String path = '';

  Future<List<Recipe>> getRecipesFromFuture() async {
    List<Recipe> recipes = await dbrepo.getRecipes();
    path = await dbrepo.getDatabasePath();
    return recipes;
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
        title: Text("View Recipes"),
      ),
      body: FutureBuilder(
        future: recipesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) 
          {
            return CircularProgressIndicator();
          }
           else if (snapshot.hasError)
         {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Recipe> recipes = snapshot.data as List<Recipe>;
            
            return RecipeList(
              recipes: recipes,
              onEditRecipeClick: navigateToEditProductPage,
              onAddRecipeClick: navigateToAddProductPage,
              onDeleteRecipeClick: navigateToDeleteProductPage,
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
        builder: (context) => AddRecipePage(
          onAddRecipe: (Recipe newRecipe) {
            setState(() {
              dbrepo.addRecipe(newRecipe);
              recipesFuture = getRecipesFromFuture();
            });
          },
        ),
      ),
    );

  }

  void navigateToEditProductPage(Recipe recipe) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditRecipePage(
          recipe: recipe,
          onEditRecipe: (Recipe editedRecipe) {
            setState(() {
              editedRecipe.id = recipe.id;
              dbrepo.editRecipe(editedRecipe);
              recipesFuture = getRecipesFromFuture();
            });
          },
        ),
      ),
    );
  }

  void navigateToDeleteProductPage(Recipe recipe) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeleteRecipePage(
          recipe: recipe,
          onDeleteRecipe: (Recipe deletedRecipe) {
            setState(() {
              dbrepo.deleteRecipe(deletedRecipe.id!);
              recipesFuture = getRecipesFromFuture();
            });
          },
        ),
      ),
    );
  }

  
}