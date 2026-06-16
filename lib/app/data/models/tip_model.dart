class TipModel {
  final int id;
  final String title;
  final String description;
  final String icon;

  TipModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });

  factory TipModel.fromJson(Map<String, dynamic> json) {
    return TipModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
    );
  }
}