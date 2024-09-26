// The Recipe Class Definition

class Recipe{
  static int currentId = 0;
  int? id;
  String name;
  String category;
  int time;
  int servings;
  String ingredients;
  String instructions;

  Recipe({
    this.id,
    required this.name,
    required this.category,
    required this.time,
    required this.servings,
    required this.ingredients,
    required this.instructions,
  });

   factory Recipe.fromMap(Map<String, dynamic> json) => Recipe(
    id: json['id'],
    name: json['name'],
    category: json['category'],
    time: json['time'],
    servings: json['servings'],
    ingredients: json['ingredients'],
    instructions: json['instructions']
  );

  Map<String, dynamic> toMap()
  {
    return{
        'id': id,
        'name': name,     
        'category': category,
        'time': time,
        'servings': servings,
        'ingredients': ingredients,
        'instructions': instructions
    };
  }

  static List<Recipe> init(){
    List<Recipe> recipes = [
      Recipe(
        name: "Apple Pie",
        category: "Desserts",
        time: 60,
        servings: 4,
        ingredients: "1 apple, 500 g flour, 500 ml milk",
        instructions: "Prepare ingredients. Cook. Eat."
      ),
    ];
    return recipes;
  }
}
  // List of values for Recipe Categories
  List<String> recipeCategories = [
    "Select category",
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
// List of values for Recipe Preparation Times
List<String> recipeTimes= [
  "Select time",
  "Under 15 minutes",
  "Under 30 minutes",
  "Under 45 minutes",
  "Under 60 minutes",
  "Under 90 minutes",
  "Under 120 minutes",
  "More than 120 minutes"
  ];

// List of values for Recipe Number of Servings
List<String> recipeServings= [
  "Select servings", 
  "1 servings",
  "2 servings",
  "4 servings",
  "8 servings",
  "12 servings",
  "16 servings",
  "More than 16 servings"
  ];

  List<String> recipeAvailability= [
  "Select status", 
  "Available",
  "Missing Ingredients",
  "Unavailable",
  ];