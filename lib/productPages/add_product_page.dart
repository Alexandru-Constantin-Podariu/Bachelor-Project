import 'package:bachelor_project/productPages/ocr_scan.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:number_editing_controller/number_editing_controller.dart';
import '../model/Product.dart';
import 'package:intl/intl.dart';

class AddProductPage extends StatefulWidget {
  final Function(Product) onAddProduct;
  const AddProductPage({required this.onAddProduct});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  bool sgr = false;
  int sgrInt = 0;
  // Controllers for the values of a Products
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
    categoryController = TextEditingController(text: ProductCategories.first);
    brandController = TextEditingController();
    unitController = TextEditingController(text: MeasurementUnit.first);
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
    // Date selection for the Date picker
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
    // Error dialog for field completion
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
// Error dialog for SGR RetuRo
void ErrorDialogSgr() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Only Drinks can have bottles with SGR'),
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
  // Function for navigation to the OCR scanner, handles returned data from scan
  void navigateToAddProductPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OcrScan(
          onScanProduct: (Product scannedProduct) {
            setState(() {
              nameController = TextEditingController(text: scannedProduct.name);
              categoryController =
                  TextEditingController(text: scannedProduct.category);
              brandController =
                  TextEditingController(text: scannedProduct.brand);
              quantityController.number = scannedProduct.quantity;
              unitController = TextEditingController(text: scannedProduct.unit);
              bestBeforeDateController =
                  TextEditingController(text: scannedProduct.bestBeforeDate);
            });
          },
        ),
      ),
    );
  }

  // Scaffold for the Add Page widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(title: const Text('Add Product')),
        body: SingleChildScrollView(
        child: Padding(    
            padding: const EdgeInsets.all(5.0),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: navigateToAddProductPage,
                      child: const Icon(Icons.photo_camera),
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    DropdownButtonFormField<String>(
                      value: ProductCategories.first,
                      items: ProductCategories.map((category) {
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
                      decoration:
                          const InputDecoration(labelText: 'Measurement Unit'),
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
                    Row(
                      // Special case for SGR, only Drinks can have SGR Bottles
                      children: [
                        const Text("SGR: "),
                        Checkbox(
                            value: sgr,
                            onChanged: categoryController.text != ProductCategories[5] ? 
                            (bool? value) {
                              if (value != null) {
                                setState(() {
                                  sgr = value;
                                  if(sgr)
                                  {
                                    sgrInt = 1;
                                  }
                                  else{
                                    sgrInt = 0;
                                  }
                                });
                              }
                            }
                            : null
                            ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            //Verify that all fields are filled correctly
                            if (nameController.text.isNotEmpty &&
                                categoryController.text !=
                                    ProductCategories.first &&
                                brandController.text.isNotEmpty &&
                                unitController.text != MeasurementUnit.first &&
                                bestBeforeDateController.text.isNotEmpty &&
                                quantityController.number != null) {
                              if (sgr &&
                                  categoryController.text != ProductCategories[5]) {
                                ErrorDialogSgr();
                              } else {
                                //Create new Product and add to Database
                                final Product newProduct = Product(
                                  name: nameController.text,
                                  category: categoryController.text,
                                  brand: brandController.text,
                                  quantity:
                                      quantityController.number!.toDouble(),
                                  unit: unitController.text,
                                  sgr: sgrInt,
                                  bestBeforeDate: bestBeforeDateController.text,
                                );
                                widget.onAddProduct(newProduct);
                                if (_formKey.currentState!.validate()) {
                                  Navigator.pop(context);
                                }
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
                )))));
  }
}
