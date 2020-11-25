import 'package:asiddharth/views/auth/Signin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:asiddharth/components/textfield.dart';
import 'package:asiddharth/components/button.dart';
import 'package:asiddharth/components/textComp.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asiddharth/models/Usermodel.dart';
import 'package:asiddharth/controllers/UserController.dart';
import 'package:toast/toast.dart';

class SignUP extends StatefulWidget {
  @override
  _SignUPState createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {
  UserModel user = UserModel();
  String password;
  final UserController controller = UserController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confpasswordTextController = TextEditingController();
  final nameTextController = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xffF7F7F7),
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: SafeArea(
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: _height * 0.04,
              ),
              Center(
                child: Text('Signup',
                    style: GoogleFonts.robotoSlab(
                      fontSize: _height * 0.055,
                    )),
              ),
              SizedBox(
                height: _height * 0.05,
              ),
              Textfields(
                inputType: TextInputType.emailAddress,
                labetText: 'name',
                hintText: 'Enter your name',
                icon: Icons.person,
                enabled: true,
                controller: nameTextController,
                onChanged: (value) {
                  setState(() {
                    user.username = value;
                  });
                },
              ),
              SizedBox(
                height: _height * 0.025,
              ),
              Textfields(
                  inputType: TextInputType.emailAddress,
                  labetText: 'Email',
                  hintText: 'Enter your email',
                  icon: Icons.person,
                  enabled: true,
                  controller: emailTextController,
                  onChanged: (value) {
                    setState(() {
                      user.useremail = value;
                    });
                  }),
              SizedBox(
                height: _height * 0.025,
              ),
              Textfields(
                  inputType: TextInputType.visiblePassword,
                  labetText: 'password',
                  hintText: 'Enter your password',
                  icon: Icons.lock,
                  password: true,
                  controller: passwordTextController,
                  onChanged: (value) {
                    setState(() {
                      user.userpassword = value;
                    });
                  }),
              SizedBox(
                height: _height * 0.025,
              ),
              Textfields(
                  inputType: TextInputType.visiblePassword,
                  labetText: 'password',
                  hintText: 'confirme  your password',
                  icon: Icons.lock,
                  password: true,
                  controller:confpasswordTextController,
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  }),
              TextComp(
                text: "do you have account?",
                ontap: () {
                  Navigator.pop(context);
                },
                alignment: AlignmentDirectional.bottomEnd,
              ),
              SizedBox(
                height: _height * 0.025,
              ),
              Button(
                  text: 'SignUP',
                  ontap: () async {
                    setState(() {
                      loading=true;
                    });
                      final response = await controller.signup(user.useremail, user.userpassword,password, user.username);
                      if (response['status']==true) {
                        emailTextController.clear();
                        passwordTextController.clear();
                        nameTextController.clear();
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
        ),
      ),
    );
  }
}
