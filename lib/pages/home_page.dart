import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../services/auth_service.dart';
import '../services/db_service.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  static const String id = "home_page";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List<Post> items = [];

  _apiLoadPosts() async {
    setState(() {
      isLoading = true;
    });
    List<Post> posts = await DBService.loadPosts();
    setState(() {
      items = posts;
      isLoading = false;
    });
  }

  Future _callDetailPage() async {
    bool results = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return DetailPage();
    }));
    if (results) {
      _apiLoadPosts();
    }
  }

  @override
  void initState() {
    super.initState();
    _apiLoadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("My Posts",style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            onPressed: () {
              AuthService.signOutUser(context);
            },
            icon: const Icon(Icons.exit_to_app,color: Colors.white,),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, index) {
              return itemOfPost(items[index]);
            },
          ),
          isLoading
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : const SizedBox.shrink(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          _callDetailPage();
        },
      ),
    );
  }

  Widget itemOfPost(Post post) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            height: 70,
            width: 70,
            imageUrl: post.img_url!,
            placeholder: (context, url) => Container(
              color: Colors.grey.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey.withOpacity(0.5),
            ),
            fit: BoxFit.cover,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 15,
                ),
                Text(
                  post.title,
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  post.content,
                  maxLines: 2,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}