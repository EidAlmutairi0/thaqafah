import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'UserScreens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:thaqafah/Log_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  final _firebase = FirebaseFirestore.instance;
  bool showSpinner = false;

  var username;
  var confirmPassword;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("SIGN UP"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF9188E4), Color(0xFF776ECB)])),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF9188E4), Color(0xFF776ECB)],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 65, right: 65),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                username = value;
                              });
                            },
                            style: TextStyle(fontSize: 18, height: 1),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              hintText: "Username",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fillColor: Colors.grey[300],
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 65, right: 65),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                            style: TextStyle(fontSize: 18, height: 1),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              hintText: "Email",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fillColor: Colors.grey[300],
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 65, right: 65),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            obscureText: true,
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                            style: TextStyle(fontSize: 18, height: 1),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              hintText: "Password",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fillColor: Colors.grey[300],
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 65, right: 65),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            obscureText: true,
                            onChanged: (value) {
                              setState(() {
                                confirmPassword = value;
                              });
                            },
                            style: TextStyle(fontSize: 18, height: 1),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              hintText: "Confirm Password",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fillColor: Colors.grey[300],
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 80, right: 80),
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Color(0xFFD3A762),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: FlatButton(
                            onPressed: () async {
                              if (email == null ||
                                  password == null ||
                                  email == "" ||
                                  password == "" ||
                                  confirmPassword == null ||
                                  confirmPassword == "" ||
                                  username == null ||
                                  username == "") {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: Text("Empty blank is there"),
                                          content: Text(
                                              "Please fill all the blanks"),
                                          actions: [
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("OK"))
                                          ],
                                        ));
                              } else if (password != confirmPassword) {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: Text(
                                              "Password and it's Confirmation are not the same"),
                                          content: Text(
                                              "Please write them correctly"),
                                          actions: [
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("OK"))
                                          ],
                                        ));
                              } else {
                                try {
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  final checkuser = await _firebase
                                      .collection("Users")
                                      .doc("$username")
                                      .get();
                                  if (checkuser.exists) {
                                    throw ('username');
                                  }
                                  final newUser = await _auth
                                      .createUserWithEmailAndPassword(
                                          email: email, password: password);
                                  if (newUser != null) {
                                    _firebase
                                        .collection("Users")
                                        .doc(email)
                                        .set({
                                      "Username": username,
                                      "admin": false
                                    });
                                    _firebase
                                        .collection("Usernames")
                                        .doc(username)
                                        .set({"email": email});
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UserHomeScreen()),
                                    ).then((value) => setState(() {}));
                                  }
                                } catch (e) {
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  print("-------");
                                  print(e);
                                  print("-------");

                                  if (e == "username") {
                                    showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                              title: Text(
                                                  "Username is already taken"),
                                              content: Text(
                                                  "Please choose a new one"),
                                              actions: [
                                                FlatButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("OK"))
                                              ],
                                            ));
                                  } else if (e.toString() ==
                                      "[firebase_auth/weak-password] Password should be at least 6 characters") {
                                    showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                              title: Text(
                                                  "Password should be at least 6 characters"),
                                              actions: [
                                                FlatButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("OK"))
                                              ],
                                            ));
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                              title: Text("Email error "),
                                              content: Text(
                                                  "The email format may be invalid or the email has been taken "),
                                              actions: [
                                                FlatButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("OK"))
                                              ],
                                            ));
                                  }
                                }

                                setState(() {
                                  showSpinner = false;
                                });
                              }
                            },
                            child: Text(
                              "Sign up",
                              style:
                                  TextStyle(fontSize: 22, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => UserHomeScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
