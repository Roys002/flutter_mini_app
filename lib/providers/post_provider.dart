import 'package:flutter/material.dart';
import '../api/post_service.dart';
import '../models/post.dart';

class PostProvider extends ChangeNotifier {
  List<Post> _posts = [];
  List<Post> get posts => _posts;

  Future<void> fetchPosts() async {
    _posts = await PostService.getPosts();
    notifyListeners();
  }

  Future<void> addPost(Post post) async {
    final newPost = await PostService.createPost(post);
    _posts.add(newPost);
    notifyListeners();
  }

  Future<void> editPost(int id, Post post) async {
    final updated = await PostService.updatePost(id, post);
    final index = _posts.indexWhere((p) => p.id == id);
    if (index != -1) {
      _posts[index] = updated;
      notifyListeners();
    }
  }

  Future<void> removePost(int id) async {
    await PostService.deletePost(id);
    _posts.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
