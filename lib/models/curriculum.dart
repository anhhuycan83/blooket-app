class GradeItem {
  final String id;
  final String name;
  final int gradeNumber;
  final bool enabled;
  final String? badge;
  final List<SubjectItem> subjects;

  GradeItem({
    required this.id,
    required this.name,
    required this.gradeNumber,
    required this.enabled,
    this.badge,
    required this.subjects,
  });

  factory GradeItem.fromJson(Map<String, dynamic> json) {
    return GradeItem(
      id: json['id'] as String,
      name: json['name'] as String,
      gradeNumber: json['gradeNumber'] as int,
      enabled: json['enabled'] as bool? ?? false,
      badge: json['badge'] as String?,
      subjects: (json['subjects'] as List<dynamic>? ?? [])
          .map((e) => SubjectItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class WeekItem {
  final int weekNumber;
  final String title;
  final String subTitle;
  final String? badge;
  final String? emoji;
  final String? color;
  final String? bgColor;
  final String? borderColor;
  final bool isHighlighted;

  WeekItem({
    required this.weekNumber,
    required this.title,
    required this.subTitle,
    this.badge,
    this.emoji,
    this.color,
    this.bgColor,
    this.borderColor,
    this.isHighlighted = false,
  });

  factory WeekItem.fromJson(Map<String, dynamic> json) {
    return WeekItem(
      weekNumber: json['weekNumber'] as int,
      title: json['title'] as String? ?? 'W${json['weekNumber']}',
      subTitle: json['subTitle'] as String? ?? 'Tuần ${json['weekNumber']}',
      badge: json['badge'] as String?,
      emoji: json['emoji'] as String?,
      color: json['color'] as String?,
      bgColor: json['bgColor'] as String?,
      borderColor: json['borderColor'] as String?,
      isHighlighted: json['isHighlighted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'weekNumber': weekNumber,
    'title': title,
    'subTitle': subTitle,
    'badge': badge,
    'emoji': emoji,
    'color': color,
    'bgColor': bgColor,
    'borderColor': borderColor,
    'isHighlighted': isHighlighted,
  };
}

class SubjectItem {
  final String id;
  final String name;
  final String englishName;
  final String icon;
  final String color;
  final String accentColor;
  final String description;
  final int totalWeeks;
  final List<WeekItem> weeks;

  SubjectItem({
    required this.id,
    required this.name,
    required this.englishName,
    required this.icon,
    required this.color,
    required this.accentColor,
    required this.description,
    required this.totalWeeks,
    required this.weeks,
  });

  factory SubjectItem.fromJson(Map<String, dynamic> json) {
    final total = json['totalWeeks'] as int? ?? 9;
    final List<WeekItem> parsedWeeks;
    if (json['weeks'] != null && json['weeks'] is List) {
      parsedWeeks = (json['weeks'] as List<dynamic>)
          .map((e) => WeekItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      parsedWeeks = List.generate(
        total,
        (i) => WeekItem(
          weekNumber: i + 1,
          title: 'W${i + 1}',
          subTitle: 'Tuần ${i + 1}',
        ),
      );
    }

    return SubjectItem(
      id: json['id'] as String,
      name: json['name'] as String,
      englishName: json['englishName'] as String? ?? '',
      icon: json['icon'] as String? ?? 'school',
      color: json['color'] as String? ?? '#4F46E5',
      accentColor: json['accentColor'] as String? ?? '#EEF2FF',
      description: json['description'] as String? ?? '',
      totalWeeks: parsedWeeks.isNotEmpty ? parsedWeeks.length : total,
      weeks: parsedWeeks,
    );
  }
}
