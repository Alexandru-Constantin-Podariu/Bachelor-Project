import '../model/Recipe.dart';
import 'package:flutter/material.dart';
class RecipeList extends StatefulWidget {
  final List<Recipe> recipes;
  final Function(Recipe) onEditRecipeClick;
  final Function() onAddRecipeClick;
  final Function(Recipe) onDeleteRecipeClick;

  RecipeList({
    required this.recipes,
    required this.onEditRecipeClick,
    required this.onAddRecipeClick,
    required this.onDeleteRecipeClick,
  });

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = RecipeCategories.first;
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
      filteredRecipes = widget.recipes
        .where((recipe) => recipe.category == _selectedCategory)
        .toList();
    }

    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: widget.onAddRecipeClick,
              child: const Icon(Icons.add_circle),
              
            ),
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
                onEditRecipeClick: widget.onEditRecipeClick,
                onDeleteRecipeClick: widget.onDeleteRecipeClick,
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
  final Function(Recipe) onEditRecipeClick;
  final Function(Recipe) onDeleteRecipeClick;

  RecipeListItem({
    required this.recipe,
    required this.onEditRecipeClick,
    required this.onDeleteRecipeClick,
  });
  void selectCategory()
  {
    // getProductsFromFuture();
  }

  @override
  Widget build(BuildContext context) {
    
    return Card(
      margin: const EdgeInsets.all(4),
      color: Theme.of(context).colorScheme.onPrimary,
      child: ExpansionTile(
        title: Text(recipe.name,
            style: const TextStyle(color: Colors.red, fontSize: 25)),
        children: [
          ListTile(
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ingredients: ${recipe.ingredients}',
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                ),
                Text(
                  'Instructions:  ${recipe.instructions}',
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                icon: const Icon(Icons.delete_sweep_outlined),
                onPressed: () => onDeleteRecipeClick(recipe),
              ),
              const SizedBox(width: 280),
              IconButton(
                icon: Icon(Icons.edit_note),
                onPressed: () => onEditRecipeClick(recipe),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
