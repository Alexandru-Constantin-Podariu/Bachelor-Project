import '../model/Recipe.dart';
import 'package:flutter/material.dart';

class RecipeList extends StatefulWidget {
  final List<Recipe> recipes;
  final Map<int, String> statusOfRecipes;
  final Function(Recipe) onEditRecipeClick;
  final Function() onAddRecipeClick;
  final Function(Recipe) onDeleteRecipeClick;
  final Function(Recipe) onPrepareRecipeClick;

  RecipeList({
    required this.recipes,
    required this.statusOfRecipes,
    required this.onEditRecipeClick,
    required this.onAddRecipeClick,
    required this.onDeleteRecipeClick,
    required this.onPrepareRecipeClick,
  });

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  late String _selectedCategory;
  late String _selectedTime;
  late String _selectedServings;

  @override
  void initState() {
    super.initState();
    _selectedCategory = recipeCategories.first;
    _selectedTime = recipeTimes.first;
    _selectedServings = recipeServings.first;
  }

  @override
  Widget build(BuildContext context) {
    List<Recipe> filteredRecipes;
    if (_selectedCategory == recipeCategories.first) {
      filteredRecipes = widget.recipes.toList();
    } else {
      filteredRecipes = widget.recipes
          .where((recipe) => recipe.category == _selectedCategory)
          .toList();
    }

    if (_selectedTime != recipeTimes.first &&
        _selectedTime != recipeTimes.last) {
      String timeCategory = _selectedTime.split(" ")[1];
      int time = int.parse(timeCategory);
      filteredRecipes.retainWhere((recipe) => recipe.time <= time);
    } else if (_selectedTime == recipeTimes.last) {
      filteredRecipes.retainWhere((recipe) => recipe.time > 120);
    }

    if (_selectedServings != recipeServings.first &&
        _selectedServings != recipeServings.last) {
      String servingsCategory = _selectedServings.split(" ")[0];
      int servings = int.parse(servingsCategory);
      filteredRecipes.retainWhere((recipe) => recipe.servings <= servings);
    } else if (_selectedServings == recipeServings.last) {
      filteredRecipes.retainWhere((recipe) => recipe.servings > 16);
    }

    return Column(
      children: [
        Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 80),
                const Text("Categories: "),
                const SizedBox(width: 20),
                DropdownButton<String>(
                  value: _selectedCategory,
                  items: recipeCategories.map((category) {
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
            Row(
              children: [
                const SizedBox(width: 80),
                const Text("Times: "),
                const SizedBox(width: 20),
                DropdownButton<String>(
                  value: _selectedTime,
                  items: recipeTimes.map((time) {
                    return DropdownMenuItem<String>(
                      value: time,
                      child: Text(time),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        _selectedTime = value;
                      });
                    }
                  },
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 80),
                const Text("Servings: "),
                const SizedBox(width: 20),
                DropdownButton<String>(
                  value: _selectedServings,
                  items: recipeServings.map((servings) {
                    return DropdownMenuItem<String>(
                      value: servings,
                      child: Text(servings),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        _selectedServings = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredRecipes.length,
            itemBuilder: (context, index) {
              return RecipeListItem(
                recipe: filteredRecipes[index],
                statusOfRecipe:
                    widget.statusOfRecipes[filteredRecipes[index].id]!,
                onEditRecipeClick: widget.onEditRecipeClick,
                onDeleteRecipeClick: widget.onDeleteRecipeClick,
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
  final String statusOfRecipe;
  final Function(Recipe) onEditRecipeClick;
  final Function(Recipe) onDeleteRecipeClick;
  final Function(Recipe) onPrepareRecipeClick;

  RecipeListItem(
      {required this.recipe,
      required this.statusOfRecipe,
      required this.onEditRecipeClick,
      required this.onDeleteRecipeClick,
      required this.onPrepareRecipeClick});
  void selectCategory() {
    // getProductsFromFuture();
  }
  Color getColorOfCard() {
    if (statusOfRecipe == "Possible") {
      return const Color.fromARGB(255, 188, 248, 133);
    } else if (statusOfRecipe == "NoneAreAvailable") {
      return const Color.fromARGB(255, 227, 107, 107);
    }
    return const Color.fromARGB(255, 252, 248, 123);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(4),
      color: getColorOfCard(),
      child: ExpansionTile(
        leading: Image.asset("images/${recipe.category}.png"),
        title: Text(recipe.name, style: const TextStyle(fontSize: 25)),
        children: [
          ListTile(
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Category: ${recipe.category}',
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  'Preparation time: ${recipe.time} minutes',
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  'Servings: ${recipe.servings}',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.delete_sweep_outlined),
                onPressed: () => onDeleteRecipeClick(recipe),
              ),
              const SizedBox(width: 115),
              IconButton(
                icon: const Icon(Icons.list),
                onPressed: () => onPrepareRecipeClick(recipe),
              ),
              const SizedBox(width: 125),
              IconButton(
                icon: const Icon(Icons.edit_note),
                onPressed: () => onEditRecipeClick(recipe),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
