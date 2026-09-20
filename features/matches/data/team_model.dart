class TeamModel {
  const TeamModel({required this.id, required this.name, this.crestUrl});

  final int id;
  final String name;
  final String? crestUrl;

  factory TeamModel.fromJson(Map<String, dynamic> json) => TeamModel(
    id: json['id'] as int,
    name: json['name'] as String,
    crestUrl: json['crest'] as String?,
  );
}
