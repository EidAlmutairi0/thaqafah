import 'dart:math';

class Questions {
  var QuestionTilte;
  var CorrectAnswer;
  var WrongAnswer1;
  var WrongAnswer2;
  var WrongAnswer3;
  List<String> Answers;

  Questions(this.QuestionTilte, this.CorrectAnswer, this.WrongAnswer1,
      this.WrongAnswer2, this.WrongAnswer3) {
    Answers = List<String>();
    Answers.add(CorrectAnswer);
    Answers.add(WrongAnswer1);
    Answers.add(WrongAnswer2);
    Answers.add(WrongAnswer3);

    Answers.shuffle();
  }
}
