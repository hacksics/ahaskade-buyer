import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:g2hv1/assets/user_builder.dart';
import 'package:g2hv1/constants.dart';
import 'package:g2hv1/enums.dart';
import 'package:g2hv1/screens/add_new_order.dart';
import 'package:g2hv1/screens/loading_screen.dart';
import 'package:g2hv1/screens/order_details.dart';
import 'package:g2hv1/screens/user_profile_setup_screen.dart';
import 'package:g2hv1/widgets/common.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:g2hv1/widgets/order_details_card.dart';
import 'package:g2hv1/services/data_store.dart' as ds;
import 'package:g2hv1/services/network.dart';
import 'dart:convert';
import 'package:g2hv1/widgets/app_progress_dialog.dart';
import 'package:g2hv1/assets/order.dart';
import 'dart:developer' as logger;
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

enum SideMenu { profile, logout, about, language }

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<SlidableOrderCard>> slidableCardsFuture;
  List<Order> orders;
  int _selectedIndex = 0;

  Future<List<Order>> getOrders(int index) async {
    orders = [];
    AppProgressDialog progressDialog =
        AppProgressDialog(context: context, text: 'Loading..');
    final String request = '''
        { 
          "app-api-key": "$kAppApiKey", 
          "request": { 
            "mobile-number": "${UserController.to.user.mobileNumber}", 
            "order-status": $index, "user-type": "buyer" 
          }
        }
        ''';
    NetworkHelper nw = NetworkHelper();
    var response = await nw.postData(endpoint: '/order', data: request);
    for (var order in response['orders']) {
      Order orderObj = Order.fromJson(order);
      orders.add(orderObj);
    }
    return orders;
  }

  String getFormattedDate(double epochTime) {
    double microSecondsSinceEpoch = epochTime * 1000000;
    var date =
        new DateTime.fromMicrosecondsSinceEpoch(microSecondsSinceEpoch.toInt());
    return new DateFormat("yyyy-MM-dd hh:mm a").format(date);
  }

  Future<List<SlidableOrderCard>> getSlidableOrderCards(int index) async {
    List<SlidableOrderCard> slidableOrderCards = [];
    List<Order> orders = await getOrders(index);
    for (int orderIndex = 0; orderIndex < orders.length; orderIndex++) {
      String orderShopName = orders[orderIndex].shopName == null
          ? orders[orderIndex].sellerMobileNo
          : orders[orderIndex].shopName;
      slidableOrderCards.add(SlidableOrderCard(
        secondaryActions: <Widget>[null],
        itemsCount: orders[orderIndex].orderInfo.items.length,
        price: orders[orderIndex].orderInfo.orderTotal,
        orderDate: getFormattedDate(orders[orderIndex].orderDate),
        shopName: orderShopName,
        onTap: () {
          listenOrderCardTapEven(orderIndex);
        },
      ));
    }
    return slidableOrderCards;
  }

  Future<List<SlidableOrderCard>> deleteCard(int index) async {
    List<SlidableOrderCard> slidableOrderCardList = await slidableCardsFuture;
    slidableOrderCardList.removeAt(index);
    return slidableOrderCardList;
  }

  void listenOrderCardTapEven(int listIndex) {
    Get.to(OrderDetailsPage(
      order: orders[listIndex],
    ));
  }

  @override
  void initState() {
    slidableCardsFuture = getSlidableOrderCards(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<SideMenu>(
            icon: Icon(
              LineIcons.cog,
              //color: Colors.black,
              //size: 32,
            ),
            onSelected: (SideMenu result) async {
              if (result == SideMenu.profile) {
                Get.to(
                  UserProfileSetup(
                    userUpdateMode: UserUpdateMode.Existing,
                  ),
                );
              } else if (result == SideMenu.logout) {
                await ds.clearUserPref();
                Get.off(LoadingScreen());
              } else if (result == SideMenu.language) {
                await Get.dialog(
                  AlertDialog(
                    title: Text('Select the preferred language'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('English'),
                        onPressed: () async {
                          context.locale = Locale('en', '');
                          await ds.saveUserPref(
                              key: 'appLanguage', value: 'en');
                          logger.log('Language set: ${context.locale}');
                          Phoenix.rebirth(context);
                        },
                      ),
                      FlatButton(
                        child: Text('සිංහල'),
                        onPressed: () async {
                          context.locale = Locale('si', '');
                          await ds.saveUserPref(
                              key: 'appLanguage', value: 'si');
                          logger.log('Language set: ${context.locale}');
                          Phoenix.rebirth(context);
                        },
                      )
                    ],
                  ),
                  barrierDismissible: false,
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SideMenu>>[
              PopupMenuItem<SideMenu>(
                value: SideMenu.profile,
                child: Text(kMenuTextUserProfile),
              ),
              PopupMenuItem<SideMenu>(
                value: SideMenu.about,
                child: Text(kMenuTextAbout),
              ),
              PopupMenuItem<SideMenu>(
                value: SideMenu.language,
                child: Text('Language'),
              ),
              PopupMenuItem<SideMenu>(
                value: SideMenu.logout,
                child: Text(kMenuTextLogout),
              ),
            ],
          )
        ],
        leading: Icon(
          LineIcons.home,
          //size: 32,
          //color: Colors.grey[800],
        ),
        title: Text(
          kAppBarTextHomeScreen,
        ),
      ),
      body: Scaffold(
        body: FutureBuilder(
            future: slidableCardsFuture,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Center(child: AppProgressBroken());
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Center(child: AppProgressIndicator());
                case ConnectionState.done:
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      SlidableOrderCard slidableOrderCard =
                          snapshot.data[index];
                      return slidableOrderCard;
                    },
                  );
                default:
                  return Center(child: AppProgressBroken());
              }
            }),
      ),
      bottomNavigationBar: Container(
        decoration:
            BoxDecoration(color: kColorBackgroundWithOpacity, boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(.1),
          )
        ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
                gap: 4,
                //activeColor: Colors.white,
                iconSize: 20,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                duration: Duration(milliseconds: 800),
                tabBackgroundColor: Colors.grey[800],
                tabs: [
                  GButton(
                    icon: kIconOpenOrder,
                    text: kNavBarTextOpenOrders,
                  ),
                  GButton(
                    icon: kIconShippedOrder,
                    text: kNavBarTextScheduledOrders,
                  ),
                  GButton(
                    icon: kIconDeliveredOrder,
                    text: kNavBarTextCompletedOrders,
                  ),
                  GButton(
                    icon: kIconDeleteOrder,
                    text: kNavBarTextDeletedOrders,
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  print(index);
                  setState(() {
                    slidableCardsFuture = getSlidableOrderCards(index);
                    _selectedIndex = index;
                  });
                }),
          ),
        ),
      ),
      floatingActionButton: AppFloatingActionButton(
        buttonText: kButtonTextNewOrder,
        buttonIcon: kIconDeliveredOrder,
        onPressed: () {
          Get.to(AddNewOrder(UserController.to.user));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
