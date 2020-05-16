import 'package:flutter/material.dart';
import 'package:g2hv1/assets/user.dart';
import 'package:g2hv1/screens/select_shopping_list.dart';
import 'package:g2hv1/widgets/app_progress_dialog.dart';
import 'package:g2hv1/widgets/cards.dart';
import 'dart:developer' as logger;
import 'package:g2hv1/services/network.dart';
import 'package:g2hv1/constants.dart';
import 'package:g2hv1/assets/seller.dart';

class AddNewOrder extends StatefulWidget {
  final User user;
  AddNewOrder(this.user);
  @override
  _AddNewOrderState createState() => _AddNewOrderState();
}

class _AddNewOrderState extends State<AddNewOrder> {
  // Futures for FutureBuilder
  //Future<List<DropdownMenuItem>> dropdownMenuItemFuture;
  Future<List<SellerCard>> sellerCardListFuture;

  // Lazy loaded objects. Need to check size of the list before accessing
  List<Seller> sellerList = [];

  User user;

  String userCurrentCity;

//  Widget getCityListWidget(List<DropdownMenuItem> dropdownItems) {
//    return SearchableDropdown.single(
//        items: dropdownItems,
//        value: userCurrentCity,
//        onChanged: (item) {
//          logger.log('City selected from list: $item');
//          setState(() {
//            sellerCardListFuture = loadSellerListForACity(item);
//            userCurrentCity = item;
//          });
//        });
//  }

  Future<List<SellerCard>> loadSellerListForACity(String city) async {
    List<SellerCard> sellerCards = [];
    final String request = '''
    { 
      "app-api-key": "$kAppApiKey", 
      "request": { 
        "mobile-number": "${user.mobileNumber}",
        "city": "$city"
      }
    } 
    ''';
    logger.log('Get Sellers POST request: $request');
    NetworkHelper nw = NetworkHelper();
    var response = await nw.postData(endpoint: '/geo/sellers', data: request);
    logger.log('Get Sellers POST response: $response');
    for (var sellerJson in response['Sellers']) {
      Seller seller = Seller.fromJson(sellerJson);
      sellerList.add(seller);
      sellerCards.add(SellerCard(seller: seller, user: user));
    }
    return sellerCards;
  }

//  Future<List<DropdownMenuItem>> loadCityListToDropdownList() async {
//    List<DropdownMenuItem> list = [];
//    final String request = '''
//    {
//      "app-api-key": "$kAppApiKey",
//      "request": {
//        "mobile-number": "${user.mobileNumber}"
//      }
//    }
//    ''';
//    logger.log('Geo Cities POST request: $request');
//    NetworkHelper nw = NetworkHelper();
//    var response = await nw.postData(endpoint: '/geo/cities', data: request);
//    for (String cities in response['cities']) {
//      list.add(DropdownMenuItem(
//        child: Text(cities),
//        value: cities,
//      ));
//    }
//
//    return list;
//  }

  @override
  void initState() {
    user = widget.user;
    userCurrentCity = user.userProfile.cities[0];

    //dropdownMenuItemFuture = loadCityListToDropdownList();
    sellerCardListFuture = loadSellerListForACity(userCurrentCity);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Seller'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: Text('Showing sellers delivering to $userCurrentCity'),
//            child: Column(
//              children: <Widget>[
//                FutureBuilder(
//                  future: dropdownMenuItemFuture,
//                  builder: (context, snapshot) {
//                    switch (snapshot.connectionState) {
//                      case ConnectionState.none:
//                      case ConnectionState.active:
//                      case ConnectionState.waiting:
//                        return Center(child: AppProgressIndicator());
//                      case ConnectionState.done:
//                        return getCityListWidget(snapshot.data);
//                      default:
//                        return Center(child: AppProgressIndicator());
//                    }
//                  },
//                ),
//              ],
//            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: sellerCardListFuture,
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
                          SellerCard sellerCard = snapshot.data[index];
                          return sellerCard;
                        },
                      );
                    default:
                      return Center(child: AppProgressIndicator());
                  }
                }),
          )
        ],
      ),
    );
  }
}

class SellerCard extends StatelessWidget {
  final Seller seller;
  final User user;
  SellerCard({this.seller, this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          logger.log('seller card clicked: ${seller.mobileNumber}');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SelectShoppingList(
                        user: user,
                        seller: seller,
                      )));
        },
        child: Column(
          children: <Widget>[
//            Text(seller.sellerTitle),
//            Text(seller.sellerName),
//            Text(seller.mobileNumber),
            ShopCard(seller: seller)
          ],
        ),
      ),
    );
  }
}
