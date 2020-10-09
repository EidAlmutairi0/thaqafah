import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thaqafah/Log_in_screen.dart';
import 'package:thaqafah/AdminScreens/Admin_Category.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:thaqafah/main.dart';
import 'package:thaqafah/UserScreens/User_Category.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
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
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Current Categories ",
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
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
                                  builder: (context) => AdminCategory(),
                                ),
                              );
                            },
                            child: Text(
                              aCategory,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red,
                            ),
                            width: 60,
                            height: 60,
                            child: Center(
                              child: IconButton(
                                icon: Icon(
                                  Icons.clear,
                                ),
                                iconSize: 45,
                                color: Colors.white,
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            title: Text(
                                                "Are you sure about deleting this category"),
                                            content: Text(
                                                "Remember that if you delete this category all the quizzes in it will be deleted as well "),
                                            actions: [
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("NO")),
                                              FlatButton(
                                                  onPressed: () {
                                                    _firebase
                                                        .collection(
                                                            "Categories")
                                                        .doc("${Category.id}")
                                                        .delete();
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("YES"))
                                            ],
                                          ));
                                },
                              ),
                            ))
                      ],
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
          SizedBox(
            height: 20,
          ),
          FloatingActionButton(
              backgroundColor: Color(0xFFD3A762),
              child: Icon(Icons.add),
              onPressed: () {
                Alert(
                    context: context,
                    title: "Create category",
                    content: Column(
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Category name',
                          ),
                          onChanged: (String name) {
                            setState(() {
                              categoryName = name;
                            });
                          },
                        ),
                      ],
                    ),
                    buttons: [
                      DialogButton(
                        onPressed: () => {
                          if (categoryName == "" || categoryName == null)
                            {
                              Alert(
                                context: context,
                                type: AlertType.warning,
                                title: "Wrong",
                                desc: "Category name should not be empty",
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "OK",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    gradient: LinearGradient(colors: [
                                      Color.fromRGBO(116, 116, 191, 1.0),
                                      Color.fromRGBO(52, 138, 199, 1.0)
                                    ]),
                                  )
                                ],
                              ).show(),
                            }
                          else
                            {
                              _firebase
                                  .collection("Categories")
                                  .doc("$categoryName")
                                  .set({}),
                              Navigator.pop(context)
                            }
                        },
                        child: Text(
                          "Create",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        color: Color(0xFFD3A762),
                      )
                    ]).show();
              }),
          SizedBox(
            height: 70,
          ),
        ],
      ),
    ];
    return Scaffold(
      bottomNavigationBar: ConvexAppBar(
        color: Colors.white,
        backgroundColor: Color(0xFF673ab7),
        items: [
          TabItem(icon: Icons.person, title: 'Profile'),
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.build_rounded, title: 'administration '),
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
