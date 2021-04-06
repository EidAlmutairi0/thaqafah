import 'package:flutter/material.dart';
import 'package:thaqafah/UserScreens/Quiz_description.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thaqafah/main.dart';
import 'package:thaqafah/UserScreens/User_Category.dart';

class aQuiz extends StatefulWidget {
  @override
  _aQuizState createState() => _aQuizState();
}

class _aQuizState extends State<aQuiz> {
  CalScore() {
    double sec = _controller.conValue();
    if (sec >= 0.66666667) {
      score++;
    } else if (sec >= 0.33333333 && sec < 0.66666667) {
      score = score + 0.5;
    } else if (sec >= 0.00000001 && sec < 0.33333333) {
      score = score + 0.25;
    }
  }

  var tempA;
  var tempb;
  checkLeaderBoard() async {
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
        .whenComplete(() => {
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
  }

  initState() {
    Q.shuffle();
    for (var x in Q) {
      x.Answers.shuffle();
    }
  }

  int currntQua = 0;
  double score = 0;
  bool answered = false;
  CountDownController _controller = CountDownController();
  double rate = 0;
  final _firebase = FirebaseFirestore.instance;

  leaderBaord(double score) {
    if (score > first) {
      _firebase
          .collection("Categories")
          .doc("$currentCategory")
          .collection("Quizzes")
          .doc("$currentQuiz")
          .update({
        "ThirdName": secondName,
        "Third": second,
      }).then((value) => {
                _firebase
                    .collection("Categories")
                    .doc("$currentCategory")
                    .collection("Quizzes")
                    .doc("$currentQuiz")
                    .update({
                  "SecondName": firstName,
                  "Second": first,
                }).then((value) => {
                          _firebase
                              .collection("Categories")
                              .doc("$currentCategory")
                              .collection("Quizzes")
                              .doc("$currentQuiz")
                              .update({
                            "FirstName": username,
                            "First": score,
                          })
                        })
              });
      return;
    } else if (score > second) {
      _firebase
          .collection("Categories")
          .doc("$currentCategory")
          .collection("Quizzes")
          .doc("$currentQuiz")
          .update({
        "ThirdName": secondName,
        "Third": second,
      }).then((value) => {
                _firebase
                    .collection("Categories")
                    .doc("$currentCategory")
                    .collection("Quizzes")
                    .doc("$currentQuiz")
                    .update({
                  "SecondName": username,
                  "Second": score,
                })
              });
      return;
    } else if (score > third) {
      _firebase
          .collection("Categories")
          .doc("$currentCategory")
          .collection("Quizzes")
          .doc("$currentQuiz")
          .update({
        "ThirdName": username,
        "Third": score,
      });
      return;
    }

    if (first == -1) {
      _firebase
          .collection("Categories")
          .doc("$currentCategory")
          .collection("Quizzes")
          .doc("$currentQuiz")
          .update({
        "FirstName": username,
        "First": score,
      });
      return;
    } else if (second == -1) {
      _firebase
          .collection("Categories")
          .doc("$currentCategory")
          .collection("Quizzes")
          .doc("$currentQuiz")
          .update({
        "SecondName": username,
        "Second": score,
      });
      return;
    } else if (third == -1) {
      _firebase
          .collection("Categories")
          .doc("$currentCategory")
          .collection("Quizzes")
          .doc("$currentQuiz")
          .update({
        "ThirdName": username,
        "Third": score,
      });
      return;
    }
  }

  nextQua() {
    if (currntQua >= Q.length - 1) {
      _controller.pause();
      score = (score / Q.length) * 100;

      checkLeaderBoard();

      SweetAlert.show(context,
          title: "You have finished the quiz",
          subtitle: Column(
            children: [
              Text("Your score is ${score.toInt()} out of 100"),
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                  setState(() {
                    rate = rating;
                  });
                  print(rate);
                },
              ),
            ],
          ),
          // ignore: missing_return
          style: SweetAlertStyle.success, onPress: (bool x) {
        if (rate != 0) {
          _firebase
              .collection("Categories")
              .doc("$currentCategory")
              // ignore: missing_return
              .collection("Quizzes")
              .doc("/$currentQuiz")
              .update({
            "Total Rate": FieldValue.increment(rate),
            "number of ratings": FieldValue.increment(1),
          }).then((value) => {
                    _firebase
                        .collection("Categories")
                        .doc("$currentCategory")
                        // ignore: missing_return
                        .collection("Quizzes")
                        .doc("/$currentQuiz")
                        .get()
                        .then((value) => {
                              tempA = value.get("Total Rate"),
                              tempb = value.get("number of ratings"),
                            })
                        .then((value) => {
                              _firebase
                                  .collection("Categories")
                                  .doc("$currentCategory")
                                  // ignore: missing_return
                                  .collection("Quizzes")
                                  .doc("/$currentQuiz")
                                  .update({
                                "The rate": (tempA / tempb),
                              })
                            })
                  });
        }
        DateTime now = new DateTime.now();
        DateTime date = new DateTime(
            now.year, now.month, now.day, now.hour, now.minute, now.second);
        _firebase
            .collection("Usernames")
            .doc("$username")
            .collection("MyHistory")
            .add({
          "Quiz name": currentQuiz,
          "Quiz Score": score.toString(),
          "date": date,
        });

        Navigator.pop(context);
      });
      leaderBaord(score);
    }
    if (currntQua < Q.length - 1) {
      _controller.restart();
      currntQua++;
      answered = false;
      print(currntQua);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                        title: Text("Are you sure about exiting the quiz?"),
                        content: Text(
                            "Notice that you will lose any progress you have made"),
                        actions: [
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("NO")),
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text("YES"))
                        ],
                      ));
            },
          ),
          centerTitle: true,
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Text(
                          "Question: ${currntQua + 1}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      CircularCountDownTimer(
                        duration: 30,

                        // Controller to control (i.e Pause, Resume, Restart) the Countdown
                        controller: _controller,

                        // Width of the Countdown Widget
                        width: 80,

                        // Height of the Countdown Widget
                        height: 80,

                        // Default Color for Countdown Timer
                        color: Colors.white,

                        // Filling Color for Countdown Timer
                        fillColor: Colors.red,

                        // Background Color for Countdown Widget
                        backgroundColor: null,

                        // Border Thickness of the Countdown Circle
                        strokeWidth: 5.0,

                        // Text Style for Countdown Text
                        textStyle: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),

                        // true for reverse countdown (max to 0), false for forward countdown (0 to max)
                        isReverse: true,

                        // true for reverse animation, false for forward animation
                        isReverseAnimation: true,

                        onComplete: () {
                          setState(() {
                            nextQua();
                          });
                        },

                        // Optional [bool] to hide the [Text] in this widget.
                        isTimerTextShown: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Container(
                          height: 140,
                          alignment: Alignment.center,
                          child: Text(
                            Q[currntQua].QuestionTilte,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFD3A762),
                          ),
                          child: FlatButton(
                            onPressed: () {
                              setState(() {
                                if (answered == false) {
                                  if (Q[currntQua].Answers[0] ==
                                      Q[currntQua].CorrectAnswer) {
                                    CalScore();
                                    print(_controller.conValue());
                                  }
                                  answered = true;
                                  nextQua();
                                }
                              });
                            },
                            child: Text(
                              Q[currntQua].Answers[0],
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFD3A762),
                          ),
                          child: FlatButton(
                            onPressed: () {
                              setState(() {
                                if (answered == false) {
                                  if (Q[currntQua].Answers[1] ==
                                      Q[currntQua].CorrectAnswer) {
                                    CalScore();
                                    print(_controller.conValue());
                                  }
                                  answered = true;
                                  nextQua();
                                }
                              });
                            },
                            child: Text(
                              Q[currntQua].Answers[1],
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFD3A762),
                          ),
                          child: FlatButton(
                            onPressed: () {
                              setState(() {
                                if (answered == false) {
                                  if (Q[currntQua].Answers[2] ==
                                      Q[currntQua].CorrectAnswer) {
                                    CalScore();
                                    print(_controller.conValue());
                                  }
                                  answered = true;
                                  nextQua();
                                }
                              });
                            },
                            child: Text(
                              Q[currntQua].Answers[2],
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFD3A762),
                          ),
                          child: FlatButton(
                            onPressed: () {
                              setState(() {
                                if (answered == false) {
                                  if (Q[currntQua].Answers[3] ==
                                      Q[currntQua].CorrectAnswer) {
                                    CalScore();
                                    print(_controller.conValue());
                                  }
                                  answered = true;
                                  nextQua();
                                }
                              });
                            },
                            child: Text(
                              Q[currntQua].Answers[3],
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
