import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';
import '../models/post.dart';

class PostScreen extends StatefulWidget {
  final String role; // role dikirim dari HomeScreen (admin/user)
  const PostScreen({required this.role, Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PostProvider>().fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    final posts = context.watch<PostProvider>().posts;

    return Scaffold(
      appBar: AppBar(title: Text("Posts")),
      floatingActionButton: widget.role == "admin"
          ? FloatingActionButton(
              onPressed: () {
                _showPostDialog(context);
              },
              child: Icon(Icons.add),
            )
          : null,
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                post.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(post.content),
              trailing: widget.role == "admin"
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showPostDialog(context, post: post),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              context.read<PostProvider>().removePost(post.id),
                        ),
                      ],
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }

  void _showPostDialog(BuildContext context, {Post? post}) {
    final titleCtrl = TextEditingController(text: post?.title ?? "");
    final contentCtrl = TextEditingController(text: post?.content ?? "");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(post == null ? "Tambah Post" : "Edit Post"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: contentCtrl,
              decoration: InputDecoration(labelText: "Content"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              if (post == null) {
                context.read<PostProvider>().addPost(
                  Post(id: 0, title: titleCtrl.text, content: contentCtrl.text),
                );
              } else {
                context.read<PostProvider>().editPost(
                  post.id,
                  Post(
                    id: post.id,
                    title: titleCtrl.text,
                    content: contentCtrl.text,
                  ),
                );
              }
              Navigator.pop(context);
            },
            child: Text("Simpan"),
          ),
        ],
      ),
    );
  }
}
