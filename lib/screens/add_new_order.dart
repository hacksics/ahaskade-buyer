import 'package:flutter/material.dart';
import 'package:g2hv1/assets/user.dart';
import 'package:g2hv1/assets/user_builder.dart';
import 'package:g2hv1/screens/select_shopping_list.dart';
import 'package:g2hv1/widgets/app_progress_dialog.dart';
import 'package:g2hv1/widgets/cards.dart';
import 'dart:developer' as logger;
import 'package:g2hv1/services/network.dart';
import 'package:g2hv1/constants.dart';
import 'package:g2hv1/assets/seller.dart';
import 'package:get/get.dart';

class AddNewOrder extends StatefulWidget {
  AddNewOrder();
  @override
  _AddNewOrderState createState() => _AddNewOrderState();
}

class _AddNewOrderState extends State<AddNewOrder> {
  // Futures for FutureBuilder
  Future<List<SellerCard>> sellerCardListFuture;

  // Lazy loaded objects. Need to check size of the list before accessing
  List<Seller> sellerList = [];

  User user;
  String userCurrentCity;

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
    NetworkHelper nw = NetworkHelper();
    var response = await nw.postData(endpoint: '/geo/sellers', data: request);
    for (var sellerJson in response['Sellers']) {
      Seller seller = Seller.fromJson(sellerJson);
      sellerList.add(seller);
      sellerCards.add(SellerCard(seller: seller));
    }
    return sellerCards;
  }

  @override
  void initState() {
    user = UserController.to.user;
    userCurrentCity = user.userProfile.cities[0];
    sellerCardListFuture = loadSellerListForACity(userCurrentCity);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kAppBarTextSelectSeller),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: Text(kTextSellerHeaderText(city: userCurrentCity)),
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
  SellerCard({@required this.seller});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Get.to(SelectShoppingList(
            seller: seller,
          ));
        },
        child: Column(
          children: <Widget>[ShopCard(seller: seller)],
        ),
      ),
    );
  }
}
