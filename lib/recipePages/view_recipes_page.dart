import 'package:bachelor_project/main.dart';
import 'package:bachelor_project/model/RecipeFunctions.dart';
import 'package:bachelor_project/productPages/view_products_page.dart';
import 'package:bachelor_project/recipePages/prepare_recipe_page.dart';
import 'package:bachelor_project/shoppingListPages/view_shoppingList_page.dart';
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
  Map<int, String> statusOfRecipes = {}; 
  String path = '';

  Future<List<Recipe>> getRecipesFromFuture() async {
    List<Recipe> recipes = await dbrepo.getRecipes();
    

    for(Recipe recipe in recipes) 
    {
       String status = await recipeStatus(recipe);
       final entry = <int, String>{recipe.id!: status};
       statusOfRecipes.addEntries(entry.entries);
    }

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
        title: const Text("View Recipes"),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: recipesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) 
          {
            return const CircularProgressIndicator();
          }
           else if (snapshot.hasError)
         {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Recipe> recipes = snapshot.data as List<Recipe>;
            
            return RecipeList(
              recipes: recipes,
              statusOfRecipes: statusOfRecipes,
              onEditRecipeClick: navigateToEditRecipePage,
              onAddRecipeClick: navigateToAddRecipePage,
              onDeleteRecipeClick: navigateToDeleteRecipePage,
              onPrepareRecipeClick: navigateToPrepareRecipe,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToAddRecipePage();
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
        currentIndex: 2,
        selectedItemColor: const Color.fromARGB(255, 243, 158, 79),
        unselectedItemColor: Colors.blue,
        onTap: (index){
          switch(index){
            case 0:
             
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage(title: "Kitchen Assist")));
              break;
            case 1:
            
              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewProductsPage()));
            case 2:          
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

  void navigateToAddRecipePage() async {
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

  void navigateToEditRecipePage(Recipe recipe) async {
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

  void navigateToDeleteRecipePage(Recipe recipe) async {
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


  void navigateToPrepareRecipe(Recipe recipe) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrepareRecipePage(
          recipe: recipe,
          onPrepareRecipe: (Recipe preparedRecipe, List<String> ingredients, int status) {
            setState(() {
              if(status == 1) {
                updateInventory(preparedRecipe);
              }
              else {
                addToShoppingList(ingredients);
              }
              recipesFuture = getRecipesFromFuture();
            });
          },
        ),
      ),
    );
  }
}