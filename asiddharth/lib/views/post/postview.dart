import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:asiddharth/controllers/PostController.dart';
import 'package:toast/toast.dart';

import '../HomePage.dart';

class PostView extends StatefulWidget {
  final id;
  PostView({@required this.id});
  @override
  _Poststateview createState() => _Poststateview(id: id);
}

class _Poststateview extends State<PostView> {
  final id;
  _Poststateview({@required this.id});
  PostController controller = PostController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return FutureBuilder<DocumentSnapshot>(
        future: controller.getpost(id),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if(!snapshot.hasData){
            return Center(
              child:Icon(Icons.access_time),
            );
          }
          else {
            if(snapshot.data!=null) {
              final post = snapshot.data.data();
              return Scaffold(
                  backgroundColor: Color(0xffF7F7F7),
                  body: ModalProgressHUD(
                    inAsyncCall: loading,
                    child: SafeArea(
                      child: ListView(
                        children: [
                          Padding(
                            padding:
                            EdgeInsets.all(0).copyWith(top: _height * 0.05),
                              child: Container(
                                height: _height * 0.5,
                                width: _width * 0.9,
                                child: InteractiveViewer(
                                    minScale: 0.5,
                                    maxScale: 2,
                                    child: Image.network(post['imagepath'])),
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
                          ),
                          Padding(
                            padding: EdgeInsets.all(0).copyWith(
                                top: _height * 0.015,),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children:[
                                post["userid"]==FirebaseAuth.instance.currentUser.uid?
                                IconButton(
                                  icon:Icon(Icons.delete_forever),
                                  onPressed:()async{
                                    setState(() {
                                      loading=false;
                                    });
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()));
                                      final res=await controller.deletpost(id,post['imagepath']);
                                      setState(() {
                                        loading=false;
                                      });
                                      Toast.show(
                                          res['message'],
                                          context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.BOTTOM);
                                  },
                                ):SizedBox(),
                                SizedBox(
                                  width: _width*0.05,
                                ),
                               IconButton(
                                icon: Icon(
                                    post['status'] == 'public'
                                        ? Icons.cloud_download
                                        : Icons.not_interested,
                                    color: post['status'] == 'public'
                                        ? Colors.teal
                                        : Colors.deepOrange),
                                onPressed: () async{
                                  if (post['status'] == 'public') {
                                    final res=await controller.downloadpostimage(post['imagepath']);
                                    Toast.show(
                                        res['message'],
                                        context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.BOTTOM);
                                  }
                                  else {
                                    Toast.show(
                                        'this image can not be downloaded',
                                        context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.BOTTOM);
                                  }
                                },
                              ),
                    ]
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(0).copyWith(left:_width*0.04),
                            child: Text(
                              post['description'] != null
                                  ? post['description']
                                  : "no description",
                              style: GoogleFonts.roboto(
                                  color: Colors.black, fontSize: _height * 0.03),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
              );
            }
            else{
              return Center(
                child:Icon(Icons.access_time),
              );
            }
          }
        });
  }
}
