import 'package:flutter/material.dart';
import 'package:thaqafah/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thaqafah/Create_Quiz_Screen.dart';

class UserCategory extends StatefulWidget {
  @override
  _UserCategoryState createState() => _UserCategoryState();
}

class _UserCategoryState extends State<UserCategory> {
  @override
  Widget build(BuildContext context) {
    final _firebase = FirebaseFirestore.instance;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFFD3A762),
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CreateQuizScreen(),
              ),
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          currentCategory,
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        backgroundColor: Color(0xFF673ab7),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF9188E4), Color(0xFF776ECB)],
          ),
        ),
        child: SafeArea(
          child: SizedBox.expand(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Current Quizzes ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: _firebase
                        .collection("Categories")
                        .doc("$currentCategory")
                        .collection("quizzes")
                        .snapshots(),
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
                                    onPressed: () {},
                                    child: Text(
                                      aCategory,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 30),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          );
                          categoriesWidgets.add(CategoryWidget);
                        }
                        if (categoriesWidgets.isEmpty)
                          return Center(
                            child: Text(
                              "There is no quizzes",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30),
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
                    height: 50,
                  ),
                  SizedBox(
                    height: 70,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
