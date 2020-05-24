import 'package:flutter/material.dart';
import 'package:flutter_counter/flutter_counter.dart';
import 'package:g2hv1/constants.dart';
import 'package:g2hv1/assets/order.dart';
import 'package:g2hv1/assets/seller.dart';
import 'package:g2hv1/assets/shopping_list.dart';
import 'dart:developer' as logger;

import 'package:g2hv1/assets/user_builder.dart';

class ItemDetailsCard extends StatelessWidget {
  final Item listItem;
  final String sellerMobileNumber;
  ItemDetailsCard({this.listItem, this.sellerMobileNumber});

  @override
  Widget build(BuildContext context) {
    double itemUnit = 1.0;
    if (listItem.quantity.remainder(100) == 0) {
      itemUnit = 100;
    } else if (listItem.quantity.remainder(50) == 0) {
      itemUnit = 50;
    }
    double total = listItem.price * (listItem.quantity / itemUnit);

    ImageProvider imageProvider;

    if (listItem.image != null) {
      String mobileNumberPrefix =
          sellerMobileNumber.replaceAll(new RegExp(r'[^\w\s]+'), '');
      imageProvider = NetworkImage(
          '$kS3ImageBucketUrl/$mobileNumberPrefix/${listItem.image}');
    } else {
      imageProvider = AssetImage('images/item_template.png');
    }

    return Container(
      margin: EdgeInsets.all(4.0),
      color: kCardColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CircleAvatar(
                  radius: 36.0,
                  backgroundImage: imageProvider,
                ),
                SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        listItem.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${formatDoubleToPrice(listItem.price)} per $itemUnit unit/s',
                        style: TextStyle(
                            fontSize: 10.0, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text('Qty: ${listItem.quantity}'),
                    ],
                  ),
                ),
                Text(
                  '${formatDoubleToPrice(total)}',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final Function onChanged;
  final Function onCheckBoxChanged;
  final ShoppingListItem shoppingListItem;
  final cardIndex;
  final String sellerMobileNumber;

  ItemCard(
      {this.onChanged,
      this.shoppingListItem,
      this.cardIndex,
      this.onCheckBoxChanged,
      this.sellerMobileNumber});

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;

    if (shoppingListItem.image != null) {
      String mobileNumberPrefix =
          sellerMobileNumber.replaceAll(new RegExp(r'[^\w\s]+'), '');
      imageProvider = NetworkImage(
          '$kS3ImageBucketUrl/$mobileNumberPrefix/${shoppingListItem.image}');
    } else {
      imageProvider = AssetImage('images/item_template.png');
    }

    logger.log(
        'Generating ItemCard, name: ${shoppingListItem.name}, price: ${shoppingListItem.price}, unit: ${shoppingListItem.unit}, selected: ${shoppingListItem.selected}');
    logger.log('Card image property: ${shoppingListItem.image}');
    double totalPrice = shoppingListItem.price *
        (shoppingListItem.unit / shoppingListItem.itemUnit);
    double minValue = shoppingListItem.itemUnit;
    double maxValue = shoppingListItem.itemUnit * 10;
    double step = 1;
    int decimalPlaces = 1;
    if (minValue.remainder(100) == 0) {
      step = 100;
      decimalPlaces = 0;
    } else if (minValue.remainder(50) == 0) {
      step = 50;
      decimalPlaces = 0;
    }
    return Container(
      margin: EdgeInsets.all(4.0),
      color: kCardColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CircleAvatar(
                  radius: 36.0,
                  backgroundImage: imageProvider,
                ),
                SizedBox(
                  width: 65.0,
                  child: Counter(
                    color: Colors.lightBlueAccent,
                    heroTag: 'heroTag $cardIndex',
                    initialValue: shoppingListItem.unit,
                    minValue: minValue,
                    maxValue: maxValue,
                    decimalPlaces: decimalPlaces,
                    step: step,
                    onChanged: onChanged,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        shoppingListItem.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                          '${formatDoubleToPrice(shoppingListItem.price)} per ${shoppingListItem.itemUnit} unit/s'),
                      Text(
                        formatDoubleToPrice(totalPrice),
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                Transform.scale(
                  scale: 2.0,
                  child: Checkbox(
                    checkColor: Colors.black,
                    activeColor: Colors.lightBlueAccent,
                    value: shoppingListItem.selected,
                    onChanged: onCheckBoxChanged,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ListCard extends StatelessWidget {
  final String cardTitle;
  final String cardDescription;
  ListCard({this.cardTitle, this.cardDescription});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.0),
      color: kCardColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CircleAvatar(
                  radius: 36.0,
                  backgroundImage: AssetImage('images/shopping_list.png'),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        cardTitle.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 6.0,
                      ),
                      Text(cardDescription),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ShopCard extends StatelessWidget {
  final Seller seller;
  ShopCard({this.seller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.0),
      color: kCardColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CircleAvatar(
                  radius: 36.0,
                  backgroundImage:
                      AssetImage('images/shop_template_image_2.png'),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        seller.sellerTitle.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(kTextShopCardSellerName(seller.sellerName)),
                      Text(kTextShopCardSellerMobile(seller.mobileNumber)),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
