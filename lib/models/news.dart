import 'package:frontline/models/article.dart';

class News{
  final String status;
  final int totalResults;
  final List<Article> articles;

  News({this.status, this.totalResults, this.articles});

  factory News.fromJson(Map<String, dynamic> json){
    return News(
      status: json['status'],
      totalResults: json['totalResults'],
      articles: new List<Article>.from(json["articles"].map((x) => Article.fromJson(x))),

    );
  }

}