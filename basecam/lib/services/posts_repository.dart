import 'dart:async';
import 'package:basecam/models/post.dart';

class PostsRepository {
  // Minimal stub: provide a stream of empty list and a no-op ensureCollectionExists
  Stream<List<Post>> streamPosts() async* {
    yield <Post>[];
  }

  Future<String> addPost(Post p) async {
    return Future.value('stub-id');
  }

  Future<void> ensureCollectionExists() async {}
}

final postsRepo = PostsRepository();
