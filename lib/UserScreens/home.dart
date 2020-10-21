import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thaqafah/Log_in_screen.dart';
import 'package:thaqafah/main.dart';
import 'package:thaqafah/UserScreens/User_Category.dart';
import 'package:thaqafah/my_quizzes.dart';

class UserHomeScreen extends StatefulWidget {
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen>
    with TickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;

  int currentIndex = 1;

  final _firebase = FirebaseFirestore.instance;

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
    String categoryName;
    final tabs = [
      Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.white,
                ),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.white)),
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                "Username: $username",
                style: TextStyle(fontSize: 25),
              )
            ],
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
                "My Quizzes",
                style: TextStyle(fontSize: 22, color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MyQuizzes(),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 40,
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
      Column(
        children: [
          Text(
            "Categories ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _firebase.collection("Categories").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final categories = snapshot.data.docs;
                List<Padding> categoriesWidgets = [];
                for (var Category in categories) {
                  var aCategory = Category.id;
                  // ignore: non_constant_identifier_names
                  final CategoryWidget = Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFF673ab7),
                      ),
                      width: 300,
                      height: 60,
                      child: FlatButton(
                        onPressed: () {
                          currentCategory = aCategory;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UserCategory(),
                            ),
                          );
                        },
                        child: Text(
                          aCategory,
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ),
                    ),
                  );
                  categoriesWidgets.add(CategoryWidget);
                }
                if (categoriesWidgets.isEmpty)
                  return Center(
                    child: Text(
                      "There is no categories",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  );

                return Column(
                  children: categoriesWidgets,
                );
              } else {
                return Center();
              }
            },
          ),
        ],
      ),
    ];
    return Scaffold(
      bottomNavigationBar: ConvexAppBar(
        initialActiveIndex: currentIndex,
        controller: TabController(
          initialIndex: currentIndex,
          length: 3,
          vsync: this,
        ),
        color: Colors.white,
        backgroundColor: Color(0xFF673ab7),
        items: [
          TabItem(icon: Icons.person, title: 'Profile'),
          TabItem(icon: Icons.home, title: 'Home'),
        ],
        //optional, default as 0
        onTap: (int i) {
          setState(() {
            currentIndex = i;
          });
        },
      ),
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF9188E4), Color(0xFF776ECB)],
            ),
          ),
          child: SafeArea(
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

class Category extends StatelessWidget {
  var text;

  Category(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xFF673ab7),
        ),
        width: 300,
        height: 60,
        child: FlatButton(
          onPressed: () {},
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
      ),
    );
  }
}
