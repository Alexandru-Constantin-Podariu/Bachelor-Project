import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:number_editing_controller/number_editing_controller.dart';
import '../model/Product.dart';
import 'package:intl/intl.dart';

class AddProductPage extends StatefulWidget {
  final Function(Product) onAddProduct;

  const AddProductPage({Key? key, required this.onAddProduct})
      : super(key: key);
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController categoryController;
  late TextEditingController brandController;
  late NumberEditingTextController quantityController;
  late TextEditingController bestBeforeDateController;
  late TextEditingController unitController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    categoryController = TextEditingController();
    brandController = TextEditingController();
    unitController = TextEditingController();
    quantityController =
        NumberEditingTextController.decimal(allowNegative: false);
    bestBeforeDateController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    brandController.dispose();
    quantityController.dispose();
    bestBeforeDateController.dispose();
    unitController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (picked != null) {
      setState(() {
        final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        bestBeforeDateController.text = formattedDate;
      });
    }
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
        appBar: AppBar(title: const Text('Add Product')),
        body: Padding(
          
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
                      value: RecipeCategories.first,
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
                      controller: brandController,
                      decoration: const InputDecoration(labelText: 'Brand'),
                    ),
                    TextFormField(
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true, signed: false),
                      controller: quantityController,
                      decoration: const InputDecoration(labelText: 'Quantity'),
                    ),
                    DropdownButtonFormField<String>(
                      value: MeasurementUnit.first,
                      items: MeasurementUnit.map((unit) {
                        return DropdownMenuItem<String>(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        if (value != null) {
                          setState(() {
                            unitController.text = value;
                          });
                        }
                      },
                      decoration:
                          InputDecoration(labelText: 'Measurement Unit'),
                    ),
                    TextFormField(
                      controller: bestBeforeDateController,
                      decoration:
                          const InputDecoration(labelText: 'Best Before Date'),
                      onTap: () {
                        _selectDate(context);
                      },
                      readOnly: true,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (nameController.text.isNotEmpty &&
                                categoryController.text != "Select a category" &&
                                brandController.text.isNotEmpty &&
                                unitController.text != "Select a unit" &&
                                bestBeforeDateController.text.isNotEmpty &&
                                quantityController.number != null) {
                              final Product newProduct = Product(
                                name: nameController.text,
                                category: categoryController.text,
                                brand: brandController.text,
                                quantity: quantityController.number!.toDouble(),
                                unit: unitController.text,
                                bestBeforeDate: bestBeforeDateController.text,
                              );
                              widget.onAddProduct(newProduct);
                              if (_formKey.currentState!.validate()) {
                                Navigator.pop(context);
                              }
                            } else {
                              ErrorDialog();
                            }
                          },
                          child: const Text('Add Product'),
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
                ))));
  }
}
