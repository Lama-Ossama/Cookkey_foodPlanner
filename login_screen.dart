import 'package:flutter/material.dart';
import 'package:food_planner_app/constants.dart';
import 'package:food_planner_app/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_planner_app/widgets/common_background.dart';
import 'package:provider/provider.dart';
import 'package:food_planner_app/providers/auth_provider.dart';
class LoginScreen extends StatefulWidget{
@override
  LoginScreenState createState() => LoginScreenState();
}
class LoginScreenState extends State<LoginScreen> {

  String? email;
  String? password;
  GlobalKey<FormState> formkey = GlobalKey();
  bool isPasswordVisible = false;
  final AuthService _auth = AuthService();
  bool _isGoogleLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          buildBackGround(),
          // Content
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child : Form(
                  key: formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sign In",
                        style: GoogleFonts.alexandria(
                          textStyle: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Hi! Welcome back, you've been missed",
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(height: 30),

                      // Email Field
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


                      // Sign In Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async{
                            print("Login button pressed");
                            if (formkey.currentState!.validate()) {
                              try {
                                UserCredential userCredential = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(email: email!, password: password!);
                                final authProvider = Provider.of<MyAuthProvider>(context,listen: false);
                                await authProvider.login(userCredential.user);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Logged in Successfully')),
                                );
                                Navigator.pushNamed(context, 'home_screen');
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('No user found for that email.')),
                                  );
                                } else if (e.code == 'wrong-password') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Wrong password provided.')),
                                  );
                                }
                                else
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.message ?? 'An error occurred')),
                                  );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text("Login",style: TextStyle(color: Colors.black),),
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
                              "Or sign in with",
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
                            "Don't have an account?",
                            style: TextStyle(color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, 'register_screen');
                            },
                            child: Text(
                              " Sign Up",
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
                      ElevatedButton(
                        onPressed: () async{
                        final authProvider = Provider.of<MyAuthProvider>(context,listen:false);
                        await authProvider.loginAsGuest();
                        Navigator.pushNamed(context, 'home_screen');
                      },
                        style: ElevatedButton.styleFrom(shape:
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),

                          )), child: Text("Continue as Guest",style: TextStyle(color: Colors.black),),)

                    ],
                  ),
    )

              ),
            ),
          ),
        ],
      ),
    );
  }



  // Widget to create a social icon inside a circle
  Widget _buildSocialIcon(IconData icon, VoidCallback onTap, bool isGoogleLoading) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: FaIcon(
          icon,
          size: 20,
          color: Colors.black,
        ),
      ),
    );
  }
}