import 'dart:async';
import 'dart:developer';

import 'package:bachelor_project/database/database_repository.dart';
import 'package:bachelor_project/model/Product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';

class OcrScan extends StatefulWidget {
  final Function(Product) onScanProduct;
  const OcrScan({required this.onScanProduct});

  @override
  State<OcrScan> createState() => _OcrScanState();
}

class _OcrScanState extends State<OcrScan> {
  DatabaseRepository dbrepo = DatabaseRepository.Instance;
  String currentText = "";
  List<bool> skipped = [false, false, false, false, false];
  List<String> scannedTexts = [ "", "", "", "", "", ""];
  List<String> scannedQuantity = ["0", ""];
  int index = 0;
  final StreamController<String> controller = StreamController<String>();

  void setText(value) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    if (mounted) { 
      setState(() {
        currentText = value;
      });
    }
  });
  controller.add(value);
}

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  void ErrorDialogDate() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Date is not valid'),
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

  void ErrorDialogQuantity() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Quantity is not valid'),
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

  String handleDate() {
    List<String> splittedText;
    if (currentText.contains(".")) {
      splittedText = currentText.split(".");
    } else if (currentText.contains("/")) {
      splittedText = currentText.split("/");
    } else {
      splittedText = currentText.split(" ");
    }
    // Divide date to check it
    if (splittedText.length != 3) {
      return "error";
    }

    int? day = int.tryParse(splittedText[0]);
    int? month = int.tryParse(splittedText[1]);
    int? year = int.tryParse(splittedText[2]);

    //Verify values for the day, month and year
    if (day == null || month == null || year == null) {
      return "error";
    }
    if (day < 1 || day > 31 || month < 1 || month > 12) {
      return "error";
    }

    if (year > 23 && year < 100) {
      year += 2000;
    } else if (year < 2023) {
      return "error";
    }

    // Return the date with Database correct format
    return "$year-${splittedText[1].trim()}-${splittedText[0].trim()}";
  }

  List<String> handleQuantity() {
    final List<String> possibleUnits = ["ml", "l", "g", "kg"];

    String quantityText = currentText.replaceAll(" ", "");

    String numericSide = "", unitSide = "";

    //Split the value into a numeric side and a measurement unit side
    bool decimalPoint = false;
    for (int i = 0; i < quantityText.length; i++) {
      if (quantityText[i].contains(RegExp(r'[0-9]')) ||
          (quantityText[i] == "." && !decimalPoint)) {
        numericSide += quantityText[i];
        if (quantityText[i] == ".") {
          // Take into account decimal points
          decimalPoint = true;
        }
      } else {
        unitSide = quantityText.substring(i);
        break;
      }
    }

    // If the values are incorrect, send error
    if (numericSide.isEmpty || !possibleUnits.contains(unitSide)) {
      return ["error", "error"];
    }

    return [numericSide, unitSide];
  }

  void saveTexts() {
    setState(() {
      // Special case for the Date, call Date handler
      if (index == 3) {
        String value = handleDate();
        if (value == "error") {
          ErrorDialogDate();
          index--;
        } else {
          scannedTexts[index] = value;
        }
      } 
      // Special case for the Quantity, call Quantity handler
      else if (index == 2) {
        List<String> value = handleQuantity();
        if (value[0] == "error") {
          ErrorDialogQuantity();
          index--;
        } else {
          scannedQuantity = value;
          scannedTexts[index] = "${value[0]} ${value[1]}";
        }
      } else {
        scannedTexts[index] = currentText;
      }

      if (index < 4) {
        index++;
        currentText = "";
      } else {
        Product product = Product(
          name: !(scannedTexts[0] == "Skipped") ? scannedTexts[0].trim() : "",
          category: ProductCategories.first,
          brand: !(scannedTexts[1] == "Skipped") ? scannedTexts[1].trim() : "",
          quantity: !(scannedTexts[2] == "Skipped") ? double.parse(scannedQuantity[0]) : 0,
          unit: !(scannedTexts[2] == "Skipped") ? scannedQuantity[1].trim() : MeasurementUnit.first,
          sgr: 0,
          bestBeforeDate: !(scannedTexts[3] == "Skipped") ? scannedTexts[3].trim() : "",
        );
        widget.onScanProduct(product);
        Navigator.pop(context);
      }
    });
  }

  // Alternate the Text for the button based on Current scanning status
  String buttonText(int index) {
    if (index > 4) {
      return "Finish";
    }
    return "Next";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Packaging Information"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: ScalableOCR(
                paintboxCustom: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 4.0
                  ..color = const Color.fromARGB(153, 102, 160, 241),
                boxLeftOff: 5,
                boxBottomOff: 2.5,
                boxRightOff: 5,
                boxTopOff: 2.5,
                boxHeight: MediaQuery.of(context).size.height / 3,
                getRawData: (value) {
                  inspect(value);
                },
                getScannedText: (value) {
                  setText(value);
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  StreamBuilder<String>(
                    stream: controller.stream,
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      currentText = snapshot.data != null ? snapshot.data! : "";
                      return Column(
                        children: [
                          Text(
                            "Current text: $currentText",
                            style: const TextStyle(fontSize: 17),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "Name: ${scannedTexts[0]}",
                            style: const TextStyle(fontSize: 17),
                          ),
                          Text(
                            "Brand: ${scannedTexts[1]}",
                            style: const TextStyle(fontSize: 17),
                          ),
                          Text(
                            "Quantity: ${scannedTexts[2]}",
                            style: const TextStyle(fontSize: 17),
                          ),
                          Text(
                            "Best Before Date: ${scannedTexts[3]}",
                            style: const TextStyle(fontSize: 17),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (index < 4) {
                                    scannedTexts[index] = "Skipped";
                                    index++;
                                  }
                                },
                                child: const Text("Skip"),
                              ),
                              ElevatedButton(
                                onPressed: saveTexts,
                                child: Text(buttonText(index)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
