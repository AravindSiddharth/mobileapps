import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:asiddharth/components/textfield.dart';
import 'package:asiddharth/components/button.dart';
import 'package:asiddharth/components/textComp.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asiddharth/views/auth/Signin.dart';
import 'package:asiddharth/controllers/UserController.dart';
import 'package:toast/toast.dart';
class Resetpass extends StatefulWidget {
  @override
  _ResetpassState createState() => _ResetpassState();
}

class _ResetpassState extends State<Resetpass> {
  UserController controller = UserController();
  bool loading=false;
  final emailTextController = TextEditingController();
  String email;
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Color(0xffF7F7F7),
        resizeToAvoidBottomInset: false,
        body:SingleChildScrollView(
          child: ModalProgressHUD(
            inAsyncCall: loading,
            child:SafeArea(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height:_height * 0.15,
                    ),
                    Text(
                        'Reset Password',
                        style:GoogleFonts.robotoSlab(
                          fontSize:_height * 0.050,
                        )
                    ),
                    SizedBox(
                      height:_height * 0.15,
                    ),
                    Textfields(
                      inputType: TextInputType.emailAddress,
                      labetText: 'Email',
                      hintText: 'Enter your email',
                      icon: Icons.person,
                      enabled: true,
                      controller: emailTextController,
                      onChanged:(value){
                        setState(() {
                          email=value;
                        });
                      },
                    ),
                    TextComp(
                      text: "we will send reset password message to this email",
                      ontap: (){},
                      alignment: AlignmentDirectional.bottomStart,
                    ),

                    SizedBox(
                      height:_height * 0.1,
                    ),
                    Button(text: 'Send',
                        ontap: ()async{
                       setState(() {
                         loading=false;
                       });
                     final response= await controller.resetpassword(email);
                       if (response['status']==true) {
                         emailTextController.clear();
                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>SignIn()));
                       }
                       else{
                         Toast.show(response['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                       }
                       setState(() {
                         loading=false;
                       });
                        })

                  ],
                ),
            ) ,
          ),
        )
    );
  }
}