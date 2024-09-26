import 'package:bachelor_project/model/ShoppingList.dart';
import 'package:flutter/material.dart';
import 'package:number_editing_controller/number_editing_controller.dart';

class EditItemPage extends StatefulWidget {
  final ShoppingList item;
  final Function(ShoppingList) onEditItem;

  EditItemPage({required this.item, required this.onEditItem});

  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late NumberEditingTextController quantityController;
  late TextEditingController unitController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item.name);
    quantityController =
        NumberEditingTextController.decimal(allowNegative: false);
    quantityController.number = widget.item.quantity;
    unitController = TextEditingController(text: widget.item.unit);
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
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          title: const Text('Edit Shopping List Item'),
        ),
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
                  value: MeasurementUnit.firstWhere(
                      (element) => element == unitController.text),
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
                  decoration: const InputDecoration(labelText: 'Measurement Unit'),
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
                          ShoppingList editedItem = ShoppingList(
                            name: nameController.text,
                            quantity: quantityController.number!.toDouble(),
                            unit: unitController.text,
                          );
                          widget.onEditItem(editedItem);
                          if (_formKey.currentState!.validate()) {
                            Navigator.pop(context);
                          }
                        } else {
                          ErrorDialog();
                        }
                      },
                      child: const Text('Edit Item'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )));
  }
}
