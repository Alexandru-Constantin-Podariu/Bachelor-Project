import 'package:bachelor_project/database/database_repository.dart';
import 'package:bachelor_project/model/Product.dart';
import 'package:bachelor_project/model/Recipe.dart';

Future<List<String>> isRecipePossible(Recipe recipe) async {
  DatabaseRepository dbrepo = DatabaseRepository.Instance;
  List<String> missingIngredients = [];
  String recipeIngredients = recipe.ingredients;

  final splittedRecipe = recipeIngredients.split(',');
  for (String ingredient in splittedRecipe) {
    final ingredientValues = ingredient.trim().split(' ');
    if (ingredientValues.length == 2) {
      double quantity = double.parse(ingredientValues[0]);
      String name = ingredientValues[1];
      List<Product> items =
          await dbrepo.getProductFromRecipe(name);

      double totalQuantity = 0;
      for (Product item in items) {
        totalQuantity += item.quantity;
      }

      if (totalQuantity < quantity) {
        missingIngredients.add(name);
      }
    } else if (ingredientValues.length == 3) {
      double quantity = double.parse(ingredientValues[0]);
      String unit = ingredientValues[1];
      String name = ingredientValues[2];

      if (unit == "kg") {
        unit = "g";
        quantity *= 1000;
      }
      if (unit == "l") {
        unit = "ml";
        quantity *= 1000;
      }

      List<Product> items = await dbrepo.getProductFromRecipe(name);
      double totalQuantity = 0;
      for (Product item in items) {
        if (item.unit == "kg" || item.unit == "l") {
          totalQuantity += item.quantity * 1000;
        } else {
          totalQuantity += item.quantity;
        }
      }

      if (totalQuantity < quantity) {
        missingIngredients.add(name);
      }
    }
  }
  return missingIngredients;
}


void updateInventory(Recipe recipe) async {
  DatabaseRepository dbrepo = DatabaseRepository.Instance;
  String recipeIngredients = recipe.ingredients;

  final splittedRecipe = recipeIngredients.split(',');

  for (String ingredient in splittedRecipe) {

    final ingredientValues = ingredient.trim().split(' ');

    if (ingredientValues.length == 2) {

      double quantity = double.parse(ingredientValues[0]);
      String name = ingredientValues[1];

      List<Product> items = await dbrepo.getProductFromRecipe(name);

      double remainingQuantity = quantity;
      for (Product item in items) {
        if(remainingQuantity >= item.quantity) {
          dbrepo.deleteProduct(item.id!);
          remainingQuantity -= item.quantity;
        }
        else
        {
          item.quantity -= remainingQuantity;
          dbrepo.editProduct(item);
          remainingQuantity = 0;
          break;
        }
      }
    } else if (ingredientValues.length == 3) {
      double quantity = double.parse(ingredientValues[0]);
      String unit = ingredientValues[1];
      String name = ingredientValues[2];

      if (unit == "kg") {
        unit = "g";
        quantity *= 1000;
      }
      if (unit == "l") {
        unit = "ml";
        quantity *= 1000;
      }

      List<Product> items = await dbrepo.getProductFromRecipe(name);

      double remainingQuantity = quantity;

      for (Product item in items) {
        if (item.unit == "kg")  {
          item.quantity *= 1000;
          item.unit = "g";
        } 
        else if(item.unit == "l")
        {
          item.quantity *= 1000;
          item.unit = "ml";
        }
        if(remainingQuantity >= item.quantity) {
          dbrepo.deleteProduct(item.id!);
          remainingQuantity -= item.quantity;
        }
        else
        {
          item.quantity -= remainingQuantity;
          if(item.quantity / 1000 > 1)
          {
             item.quantity /= 1000;
             if(item.unit == "g")
             {
              item.unit = "kg";
             }
             else if(item.unit == "ml")
             {
              item.unit = "l";
             }
          }
          dbrepo.editProduct(item);
          remainingQuantity = 0;
          break;
        }
      }
    }
  }
}
