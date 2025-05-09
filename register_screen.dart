import 'package:flutter/material.dart';
import 'package:food_planner_app/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_planner_app/services/auth_service.dart';
import 'package:food_planner_app/widgets/common_background.dart';
class RegisterScreen extends StatefulWidget {
  @override
  RegisterScreenState  createState() =>  RegisterScreenState ();
}
class RegisterScreenState extends State<RegisterScreen>{
  String? email;
  String? password;
  GlobalKey<FormState> formkey = GlobalKey();
  bool isPasswordVisible = false;
  final AuthService _auth = AuthService();
  bool _isGoogleLoading = false;

  Widget build(BuildContext context) {

    return Scaffold(
      body :Stack(
        children: [
          buildBackGround(),
          Center(

            child:Padding(padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Form(
                key: formkey,

                child:Column(
                  children: [
                    Text(
                      "Register",
                      style: GoogleFonts.alexandria(
                        textStyle: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      validator: (data){
                        if(data!.isEmpty){
                          return'the field is required';
                        }
                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(data)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      onChanged:(data) {
                        email = data;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Password Field
                    TextFormField(
                      validator: (data){
                        if(data!.isEmpty){
                          return'the field is required';
                        }
                        if (data.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        if (!data.contains(RegExp(r'[0-9]'))) {
                          return 'Password must contain at least one number';
                        }
                        if (!data.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                          return 'Password must contain at least one symbol';
                        }
                        return null;
                      },
                      onChanged: (data){
                        password = data;
                      },
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if(formkey.currentState!.validate()){
                            try {
                              UserCredential userCredential = await FirebaseAuth
                                  .instance.createUserWithEmailAndPassword(
                                  email: email!, password: password!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Registered Successfully'),),);
                            }
                            on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('weak Password'),),);
                              } else if (e.code == 'email-already-in-use') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('the account already exists for this email'),),);
                              }
                            }
                          }

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text("Sign Up",style: TextStyle(color: Colors.black),),
                      ),
                    ),
                    SizedBox(height: 20),


                    Row(
                      children: [
                        Expanded(
                            child: Divider(
                              color: Colors.white,
                              thickness: 1,
                            )),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Or Sign Up With",
                            style:
                            TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        Expanded(
                            child: Divider(
                              color: Colors.white,
                              thickness: 1,
                            )),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Social Icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialIcon(FontAwesomeIcons.google, () async {
                          setState(() => _isGoogleLoading = true);
                          final user = await _auth.signInWithGoogle();
                          setState(() => _isGoogleLoading = false);
                          if (user != null) {
                            Navigator.pushReplacementNamed(
                              context,
                              'home_screen'
                            );
                          }
                        },
                          _isGoogleLoading,
                        ),
                      ],
                    ),
                    SizedBox(height: 30),

                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an Account?",
                          style: TextStyle(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            " Log In",
                            style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                  ],
                ),
            ),
            ),)

          )
        ],
      )
    );
  }
} Widget _buildSocialIcon(IconData icon, VoidCallback onTap,bool isLoading) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: isLoading
          ? CircularProgressIndicator(
        color: Colors.black,
        strokeWidth: 2,
      ):
      FaIcon(
        icon,
        size: 20,
        color: Colors.black,
      ),
    ),
  );
}
