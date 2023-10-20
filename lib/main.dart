import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() => runApp(MyApp());

Future<List<Post>> fetchPosts() async {
  final response = await http.get(Uri.parse('https://calm-plum-jaguar-tutu.cyclic.app/todos'));

  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body)["data"];
    List<Post> posts = body.map((dynamic item) => Post.fromJson(item)).toList();
    return posts;
  } else {
    throw Exception('Failed to load posts');
  }
}

class Post {
  final String id;
  final String todoName;
  final String isComplete;
  final String createdAt;
  final String updatedAt;

  Post({
    required this.id,
    required this.todoName,
    required this.isComplete,
    required this.createdAt,
    required this.updatedAt
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'] ?? '',
      todoName: json['todoName'] ?? '',
      isComplete: json['isComplete'] == true ? 'Selesai' : 'Belum Selesai',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final Future<List<Post>> posts = fetchPosts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts from API'),
      ),
      body: Center(
        child: FutureBuilder<List<Post>>(
          future: posts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5, // Tambahkan elevasi untuk efek bayangan
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Tambahkan margin
                    child: ListTile(
                      leading: const Icon(Icons.flight_land),
                      title: Text(snapshot.data![index].todoName),
                      subtitle: Text(snapshot.data![index].isComplete),
                      // Tambahkan animasi ketika item di-tap
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailScreen(post: snapshot.data![index]),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Post post;

  DetailScreen({required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.todoName),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text('ID : ${post.id}',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),

            SizedBox(height: 8),

            Text('ToDo Name : ${post.todoName}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            SizedBox(height: 8),
            Text('Status : ${post.isComplete}',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),

            SizedBox(height: 8),
            Text('Created At : ${post.createdAt}',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
            SizedBox(height: 8),
            Text('Updated At : ${post.updatedAt}',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
            SizedBox(height: 8)
          ],
        ),
      ),
    );
  }
}