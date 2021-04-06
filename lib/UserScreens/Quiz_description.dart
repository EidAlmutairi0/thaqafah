import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thaqafah/QuestionsBank.dart';
import 'package:thaqafah/UserScreens/User_Category.dart';
import 'package:thaqafah/UserScreens/aQuiz.dart';

import 'package:thaqafah/main.dart';

String QuizName = currentQuiz;
String QuizDescrepyion = "test";
String numOfQuestions = " 8";
String firstOne = "";
String secondOne = "";
String thirdOne = "";
List<Questions> Q = List<Questions>();

class QuizDescription extends StatefulWidget {
  @override
  _QuizDescriptionState createState() => _QuizDescriptionState();
}

class _QuizDescriptionState extends State<QuizDescription> {
  Questions x;
  final _firebase = FirebaseFirestore.instance;
  dynamic Leader = FirebaseFirestore.instance
      .collection("Categories")
      .doc("$currentCategory")
      .collection("Quizzes")
      .get();

  getQua(QuerySnapshot ss) async {
    for (DocumentSnapshot ds in ss.docs) {
      Questions x = await Questions(
          ds.get("question Title"),
          ds.get("correct Answer"),
          ds.get("wrong Answer One"),
          ds.get("wrong Answer two"),
          ds.get("wrong Answer Three"));
      x.Answers.shuffle();
      Q.add(x);
    }
  }

  @override
  void dispose() {
    setState(() {
      firstOne = "-";
      secondOne = "-";
      thirdOne = "-";
    });
    super.dispose();
  }

  checkLeaderBoard() {
    setState(() {
      _firebase
          .collection("Categories")
          .doc("$currentCategory")
          .collection("Quizzes")
          .doc("$currentQuiz")
          .get()
          .then((snapshot) => {
                first = snapshot.get("First"),
                second = snapshot.get("Second"),
                third = snapshot.get("Third"),
                firstName = snapshot.get("FirstName"),
                secondName = snapshot.get("SecondName"),
                thirdName = snapshot.get("ThirdName"),
              })
          .then((value) => {
                if (first == -1.0)
                  {
                    setState(() {
                      // ignore: unnecessary_statements
                      firstOne == "-";
                    })
                  }
                else
                  {
                    setState(() {
                      firstOne = "$firstName $first";
                    })
                  },
                if (second == -1.0)
                  {
                    setState(() {
                      // ignore: unnecessary_statements
                      secondOne == "-";
                    })
                  }
                else
                  {
                    setState(() {
                      secondOne = "$secondName $second";
                    })
                  },
                if (third == -1.0)
                  {
                    setState(() {
                      // ignore: unnecessary_statements
                      thirdOne == "-";
                    })
                  }
                else
                  {
                    setState(() {
                      thirdOne = "$thirdName $third";
                    })
                  }
              });
    });
  }

  Future onGoBack(dynamic value) {
    checkLeaderBoard();
    setState(() {});
  }

  @override
  void initState() {
    setState(() {});
    checkLeaderBoard();
    _firebase
        .collection("Categories")
        .doc("$currentCategory")
        .collection("Quizzes")
        .doc("$currentQuiz")
        .collection("Questions")
        .orderBy("time")
        .get()
        .then((snapshot) => getQua(snapshot));

    super.initState();
  }

  @override
  void deactivate() {
    Q = List<Questions>();
    super.deactivate();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            currentQuiz,
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
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: SizedBox.expand(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF46287D),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Text(
                          QuizName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Number of Questions : $numOfQuestions",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Text(
                          "Leaderboard : ",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 28, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Text(
                          "1. $firstOne",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Text(
                          "2. $secondOne",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Text(
                          "3. $thirdOne",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Text(
                          QuizDescrepyion,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFD3A762),
                          ),
                          child: FlatButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (context) => aQuiz(),
                                    ),
                                  )
                                  .then(onGoBack);
                            },
                            child: Text(
                              "Take",
                              style: TextStyle(fontSize: 40),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
