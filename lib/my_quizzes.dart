import 'package:flutter/material.dart';
import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyQuizzes extends StatefulWidget {
  @override
  _MyQuizzesState createState() => _MyQuizzesState();
}

class _MyQuizzesState extends State<MyQuizzes> {
  String quizName;
  String quizCategory;
  @override
  Widget build(BuildContext context) {
    final _firebase = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Quizzes",
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
                        .collection("Usernames")
                        .doc("$username")
                        .collection("MyQuizzes")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final categories = snapshot.data.docs;
                        List<Padding> categoriesWidgets = [];
                        for (var Category in categories) {
                          var aCategory = Category.id;
                          quizName = Category.get("Quiz name");
                          quizCategory = Category.get("Quiz Category");

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
                                  child: Text(
                                    quizName,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 30),
                                  ),
                                  alignment: Alignment.center,
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
                                          print(quizName);
                                          print(quizCategory);
                                          showDialog(
                                              context: context,
                                              builder: (_) => AlertDialog(
                                                    title: Text(
                                                        "Are you sure about deleting this quiz"),
                                                    actions: [
                                                      FlatButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text("NO")),
                                                      FlatButton(
                                                          onPressed: () {
                                                            _firebase
                                                                .collection(
                                                                    "Categories")
                                                                .doc(
                                                                    "$quizCategory")
                                                                .collection(
                                                                    "Quizzes")
                                                                .doc(
                                                                    "${quizName}")
                                                                .collection(
                                                                    "Questions")
                                                                .get()
                                                                .then(
                                                                    (snapshot) =>
                                                                        {
                                                                          for (DocumentSnapshot ds in snapshot
                                                                              .docs)
                                                                            {
                                                                              ds.reference.delete()
                                                                            }
                                                                        })
                                                                .then(
                                                                    (value) => {
                                                                          _firebase
                                                                              .collection("Categories")
                                                                              .doc("$quizCategory")
                                                                              .collection("Quizzes")
                                                                              .doc("${quizName}")
                                                                              .delete()
                                                                        })
                                                                .then(
                                                                    (value) => {
                                                                          _firebase
                                                                              .collection("Usernames")
                                                                              .doc("$username")
                                                                              .collection("MyQuizzes")
                                                                              .doc("$quizName")
                                                                              .delete()
                                                                        })
                                                                .then((value) =>
                                                                    {
                                                                      Navigator.pop(
                                                                          context)
                                                                    });
                                                          },
                                                          child: Text("YES"))
                                                    ],
                                                  ));
                                        },
                                      ),
                                    )),
                              ],
                            ),
                          );
                          categoriesWidgets.add(CategoryWidget);
                        }
                        if (categoriesWidgets.isEmpty)
                          return Center(
                            child: Text(
                              "You didn't create any quiz",
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
