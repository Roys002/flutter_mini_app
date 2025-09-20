import 'api_client.dart';
import '../models/post.dart';

class PostService {
  static Future<List<Post>> getPosts() async {
    final response = await ApiClient.dio.get("/posts");
    List data = response.data["data"]; // asumsi format Laravel API pakai "data"
    return data.map((e) => Post.fromJson(e)).toList();
  }

  static Future<Post> createPost(Post post) async {
    final response = await ApiClient.dio.post("/posts", data: post.toJson());
    return Post.fromJson(response.data["data"]);
  }

  static Future<Post> updatePost(int id, Post post) async {
    final response = await ApiClient.dio.put("/posts/$id", data: post.toJson());
    return Post.fromJson(response.data["data"]);
  }

  static Future<void> deletePost(int id) async {
    await ApiClient.dio.delete("/posts/$id");
  }
}
