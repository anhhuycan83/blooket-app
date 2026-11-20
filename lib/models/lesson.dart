class TheoryCard {
  final String id;
  final String term;
  final String phonetic;
  final String vietnamese;
  final String definition;
  final String example;
  final String category;
  final String imageHint;

  TheoryCard({
    required this.id,
    required this.term,
    required this.phonetic,
    required this.vietnamese,
    required this.definition,
    required this.example,
    required this.category,
    required this.imageHint,
  });

  factory TheoryCard.fromJson(Map<String, dynamic> json) {
    return TheoryCard(
      id: json['id'] as String,
      term: json['term'] as String,
      phonetic: json['phonetic'] as String? ?? '',
      vietnamese: json['vietnamese'] as String? ?? '',
      definition: json['definition'] as String? ?? '',
      example: json['example'] as String? ?? '',
      category: json['category'] as String? ?? '',
      imageHint: json['imageHint'] as String? ?? '📖',
    );
  }
}

class ExerciseItem {
  final String id;
  final String lesson;
  final String type;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final int points;

  ExerciseItem({
    required this.id,
    required this.lesson,
    required this.type,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.points,
  });

  factory ExerciseItem.fromJson(Map<String, dynamic> json) {
    return ExerciseItem(
      id: json['id'] as String,
      lesson: json['lesson'] as String? ?? '',
      type: json['type'] as String? ?? 'multiple_choice',
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>).map((e) => e.toString()).toList(),
      correctIndex: json['correctIndex'] as int? ?? 0,
      explanation: json['explanation'] as String? ?? '',
      points: json['points'] as int? ?? 100,
    );
  }
}

class LessonData {
  final String id;
  final int grade;
  final String subject;
  final String subjectName;
  final int week;
  final String title;
  final String subTitle;
  final List<TheoryCard> theoryCards;
  final List<ExerciseItem> exercises;

  LessonData({
    required this.id,
    required this.grade,
    required this.subject,
    required this.subjectName,
    required this.week,
    required this.title,
    required this.subTitle,
    required this.theoryCards,
    required this.exercises,
  });

  factory LessonData.fromJson(Map<String, dynamic> json) {
    final theoryObj = json['theory'] as Map<String, dynamic>? ?? {};
    final rawCards = theoryObj['cards'] as List<dynamic>? ?? [];
    final rawExercises = json['exercises'] as List<dynamic>? ?? [];

    return LessonData(
      id: json['id'] as String,
      grade: json['grade'] as int? ?? 5,
      subject: json['subject'] as String? ?? 'english',
      subjectName: json['subjectName'] as String? ?? '',
      week: json['week'] as int? ?? 1,
      title: json['title'] as String? ?? '',
      subTitle: json['subTitle'] as String? ?? '',
      theoryCards: rawCards.map((e) => TheoryCard.fromJson(e as Map<String, dynamic>)).toList(),
      exercises: rawExercises.map((e) => ExerciseItem.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
