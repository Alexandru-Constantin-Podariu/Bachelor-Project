import 'package:flutter/material.dart';
import '../model/Product.dart';
class ProductList extends StatefulWidget {
  final List<Product> products;
  final Function(Product) onEditProductClick;
  final Function() onAddProductClick;
  final Function(Product) onDeleteProductClick;

  ProductList({
    required this.products,
    required this.onEditProductClick,
    required this.onAddProductClick,
    required this.onDeleteProductClick,
  });

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late String selectedCategory;
  List<String> freshnessMenu = ["All", "Fresh", "Expiring this week", "Expired"];
  late String selectedOption;

  @override
  void initState() {
    super.initState();
    selectedCategory = ProductCategories.first;
    selectedOption = freshnessMenu[0];
  }

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts;
    if (selectedCategory == ProductCategories.first) 
    {
      filteredProducts = widget.products.toList();
    }
    else 
    {
      filteredProducts = widget.products
          .where((product) => product.category == selectedCategory)
          .toList();
    }

    if(selectedOption == freshnessMenu[1])
    {
        filteredProducts.retainWhere((product) =>
            product.bestBeforeDate.compareTo(DateTime.now().add(const Duration(days: 7)).toString()) > 0);
    }
    else if (selectedOption == freshnessMenu[2])
    {
      filteredProducts.retainWhere((product) =>
            product.bestBeforeDate.compareTo(DateTime.now().toString()) >= 0 &&
            product.bestBeforeDate.compareTo(DateTime.now().add(const Duration(days: 7)).toString()) <= 0);
    }
    else if (selectedOption == freshnessMenu[3])
    {
        filteredProducts.retainWhere((product) =>
            product.bestBeforeDate.compareTo(DateTime.now().toString()) < 0);
    }

     return Column(
      children: [
        Column(
          children: [
            Row(
              children: [             
                const SizedBox(width: 80),
                const Text("View: "),
                const SizedBox(width: 20),
                DropdownButton<String>(
                  value: selectedOption,
                  items: freshnessMenu.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        selectedOption = value;
                      });
                    }
                  },
                ),
              ],
            ),
            Row(children: 
            [
              const SizedBox(width: 80),                
              const Text("Categories: "),
              const SizedBox(width: 20),
              DropdownButton<String>(
                value: selectedCategory,
                items: ProductCategories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      selectedCategory = value;
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
    } 
    else 
    {
      return product.quantity.toString();
    }
  }
  void selectCategory()
  {
    // getProductsFromFuture();
  }
  Color getColorOfCard(Product product)
  {
    if(product.bestBeforeDate.compareTo(DateTime.now().add(const Duration(days: 7)).toString()) >= 0)
    {
      return const Color.fromARGB(255, 188, 248, 133);
    }
    else if(product.bestBeforeDate.compareTo(DateTime.now().toString()) < 0)
    {
      return const Color.fromARGB(255, 227, 107, 107);
    }
   return const Color.fromARGB(255, 252, 248, 123);
  }

  @override
  Widget build(BuildContext context) {
    
    return Card(
      margin: const EdgeInsets.all(4),
      color: getColorOfCard(product),
      child: ExpansionTile(
        leading: Image.asset("images/${product.category}.png"),
        title: Text(product.name,
            style: const TextStyle( fontSize: 25)),
        children: [
          ListTile(
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [  
                Text(
                  'Category: ${product.category}',
                  style: const TextStyle( fontSize: 20),
                ),    
                Text(
                  'Brand: ${product.brand}',
                  style: const TextStyle( fontSize: 20),
                ),
                Text(
                  'Quantity: ${printquantity(product)} ${product.unit}',
                  style: const TextStyle( fontSize: 20),
                ),
                Text(
                  'Best Before Date:  ${product.bestBeforeDate}',
                  style: const TextStyle( fontSize: 20),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.delete_sweep_outlined),
                onPressed: () => onDeleteProductClick(product),
              ),
              const SizedBox(width: 290),
              IconButton(
                icon: const Icon(Icons.edit_note),
                onPressed: () => onEditProductClick(product),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
