class Post {
  final String id;
  final String title;
  final String? imageUrl;
  final String? price;
  final String? description;

  Post({
    required this.id,
    required this.title,
    this.imageUrl,
    this.price,
    this.description,
  });

  factory Post.fromMap(Map<String, dynamic> data, String id) => Post(
    id: id,
    title: data['title'] ?? '',
    imageUrl: data['imageUrl'] as String?,
    price: data['price']?.toString(),
    description: data['description'] as String?,
  );

  Map<String, dynamic> toMap() => {
    'title': title,
    'imageUrl': imageUrl,
    'price': price,
    'description': description,
  };
}
