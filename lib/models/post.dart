class Post {
  final int id;
  final String title;
  final String content;

  Post({required this.id, required this.title, required this.content});
  // konversi dari JSON ke Dart object
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(id: json['id'], title: json['title'], content: json['content']);
  }
  // konversi dari Dart object ke JSON (dipakai saat create/update)
  Map<String, dynamic> toJson() {
    return {"title": title, "content": content};
  }
}
