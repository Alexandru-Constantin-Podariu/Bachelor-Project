class Recipe{
  static int currentId = 0;
  int? id;
  String name;
  String category;
  String ingredients;
  String instructions;

  Recipe({
    this.id,
    required this.name,
    required this.category,
    required this.ingredients,
    required this.instructions,
  });

   factory Recipe.fromMap(Map<String, dynamic> json) => Recipe(
    id: json['id'],
    name: json['name'],
    category: json['category'],
    ingredients: json['ingredients'],
    instructions: json['instructions']
  );

  Map<String, dynamic> toMap()
  {
    return{
        'id': id,
        'name': name,
        'category': category,
        'ingredients': ingredients,
        'instructions': instructions
    };
  }

  static List<Recipe> init(){
    List<Recipe> recipes = [
      Recipe(
        name: "Apple Pie",
        category: "Desserts",
        ingredients: "1 apple, 500 g flour, 500 ml milk",
        instructions: "Prepare ingredients. Cook. Eat."
      ),
    ];
    return recipes;
  }
}

  List<String> RecipeCategories = [
    "Select a category",
    "Breakfast",
    "Lunch",
    "Dinner",
    "Soups",
    "Main-courses",
    "Side-dishes",
    "Desserts",
    "Drinks",
    "Holiday",
    "Vegeterian"
  ];
