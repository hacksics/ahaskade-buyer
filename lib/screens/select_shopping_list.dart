import 'package:flutter/material.dart';
import 'package:g2hv1/assets/shopping_list.dart';
import 'package:g2hv1/assets/user.dart';
import 'package:g2hv1/screens/complete_order.dart';
import 'package:g2hv1/widgets/app_progress_dialog.dart';
import 'package:g2hv1/widgets/cards.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'dart:developer' as logger;
import 'package:g2hv1/services/network.dart';
import 'package:g2hv1/constants.dart';
import 'package:g2hv1/assets/seller.dart';

class SelectShoppingList extends StatefulWidget {
  final Seller seller;
  final User user;
  SelectShoppingList({this.seller, this.user});
  @override
  _SelectShoppingListState createState() => _SelectShoppingListState();
}

class _SelectShoppingListState extends State<SelectShoppingList> {
  Future<List<ShoppingListCard>> shoppingListCardListFuture;
  Seller seller;
  User user;
  List<ShoppingList> shoppingListList = [];

  Future<List<ShoppingListCard>> getShoppingListCardsList() async {
    List<ShoppingListCard> listShoppingCard = [];
    final String request = '''
    { 
      "app-api-key": "$kAppApiKey", 
      "request": { 
        "mobile-number": "${user.mobileNumber}",
        "seller-mobile-number": "${seller.mobileNumber}"
      }
    } 
    ''';
    logger.log('Get Sellers POST request: $request');
    NetworkHelper nw = NetworkHelper();
    var response = await nw.postData(endpoint: '/seller/list', data: request);
    logger.log('Get Sellers POST response: $response');
    for (var listsJson in response['shopping-lists']) {
      ShoppingList shoppingList = ShoppingList.fromJson(listsJson);
      shoppingListList.add(shoppingList);
      listShoppingCard.add(ShoppingListCard(
        shoppingList: shoppingList,
        user: user,
        seller: seller,
      ));
    }

    return listShoppingCard;
  }

  @override
  void initState() {
    seller = widget.seller;
    user = widget.user;
    logger.log(
        'select shopping list init with seller: ${seller.mobileNumber} and user: ${user.mobileNumber}');
    shoppingListCardListFuture = getShoppingListCardsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose a Shopping List'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 10.0),
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
                      height: 10.0,
                    ),
                    Text(
                      'Seller: ${seller.sellerName}',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(
                      height: 6.0,
                    ),
                    Text('Mobile: ${seller.mobileNumber}')
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: shoppingListCardListFuture,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Center(child: AppProgressIndicator());
                  case ConnectionState.done:
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        ShoppingListCard shoppingListCard =
                            snapshot.data[index];
                        return shoppingListCard;
                      },
                    );
                  default:
                    return Center(child: AppProgressIndicator());
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class ShoppingListCard extends StatelessWidget {
  final ShoppingList shoppingList;
  final User user;
  final Seller seller;
  ShoppingListCard({this.shoppingList, this.user, this.seller});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
          onTap: () {
            logger.log('shopping list card clicked: ${shoppingList.listId}');
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CompleteOrder(
                          user: user,
                          shoppingList: shoppingList,
                          seller: seller,
                        )));
          },
          child: ListCard(
            cardTitle: shoppingList.listId,
            cardDescription: shoppingList.listName,
          )),
    );
  }
}
