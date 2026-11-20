class WeekProgress {
  final String lessonId;
  final bool theoryCompleted;
  final bool exercisesCompleted;
  final int highestScore;
  final int flagsEarned;
  final int stars; // 1 to 3 stars

  WeekProgress({
    required this.lessonId,
    this.theoryCompleted = false,
    this.exercisesCompleted = false,
    this.highestScore = 0,
    this.flagsEarned = 0,
    this.stars = 0,
  });

  Map<String, dynamic> toJson() => {
    'lessonId': lessonId,
    'theoryCompleted': theoryCompleted,
    'exercisesCompleted': exercisesCompleted,
    'highestScore': highestScore,
    'flagsEarned': flagsEarned,
    'stars': stars,
  };

  factory WeekProgress.fromJson(Map<String, dynamic> json) {
    return WeekProgress(
      lessonId: json['lessonId'] as String,
      theoryCompleted: json['theoryCompleted'] as bool? ?? false,
      exercisesCompleted: json['exercisesCompleted'] as bool? ?? false,
      highestScore: json['highestScore'] as int? ?? 0,
      flagsEarned: json['flagsEarned'] as int? ?? 0,
      stars: json['stars'] as int? ?? 0,
    );
  }

  WeekProgress copyWith({
    bool? theoryCompleted,
    bool? exercisesCompleted,
    int? highestScore,
    int? flagsEarned,
    int? stars,
  }) {
    return WeekProgress(
      lessonId: lessonId,
      theoryCompleted: theoryCompleted ?? this.theoryCompleted,
      exercisesCompleted: exercisesCompleted ?? this.exercisesCompleted,
      highestScore: highestScore ?? this.highestScore,
      flagsEarned: flagsEarned ?? this.flagsEarned,
      stars: stars ?? this.stars,
    );
  }
}
