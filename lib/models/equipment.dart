class Equipment {
  final String id;
  final String name;
  final String? description;

  Equipment({required this.id, required this.name, this.description});

  factory Equipment.fromMap(Map<String, dynamic> data, String id) => Equipment(
    id: id,
    name: data['name'] ?? '',
    description: data['description'] as String?,
  );

  Map<String, dynamic> toMap() => {'name': name, 'description': description};
}
