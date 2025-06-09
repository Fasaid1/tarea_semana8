class Task {
  final String title;
  final String marca;         
  bool isCompleted;

  Task({
    required this.title,
    required this.marca,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'marca': marca,
    'isCompleted': isCompleted,
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    title: json['title'],
    marca: json['marca'],
    isCompleted: json['isCompleted'] ?? false,
  );
}
