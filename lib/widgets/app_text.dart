import 'package:flutter/material.dart';

class AppTextLarge extends StatelessWidget {
  final String text;
  AppTextLarge({this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 22.0),
    );
  }
}

class ProductCardTextLarge extends StatelessWidget {
  final String text;
  ProductCardTextLarge({this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ProductCardPriceText extends StatelessWidget {
  final String text;
  ProductCardPriceText({this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
