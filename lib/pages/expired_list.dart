import 'package:flutter/material.dart';
import '../model/Product.dart';

class ExpiredList extends StatefulWidget {
  final List<Product> products;
  final Function(Product) onEditProductClick;
  final Function(Product) onDeleteProductClick;

  ExpiredList({
    required this.products,
    required this.onEditProductClick,
    required this.onDeleteProductClick,
  });

  @override
  _ExpiredListState createState() => _ExpiredListState();
}

class _ExpiredListState extends State<ExpiredList> {
  late String _selectedCategory;
  List<String> expiration_menu = ["Expired", "Expiring this week"];
  late String _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedCategory = RecipeCategories.first;
    _selectedOption = "Expired";
  }

  @override
  Widget build(BuildContext context) {

    List<Product> filteredProducts;

    if (_selectedCategory == RecipeCategories.first) 
    {
      filteredProducts = widget.products.toList();
    }
    else 
    {
      filteredProducts = widget.products
          .where((product) => product.category == _selectedCategory)
          .toList();
    }

    if (_selectedOption == "Expired")
    {
        filteredProducts.retainWhere((product) =>
            product.bestBeforeDate.compareTo(DateTime.now().toString()) < 0);
    }
    else
    {
      filteredProducts.retainWhere((product) =>
            product.bestBeforeDate.compareTo(DateTime.now().toString()) >= 0 &&
            product.bestBeforeDate.compareTo(DateTime.now().add(const Duration(days: 7)).toString()) < 0);
    }

    return Column(
      children: [
        Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 20),
                const Text("View: "),
                const SizedBox(width: 20),
                DropdownButton<String>(
                  value: _selectedOption,
                  items: expiration_menu.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        _selectedOption = value;
                      });
                    }
                  },
                ),
              ],
            ),
            Row(children: [
              const SizedBox(width: 20),
              const Text("Categories: "),
              const SizedBox(width: 20),
              DropdownButton<String>(
                value: _selectedCategory,
                items: RecipeCategories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
              ),
            ]),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              return ProductListItem(
                product: filteredProducts[index],
                onEditProductClick: widget.onEditProductClick,
                onDeleteProductClick: widget.onDeleteProductClick,
              );
            },
          ),
        ),
      ],
    );
  }
}

class ProductListItem extends StatelessWidget {
  final Product product;
  final Function(Product) onEditProductClick;
  final Function(Product) onDeleteProductClick;

  ProductListItem({
    required this.product,
    required this.onEditProductClick,
    required this.onDeleteProductClick,
  });
  String printquantity(Product product) {
    if (product.quantity == product.quantity.toInt()) {
      return product.quantity.toInt().toString();
    } else {
      return product.quantity.toString();
    }
  }

  void selectCategory() {
    // getProductsFromFuture();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(4),
      color: const Color.fromARGB(255, 212, 205, 0),
      child: ExpansionTile(
        title: Text(product.name + ' - ' + product.bestBeforeDate,
            style: const TextStyle(color: Colors.red, fontSize: 25)),
        children: [
          ListTile(
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Brand: ${product.brand}',
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                ),
                Text(
                  'Quantity: ${printquantity(product)} ${product.unit}',
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                icon: const Icon(Icons.delete_sweep_outlined),
                onPressed: () => onDeleteProductClick(product),
              ),
              const SizedBox(width: 280),
              IconButton(
                icon: Icon(Icons.edit_note),
                onPressed: () => onEditProductClick(product),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
