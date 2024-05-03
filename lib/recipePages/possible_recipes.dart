import 'package:bachelor_project/model/PossibleRecipes.dart';

import '../model/Recipe.dart';
import 'package:flutter/material.dart';
class PossibleRecipes extends StatefulWidget {
  final List<Recipe> recipes;
  final Function(Recipe) onPrepareRecipeClick;

  PossibleRecipes({
    required this.recipes,
    required this.onPrepareRecipeClick,
  });

  @override
  _PossibleRecipesState createState() => _PossibleRecipesState();
}

class _PossibleRecipesState extends State<PossibleRecipes> {
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = RecipeCategories.first;
  }

  List<Recipe> filterPossibleRecipes()
  {
      List<Recipe> filteredRecipes = widget.recipes
        .where((recipe) => recipe.category == _selectedCategory)
        .toList();

      return filteredRecipes;
  }

  @override
  Widget build(BuildContext context) {
    List<Recipe> filteredRecipes;
    if(_selectedCategory == RecipeCategories.first)
    {
        filteredRecipes = widget.recipes.toList();
    }
    else
    {
      filteredRecipes = filterPossibleRecipes();
    }

    return Column(
      
      children: [
        Row(
          children: [
            const SizedBox(width: 10),
            const Text("Categories: "),
            const SizedBox(width: 10),
            DropdownButton<String>(
              value: _selectedCategory,
              items: RecipeCategories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredRecipes.length,
            itemBuilder: (context, index) {
              return RecipeListItem(
                recipe: filteredRecipes[index],
                onPrepareRecipeClick: widget.onPrepareRecipeClick,
              );
            },
          ),
        ),
      ],
    );
  }
}

class RecipeListItem extends StatelessWidget {
  final Recipe recipe;
  final Function(Recipe) onPrepareRecipeClick;

  RecipeListItem({
    required this.recipe,
    required this.onPrepareRecipeClick,
  });
  void selectCategory()
  {
    // getProductsFromFuture();
  }

  @override
  Widget build(BuildContext context) {
    
    return Card(
      margin: const EdgeInsets.all(4),
      color: Theme.of(context).colorScheme.onInverseSurface,
      child: ExpansionTile(
        title: Text(recipe.name,
            style: const TextStyle(fontSize: 25)),
        children: [
          ListTile(
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [              
                SizedBox(height: 10),
                SizedBox(
                width: 140,
                height: 40,
                child: ElevatedButton(
                  onPressed: () => onPrepareRecipeClick(recipe),
                
                  child: const Text('Prepare',
                      style: TextStyle(
                          fontSize: 20,
                        )))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  
}
