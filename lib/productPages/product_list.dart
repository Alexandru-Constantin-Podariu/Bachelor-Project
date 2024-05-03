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
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = ProductCategories.first;
  }

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts;
    if(_selectedCategory == ProductCategories.first)
    {
        filteredProducts = widget.products.toList();
    }
    else
    {
      filteredProducts = widget.products
        .where((product) => product.category == _selectedCategory)
        .toList();
    }

    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: widget.onAddProductClick,
              child: const Icon(Icons.add_circle),
              
            ),
            const SizedBox(width: 10),
            const Text("Categories: "),
            const SizedBox(width: 10),
            DropdownButton<String>(
              value: _selectedCategory,
              items: ProductCategories.map((category) {
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

  @override
  Widget build(BuildContext context) {
    
    return Card(
      margin: const EdgeInsets.all(4),
      color: Theme.of(context).colorScheme.onInverseSurface,
      child: ExpansionTile(
        title: Text(product.name,
            style: const TextStyle( fontSize: 25)),
        children: [
          ListTile(
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
