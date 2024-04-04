
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myposts/pages/signin_page.dart';

import '../services/auth_service.dart';
import '../services/prefs_service.dart';
import '../services/utils_page.dart';

import 'home_page.dart';

class SignUpPage extends StatefulWidget {
  static const String id = "signup_page";

  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  var isLoading = false;

  var fullnameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  _doSignUp(){
    String name = fullnameController.text.toString().trim();
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    if(name.isEmpty || email.isEmpty || password.isEmpty) return;

    setState(() {
      isLoading = true;
    });
    AuthService.signUpUser(context, name, email, password).then((firebaseUser) => {
      _getFirebaseUser(firebaseUser),
    });
  }

  _getFirebaseUser(User? firebaseUser) async {
    setState(() {
      isLoading = false;
    });
    if (firebaseUser != null) {
      await Prefs.saveUserId(firebaseUser.uid);
      _callHomePage();
    } else {
      Utils.fireToast("Check your information");
    }
  }

  _callHomePage(){
    Navigator.pushReplacementNamed(context, HomePage.id);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: fullnameController,
                    decoration: InputDecoration(
                        hintText: "Fullname"
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: "Email"
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                        hintText: "Password"
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: double.infinity,
                    height: 45,
                    child: MaterialButton(
                      onPressed: _doSignUp,
                      color: Colors.blue,
                      child: Text("Sign Up",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: double.infinity,
                    height: 45,
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, SignInPage.id);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Already have an account?",style: TextStyle(color: Colors.black),),
                          SizedBox(width: 10,),
                          Text("Sign In",style: TextStyle(color: Colors.black),),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),

            isLoading?
            Center(
              child: CircularProgressIndicator(),
            ): SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

}