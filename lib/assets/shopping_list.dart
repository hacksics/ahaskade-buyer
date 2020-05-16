import 'package:g2hv1/assets/seller.dart';
import 'package:g2hv1/assets/user.dart';
import 'dart:developer' as logger;

class ShoppingList {
  final String listId;
  final String listName;
  final List<ShoppingListItem> shoppingListItems;
  ShoppingList({this.listId, this.listName, this.shoppingListItems});

  double getListTotal() {
    double listTotal = 0;
    for (ShoppingListItem item in shoppingListItems) {
      if (item.selected == true) {
        listTotal += (item.unit / item.itemUnit) * item.price;
      }
    }
    return listTotal;
  }

  int getSelectedItemsCount() {
    int selectItemsCount = 0;
    for (ShoppingListItem selectedShoppingItem in shoppingListItems) {
      if (selectedShoppingItem.selected == true) {
        selectItemsCount++;
      }
    }
    return selectItemsCount;
  }

  List<Map<String, dynamic>> _getSelectedItemsMap() {
    List<Map<String, dynamic>> selectedShoppingItemsList = [];
    for (ShoppingListItem selectedShoppingItem in shoppingListItems) {
      if (selectedShoppingItem.selected == true) {
        //logger.log('Selected Item Image: ${selectedShoppingItem.image}');
        selectedShoppingItemsList.add(selectedShoppingItem.toJson());
      }
    }
    return selectedShoppingItemsList;
  }

  Map<String, dynamic> getOrderRequest({User user, Seller seller}) => {
        'mobile-number': user.mobileNumber,
        'order': {
          'seller-mobile-number': seller.mobileNumber,
          'shop-name': seller.sellerTitle,
          'order-total': getListTotal(),
          'location': {
            'lat': user.userProfile.location.lat,
            'lon': user.userProfile.location.lon
          },
          'city': user.userProfile.cities[0],
          'items': _getSelectedItemsMap()
        }
      };

  factory ShoppingList.fromJson(dynamic json) {
    var listItemsJson = json['items'] as List;
    List<ShoppingListItem> _items = listItemsJson
        .map((tagJson) => ShoppingListItem.fromJson(tagJson))
        .toList();
    return ShoppingList(
        listName: json['list-name'],
        listId: json['list-id'],
        shoppingListItems: _items);
  }
}

class ShoppingListItem {
  final String name;
  final double price;
  final double itemUnit;
  final String image;
  double unit;
  bool selected;
  ShoppingListItem(
      {this.name, this.price, this.itemUnit, this.selected, this.image}) {
    unit = itemUnit;
    selected = selected != null ? selected : true;
  }

  Map<String, dynamic> toJson() => {
        'name': this.name,
        'price': this.price,
        'unit': this.unit,
        'image': this.image
      };

  factory ShoppingListItem.fromJson(dynamic json) {
    return ShoppingListItem(
      name: json['name'] as String,
      price: json['price'] as double,
      itemUnit: json['unit'] as double,
      image: json['image'] as String,
    );
  }
}
