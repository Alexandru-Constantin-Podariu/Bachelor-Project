// The Shopping List Class Definition
class ShoppingList{
  static int currentId = 0;
  int? id;
  String name;
  double quantity;
  String unit;

  ShoppingList({
    this.id,
    required this.name,
    required this.quantity,
    required this.unit,
  });

   factory ShoppingList.fromMap(Map<String, dynamic> json) => ShoppingList(
    id: json['id'],
    name: json['name'],
    quantity: json['quantity'],
    unit: json['unit'],
  );

  Map<String, dynamic> toMap()
  {
    return{
        'id': id,
        'name': name,
        'quantity': quantity,
        'unit': unit,
    };
  }
}
  // List of values for Measurement Units
  List<String> MeasurementUnit = [
    "Select a unit",
    "g",
    "kg",
    "ml",
    "l",
    "pack"
  ];

