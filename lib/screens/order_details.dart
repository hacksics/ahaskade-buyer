import 'package:flutter/material.dart';
import 'dart:developer' as logger;
import 'package:g2hv1/assets/order.dart';
import 'package:g2hv1/assets/user_builder.dart';
import 'package:g2hv1/screens/home_screen.dart';
import 'package:g2hv1/widgets/app_progress_dialog.dart';
import 'package:g2hv1/widgets/cards.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsPage extends StatefulWidget {
  final Order order;
  OrderDetailsPage({@required this.order});
  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  Order order;
  List<ItemDetailsCard> itemCardsList;

  @override
  void initState() {
    order = widget.order;
    itemCardsList = getItemCardsList();
    logger.log('Page init called for Order Details: ${order.orderId}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String shopName = order.shopName == null ? 'Not Available' : order.shopName;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 40.0,
                        backgroundImage: AssetImage('images/order_details.png'),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '$shopName',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          GestureDetector(
                            // TODO: Calling by tapping the number not working yet
                            onTap: () async {
                              if (await canLaunch(
                                  'tel: ${order.sellerMobileNo}')) {
                                await launch('tel: ${order.sellerMobileNo}');
                              } else {
                                logger.log(
                                    'unable to launch phone called ${order.sellerMobileNo}');
                              }
                            },
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.call,
                                  color: Colors.green,
                                ),
                                OrderDetailsHeaderWidgetText(
                                    ' ${order.sellerMobileNo}'),
                              ],
                            ),
                          ),
                          OrderDetailsHeaderWidgetText(
                              'Order Total: ${order.orderInfo.orderTotal}'),
                          OrderDetailsHeaderWidgetText(
                              'Items: ${order.orderInfo.items.length}'),
                        ],
                      ),
                    ],
                  ),
                ),
                getDeleteButton()
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: itemCardsList.length,
              itemBuilder: (context, index) {
                ItemDetailsCard itemCard = itemCardsList[index];
                return itemCard;
              },
            ),
          )
        ],
      ),
    );
  }

  Widget getDeleteButton() {
    if (order.orderStatus == 0) {
      return GestureDetector(
        onTap: () async {
          AppProgressDialog appProgressDialog =
              AppProgressDialog(text: 'Sending..', context: context);
          appProgressDialog.show();
          await order.deleteOrder(UserController.to.user);
          appProgressDialog.hide();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Icon(
                Icons.delete,
                size: 50.0,
                color: Colors.red,
              ),
              Text(
                'CANCEL',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
        ),
      );
    }
    return Container();
  }

  List<ItemDetailsCard> getItemCardsList() {
    List<ItemDetailsCard> cardsList = [];
    for (var item in order.orderInfo.items) {
      cardsList.add(ItemDetailsCard(item));
    }
    return cardsList;
  }
}

class OrderDetailsHeaderWidgetText extends StatelessWidget {
  final String text;
  OrderDetailsHeaderWidgetText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }
}
