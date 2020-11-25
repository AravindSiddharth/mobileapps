import 'package:flutter/material.dart';

class Textfields extends StatelessWidget {
  final String labetText;
  final String hintText;
  final IconData icon;
  final bool password;
  final Widget pre;
  final TextInputType inputType;
  final int min;
  final Function onChanged;
  final bool enabled;
  final TextEditingController controller;
  final int max;

  Textfields({
    @required this.labetText,
    @required this.hintText,
    @required this.icon,
    this.password = false,
    this.pre,
    this.min,
    this.inputType = TextInputType.text,
    this.onChanged,
    this.enabled = true,
    this.controller,
    this.max = 1
  });

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 26,
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        onChanged: onChanged,
        keyboardType: inputType,
        obscureText: password,
        maxLines: max,
        minLines: min,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical:10, horizontal: 20),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.black)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color:  Colors.black)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color:  Colors.black,
              )),
          labelText: labetText,
          labelStyle: TextStyle(
            fontFamily: 'Adobe Devanagari',
            color: Color(0xff4D4D4D),
            fontSize: _height * 0.02,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
              color: Color(0xff0F4B41),
              fontSize: _height * 0.02,
              fontFamily: 'Adobe Devanagari'),
          suffixIcon: Icon(
            icon,
            color:  Colors.black,
          ),
          prefix: pre,
        ),
      ),
    );
  }
}