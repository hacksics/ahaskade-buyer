import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

class SlidableOrderCard extends StatelessWidget {
  final List<Widget> secondaryActions;
  final int itemsCount;
  final String orderDate;
  final String shopName;
  final double price;
  final Function onTap;
  SlidableOrderCard({
    this.secondaryActions,
    this.itemsCount,
    this.orderDate,
    this.price,
    this.shopName,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: OrderDetails(
          itemsCount: itemsCount,
          orderDate: orderDate,
          price: price,
          shopName: shopName,
          onTap: onTap,
        ),
        secondaryActions: secondaryActions,
      ),
    );
  }
}

class OrderDetails extends StatelessWidget {
  final int itemsCount;
  final String orderDate;
  final String shopName;
  final double price;
  final Function onTap;
  OrderDetails(
      {this.itemsCount, this.orderDate, this.price, this.shopName, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.black12,
        padding: EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CircleAvatar(
              radius: 36.0,
              backgroundImage: AssetImage('images/orders.png'),
            ),
            SizedBox(
              width: 14.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    shopName.toUpperCase(),
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: Text(
                      'Number of Items: $itemsCount',
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  Text('$orderDate', style: TextStyle(fontSize: 12.0)),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Align(
                  alignment: FractionalOffset.bottomRight,
                  child: Text(
                    formatDoubleToPrice(price),
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
//            Column(
//              children: <Widget>[
//                Row(
//                  children: <Widget>[
//                    Icon(
//                      LineIcons.money,
//                      color: Colors.lightGreenAccent,
//                    ),
//                    SizedBox(
//                      width: 10.0,
//                    ),
//                    Text(
//                      '$price',
//                      style: TextStyle(
//                          fontSize: 20.0, color: Colors.lightGreenAccent),
//                    )
//                  ],
//                )
//              ],
//            )
          ],
        ),
      ),
    );
  }
}
