import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news/constant/colors.dart';
import 'package:news/constant/url.dart';
import 'package:news/constant/web_name.dart';
import 'package:news/db/sql.dart';
import 'package:news/db/sql_user.dart';

class NewsProvider with ChangeNotifier {
  List _news = [];
  List _newsUser = [];
  List _trendNews = [];
  List _twitterFeed = [];
  List _wordpressFeed = [];
  List get listNews => _news;
  List get twitterFeedtNews => _twitterFeed;
  List get wordpressNews => _wordpressFeed;
  List get listNewsUser => _newsUser;
  List get listTrendNews => _trendNews;
  bool isloading = true;
  Future getTwitterFeed(String url) async {
    try {
      // for (var i = 0; i < urlTwitter.length; i++) {
      var res = await http.get(Uri.parse(url));
      final map = json.decode(res.body);
      _twitterFeed = map['items'];
      // print(_twitterFeed);
      await sqlInsertTwitter('Twitter');
      // }
    } catch (e) {
      // print(e);
    }
  }

  Future getWordPressFeed(String search) async {
    DateTime now = DateTime.now();

    DateTime diffDt = now.subtract(const Duration(hours: 6));

    String date = DateFormat('yyyy-MM-ddTHH:mm:ss')
        .format(DateTime.parse(diffDt.toString()))
        .toString();
    // print('date = ' + date);

    for (var i = 0; i < wordpressSites.length; i++) {
      try {
        var site = wordpressSites[i];
        // NewsDB('Totenham').deleteAllNews('Totenham');
        var res = await http.get(Uri.parse(
            "$site/wp-json/wp/v2/posts?search=$search&_embed&after=$date"));
        final map = json.decode(res.body);
        _wordpressFeed = map;
        // print(_wordpressFeed);
        await sqlInsertWordPress('Totenham');
      } catch (e) {
        // print(e);
      }
    }
  }

  Future postnews(
      String title, url, imageurl, content, sitename, pubdate, category) async {
    final response = await http.post(Uri.parse(spornewsUrl), body: {
      'action': 'ADD_NEWS',
      'title': title.toString(),
      'content': content.toString(),
      'publishing_date': pubdate,
      'sitename': sitename.toString(),
      'imageurl': imageurl.toString(),
      'url': url.toString(),
      'category_id': category.toString(),
      'user_id': '1'
      // 'SQLs':
      //     "INSERT INTO `posts` (`id`, `url`, `title`, `imageurl`, `content`, `sitename`, `publishing_date`, `are_comments_enabled`, `user_id`, `category_id`) VALUES (NULL, '$url', '$title', '$imageurl', '$content', '$sitename', '$date', '1', '1', '$categoryID'); "
    });
    if (response.statusCode == 200) {
      // print(response.body);
    }
  }

  Future postComments(String comment, userID, postid) async {
    try {
      var url = Uri.parse(spornewsUrl);
      var res = await http.post(
        url,
        body: {
          'action': 'POST_COMMENTS',
          'comment': comment,
          'user_ID': userID,
          'date': DateTime.now().toString(),
          'postID': postid
        },
      );
      if (res.statusCode == 200) {
        // print(res.body);
      }

      // notifyListeners();
    } catch (e) {
      // print(e.toString());
    }
  }

  Future getTrendNews() async {
    try {
      var url = Uri.parse(spornewsUrl);
      var res = await http.post(
        url,
        body: {
          'action': 'TrendNews',
        },
      );
      final map = json.decode(res.body);
      _trendNews = map;
      notifyListeners();
      // print(res.body);
      // await sqlInsert(teamName);
    } catch (e) {
      // print(e.toString());
    }
  }

  Future getNewsFromWebSitetoSQL(String site, teamName, int id) async {
    try {
      var url = Uri.parse(
          '$site/wp-json/wp/v2/posts?per_page=10&categories=$id&_embed');
      var res = await http.get(url);
      final map = json.decode(res.body);
      _news = map;
      // print(res.reasonPhrase);
      await sqlInsert(teamName);
    } catch (e) {
      // print(e.toString());
    }
  }

