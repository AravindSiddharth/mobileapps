import 'package:flutter/material.dart';




class TextComp extends StatelessWidget {
  final String text;
  final Function ontap;
  final AlignmentDirectional alignment;

  TextComp({
    @required this.text,
    @required this.ontap,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: FlatButton(
            onPressed:ontap,
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 10,
              ),
            ),
          )),
    );
  }
}
