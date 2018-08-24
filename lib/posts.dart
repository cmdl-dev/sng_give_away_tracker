/*
import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
Future<List<Post>> fetchPosts(http.Client client) async{

  final response = await client.get('http://192.168.1.226/posts.json');

  return compute(parsePosts,response.body);
}

List<Post> parsePosts(String responseBody){
  final parsed = json.decode(responseBody).cast<Map<String,dynamic>>();

  return parsed.map<Post>((json) => Post.fromJson(json)).toList();
}
*/

import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

class Post {
  final String postOwner, postLocationLink, postOwnerProfileLink, postLocation,
      title, postLink;

  Post({this.postOwner, this.postLocationLink, this.postOwnerProfileLink,
    this.postLocation, this.title, this.postLink});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        postOwner: json['postowner'] as String,
        postLocationLink: json['postlocationlink'] as String,
        postOwnerProfileLink: json['postownerprofilelink'] as String,
        postLocation: json['postlocation'] as String,
        title: json['title']as String,
        postLink: json['postlink'] as String
    );
    }
    factory Post.fromSnapshot(Map<dynamic,dynamic> post){
      return Post(
          postOwner: post['postowner'] as String,
          postLocationLink: post['postlocationlink'] as String,
          postOwnerProfileLink: post['postownerprofilelink'] as String, 
          postLocation: post['postlocation'] as String,
          title: post['title']as String,
          postLink: post['postlink'] as String
      );
    }
  static Future<List<Post>> getGiveAwayPosts() async{
    List<Post> posts = new List<Post>();
    Completer<List<Post>> completer = new Completer<List<Post>>();
    FirebaseDatabase.instance
        .reference()
        .child("_posts")
        .once()
        .then((DataSnapshot snapshot){
          for ( var value in snapshot.value.values){
            posts.add(Post.fromSnapshot(value));
          }
         completer.complete(posts);
        });
    return completer.future;
  }
  
  static Future<List<Post>> getFrontPagePosts() async{
    List<Post> posts = new List<Post>();
    Completer<List<Post>> completer = new Completer<List<Post>>();
    FirebaseDatabase.instance
        .reference()
        .child("frontPagePosts")
        .once()
        .then((DataSnapshot snapshot){
          for (var value in snapshot.value.values)
            posts.add(Post.fromSnapshot(value));
          completer.complete(posts);
        });
      return completer.future;
  }

  toJson(){
    return{
      'title':title,
      'postowner':postOwner,
      'postlocationlink':postLocationLink,
      'postownerprofilelink':postOwnerProfileLink,
      'postlocation':postLocation,
      'postlink':postLink,
    };
  }
}
