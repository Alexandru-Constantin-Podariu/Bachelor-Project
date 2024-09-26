import 'package:bachelor_project/database/database_repository.dart';
import 'package:bachelor_project/model/Product.dart';
import 'package:bachelor_project/model/Recipe.dart';
import 'package:bachelor_project/model/ShoppingList.dart';

//Functions for Recipes Status, Preparation and adding to Shopping List Functionalities

Future<String> recipeStatus(Recipe recipe) async {
  DatabaseRepository dbrepo = DatabaseRepository.Instance;
  String recipeIngredients = recipe.ingredients;

  // Divide the Ingredient List By ","
  final splittedRecipe = recipeIngredients.split(',');
  int missingIngredientsCount = 0; 

  for (String ingredient in splittedRecipe) 
  {
    final ingredientValues = ingredient.trim().split(' ');

    // For piece-wise ingredients
    if (ingredientValues.length == 2)
    {
      double quantity = double.parse(ingredientValues[0]);
      String name = ingredientValues[1].replaceAll("-", " ");
      List<Product> items =
          await dbrepo.getProductFromRecipe(name);
      
      // Count the available quantities in the inventory
      double totalQuantity = 0;
      for (Product item in items) {
        totalQuantity += item.quantity;
      }
      // If the quantity in the inventory is insufficient add to missing ingredients list
      if (totalQuantity < quantity) {
        missingIngredientsCount++;
      }
    }
    // For ingredients with measured units 
    else if (ingredientValues.length == 3) {
      double quantity = double.parse(ingredientValues[0]);
      String unit = ingredientValues[1];
      String name = ingredientValues[2].replaceAll("-", " ");

      // Use lower units for easier computations
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

      // Count the available quantities in the inventory
      for (Product item in items) {
        if (item.unit == "kg" || item.unit == "l") {
          totalQuantity += item.quantity * 1000;
        } else {
          totalQuantity += item.quantity;
        }
      }
      // If the quantity in the inventory is insufficient add to missing ingredients list
      if (totalQuantity < quantity) {
        missingIngredientsCount ++;
      }
    }
  }
  if(missingIngredientsCount == 0){
    return("Possible");
  }
  if(missingIngredientsCount < splittedRecipe.length){
    return("SomeAreAvailable");
  }
  return ("NoneAreAvailable");
  
}


void updateInventory(Recipe recipe) async {
  DatabaseRepository dbrepo = DatabaseRepository.Instance;
  String recipeIngredients = recipe.ingredients;

  final splittedRecipe = recipeIngredients.split(',');

  for (String ingredient in splittedRecipe) {

    final ingredientValues = ingredient.trim().split(' ');

    if (ingredientValues.length == 2) {

      double quantity = double.parse(ingredientValues[0]);
      String name = ingredientValues[1].replaceAll("-", " ");

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
      String name = ingredientValues[2].replaceAll("-", " ");

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


Future<List<String>> ingredientsStatus(Recipe recipe) async {
  DatabaseRepository dbrepo = DatabaseRepository.Instance;
  String recipeIngredients = recipe.ingredients;
  List<String> returnMessages = [];

  final splittedRecipe = recipeIngredients.split(',');

  for (String ingredient in splittedRecipe) {

    final ingredientValues = ingredient.trim().split(' ');

    if (ingredientValues.length == 2) {

      double quantity = double.parse(ingredientValues[0]);
      String name = ingredientValues[1].replaceAll("-", " ");

      List<Product> items = await dbrepo.getProductFromRecipe(name);

      double remainingQuantity = quantity;
      for (Product item in items) {
        if(remainingQuantity >= item.quantity) {
          remainingQuantity -= item.quantity;
        }
        else
        {
          item.quantity -= remainingQuantity;
          remainingQuantity = 0;
          break;
        }
      }
      if(remainingQuantity == 0)
      {
        returnMessages.add("${printquantity(quantity)} $name - Available");
      }
      else if(remainingQuantity < quantity)
      {
        returnMessages.add("${printquantity(quantity)} $name - Missing ${printquantity(remainingQuantity)}");
      }
      else{
        returnMessages.add("${printquantity(quantity)} $name - Not Available");
      }

    } else if (ingredientValues.length == 3) {
      double quantity = double.parse(ingredientValues[0]);
      double initialQuantity = quantity;
      String unit = ingredientValues[1];
      String name = ingredientValues[2].replaceAll("-", " ");

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
          remainingQuantity = 0;
          break;
        }
      }
      if(remainingQuantity == 0)
      {
        returnMessages.add("${printquantity(initialQuantity)} ${ingredientValues[1]} $name - Available");
      }
      else if(remainingQuantity < quantity)
      {
        returnMessages.add("${printquantity(initialQuantity)} ${ingredientValues[1]} $name - Missing ${printquantity(remainingQuantity)} $unit");
      }
      else{
        returnMessages.add("${printquantity(initialQuantity)} ${ingredientValues[1]} $name - Not Available");
      }
    }
  }
  return returnMessages;
}

String printquantity(double quantity) {
    if (quantity== quantity.toInt()) {
      return quantity.toInt().toString();
    } 
    else 
    {
      return quantity.toString();
    }
  }


void addToShoppingList(List<String> ingredients) async{
  DatabaseRepository dbrepo = DatabaseRepository.Instance;
  for(String ingredientStatus in ingredients){
    final splittedIngredient = ingredientStatus.split('-');
    if(splittedIngredient[1].contains("Not Available")){
      final ingredient = splittedIngredient[0].trim().split(" ");
      if(ingredient.length == 2)
      {
        double quantity = double.parse(ingredient[0]);
        ShoppingList item = ShoppingList(name: ingredient[1].replaceAll("-", " "), quantity: quantity, unit: "pack");
        dbrepo.addShoppingListItem(item);
      }
      else if(ingredient.length == 3)
      {
        double quantity = double.parse(ingredient[0]);
        ShoppingList item = ShoppingList(name: ingredient[2].replaceAll("-", " "), quantity: quantity, unit: ingredient[1]);
        List<ShoppingList> oldItem = await dbrepo.getItemsWithName(ingredient[2]);
        print(oldItem);
        dbrepo.addShoppingListItem(item);
      }
    }
    else if(splittedIngredient[1].contains("Missing")){
      final ingredientTotal = splittedIngredient[0].trim().split(" ");
      final ingredientLeft = splittedIngredient[1].trim().split(" ");
      if(ingredientTotal.length == 2)
      {
        double quantity = double.parse(ingredientLeft[1]);
        ShoppingList item = ShoppingList(name: ingredientTotal[1].replaceAll("-", " "), quantity: quantity, unit: "pack");
        //List<ShoppingList> oldItems = await dbrepo.getItemWithName(ingredientTotal[1]);
        // if(oldItems.length != 0)
        //   dbrepo.editShoppingListItem(item)
        dbrepo.addShoppingListItem(item);
      }
      else if(ingredientTotal.length == 3)
      {
        double quantity = double.parse(ingredientLeft[1]);
        ShoppingList item = ShoppingList(name: ingredientTotal[2].replaceAll("-", " "), quantity: quantity, unit: ingredientLeft[2]);
        dbrepo.addShoppingListItem(item);
      }
    }
  }
}
