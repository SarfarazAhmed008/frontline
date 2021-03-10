import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontline/models/news.dart';
import 'package:http/http.dart' as http;

class Headline extends StatefulWidget{
  @override
  _HeadlineState createState() => _HeadlineState();
}

class _HeadlineState extends State<Headline> {
  final items = List<String>.generate(100, (i) => "Item $i");
  Future<News> news;

  Future<News> _fetchNews(String pageNumber) async {
    final response = await http.get("https://newsapi.org/v2/everything?q=apple&pageSize=10&page="+ pageNumber +"&apiKey=1e8846630c8345848cbd2ffd19cc0380");

    if (response.statusCode == 200) {
      print(response.body);
      return News.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch news');
    }
  }

  @override
  void initState() {
    super.initState();
    news = _fetchNews("10");
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Headlines'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: FutureBuilder<News>(
        future: news,
        builder: (context, snapshot){
          if(snapshot.connectionState != ConnectionState.done){
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
                strokeWidth: 3.0,
              ),
            );
          }
          if(snapshot.hasError){
            //return error
          }
          News news = snapshot.data ?? [];
          return ListView.builder(
            itemCount: news.articles.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: ()=>print("tappp"),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(news.articles[index].title, style: TextStyle(fontSize: 12.0),softWrap: true,),
                          ),
                          CachedNetworkImage(
                            imageUrl: news.articles[index].urlToImage,
                            placeholder: (context, url) => new CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
                              strokeWidth: 2.0,
                            ),
                            errorWidget: (context, url, error) => new Icon(Icons.error),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(news.articles[index].description, style: TextStyle(fontSize: 10.0), softWrap: true,),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      )
    );
  }
}

