import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const double kButtonHeight = 40.0;

const ShapeBorder kIconButtonRectangleBorder = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(5.0),
  ),
);

const ShapeBorder kTextOnlyButtonRectangleBorder = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(2.0),
  ),
);

class AppTextButton extends StatelessWidget {
  final Function onPressed;
  final String buttonText;
  AppTextButton({@required this.onPressed, @required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      child: Text(buttonText),
      shape: kTextOnlyButtonRectangleBorder,
    );
  }
}

class AppIconButton extends StatelessWidget {
  final Function onPressed;
  final String buttonText;
  final IconData buttonIcon;
  AppIconButton(
      {@required this.onPressed,
      @required this.buttonText,
      @required this.buttonIcon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kButtonHeight,
      child: RaisedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(buttonIcon),
            SizedBox(
              width: 10,
            ),
            Text(buttonText)
          ],
        ),
        shape: kIconButtonRectangleBorder,
      ),
    );
  }
}

class AppFloatingActionButton extends StatelessWidget {
  final Function onPressed;
  final IconData buttonIcon;
  final String buttonText;
  AppFloatingActionButton(
      {@required this.onPressed,
      @required this.buttonIcon,
      @required this.buttonText});
  @override
  Widget build(BuildContext context) {
    var heroTag = Uuid().v1();
    return SizedBox(
      height: kButtonHeight,
      child: FloatingActionButton.extended(
        heroTag: heroTag,
        onPressed: onPressed,
        icon: Icon(buttonIcon),
        label: Text(buttonText),
        shape: kIconButtonRectangleBorder,
      ),
    );
  }
}

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

class AppTextField extends StatelessWidget {
  final TextEditingController textEditor;
  AppTextField({@required this.textEditor});
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(fontSize: 15.0, color: Colors.black),
      controller: textEditor,
      decoration: InputDecoration(
        filled: true,
        contentPadding: EdgeInsets.only(left: 4.0),
        border: OutlineInputBorder(),
        fillColor: Colors.white,
      ),
    );
  }
}

class AppNumberField extends StatelessWidget {
  final TextEditingController textEditor;
  AppNumberField({@required this.textEditor});
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType:
          TextInputType.numberWithOptions(signed: false, decimal: true),
      style: TextStyle(fontSize: 18.0, color: Colors.black),
      controller: textEditor,
      decoration: InputDecoration(
        filled: true,
        contentPadding: EdgeInsets.only(left: 4.0),
        border: OutlineInputBorder(),
        fillColor: Colors.white,
      ),
    );
  }
}
