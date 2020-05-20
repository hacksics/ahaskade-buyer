import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:g2hv1/assets/user.dart';
import 'package:g2hv1/assets/user_builder.dart';
import 'package:g2hv1/screens/home_screen.dart';
import 'package:g2hv1/widgets/app_progress_dialog.dart';
import 'package:g2hv1/widgets/cards.dart';
import 'package:g2hv1/widgets/common.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'dart:developer' as logger;
import 'package:g2hv1/services/network.dart';
import 'package:g2hv1/constants.dart';
import 'package:g2hv1/assets/seller.dart';
import 'package:g2hv1/assets/shopping_list.dart';
import 'package:g2hv1/assets/user.dart';
import 'package:flutter_counter/flutter_counter.dart';

class CompleteOrder extends StatefulWidget {
  final ShoppingList shoppingList;
  final Seller seller;
  CompleteOrder({@required this.shoppingList, @required this.seller});
  @override
  _CompleteOrderState createState() => _CompleteOrderState();
}

class _CompleteOrderState extends State<CompleteOrder> {
  ShoppingList shoppingList;
  User user;
  Seller seller;
  double listTotal;

  @override
  void initState() {
    user = UserController.to.user;
    seller = widget.seller;
    shoppingList = widget.shoppingList;
    listTotal = shoppingList.getListTotal();
    logger.log(
        'Complete order screen initiated with, user: ${user.mobileNumber}, seller: ${seller.mobileNumber}, listTotal: $listTotal}');
    super.initState();
  }

  Future<void> submitOrder() async {
    AppProgressDialog appProgressDialog =
        AppProgressDialog(text: 'Sending..', context: context);
    appProgressDialog.show();
    var requestBody =
        jsonEncode(shoppingList.getOrderRequest(user: user, seller: seller));
    var request = '''
      {
        "app-api-key": "test-key",
        "request": $requestBody
      }
      ''';
    NetworkHelper nw = NetworkHelper();
    await nw.putData(endpoint: '/order', data: request);
    appProgressDialog.hide();
    Get.offAll(HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kAppBarCompleteOrder),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 40.0,
                  backgroundImage:
                      AssetImage('images/shop_template_image_2.png'),
                ),
                SizedBox(
                  width: 15.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${seller.sellerTitle}'.toUpperCase(),
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      kTextTotalValue(formatDoubleToPrice(listTotal)),
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      kTextItemsSelected(
                          total: shoppingList.shoppingListItems.length,
                          selected: shoppingList.getSelectedItemsCount()),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: shoppingList.shoppingListItems.length,
              itemBuilder: (context, index) {
                ItemCard itemCard = ItemCard(
                    cardIndex: index,
                    shoppingListItem: shoppingList.shoppingListItems[index],
                    onChanged: (value) {
                      setState(() {
                        shoppingList.shoppingListItems[index].unit = value;
                        listTotal = shoppingList.getListTotal();
                      });
                    },
                    onCheckBoxChanged: (value) {
                      setState(() {
                        shoppingList.shoppingListItems[index].selected = value;
                        listTotal = shoppingList.getListTotal();
                      });
                    });
                return itemCard;
              },
            ),
          ),
        ],
      ),
      floatingActionButton: AppFloatingActionButton(
        buttonText: kTextSubmitOrder,
        buttonIcon: kIconSave,
        onPressed: () async {
          await submitOrder();
        },
      ),
    );
  }
}
