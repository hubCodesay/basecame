import 'dart:async';

import 'package:basecam/models/post.dart';

class PostsRepository {
  final List<Post> _store = [];

  Stream<List<Post>> streamPosts() async* {
    yield _store;
  }

  Future<String> addPost(Post p) async {
    _store.add(p);
    return Future.value('stub-id');
  }

  Future<void> ensureCollectionExists() async {}
}

final postsRepo = PostsRepository();
