import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thaqafah/Log_in_screen.dart';

class UserHomeScreen extends StatefulWidget {
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final _auth = FirebaseAuth.instance;

  int currentIndex = 1;

  final _firebase = FirebaseFirestore.instance;
  var username;

  User loggedInUser;
  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;

      if (user != null) {
        loggedInUser = user;
        final snapshot =
            await _firebase.collection("Users").doc("$email").get();
        username = await snapshot.get("Username");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      Center(
        child: Column(
          children: [
            Text(
              "Profile",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 60,
              width: 200,
              decoration: BoxDecoration(
                color: Color(0xFFD3A762),
                borderRadius: BorderRadius.circular(5),
              ),
              child: FlatButton(
                child: Text(
                  "Log out",
                  style: TextStyle(fontSize: 22, color: Colors.black),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: Text("Are you sure about logging out? "),
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("NO")),
                              FlatButton(
                                  onPressed: () {
                                    _auth.signOut();

                                    Navigator.popUntil(context,
                                        ModalRoute.withName("LoginScreen"));
                                  },
                                  child: Text("YES"))
                            ],
                          ));
                },
              ),
            )
          ],
        ),
      ),
      Center(
        child: Text(
          "Home ",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
      Center(
        child: Text(
          "Leaderboard",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
    ];
    return Scaffold(
      bottomNavigationBar: ConvexAppBar(
        color: Colors.white,
        backgroundColor: Color(0xFF673ab7),
        items: [
          TabItem(icon: Icons.person, title: 'Profile'),
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.poll_outlined, title: 'Leaderboard '),
        ],
        initialActiveIndex: 1, //optional, default as 0
        onTap: (int i) {
          setState(() {
            currentIndex = i;
          });
        },
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF9188E4), Color(0xFF776ECB)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                child: tabs[currentIndex],
                padding: const EdgeInsets.only(top: 40),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
