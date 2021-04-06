import 'package:flutter/material.dart';
import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHistory extends StatefulWidget {
  @override
  _MyHistoryState createState() => _MyHistoryState();
}

class _MyHistoryState extends State<MyHistory> {
  @override
  Widget build(BuildContext context) {
    final _firebase = FirebaseFirestore.instance;
    dynamic quizName;
    dynamic quizscore;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My History",
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
                    height: 40,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: _firebase
                        .collection("Usernames")
                        .doc("$username")
                        .collection("MyHistory")
                        .orderBy('date', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final categories = snapshot.data.docs;
                        List<Padding> categoriesWidgets = [];
                        for (var Category in categories) {
                          var aCategory = Category.id;
                          quizName = Category.get("Quiz name");
                          quizscore = Category.get("Quiz Score");

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
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      quizName.toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22),
                                    ),
                                    Text(
                                      quizscore.toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22),
                                    ),
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                              ),
                              alignment: Alignment.center,
                            ),
                          );
                          categoriesWidgets.add(CategoryWidget);
                        }
                        if (categoriesWidgets.isEmpty)
                          return Center(
                            child: Text(
                              "You didn't take any quiz",
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
