import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:html/parser.dart';
import 'package:news/constant/colors.dart';
import 'package:news/constant/url.dart';
import 'package:news/constant/web_name.dart';
import 'package:news/db/sql.dart';
import 'package:news/provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:cron/cron.dart';

class WordPressFeedAdmin extends StatefulWidget {
  const WordPressFeedAdmin({Key? key}) : super(key: key);

  @override
  State<WordPressFeedAdmin> createState() => _WordPressFeedAdminState();
}

class _WordPressFeedAdminState extends State<WordPressFeedAdmin> {
  final cron = Cron();
  bool isloading = true;
  List wordpressFeed = [];
  Future getHaber() async {
    for (var i = 0; i < teams.length; i++) {
      NewsDB('Totenham').deleteAllNews('Totenham');
      await NewsProvider().getWordPressFeed(teams[i].toString());
      await NewsDB('Totenham'.toString()).gitDistnct().then((value) {
        setState(() {
          wordpressFeed = value;
          isloading = false;
        });
        Fluttertoast.showToast(
            msg: "‏تم تجهيز الأخبار ‏وعددها ${wordpressFeed.length}" +
                teams[i].toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            webShowClose: true,
            fontSize: 16.0);
      });
      for (var i = 0; i < wordpressFeed.length; i++) {
        await postnews(
          wordpressFeed[i]['title'].toString(),
          wordpressFeed[i]['link'].toString(),
          wordpressFeed[i]['imageurl'].toString(),
          wordpressFeed[i]['content'].toString(),
          wordpressFeed[i]['sitename'].toString(),
          wordpressFeed[i]['pubdate'].toString(),
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
      setState(() {
        isloading = true;
      });
    }
    setState(() {
      isloading = false;
    });
    await http.post(Uri.parse(spornewsUrl), body: {
      'action': 'DELETE_NEWS',
    });
  }

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

  @override
  void initState() {
    cron.schedule(Schedule.parse('*/1 * * * *'), () async {
      getHaber();
      print('every one minutes');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WordPress'),
        actions: [
          IconButton(
              onPressed: () async {
                for (var i = 0; i < wordpressFeed.length; i++) {
                  await postnews(
                    wordpressFeed[i]['title'].toString(),
                    wordpressFeed[i]['link'].toString(),
                    wordpressFeed[i]['imageurl'].toString(),
                    wordpressFeed[i]['content'].toString(),
                    wordpressFeed[i]['sitename'].toString(),
                    wordpressFeed[i]['pubdate'].toString(),
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
              },
              icon: const Icon(Icons.share))
        ],
      ),
      body: Center(
        child: isloading
            ? const CircularProgressIndicator()
            : Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.50),
                          Colors.black.withOpacity(0.80)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  // Image.network(
                  //   'https://r1.ilikewallpaper.net/iphone-wallpapers/download/19996/FC-Barcelona-iphone-wallpaper-ilikewallpaper_com_200.jpg',
                  //   height: double.maxFinite,
                  //   width: double.maxFinite,
                  //   fit: BoxFit.cover,
                  // ),
                  ListView.builder(
                    itemBuilder: (context, index) {
                      var news = wordpressFeed[index];
                      // print('post id = ' + news['post_id'].toString());
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

                      DateTime realtime =
                          dateTime.add(Duration(hours: zonetime));
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

                      // print(news['isread'].toString() + 'isread');
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
                              onTap: () {},
                              // print(news['content'].toString());
                              // print(news['post_id']);
                              // Navigator.push(context, MaterialPageRoute(
                              //   builder: (BuildContext context) {
                              //     return NewsDetails(
                              //       id: news['id'],
                              //       teamName: widget.teamName,
                              //       content: news['content'].toString(),
                              //         desc: news['desc'].toString(),
                              //         imageurl: news['imageurl'].toString(),
                              //         pupdate: realtime.toString(),

                              //         // pupdate: news['pubdate'].toString(),
                              //         title: news['title'].toString(),
                              //         site: news['link'].toString(),
                              //         siteName: news['sitename'].toString(),
                              //         postID: news['post_id'].toString(),
                              //       );
                              //     },
                              //   ));
                              // },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    bottom: 6, right: 6, left: 6),
                                child: GlassContainer.frostedGlass(
                                  height: 270,
                                  width: 350,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            Image.network(
                                              news['imageurl'].toString(),
                                              fit: BoxFit.cover,
                                              width: double.maxFinite,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .22,
                                              filterQuality: FilterQuality.high,
                                            ),
                                            Positioned(
                                              left: -3,
                                              top: 2,
                                              child: Transform.rotate(
                                                angle: -.3,
                                                child:
                                                    GlassContainer.clearGlass(
                                                  height: 50,
                                                  width: 60,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.comment,
                                                          size: 30,
                                                          color: Colors.red,
                                                        ),
                                                        Text(
                                                          news['count']
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 25),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
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
                                                Text(
                                                  timeName,
                                                  style: TextStyle(
                                                      decorationColor: sa4,
                                                      color: sa3,
                                                      decorationThickness: 3,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontFamily: 'Cairo',
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                Text(diffDt.toString()),
                                                Text(
                                                  ' ‏منذ',
                                                  style: TextStyle(
                                                      decorationColor: sa4,
                                                      color: sa3,
                                                      decorationThickness: 3,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontFamily: 'Cairo',
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      siteName,
                                                      softWrap: true,
                                                      style: TextStyle(
                                                          decorationColor: sa4,
                                                          color: sa3,
                                                          decorationThickness:
                                                              3,
                                                          fontStyle:
                                                              FontStyle.normal,
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
                                                          decorationThickness:
                                                              3,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontFamily: 'Cairo',
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Image.network(
                                                  siteImage,
                                                  width: 60,
                                                  height: 50,
                                                  // color: sa4,
                                                  fit: BoxFit.scaleDown,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
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
                                // ),
                              ))
                        ],
                      );
                    },
                    itemCount: wordpressFeed.length,
                  ),
                ],
              ),
      ),

      // Center(
      //   child: isloading
      //       ? const CircularProgressIndicator()
      //       : ListView.builder(
      //           itemCount: wordpressFeed.length,
      //           itemBuilder: (BuildContext context, int index) {
      //             var res = wordpressFeed[index];
      //             return Card(
      //               child: Text(res['title']),
      //             );
      //           },
      //         ),
      // ),
    );
  }
}
