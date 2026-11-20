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

class SubjectItem {
  final String id;
  final String name;
  final String englishName;
  final String icon;
  final String color;
  final String accentColor;
  final String description;
  final int totalWeeks;

  SubjectItem({
    required this.id,
    required this.name,
    required this.englishName,
    required this.icon,
    required this.color,
    required this.accentColor,
    required this.description,
    required this.totalWeeks,
  });

  factory SubjectItem.fromJson(Map<String, dynamic> json) {
    return SubjectItem(
      id: json['id'] as String,
      name: json['name'] as String,
      englishName: json['englishName'] as String? ?? '',
      icon: json['icon'] as String? ?? 'school',
      color: json['color'] as String? ?? '#4F46E5',
      accentColor: json['accentColor'] as String? ?? '#EEF2FF',
      description: json['description'] as String? ?? '',
      totalWeeks: json['totalWeeks'] as int? ?? 9,
    );
  }
}
