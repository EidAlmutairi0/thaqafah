import 'package:flutter/material.dart';
import 'package:thaqafah/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thaqafah/Create_Quiz_Screen.dart';
import 'package:thaqafah/UserScreens/Quiz_description.dart';

var first;
var firstName;
var second;
var secondName;
var third;
var thirdName;

class UserCategory extends StatefulWidget {
  @override
  _UserCategoryState createState() => _UserCategoryState();
}

class _UserCategoryState extends State<UserCategory> {
  var totalRate;
  var numOfRatrings;
  String aQuizRate = "--";

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
                        .collection("Quizzes")
                        .orderBy("The rate", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final categories = snapshot.data.docs;
                        List<Padding> categoriesWidgets = [];
                        for (var Category in categories) {
                          var aCategory = Category.id;
                          totalRate = Category.get("Total Rate");
                          numOfRatrings = Category.get("number of ratings");

                          if (numOfRatrings != 0) {
                            aQuizRate =
                                Category.get("The rate").toStringAsFixed(1);
                          } else {
                            aQuizRate = "--";
                          }

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
                                        setState(() {
                                          currentQuiz = aCategory;
                                          QuizName = aCategory;
                                          first = Category.get("First");
                                          second = Category.get("Second");
                                          third = Category.get("Third");
                                          firstName = Category.get("FirstName");
                                          secondName =
                                              Category.get("SecondName");
                                          thirdName = Category.get("ThirdName");

                                          QuizDescrepyion =
                                              Category.get("Quiz Description");

                                          numOfQuestions = Category.get(
                                                  "number of Questions")
                                              .toString();
                                          if (first == -1.0) {
                                            setState(() {
                                              // ignore: unnecessary_statements
                                              firstOne == "-";
                                            });
                                          } else {
                                            setState(() {
                                              firstOne = "$firstName $first";
                                            });
                                          }
                                          if (second == -1.0) {
                                            setState(() {
                                              // ignore: unnecessary_statements
                                              secondOne == "-";
                                            });
                                          } else {
                                            setState(() {
                                              secondOne = "$secondName $second";
                                            });
                                          }
                                          if (third == -1.0) {
                                            setState(() {
                                              // ignore: unnecessary_statements
                                              thirdOne == "-";
                                            });
                                          } else {
                                            setState(() {
                                              thirdOne = "$thirdName $third";
                                            });
                                          }
                                        });
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                QuizDescription(),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            aCategory,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24),
                                          ),
                                          Container(
                                            child: Center(
                                              child: Text(
                                                aQuizRate,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Colors.white)),
                                            height: 35,
                                            width: 35,
                                          ),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                      )),
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
