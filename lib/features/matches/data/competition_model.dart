class CompetitionModel {
  const CompetitionModel({required this.id, required this.name});

  final int id;
  final String name;

  factory CompetitionModel.fromJson(Map<String, dynamic> json) =>
      CompetitionModel(id: json['id'] as int, name: json['name'] as String);
}
