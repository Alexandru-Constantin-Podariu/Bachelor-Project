import 'package:bachelor_project/model/ShoppingList.dart';
import 'package:flutter/material.dart';

class ShoppingListItems extends StatefulWidget {
  final List<ShoppingList> items;
  final Function(ShoppingList) onEditItemClick;
  final Function() onAddItemClick;
  final Function(ShoppingList) onDeleteItemClick;

  ShoppingListItems({
    required this.items,
    required this.onEditItemClick,
    required this.onAddItemClick,
    required this.onDeleteItemClick,
  });

  @override
  _ShoppingListItemsState createState() => _ShoppingListItemsState();
}

class _ShoppingListItemsState extends State<ShoppingListItems> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<ShoppingList> itemsList = widget.items.toList(); 
     return Column(
      children: [       
        Expanded(
          child: ListView.builder(
            itemCount: itemsList.length,
            itemBuilder: (context, index) {
              return ShoppingListItem(
                item: itemsList[index],
                onEditItemClick: widget.onEditItemClick,
                onDeleteItemClick: widget.onDeleteItemClick,
              );
            },
          ),
        ),
      ],
    );
  }
}

class ShoppingListItem extends StatelessWidget {
  final ShoppingList item;
  final Function(ShoppingList) onEditItemClick;
  final Function(ShoppingList) onDeleteItemClick;

  ShoppingListItem({
    required this.item,
    required this.onEditItemClick,
    required this.onDeleteItemClick,
  });
  String printquantity(ShoppingList item) {
    if (item.quantity == item.quantity.toInt()) {
      return item.quantity.toInt().toString();
    } 
    else 
    {
      return item.quantity.toString();
    }
  }
  @override
  Widget build(BuildContext context) {
    
    return Card(
      margin: const EdgeInsets.all(4),
      color: const Color.fromARGB(255, 248, 204, 147),
      child: ExpansionTile(
        title: Text(item.name,
            style: const TextStyle( fontSize: 25)),
        children: [
          ListTile(
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [            
                Text(
                  'Quantity: ${printquantity(item)} ${item.unit}',
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
                onPressed: () => onDeleteItemClick(item),
              ),
              const SizedBox(width: 290),
              IconButton(
                icon: const Icon(Icons.edit_note),
                onPressed: () => onEditItemClick(item),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
