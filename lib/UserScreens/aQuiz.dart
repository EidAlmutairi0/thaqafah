import 'package:flutter/material.dart';
import 'package:thaqafah/UserScreens/Quiz_description.dart';

class aQuiz extends StatefulWidget {
  @override
  _aQuizState createState() => _aQuizState();
}

class _aQuizState extends State<aQuiz> {
  int currntQua = 1;
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Text(
                          Q[currntQua].QuestionTilte,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
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
                            onPressed: () {},
                            child: Text(
                              Q[currntQua].Answers[0],
                              style: TextStyle(fontSize: 40),
                            ),
                          ),
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
                            onPressed: () {},
                            child: Text(
                              Q[currntQua].Answers[1],
                              style: TextStyle(fontSize: 40),
                            ),
                          ),
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
                            onPressed: () {},
                            child: Text(
                              Q[currntQua].Answers[2],
                              style: TextStyle(fontSize: 40),
                            ),
                          ),
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
                            onPressed: () {},
                            child: Text(
                              Q[currntQua].Answers[3],
                              style: TextStyle(fontSize: 40),
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
