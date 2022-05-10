import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:news/constant/colors.dart';
import 'package:news/constant/web_name.dart';
import 'package:news/db/sql.dart';
import 'package:news/provider/provider.dart';
import 'package:http/http.dart' as http;

import '../news_details.dart';

// ignore: must_be_immutable
class NewsPageAdmin extends StatefulWidget {
  final String teamName;
  final String site1, site2, site3, site4;
  int id1, id2, id3, id4, id5, id6, id7, categoryID;
  final List? list;
  final Color color;

  NewsPageAdmin({
    Key? key,
    required this.teamName,
    required this.categoryID,
    this.list,
    required this.site1,
    required this.id1,
    required this.id2,
    required this.id3,
    required this.id4,
    required this.id5,
    required this.id6,
    required this.id7,
    required this.site2,
    required this.site3,
    required this.site4,
    required this.color,
  }) : super(key: key);
  @override
  _NewsPageAdminState createState() => _NewsPageAdminState();
}

class _NewsPageAdminState extends State<NewsPageAdmin> {
  List haber = [];
  bool isloading = true;
  @override
  void initState() {
    getHaber();
    super.initState();
  }

  Future getHaber() async {
    // NewsDB(widget.teamName).deleteAllNews(widget.teamName);
    try {
      await NewsProvider()
          .getNewsFromWebSitetoSQL(widget.site1, widget.teamName, widget.id1);
      await NewsProvider()
          .getNewsFromWebSitetoSQL(widget.site2, widget.teamName, widget.id2);
      await NewsProvider().getMercato(widget.teamName, widget.id3);
      await NewsProvider().getWhatsKoora(widget.teamName, widget.id5);
      await NewsProvider().getCornerSport(widget.teamName, widget.id4);
      await NewsProvider().getSport195(widget.teamName, widget.id6);
      await NewsProvider().getSaudiLeague(widget.teamName, widget.id7);
    } catch (e) {
      //
    }

    await NewsDB(widget.teamName.toString()).gitDistnct().then((value) {
      setState(() {
        haber = value;
        isloading = false;
      });
      Fluttertoast.showToast(
          msg: "‏تم تجهيز الأخبار ‏وعددها ${haber.length}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          webShowClose: true,
          fontSize: 16.0);
    });
  }

