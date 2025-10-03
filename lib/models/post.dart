class Post {
  final String id;
  final String title;
  final String? imageUrl;
  final String? price;
  final String? description;
  final DateTime? createdAt;

  Post({
    required this.id,
    required this.title,
    this.imageUrl,
    this.price,
    this.description,
    this.createdAt,
  });

  factory Post.fromMap(Map<String, dynamic> data, String id) => Post(
    id: id,
    title: data['title'] ?? '',
    imageUrl: data['imageUrl'] as String?,
    price: data['price']?.toString(),
    description: data['description'] as String?,
    createdAt: data['createdAt'] != null
        ? DateTime.fromMillisecondsSinceEpoch(
            (data['createdAt'] is int)
                ? data['createdAt'] as int
                : int.parse(data['createdAt'].toString()),
          )
        : null,
  );

  Map<String, dynamic> toMap() => {
    'title': title,
    'imageUrl': imageUrl,
    'price': price,
    'description': description,
    'createdAt': createdAt?.millisecondsSinceEpoch,
  };
}
