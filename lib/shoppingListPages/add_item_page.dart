import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:number_editing_controller/number_editing_controller.dart';
import '../model/ShoppingList.dart';

class AddItemPage extends StatefulWidget {
  final Function(ShoppingList) onAddItem;

  const AddItemPage({Key? key, required this.onAddItem})
      : super(key: key);
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late NumberEditingTextController quantityController;
  late TextEditingController unitController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    unitController = TextEditingController();
    quantityController =
        NumberEditingTextController.decimal(allowNegative: false);
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    unitController.dispose();
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
        appBar: AppBar(title: const Text('Add to Shopping List')),
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
                          const InputDecoration(labelText: 'Measurement Unit'),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (nameController.text.isNotEmpty &&
                                unitController.text != MeasurementUnit[0] &&
                                quantityController.number != null) {
                              final ShoppingList newItem = ShoppingList(
                                name: nameController.text,
                                quantity: quantityController.number!.toDouble(),
                                unit: unitController.text,
                              );
                              widget.onAddItem(newItem);
                              if (_formKey.currentState!.validate()) {
                                Navigator.pop(context);
                              }
                            } else {
                              ErrorDialog();
                            }
                          },
                          child: const Text('Add Item'),
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