  Future getMercato(String teamName, int id) async {
    Uri url =
        Uri.parse('$mercato/wp-json/wp/v2/posts?per_page=4&tags=$id&_embed');
    var res = await http.get(url);
    final map = json.decode(res.body);
    _news = map;
    // print(res.reasonPhrase);
    await sqlInsert(teamName);
  }

  Future getWhatsKoora(String teamName, int id) async {
    Uri url = Uri.parse(
        'https://wtskora.com/wp-json/wp/v2/posts?league=$id&per_page=5&_embed');
    var res = await http.get(url);
    final map = json.decode(res.body);
    _news = map;
    // print(res.reasonPhrase);
    await sqlInsert(teamName);
  }

  Future getCornerSport(String teamName, int id) async {
    Uri url = Uri.parse(
        'https://www.cornersport.org/wp-json/wp/v2/posts?categories=$id&_embed&per_page=4');
    var res = await http.get(url);
    final map = json.decode(res.body);
    _news = map;
    // print(res.reasonPhrase);
    await sqlInsert(teamName);
  }

  Future getSport195(String teamName, int id) async {
    Uri url = Uri.parse(
        'https://www.195sports.com/wp-json/wp/v2/posts?categories=$id&_embed&per_page=5');
    var res = await http.get(url);
    final map = json.decode(res.body);
    _news = map;
    // print(res.reasonPhrase);
    await sqlInsert(teamName);
  }

  Future getSaudiLeague(String teamName, int id) async {
    Uri url = Uri.parse(
        'https://saudileague.com/wp-json/wp/v2/posts?categories=$id&_embed&per_page=5');
    var res = await http.get(url);
    final map = json.decode(res.body);
    _news = map;
    // print(res.reasonPhrase);
    await sqlInsert(teamName);
  }

  Future getNewsFromSQLtoWeb(String teamName, List list) async {
    await NewsDB(teamName).gitDistnct().then((value) {
      list = value.toList();
      notifyListeners();
    });
  }

  Future getNewsFromSQLtoUser(String teamName, List list) async {
    await NewsUserDB(teamName).gitDistnct().then((value) {
      list = value.toList();
      notifyListeners();
    });
  }

  Future getFromPHP(String teamName, String title) async {
    Uri url = Uri.parse(spornewsUrl);
    try {
      var res = await http.post(url, body: {
        'action': 'GetPost',
        'title': title.toString(),
      });
      final map = json.decode(res.body);
      _newsUser = map;
      // notifyListeners();
      // print(_newsUser);
      await sqlInsertUser(teamName);
    } catch (e) {
      // print(e.toString());
    }
  }

  Future sqlInsertUser(String teamName) async {
    for (var i = 0; i < listNewsUser.length; i++) {
      NewsUserDB(teamName).create({
        'title': listNewsUser[i]['title'].toString(),
        'desc': listNewsUser[i]['content'].toString(),
        'imageurl': listNewsUser[i]['imageurl'].toString(),
        'pubDate': listNewsUser[i]['publishing_date'].toString(),
        'link': listNewsUser[i]['url'].toString(),
        'sitename': listNewsUser[i]['sitename'].toString(),
        'content': listNewsUser[i]['content'].toString(),
        'post_id': listNewsUser[i]['post_id'].toString(),
        'CommentDate': listNewsUser[i]['CommentDate'].toString(),
        'count': listNewsUser[i]['count'].toString(),
        'isread': 'false',
      }).then((value) {
        // print('inserted successfully User : ' + value.toString());
      });
    }
  }