  Future postnews(String title, url, imageurl, content, sitename, pubdate,
      categoryID) async {
    final response = await http.post(
        Uri.parse('https://databasetestarf.000webhostapp.com/news/action.php'),
        body: {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.teamName),
        actions: [
          IconButton(
            onPressed: () async {
              for (var i = 0; i < haber.length; i++) {
                await postnews(
                  haber[i]['title'].toString(),
                  haber[i]['link'].toString(),
                  haber[i]['imageurl'].toString(),
                  haber[i]['content'].toString(),
                  haber[i]['sitename'].toString(),
                  haber[i]['pubdate'].toString(),
                  widget.categoryID.toString(),
                );
                Fluttertoast.showToast(
                    msg: "‏تم تجهيز الأخبار $i ",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP_LEFT,
                    timeInSecForIosWeb: 1,
                    backgroundColor: widget.color.withOpacity(.3),
                    textColor: Colors.white,
                    webShowClose: true,
                    fontSize: 16.0);
              }
              Fluttertoast.showToast(
                  msg: "‏تم تجهيز الأخبار  ",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 3,
                  backgroundColor: widget.color,
                  textColor: Colors.black26,
                  webShowClose: true,
                  fontSize: 16.0);
              await http.post(
                  Uri.parse(
                      'https://databasetestarf.000webhostapp.com/news/action.php'),
                  body: {
                    'action': 'DELETE_NEWS',
                  });
            },
            icon: const Icon(Icons.publish),
            color: news2,
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
            color: news2,
          )
        ],
      ),
      body: Center(
        child: isloading
            ? CircularProgressIndicator(
                backgroundColor: dirctive1.withOpacity(.3),
                semanticsValue: 'loading...',
                color: dirctive.withOpacity(.6),
                semanticsLabel: 'hhhh',
                strokeWidth: 3,
              )
            : ListView.builder(
                itemCount: haber.length,
                itemBuilder: (context, index) {
                  var news = haber[index];

                  DateTime now = DateTime.now();
                  DateTime dateTime =
                      DateTime.parse(news['pubdate'].toString());
                  var timezone = dateTime.timeZoneOffset.toString();
                  // print('timzone ' + timezone.toString());
                  int zonetime = 0;
                  if (timezone == '2:00:00.000000') {
                    zonetime = 2;
                  } else if (timezone == '3:00:00.000000') {
                    zonetime = 3;
                  } else if (timezone == '1:00:00.000000') {
                    zonetime = 1;
                  }

                  DateTime realtime = dateTime.add(Duration(hours: zonetime));
                  var diffDt = now.difference(realtime).inMinutes;

                  var diffDays = now.difference(realtime).inHours;
                  String timeName;
                  if (diffDays > 24) {
                    double diffDays1 = diffDays / 24.toInt();
                    diffDays = diffDays1.toInt();
                    timeName = 'day';
                  }
                  if (diffDt > 60) {
                    double diffDt1 = diffDt / 60.toInt();
                    diffDt = diffDt1.toInt();
                    timeName = '‏ساعة ';
                  } else {
                    timeName = '‏ دقيقة';
                  }

                  print(news['isread'].toString() + 'isread');
                  String siteName = '', siteImage = '';
                  if (news['sitename'].toString() ==
                      '$hihi2/wp-json/wp/v2/posts') {
                    siteName = '‏هاي كورة';
                    siteImage =
                        'https://sc5.hihi2.com/wp-content/themes/hihi2/images/hihi2-logo.png';
                  } else if (news['sitename'].toString() ==
                      '$sport195/wp-json/wp/v2/posts') {
                    siteName = 'Sport195';
                    siteImage =
                        'https://www.195sports.com/wp-content/uploads/2020/09/195sportslogo.png';
                  } else if (news['sitename'].toString() ==
                      '$barsalony/wp-json/wp/v2/posts') {
                    siteName = '‏برشلوني';
                    siteImage =
                        'https://barslony.com/wp-content/uploads/2016/05/Barslony-Logo.png';
                  } else if (news['sitename'].toString() ==
                      '$hihisaudi/wp-json/wp/v2/posts') {
                    siteName = '‏هاي كورة';
                    siteImage =
                        'https://sc5.hihi2.com/wp-content/themes/hihi2/images/hihi2-logo.png';
                  } else if (news['sitename'].toString() ==
                      'https://saudileague.com/wp-json/wp/v2/posts') {
                    siteName = 'SaudiLeague';
                    siteImage =
                        'https://saudileague.wpengine.com/wp-content/uploads/2016/10/logo.png';
                  } else if (news['sitename'].toString() ==
                      '$belgol/wp-json/wp/v2/posts') {
                    siteName = '‏بالجول';
                    siteImage =
                        'https://www.belgoal.com/wp-content/uploads/2017/08/BelGoal300.png';
                  } else if (news['sitename'].toString() ==
                      '$cornersport/wp-json/wp/v2/posts') {
                    siteName = '‏كورنر';
                    siteImage =
                        'https://cornersport.org/wp-content/uploads/2020/02/86840879_650142765555703_5804754399121113088_n.png';
                  } else if (news['sitename'].toString() ==
                      '$mercato/wp-json/wp/v2/posts') {
                    siteName = '‏ميركاتو';
                    siteImage =
                        'https://mercatoday.com/wp-content/uploads/2020/04/x2-logo.png';
                  } else if (news['sitename'].toString() ==
                      'https://www.sportksa.net/main/wp-json/wp/v2/posts') {
                    siteName = '‏سبورت سعودي';
                    siteImage =
                        'https://s2.sportksa.net/main/wp-content/themes/sports/images/logo5.png';
                  } else if (news['sitename'].toString() ==
                      'https://wtskora.com/wp-json/wp/v2/posts') {
                    siteName = '‏واتس كورة';
                    siteImage =
                        'https://wtskora.com/wp-content/uploads/2021/01/wtskora-main-logo@2x.png';
                  }

                  return Column(
                    children: [
                      // SafeArea(
                      //   child: Container(
                      //     child: AdmobBanner(
                      //       adUnitId: getBannerAdUnitId(),
                      //       adSize: bannerSize,
                      //       listener: (AdmobAdEvent event,
                      //           Map<String, dynamic> args) {
                      //         // AdmobAdEvent.loaded;
                      //         // AdmobAdEvent.opened;

                      //         // handleEvent(event, args, 'Banner');
                      //       },
                      //     ),
                      //   ),
                      //   // Facebook_Banner(),
                      // ),
                      InkWell(
                        onTap: () {
                          print(news['content'].toString());

                          Navigator.push(context, MaterialPageRoute(
                            builder: (BuildContext context) {
                              return NewsDetails(
                                id: 1, teamName: '',
                                content: news['content'].toString(),
                                desc: news['desc'].toString(),
                                imageurl: news['imageurl'].toString(),
                                pupdate: realtime.toString(),
                                // pupdate: news['pubdate'].toString(),
                                title: news['title'].toString(),
                                site: news['link'].toString(),
                                siteName: news['siteName'].toString(),
                                postID: '1',
                              );
                            },
                          ));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              bottom: 6, right: 6, left: 6),
                          child: Card(
                            elevation: 2,
                            color: news5.withOpacity(.7),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Image.network(
                                    news['imageurl'].toString(),
                                    fit: BoxFit.cover,
                                    width: double.maxFinite,
                                    height: MediaQuery.of(context).size.height *
                                        .22,
                                    filterQuality: FilterQuality.high,
                                  ),
                                  // Text(news['content'].toString()),
                                  // Text(news['imageUrl']),
                                  //  parse((widget.title).toString()).documentElement.text,
                                  Text(
                                    parse(news['title'].toString())
                                        .documentElement!
                                        .text,
                                    textAlign: TextAlign.center,
                                    // textDirection:

                                    softWrap: true,
                                    style: TextStyle(
                                        decorationColor: sa4,
                                        color: white12Color,
                                        decorationThickness: 3,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: 'NizarBBCKurdish',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        children: [
                                          TextButton.icon(
                                              onPressed: () async {
                                                print(dateTime.toString());
                                                await postnews(
                                                  news['title'].toString(),
                                                  news['link'].toString(),
                                                  news['imageurl'].toString(),
                                                  news['content'].toString(),
                                                  news['sitename'].toString(),
                                                  dateTime.toString(),
                                                  '6',
                                                );
                                              },
                                              icon: Icon(Icons.post_add),
                                              label: Text('post')),
                                          Text(
                                            timeName,
                                            style: TextStyle(
                                                decorationColor: sa4,
                                                color: sa3,
                                                decorationThickness: 3,
                                                fontStyle: FontStyle.normal,
                                                fontFamily: 'Cairo',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(diffDt.toString()),
                                          Text(
                                            ' ‏منذ',
                                            style: TextStyle(
                                                decorationColor: sa4,
                                                color: sa3,
                                                decorationThickness: 3,
                                                fontStyle: FontStyle.normal,
                                                fontFamily: 'Cairo',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                siteName,
                                                softWrap: true,
                                                style: TextStyle(
                                                    decorationColor: sa4,
                                                    color: sa3,
                                                    decorationThickness: 3,
                                                    fontStyle: FontStyle.normal,
                                                    fontFamily: 'Cairo',
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              Text(
                                                '     ‏موقع',
                                                style: TextStyle(
                                                    decorationColor: sa4,
                                                    color: sa3,
                                                    decorationThickness: 3,
                                                    fontStyle: FontStyle.normal,
                                                    fontFamily: 'Cairo',
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Image.network(
                                            siteImage,
                                            width: 60,
                                            height: 50,
                                            // color: sa4,
                                            fit: BoxFit.scaleDown,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  // RaisedButton(
                                  //   onPressed: () {
                                  //     Haber(widget.teamName)
                                  //         .deleteNote(widget.teamName, index);
                                  //   },
                                  //   child: Text('Delete'),
                                  // )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
      ),
    );
  }
}
