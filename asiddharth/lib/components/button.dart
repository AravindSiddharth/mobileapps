import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final Function ontap;
   final Color color;
  Button({
    @required this.text,
    @required this.ontap,
     this.color=Colors.black
});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: ontap,
      child: Container(
        child:Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 26,
          ),
          child: Text(
            text,
            style: TextStyle(
                fontSize:20,
                color: Colors.white
            ),
          ),
        ),
        decoration: BoxDecoration(
            color: color,
            borderRadius:BorderRadius.circular(20)
        ),

      ),
    );
  }

}