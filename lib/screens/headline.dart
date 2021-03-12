import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_link_preview/flutter_link_preview.dart';
import 'package:frontline/models/article.dart';
import 'package:frontline/models/news.dart';
import 'package:frontline/widgets/webview.dart';
import 'package:http/http.dart' as http;

class Headline extends StatefulWidget{
  @override
  _HeadlineState createState() => _HeadlineState();
}

class _HeadlineState extends State<Headline> {
  ScrollController _scrollController = ScrollController();
  List<Article> newsArticleList = [];
  int pageNumber = 1;
  bool initLoad = true;
  bool lazyLoad = false;

  Future<List<Article>> _fetchNews(String pageNumber) async {
    News news;
    List<Article> articleList = [];
    final response = await http.get("https://newsapi.org/v2/everything?q=apple&pageSize=5&page="+ pageNumber +"&apiKey=1e8846630c8345848cbd2ffd19cc0380");

    if (response.statusCode == 200) {
      print(response.body);
      news = News.fromJson(json.decode(response.body));
      articleList.addAll(news.articles);
      return articleList;
    } else {
      throw Exception('Failed to fetch news');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchNews(pageNumber.toString()).then((value){
      setState(() {
        initLoad = false;
        newsArticleList.addAll(value);
      });
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          pageNumber++;
          lazyLoad = true;
        });
        _fetchNews(pageNumber.toString()).then((value){
          setState(() {
            lazyLoad = false;
            newsArticleList.addAll(value);
          });
        });
      }
    });
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
      body: initLoad ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
          strokeWidth: 3.0,
        ),
      ) :
      Scrollbar(
        child: ListView.builder(
          controller: _scrollController,
          itemBuilder: (context, index) {
            if(index == newsArticleList.length){
              return Center(
                child: SizedBox(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
                    strokeWidth: 3.0,
                  ),
                  height: 24,
                  width: 24,
                ),
              );
            }
            return InkWell(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WebViewWidget(newsArticleList[index].title, newsArticleList[index].url)));
              },
              child: FlutterLinkPreview(
                url: newsArticleList[index].url,
                bodyStyle: TextStyle(
                  fontSize: 18.0,
                ),
                titleStyle: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                showMultimedia: true,
                builder: (info) {
                  if (info is WebInfo) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SizedBox(
                        height: 350,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (info.image != null)
                                Expanded(
                                  child: CachedNetworkImage(
                                    width: double.maxFinite,
                                    fit: BoxFit.cover,
                                    imageUrl: newsArticleList[index].urlToImage,
                                    placeholder: (context, url) => new CupertinoActivityIndicator(),
                                    errorWidget: (context, url, error) => new Icon(Icons.error),
                                  ),
                                ),
                              Padding(
                                padding:
                                const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                                child: Text(
                                  info.title,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (info.description != null)
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(info.description),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            );
          },
          itemCount: newsArticleList.length + 1,
        ),
      )
    );
  }
}

