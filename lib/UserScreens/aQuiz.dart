import 'package:flutter/material.dart';
import 'package:thaqafah/UserScreens/Quiz_description.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class aQuiz extends StatefulWidget {
  @override
  _aQuizState createState() => _aQuizState();
}

class _aQuizState extends State<aQuiz> {
  int currntQua = 0;
  int score = 0;
  bool answered = false;
  CountDownController _controller = CountDownController();

  nextQua() {
    if (currntQua >= Q.length - 1) {
      _controller.pause();
      SweetAlert.show(context,
          title: "You have finished the quiz",
          subtitle: "Your score is $score out of ${Q.length}",
          style: SweetAlertStyle.success, onPress: (bool x) {
        Navigator.pop(context);
      });
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
                                    score++;
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
                                    score++;
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
                                    score++;
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
                                    score++;
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
