import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:asiddharth/components/textfield.dart';
import 'package:asiddharth/components/button.dart';
import 'package:asiddharth/components/textComp.dart';
import 'Signup.dart';
import 'resetpassword.dart';
import 'package:asiddharth/views/HomePage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asiddharth/models/Usermodel.dart';
import 'package:asiddharth/controllers/UserController.dart';
import 'package:toast/toast.dart';
class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  UserModel user= UserModel();
 final UserController controller=UserController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xffF7F7F7),
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
          inAsyncCall: loading,
          child:SafeArea(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height:_height * 0.13,
                ),
                Center(
                  child: Text(
                    'Signin',
                    style:GoogleFonts.robotoSlab(
                      fontSize:_height * 0.055,
                    )
                    ),
                ),
                SizedBox(
                  height:_height * 0.13,
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
                      user.useremail=value;
                    });

                  },
                ),
                SizedBox(
                  height:_height * 0.03,
                ),

                Textfields(
                  inputType: TextInputType.visiblePassword,
                  labetText: 'password',
                  hintText: 'Enter your password',
                  icon: Icons.lock,
                  password: true,
                  controller: passwordTextController,
                  onChanged:(value){
                    setState(() {
                      user.userpassword=value;
                    });

                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextComp(
                      text: "you forget password?",
                      ontap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Resetpass()));
                      },
                      alignment: AlignmentDirectional.bottomStart,
                    ),
                    TextComp(
                      text: "you don't have account?",
                      ontap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUP()));
                      },
                      alignment: AlignmentDirectional.bottomEnd,
                    ),
                  ],
                ),
                SizedBox(
                  height:_height * 0.085,
                ),
                Button(
                    text: 'SignIn',
                  ontap: () async {

                      setState(() {
                        loading=true;
                      });
                      final response =await controller.
                      login(user.useremail!=null?user.useremail:'',
                          user.userpassword!=null?user.userpassword:'');
                      if (response['status']==true) {
                        emailTextController.clear();
                        passwordTextController.clear();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                        }
                      else{

                        Toast.show(response['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                      }

                      setState(() {
                        loading=false;
                      });

                  },

                )

              ],
            ),
          ) ,
        ),

    );
  }
}