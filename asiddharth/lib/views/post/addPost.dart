import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:asiddharth/components/button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asiddharth/controllers/PostController.dart';
import 'package:asiddharth/models/postmodel.dart';
import 'package:toast/toast.dart';
import 'package:smart_select/smart_select.dart';

import '../HomePage.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class Post extends StatefulWidget {
  @override
  _Poststate createState() => _Poststate();
}

class _Poststate extends State<Post> {
  PostController controller = PostController();
  PostModel post = PostModel();
  final descTextController = TextEditingController();
  bool loading = false;
  int etap = 0;
  String dos = "next";
  List<String> text = ['add image', 'add description', 'add status'];
  @override
  Widget build(BuildContext context) {
    List<Widget> containers = [
      Containerimage(
          post: post,
          onpressed: () async {
            final x = await controller.getImage();
            setState(() {
              post.fileImage = x;
            });
          }),
      Containerdesc(
          controller: descTextController,
          onchanged: (value) {
            setState(() {
              post.description = value;
            });
          },
          post: post,
          changed: (state) {
            setState(() {
              post.status = state.value;
            });
          })
    ];
    post.userid = _auth.currentUser.uid.toString();
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Color(0xffF7F7F7),
        body: ModalProgressHUD(
            inAsyncCall: loading,
            child: SafeArea(
              child: ListView(
                children: [
                  SizedBox(
                    height: _height * 0.1,
                  ),
                  Center(
                    child: Padding(
                      padding:
                          EdgeInsets.all(0).copyWith(bottom: _height * 0.04),
                      child: Text(
                        text[etap],
                        style:
                            GoogleFonts.robotoSlab(fontSize: _height * 0.055),
                      ),
                    ),
                  ),
                  containers[etap],
                  SizedBox(
                    height: _height * 0.05,
                  ),
                  Padding(
                    padding: EdgeInsets.all(_height * 0.005),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Button(
                            text: 'back',
                            color: Colors.blueGrey,
                            ontap: () {
                              if (etap > 0) {
                                setState(() {
                                  etap--;
                                  setState(() {
                                    dos = "next";
                                  });
                                });
                              } else {
                                Toast.show('you are in the first page', context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                              }
                            }),
                        Button(
                            text: dos,
                            color: Colors.teal,
                            ontap: () async {
                              if (etap == 1) {
                                setState(() {
                                  loading=true;
                                });
                                final response = await controller.pushpost(post.userid, post.description, post.status);
                                if (response['status'] == true) {
                                  descTextController.clear();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()));
                                }
                                setState(() {
                                  loading=false;
                                });
                                Toast.show(response['message'], context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                              } else {
                                if (post.fileImage != null) {
                                  etap++;
                                  if (etap == 1) {
                                    setState(() {
                                      dos = "post";
                                    });
                                  }
                                } else {
                                  Toast.show(
                                      'image should not be empty', context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                }
                              }
                            }),
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}

class Containerimage extends StatelessWidget {
  Containerimage({this.post, this.onpressed});
  final post;
  final onpressed;
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Center(
      child: FlatButton(
        onPressed: onpressed,
        child: Container(
          height: _height * 0.5,
          width: _width * 0.9,
          child: post.fileImage != null
              ? Image.file(post.fileImage)
              : Icon(
                  Icons.add_a_photo,
                  color: Colors.teal,
                ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 1,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        hoverColor: Colors.amber,
      ),
    );
  }
}

class Containerdesc extends StatelessWidget {
  Containerdesc({this.controller, this.onchanged, this.post, this.changed});
  final post;
  final onchanged;
  final changed;
 final List<S2Choice<String>> options = [
    S2Choice<String>(value: 'public', title: 'public'),
    S2Choice<String>(value: 'private', title: 'private'),
  ];
  final controller;
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        height: _height * 0.5,
        width: _width * 0.9,
        child: ListView(children: [
          Padding(
            padding: EdgeInsets.all(0).copyWith(bottom: _height * 0.02),
            child: SmartSelect<String>.single(
              title: 'post status',
              value: post.status != null ? post.status : 'public',
              choiceItems: options,
              onChange: changed,
            ),
          ),
          Container(
            height: _height * 0.38,
            width: _width * 0.9,
            child: TextField(
              controller: controller,
              maxLines: 20,
              onChanged: onchanged,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.teal)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.white)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color: Colors.white,
                      )),
                  hintText: "describe your image ...."),
            ),
          ),
        ]),
      ),
    );
  }
}
