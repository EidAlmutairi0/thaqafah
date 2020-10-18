import 'package:flutter/material.dart';
import 'package:thaqafah/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminCategory extends StatefulWidget {
  @override
  _AdminCategoryState createState() => _AdminCategoryState();
}

class _AdminCategoryState extends State<AdminCategory> {
  @override
  Widget build(BuildContext context) {
    final _firebase = FirebaseFirestore.instance;

    return Scaffold(
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
                                    onPressed: () {
                                      setState(() {
                                        currentQuiz = aCategory;
                                      });
                                    },
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
                                                                    "$currentCategory")
                                                                .collection(
                                                                    "Quizzes")
                                                                .doc(
                                                                    "${aCategory}")
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
                                                                              .doc("$currentCategory")
                                                                              .collection("Quizzes")
                                                                              .doc("${aCategory}")
                                                                              .delete()
                                                                        })
                                                                .then(
                                                                    (value) => {
                                                                          Navigator.pop(
                                                                              context),
                                                                        });
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
                    height: 20,
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
