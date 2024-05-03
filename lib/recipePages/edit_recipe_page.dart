import '../model/Recipe.dart';
import 'package:flutter/material.dart';
//import 'package:number_editing_controller/number_editing_controller.dart';
//import 'package:intl/intl.dart';

class EditRecipePage extends StatefulWidget {
  final Recipe recipe;
  final Function(Recipe) onEditRecipe;

  EditRecipePage({required this.recipe, required this.onEditRecipe});

  @override
  _EditRecipePageState createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController categoryController;
    late TextEditingController ingredientsController;
  late TextEditingController instructionsController;
  

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.recipe.name);
    categoryController = TextEditingController(text: widget.recipe.category);
    ingredientsController = TextEditingController(text: widget.recipe.ingredients);
    instructionsController = TextEditingController(text: widget.recipe.instructions);
  }

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    ingredientsController.dispose();
    instructionsController.dispose();
    super.dispose();
  }

  void ErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Please fill in all of the fields.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          title: Text('Edit Recipe'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                DropdownButtonFormField<String>(
                  value: RecipeCategories.firstWhere((element) => element == categoryController.text),
                  items: RecipeCategories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        categoryController.text = value;
                      });
                    }
                  },
                  decoration: InputDecoration(labelText: 'Category'),
                ),
                TextFormField(
                  controller: ingredientsController,
                  decoration: InputDecoration(labelText: 'Ingredients'),
                ),
                TextFormField(
                  controller: instructionsController,
                  decoration: InputDecoration(labelText: 'Instructions'),
                ),
                
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (nameController.text.isNotEmpty &&
                                categoryController.text != RecipeCategories[0] &&
                                instructionsController.text.isNotEmpty &&
                                ingredientsController.text.isNotEmpty) {
                          Recipe editedRecipe = Recipe(
                            name: nameController.text,
                                category: categoryController.text,
                                ingredients: ingredientsController.text,
                                instructions: instructionsController.text
                          );
                          widget.onEditRecipe(editedRecipe);
                          if (_formKey.currentState!.validate()) {
                            Navigator.pop(context);
                          }
                        } else {
                          ErrorDialog();
                        }
                      },
                      child: Text('Edit Recipe'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
