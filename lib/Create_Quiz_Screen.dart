import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thaqafah/Log_in_screen.dart';
import 'package:thaqafah/main.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cool_alert/cool_alert.dart';

class CreateQuizScreen extends StatefulWidget {
  @override
  _CreateQuizScreenState createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final _firebase = FirebaseFirestore.instance;
  String quizName;
  String quizDescription;
  String questionTitle;
  String correctAnswer;
  String wrongAnswerOne;
  String wrongAnswerTwo;
  String wrongAnswerthree;
  List<String> answers;
  int currentStep;

  final HttpsCallable callable =
      CloudFunctions.instance.getHttpsCallable(functionName: 'recursiveDelete');

  // ignore: must_call_super
  initState() {
    currentStep = 0;
    quizName = null;
    quizDescription = null;
  }

  bool complete = false;

  cancel() {
    if (currentStep == 2) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text("Are you sure about canceling this operation?"),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("NO")),
                  FlatButton(
                      onPressed: () {
                        _firebase
                            .collection("Categories")
                            .doc("$currentCategory")
                            .collection("Quizzes")
                            .doc("${quizName}")
                            .collection("Questions")
                            .get()
                            .then((snapshot) => {
                                  for (DocumentSnapshot ds in snapshot.docs)
                                    {ds.reference.delete()}
                                })
                            .then((value) => {
                                  _firebase
                                      .collection("Categories")
                                      .doc("$currentCategory")
                                      .collection("Quizzes")
                                      .doc("${quizName}")
                                      .delete()
                                })
                            .then((value) => {
                                  Navigator.pop(context),
                                  goto(currentStep - 1),
                                });
                      },
                      child: Text("YES"))
                ],
              ));
    } else if (currentStep > 0) {
      goto(currentStep - 1);
    }
  }

  goto(int step) {
    setState(() {
      currentStep = step;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _firebase = FirebaseFirestore.instance;
    List<Step> steps = [
      Step(
          title: const Text('Quiz Name'),
          //subtitle: const Text('Enter your name'),
          isActive: true,
          //state: StepState.error,
          state: StepState.indexed,
          content: TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            onChanged: (String value) {
              quizName = value;
            },
            maxLines: 1,
            decoration: new InputDecoration(
                labelText: 'Enter a Quiz name',
                hintText: 'Enter a name',
                //filled: true,
                labelStyle:
                    new TextStyle(decorationStyle: TextDecorationStyle.solid)),
          )),
      Step(
          title: const Text('Quiz description'),
          //subtitle: const Text('Subtitle'),
          isActive: true,
          //state: StepState.editing,
          state: StepState.indexed,
          content: TextFormField(
            keyboardType: TextInputType.text,
            onSaved: (String value) {
              quizDescription = value;
            },
            autocorrect: false,
            maxLines: 5,
            decoration: new InputDecoration(
                labelText: 'Enter the quiz description',
                hintText: 'Enter a description',
                labelStyle:
                    new TextStyle(decorationStyle: TextDecorationStyle.solid)),
          )),
      Step(
          title: const Text('Quiz questions'),
          //subtitle: const Text('Subtitle'),
          isActive: true,
          //state: StepState.editing,
          state: StepState.indexed,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: _firebase
                    .collection("Categories")
                    .doc("$currentCategory")
                    .collection("Quizzes")
                    .doc("$quizName")
                    .collection("Questions")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final categories = snapshot.data.docs;
                    List<Padding> categoriesWidgets = [];
                    for (var Category in categories) {
                      var aQuestion = Category.id;
                      var corrAnswer = Category.get("correct Answer");
                      var wroAnswer1 = Category.get("wrong Answer One");
                      var wroAnswer2 = Category.get("wrong Answer two");
                      var wroAnswer3 = Category.get("wrong Answer Three");

                      // ignore: non_constant_identifier_names
                      final CategoryWidget = Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Color(0xFF673ab7))),
                              width: 200,
                              child: Column(
                                children: [
                                  Text(
                                    aQuestion,
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 20),
                                  ),
                                  Text(
                                    corrAnswer,
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 15),
                                  ),
                                  Text(
                                    wroAnswer1,
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 15),
                                  ),
                                  Text(
                                    wroAnswer2,
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 15),
                                  ),
                                  Text(
                                    wroAnswer3,
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 15),
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                width: 30,
                                height: 30,
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                    ),
                                    iconSize: 15,
                                    color: Colors.white,
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                title: Text(
                                                    "Are you sure about deleting this Questions"),
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
                                                            .doc(
                                                                "$currentCategory")
                                                            .collection(
                                                                "Quizzes")
                                                            .doc("$quizName")
                                                            .collection(
                                                                "Questions")
                                                            .doc("$aQuestion")
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
                          "There is no questions",
                          style: TextStyle(color: Colors.black54, fontSize: 20),
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
                height: 30,
              ),
              Container(
                height: 40,
                width: 200,
                decoration: BoxDecoration(
                  color: Color(0xFFD3A762),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: FlatButton(
                  onPressed: () {
                    Alert(
                        context: context,
                        title: "Create a question",
                        content: Column(
                          children: <Widget>[
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Question title',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  questionTitle = value;
                                });
                              },
                              maxLines: 3,
                            ),
                            TextField(
                              onChanged: (value) {
                                setState(() {
                                  correctAnswer = value;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Correct title',
                              ),
                              maxLines: 1,
                            ),
                            TextField(
                              onChanged: (value) {
                                setState(() {
                                  wrongAnswerOne = value;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'wrong answer one ',
                              ),
                              maxLines: 1,
                            ),
                            TextField(
                              onChanged: (value) {
                                setState(() {
                                  wrongAnswerTwo = value;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'wrong answer two',
                              ),
                              maxLines: 1,
                            ),
                            TextField(
                              onChanged: (value) {
                                setState(() {
                                  wrongAnswerthree = value;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'wrong answer three',
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                        buttons: [
                          DialogButton(
                            onPressed: () => {
                              if (questionTitle == null ||
                                  questionTitle == "    " ||
                                  correctAnswer == null ||
                                  correctAnswer == "    " ||
                                  wrongAnswerOne == null ||
                                  wrongAnswerOne == "    " ||
                                  wrongAnswerTwo == null ||
                                  wrongAnswerTwo == "    " ||
                                  wrongAnswerthree == null ||
                                  wrongAnswerthree == "    ")
                                {
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            title: Text(
                                                "All fields are mandatory "),
                                            content:
                                                Text("Please write them all"),
                                            actions: [
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("OK"))
                                            ],
                                          ))
                                }
                              else
                                {
                                  _firebase
                                      .collection("Categories")
                                      .doc("$currentCategory")
                                      .collection("Quizzes")
                                      .doc("$quizName")
                                      .set({"author": username}).then((value) =>
                                          {
                                            _firebase
                                                .collection("Categories")
                                                .doc("$currentCategory")
                                                .collection("Quizzes")
                                                .doc("$quizName")
                                                .collection("Questions")
                                                .doc("$questionTitle")
                                                .set({
                                              "question Title": questionTitle,
                                              "correct Answer": correctAnswer,
                                              "wrong Answer One":
                                                  wrongAnswerOne,
                                              "wrong Answer two":
                                                  wrongAnswerTwo,
                                              "wrong Answer Three":
                                                  wrongAnswerthree,
                                            }),
                                          }),
                                  Navigator.pop(context)
                                }
                            },
                            child: Text(
                              "Create",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          )
                        ]).show();
                  },
                  child: Text("create a question"),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          )),
    ];

    next() {
      if (quizName == null || quizName == "    ") {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text("Quiz name should not be empty "),
                  content: Text("Please write a name for the quiz"),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("OK"))
                  ],
                ));
      } else if (currentStep == 2) {
        CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            onConfirmBtnTap: () {
              Navigator.pop(context);
            }).then((value) => {Navigator.pop(context)});
      } else {
        currentStep + 1 != steps.length
            ? goto(currentStep + 1)
            : setState(() => complete = true);
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      title:
                          Text("Are you sure about canceling this operation?"),
                      actions: [
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("NO")),
                        FlatButton(
                            onPressed: () {
                              _firebase
                                  .collection("Categories")
                                  .doc("$currentCategory")
                                  .collection("Quizzes")
                                  .doc("${quizName}")
                                  .collection("Questions")
                                  .get()
                                  .then((snapshot) => {
                                        for (DocumentSnapshot ds
                                            in snapshot.docs)
                                          {ds.reference.delete()}
                                      })
                                  .then((value) => {
                                        _firebase
                                            .collection("Categories")
                                            .doc("$currentCategory")
                                            .collection("Quizzes")
                                            .doc("${quizName}")
                                            .delete()
                                      })
                                  .then((value) => {
                                        Navigator.pop(context),
                                      })
                                  .then((value) => {
                                        Navigator.pop(context),
                                      });
                            },
                            child: Text("YES"))
                      ],
                    ));
          },
        ),
        centerTitle: true,
        title: Text(
          "Create a Quiz",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        backgroundColor: Color(0xFF673ab7),
      ),
      body: SafeArea(
        child: Theme(
          data: ThemeData(
              primaryColor: Color(0xFF673ab7), buttonColor: Color(0xFFD3A762)),
          child: SingleChildScrollView(
            child: Stepper(
              physics: ClampingScrollPhysics(),
              type: StepperType.vertical,
              currentStep: currentStep,
              onStepContinue: next,
              onStepCancel: cancel,
              steps: steps,
            ),
          ),
        ),
      ),
    );
  }
}
