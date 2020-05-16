import 'package:flutter/cupertino.dart';
import 'package:g2hv1/assets/location.dart';
import 'package:g2hv1/assets/user.dart';
import 'package:g2hv1/services/network.dart';
import 'package:g2hv1/constants.dart';
import 'dart:developer' as logger;

class Order {
  final String sellerMobileNo;
  final String shopName;
  final String orderId;
  final double orderStatus;
  final double orderDate;
  final OrderInfo orderInfo;
  Order(
      {this.sellerMobileNo,
      this.orderInfo,
      this.orderId,
      this.orderStatus,
      this.shopName,
      this.orderDate});
  factory Order.fromJson(dynamic json) {
    return Order(
        sellerMobileNo: json['seller-mobile-number'] as String,
        orderDate: json['order-date'] as double,
        orderId: json['order-id'] as String,
        orderStatus: json['order-status'] as double,
        shopName: json['order']['shop-name'] as String,
        orderInfo: OrderInfo.fromJson(json['order']));
  }

  Map<String, dynamic> toJson() => {
        'seller-mobile-number': sellerMobileNo,
        'order-id': orderId,
        'order-status': orderStatus,
        'seller-name': shopName,
        'order-date': orderDate,
        'order': orderInfo.toJson()
      };

  deleteOrder(User user) async {
    if (orderStatus == 0) {
      final String request = '''
      { 
        "app-api-key": "$kAppApiKey", 
        "request": 
        { 
          "mobile-number": "${user.mobileNumber}", 
          "order-status": 3, 
          "order-id": "$orderId" 
        }
      }
      ''';
      logger.log('Order delete PUT request for order: $request}');
      NetworkHelper nw = NetworkHelper();
      var response = await nw.putData(endpoint: '/order/status', data: request);
      logger.log('Order delete PUT response for user: $response}');
    }
  }
}

class OrderInfo {
  final double orderTotal;
  final String city;
  final Location location;
  final List<Item> items;
  OrderInfo(
      {@required this.orderTotal,
      @required this.city,
      @required this.location,
      @required this.items});

  factory OrderInfo.fromJson(dynamic json) {
    var itemObjsJson = json['items'] as List;
    List<Item> _items =
        itemObjsJson.map((tagJson) => Item.fromJson(tagJson)).toList();
    return OrderInfo(
      items: _items,
      orderTotal: json['order-total'] as double,
      city: json['city'] as String,
      location: Location.fromJson(json['location']),
    );
  }

  Map<String, dynamic> toJson() => {
        'order-total': this.orderTotal,
        'city': this.city,
        'location': this.location.toJson(),
        'items': this.items.map((i) => i.toJson()).toList()
      };
}

class Item {
  final String name;
  final double price;
  final double quantity;
  final String image;
  Item(
      {@required this.name,
      @required this.price,
      @required this.quantity,
      this.image});
  factory Item.fromJson(dynamic json) {
    return Item(
      name: json['name'] as String,
      price: json['price'] as double,
      quantity: json['unit'] as double,
      image: json['image'] as String,
    );
  }
  Map<String, dynamic> toJson() => {
        'name': this.name,
        'price': this.price,
        'quantity': this.quantity,
      };
  @override
  String toString() {
    return '{"name": "${this.name}", "price": ${this.price}, "quantity": ${this.quantity}}';
  }
}