  Future sqlInsertTwitter(String teamName) async {
    for (var i = 0; i < twitterFeedtNews.length; i++) {
      NewsDB(teamName).create({
        'title': twitterFeedtNews[i]['title'].toString(),
        'desc': twitterFeedtNews[i]['description'].toString(),
        'imageurl': twitterFeedtNews[i]['thumbnail'],
        'pubDate': twitterFeedtNews[i]['pubDate'].toString(),
        'link': twitterFeedtNews[i]['link'].toString(),
        'sitename': twitterFeedtNews[i]['author'].toString(),
        'content': twitterFeedtNews[i]['content'].toString(),
        'isread': 'false',
      }).then((value) {
        print('inserted successfully : ' + value.toString());
      });
    }
  }

  Future sqlInsert(String teamName) async {
    for (var i = 0; i < listNews.length; i++) {
      NewsDB(teamName).create({
        'title': listNews[i]['title']['rendered'].toString(),
        'desc': listNews[i]['excerpt']['rendered'].toString(),
        'imageurl': listNews[i]['_embedded']["wp:featuredmedia"][0]
                ['media_details']['sizes']['thumbnail']['source_url'] ??
            listNews[i]['jetpack_featured_media_url'],
        'pubDate': listNews[i]['date_gmt'].toString(),
        'link': listNews[i]['link'].toString(),
        'sitename': listNews[i]['_links']['collection'][0]['href'].toString(),
        'content': listNews[i]['content']['rendered'].toString(),
        'isread': 'false',
      }).then((value) {
        print('inserted successfully : ' + value.toString());
      });
    }
  }

  Future sqlInsertWordPress(String teamName) async {
    for (var i = 0; i < wordpressNews.length; i++) {
      NewsDB(teamName).create({
        'title': wordpressNews[i]['title']['rendered'].toString(),
        'desc': wordpressNews[i]['excerpt']['rendered'].toString(),
        'imageurl': wordpressNews[i]['_embedded']["wp:featuredmedia"][0]
                ['media_details']['sizes']['thumbnail']['source_url'] ??
            wordpressNews[i]['jetpack_featured_media_url'],
        'pubDate': wordpressNews[i]['date_gmt'].toString(),
        'link': wordpressNews[i]['link'].toString(),
        'sitename':
            wordpressNews[i]['_links']['collection'][0]['href'].toString(),
        'content': wordpressNews[i]['content']['rendered'].toString(),
        'isread': 'false',
      }).then((value) {
        print('inserted successfully : ' + value.toString());
      });
    }
  }

  Future getHaber() async {
    for (var i = 0; i < teams.length; i++) {
      NewsDB('Totenham').deleteAllNews('Totenham');
      await NewsProvider().getWordPressFeed(teams[i].toString());
      await NewsDB('Totenham'.toString()).gitDistnct().then((value) {
        // setState(() {
        _wordpressFeed = value;
        isloading = false;
        // });
        notifyListeners();
        Fluttertoast.showToast(
            msg: "‏تم تجهيز الأخبار ‏وعددها ${_wordpressFeed.length}" +
                teams[i].toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            webShowClose: true,
            fontSize: 16.0);
      });
      for (var i = 0; i < _wordpressFeed.length; i++) {
        await postnews(
          _wordpressFeed[i]['title'].toString(),
          _wordpressFeed[i]['link'].toString(),
          _wordpressFeed[i]['imageurl'].toString(),
          _wordpressFeed[i]['content'].toString(),
          _wordpressFeed[i]['sitename'].toString(),
          _wordpressFeed[i]['pubdate'].toString(),
          '10',
        );
        Fluttertoast.showToast(
            msg: "‏تم تجهيز الأخبار $i ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP_LEFT,
            timeInSecForIosWeb: 1,
            backgroundColor: nb1,
            textColor: Colors.white,
            webShowClose: true,
            fontSize: 16.0);
      }
      // setState(() {
      isloading = true;
      // });
      notifyListeners();
    }
    // setState(() {
    isloading = false;
    // });
    notifyListeners();
    await http.post(Uri.parse(spornewsUrl), body: {
      'action': 'DELETE_NEWS',
    });
  }
}
