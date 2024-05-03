class Product{
  static int currentId = 0;
  int? id;
  String name;
  String category;
  String brand;
  double quantity;
  String unit;
  String bestBeforeDate;

  Product({
    this.id,
    required this.name,
    required this.category,
    required this.brand,
    required this.quantity,
    required this.unit,
    required this.bestBeforeDate,
  });

   factory Product.fromMap(Map<String, dynamic> json) => Product(
    id: json['id'],
    name: json['name'],
    category: json['category'],
    brand: json['brand'],
    quantity: json['quantity'],
    unit: json['unit'],
    bestBeforeDate: json['bestBeforeDate']
  );

  Map<String, dynamic> toMap()
  {
    return{
        'id': id,
        'name': name,
        'category': category,
        'brand': brand,
        'quantity': quantity,
        'unit': unit,
        'bestBeforeDate': bestBeforeDate
    };
  }

  static List<Product> init(){
    List<Product> products = [
      Product(
        name: "Milk",
        category: "Dairy",
        brand: "Pilos",
        quantity: 1,
        unit: 'MeasurementUnit.l',
        bestBeforeDate: "2023-12-10"
      ),
      Product(
        name: "Ice Cream",
        category: "Sweets",
        brand: "Gelatelli",
        quantity: 250,
        unit: 'MeasurementUnit.g',
        bestBeforeDate: "2024-02-10"
      ),
      Product(
        name: "Peaches",
        category: "Fruits",
        brand: "LidlFarm",
        quantity: 1,
        unit: 'MeasurementUnit.pack',
        bestBeforeDate: "2023-11-30"
      ),
      Product(
        name: "Potatoes",
        category: "Vegetables",
        brand: "LidlFarm",
        quantity: 2,
        unit: 'MeasurementUnit.kg',
        bestBeforeDate: "2023-12-30"
      ),
    ];
    return products;
  }
}
  List<String> MeasurementUnit = [
    "Select a unit",
    "g",
    "kg",
    "ml",
    "l",
    "pack"
  ];

  List<String> ProductCategories = [
    "Select a category",
    "Cereals",
    "Condiments",
    "Dairy",
    "Drinks",
    "Fruits",
    "Oils",
    "Pasta",
    "Sweets",
    "Vegetables",
  ];
