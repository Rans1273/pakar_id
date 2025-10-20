class DiagnosisHistory {
  final String name;
  final int age;
  final String gender;
  final String diagnosis;
  final DateTime date;

  DiagnosisHistory({
    required this.name,
    required this.age,
    required this.gender,
    required this.diagnosis,
    required this.date,
  });

  // Konversi dari Map (saat membaca dari local storage)
  factory DiagnosisHistory.fromJson(Map<String, dynamic> json) {
    return DiagnosisHistory(
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      diagnosis: json['diagnosis'],
      date: DateTime.parse(json['date']),
    );
  }

  // Konversi ke Map (saat menyimpan ke local storage)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'diagnosis': diagnosis,
      'date': date.toIso8601String(),
    };
  }
}