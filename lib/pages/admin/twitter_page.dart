import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news/constant/colors.dart';
import 'package:news/constant/url.dart';
import 'package:news/db/sql.dart';
import 'package:news/provider/provider.dart';
import 'package:http/http.dart' as http;

class TwitterPageFeedAdmin extends StatefulWidget {
  const TwitterPageFeedAdmin({
    Key? key,
  }) : super(key: key);

  @override
  State<TwitterPageFeedAdmin> createState() => _TwitterPageFeedAdminState();
}

class _TwitterPageFeedAdminState extends State<TwitterPageFeedAdmin> {
  bool isloading = true;
  List twitterFeed1 = [];

  Future postnews(String title, url, imageurl, content, sitename, pubdate,
      categoryID) async {
    final response = await http.post(Uri.parse(spornewsUrl), body: {
      'action': 'ADD_NEWS',
      'title': title.toString(),
      'content': content.toString(),
      'publishing_date': pubdate,
      'sitename': sitename.toString(),
      'imageurl': imageurl.toString(),
      'url': url.toString(),
      'category_id': categoryID.toString(),
      'user_id': '1'
      // 'SQLs':
      //     "INSERT INTO `posts` (`id`, `url`, `title`, `imageurl`, `content`, `sitename`, `publishing_date`, `are_comments_enabled`, `user_id`, `category_id`) VALUES (NULL, '$url', '$title', '$imageurl', '$content', '$sitename', '$date', '1', '1', '$categoryID'); "
    });
    if (response.statusCode == 200) {
      print(response.body);
    }
  }

  Future getHaber() async {
    for (var i = 0; i < urlTwitter.length; i++) {
      NewsDB('Twitter').deleteAllNews('Twitter');
      await NewsProvider().getTwitterFeed(urlTwitter[i]);
      await NewsDB('Twitter'.toString()).gitDistnct().then((value) {
        setState(() {
          twitterFeed1 = value;
          isloading = false;
        });
        Fluttertoast.showToast(
            msg: "‏تم تجهيز الأخبار ‏وعددها ${twitterFeed1.length}",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            webShowClose: true,
            fontSize: 16.0);
      });
      for (var i = 0; i < twitterFeed1.length; i++) {
        await postnews(
          twitterFeed1[i]['title'].toString(),
          twitterFeed1[i]['link'].toString(),
          twitterFeed1[i]['imageurl'].toString(),
          twitterFeed1[i]['content'].toString(),
          twitterFeed1[i]['sitename'].toString(),
          twitterFeed1[i]['pubdate'].toString(),
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
        setState(() {
          isloading = true;
        });
      }
    }
    setState(() {
      isloading = false;
    });
    await http.post(Uri.parse(spornewsUrl), body: {
      'action': 'DELETE_NEWS',
    });
  }

  @override
  void initState() {
    getHaber();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Twitter'),
      ),
      body: Center(
        child: isloading
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: twitterFeed1.length,
                itemBuilder: (BuildContext context, int index) {
                  var res = twitterFeed1[index];
                  return Card(
                    child: Text(res['title']),
                  );
                },
              ),
      ),
    );
  }
}
