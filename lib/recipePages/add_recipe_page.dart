import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:number_editing_controller/number_editing_controller.dart';
//import 'package:number_editing_controller/number_editing_controller.dart';
import '../model/Recipe.dart';
//import 'package:intl/intl.dart';

class AddRecipePage extends StatefulWidget {
  final Function(Recipe) onAddRecipe;

  const AddRecipePage({Key? key, required this.onAddRecipe}) : super(key: key);
  @override
  _AddRecipePageState createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController categoryController;
  late NumberEditingTextController timeController;
  late NumberEditingTextController servingsController;
  late TextEditingController ingredientsController;
  late TextEditingController instructionsController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    categoryController = TextEditingController();
    timeController = NumberEditingTextController.integer(allowNegative: false);
    servingsController =
        NumberEditingTextController.integer(allowNegative: false);
    ingredientsController = TextEditingController();
    instructionsController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    timeController.dispose();
    servingsController.dispose();
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
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(title: const Text('Add Recipe')),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                        ),
                        DropdownButtonFormField<String>(
                          value: recipeCategories.first,
                          items: recipeCategories.map((category) {
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
                          decoration: const InputDecoration(labelText: 'Category'),
                        ),
                        TextFormField(
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false, signed: false),
                          controller: timeController,
                          decoration: const InputDecoration(labelText: 'Time'),
                        ),
                        TextFormField(
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false, signed: false),
                          controller: servingsController,
                          decoration: const InputDecoration(
                              labelText: 'Number of Servings'),
                        ),
                        TextFormField(
                          controller: ingredientsController,
                          decoration:
                              const InputDecoration(labelText: 'Ingredients'),
                        ),
                        TextFormField(
                          controller: instructionsController,
                          decoration:
                              const InputDecoration(labelText: 'Instructions'),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (nameController.text.isNotEmpty &&
                                    categoryController.text !=
                                        recipeCategories[0] &&
                                    timeController.number != null &&
                                    servingsController.number != null &&
                                    instructionsController.text.isNotEmpty &&
                                    ingredientsController.text.isNotEmpty) {
                                  final Recipe newRecipe = Recipe(
                                      name: nameController.text,
                                      category: categoryController.text,
                                      time: timeController.number!.toInt(),
                                      servings:
                                          servingsController.number!.toInt(),
                                      ingredients: ingredientsController.text,
                                      instructions:
                                          instructionsController.text);
                                  widget.onAddRecipe(newRecipe);
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.pop(context);
                                  }
                                } else {
                                  ErrorDialog();
                                }
                              },
                              child: const Text('Add Recipe'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                          ],
                        )
                      ],
                    )))));
  }
}
