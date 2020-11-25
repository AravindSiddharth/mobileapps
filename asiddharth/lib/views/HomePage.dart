import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:asiddharth/views/post/addPost.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:asiddharth/controllers/UserController.dart';
import 'package:asiddharth/controllers/PostController.dart';
import 'package:asiddharth/views/auth/Signin.dart';
import 'post/postview.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  UserController usercontroller = UserController();
  PostController postController = PostController();
  int count = 0;
  bool loading = false;
  List<IconData> icons = [
    Icons.all_inclusive,
    Icons.cloud_download,
    Icons.not_interested
  ];
  List<Color> colors = [Colors.amber, Colors.green, Colors.redAccent];

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return StreamBuilder<QuerySnapshot>(
        stream: postController.getallposts(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return new Text('Error: ${snapshot.error}');
          }
            return Scaffold(
              backgroundColor: Color(0xffF7F7F7),
              body: ModalProgressHUD(
                inAsyncCall: loading,
                child: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(_height * 0.01)
                            .copyWith(top: _height * 0.025),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: _width * 0.7,

                              child: TextFormField(
                                cursorColor: Colors.black,
                                decoration: new InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: _height * 0.008,
                                        horizontal: _width * 0.045),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        )),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    suffixIcon: Icon(
                                      Icons.search,
                                      color: Colors.black,
                                    ),
                                    hintText: 'search'),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                icons[count],
                                color: colors[count],
                              ),
                              iconSize: _height * 0.04,
                              onPressed: () {
                                setState(() {
                                  count = (count + 1) % 3;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          itemCount: snapshot.data!=null?snapshot.data.docs.length:0,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing:_width*0.01,
                                mainAxisSpacing:_width*0.01,
                            crossAxisCount: 3,
                              ),
                          itemBuilder: (_, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  loading=true;
                                });
                                Navigator.push(context, MaterialPageRoute(builder:(context)=>PostView(id:snapshot.data.docs[index].id)));
                                setState(() {
                                  loading=false;
                                });
                              },
                              child: Image(image:NetworkImage(snapshot.data.docs[index].data()['imagepath'],),fit:BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: SpeedDial(
                marginRight: 18,
                marginBottom: 20,
                animatedIcon: AnimatedIcons.menu_close,
                animatedIconTheme: IconThemeData(size: _height * 0.04),
                overlayColor: Colors.white,
                overlayOpacity: 0.5,
                backgroundColor: Colors.amber,
                elevation: 8.0,
                shape: CircleBorder(),
                children: [
                  SpeedDialChild(
                      child: Icon(
                        Icons.person,
                      ),
                      backgroundColor: Colors.amber,
                      label: 'profile',
                      labelStyle: TextStyle(fontSize: _width * 0.04),
                      onTap: () => print('taped')),
                  SpeedDialChild(
                    child: Icon(Icons.add_a_photo),
                    backgroundColor: Colors.amber,
                    label: 'add post',
                    labelStyle: TextStyle(fontSize: _width * 0.04),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Post()));
                    },
                  ),
                  SpeedDialChild(
                    child: Icon(Icons.open_in_new),
                    backgroundColor: Colors.amber,
                    label: 'Log-out',
                    labelStyle: TextStyle(fontSize: _width * 0.04),
                    onTap: () async {
                      setState(() {
                        loading = true;
                      });
                      await usercontroller.logout();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => SignIn()));
                      setState(() {
                        loading = false;
                      });
                    },
                  ),
                ],
              ),
            );
          }
        );
  }
}
