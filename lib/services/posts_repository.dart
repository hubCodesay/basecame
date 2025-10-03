import 'dart:async';

import 'package:basecam/models/post.dart';

class PostsRepository {
  final List<Post> _store = [];

  Stream<List<Post>> streamPosts() async* {
    // yield a copy sorted by created date (newest first)
    final copy = List<Post>.from(_store);
    copy.sort((a, b) {
      final at = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bt = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bt.compareTo(at);
    });
    yield copy;
  }

  /// Return a Post by id or null if not found.
  Post? getPostById(String id) {
    try {
      return _store.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Check if a post with given id exists.
  bool contains(String id) => getPostById(id) != null;

  Future<String> addPost(Post p) async {
    final now = DateTime.now();
    final post = Post(
      id: p.id,
      title: p.title,
      imageUrl: p.imageUrl,
      price: p.price,
      description: p.description,
      createdAt: p.createdAt ?? now,
    );
    _store.add(post);
    return Future.value(post.id);
  }

  /// Synchronously add or update a post in the in-memory store.
  void addOrUpdateSync(Post p) {
    final idx = _store.indexWhere((e) => e.id == p.id);
    final post = Post(
      id: p.id,
      title: p.title,
      imageUrl: p.imageUrl,
      price: p.price,
      description: p.description,
      createdAt: p.createdAt ?? DateTime.now(),
    );
    if (idx >= 0) {
      _store[idx] = post;
    } else {
      _store.add(post);
    }
  }

  Future<void> ensureCollectionExists() async {}
}

final postsRepo = PostsRepository();
