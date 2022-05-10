import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:news/constant/colors.dart';
import 'package:news/constant/global.dart';
import 'package:news/constant/htmlstyle.dart';
import 'package:news/constant/style.dart';
import 'package:news/constant/url.dart';
import 'package:news/provider/provider.dart';
import 'package:share/share.dart';

class NewsDetails extends StatefulWidget {
  final String pupdate,
      title,
      desc,
      content,
      imageurl,
      site,
      siteName,
      teamName,
      postID;
  final int id;
  const NewsDetails({
    Key? key,
    required this.pupdate,
    required this.title,
    required this.desc,
    required this.siteName,
    required this.content,
    required this.imageurl,
    required this.site,
    required this.id,
    required this.postID,
    required this.teamName,
  }) : super(key: key);

  @override
  _NewsDetailsState createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  TextEditingController comment = TextEditingController();
  // AdmobBannerSize bannerSize;
  // AdmobInterstitial interstitialAd;
  // @override
  // void initState() {
  //   bannerSize = AdmobBannerSize.LARGE_BANNER;
  //   interstitialAd = AdmobInterstitial(
  //     adUnitId: getInterstitialAdUnitId(),
  //     listener: (AdmobAdEvent event, Map<String, dynamic> args) {
  //       if (event == AdmobAdEvent.closed) interstitialAd.load();
  //     },
  //   );
  //   interstitialAd.load();
  //   super.initState();
  // }

  @override
  void dispose() {
    // interstitialAd.dispose();
//    rewardAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(
      widget.pupdate,
    );
    // // String dateformat = DateFormat.yMMMMEEEEd().format(dateTime);
    // print(widget.postID);
    String dateformat = DateFormat("MM/dd hh:mm a").format(dateTime);
    double fSize = 22;
    return Scaffold(
      backgroundColor: nb4.withOpacity(.3),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height * .33,
            child: Stack(
              children: [
                Image.network(
                  widget.imageurl,
                  // width: MediaQuery.of(context).size.width * .98,
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height * .33,
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.cover,
                  isAntiAlias: true,
                  gaplessPlayback: true,
                  matchTextDirection: true,
                  semanticLabel: 'gg',
                  // centerSlice: Rect.fromCenter(
                  //   height: 100,
                  //   width: 200,
                  //   center: Offset.zero,
                  // ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24, bottom: 15),
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Image.asset(
                        'assets/golenci.png',
                        width: 77,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, right: 1),
                  child: Container(
                    height: 50,
                    color: Colors.transparent,
                    child: GlassContainer.clearGlass(
                      height: 50,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 30,
                              color: white12Color,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.font_download_outlined,
                                  size: 30,
                                  color: white12Color,
                                ),
                                onPressed: () {
                                  setState(() {
                                    fSize = 30.0;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.open_in_browser,
                                  color: white12Color,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return HtmlStyle(
                                          datahtml: widget.content,
                                        );
                                        // HtmlPageSourceView(widget: widget);
                                      },
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.star_border_outlined,
                                  color: white12Color,
                                  size: 30,
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.ios_share,
                                  color: white12Color,
                                  size: 30,
                                ),
                                onPressed: () {
                                  String exrpt = parse((widget.desc).toString())
                                      .documentElement!
                                      .text;
                                  Share.share(
                                    "${widget.title}"
                                    "\n"
                                    "$exrpt"
                                    "\n"
                                    "\n"
                                    "‏شاهد المزيد من تطبيقاتنا  https://play.google.com/store/apps/details?id=$appPlayStoreId ",
                                    subject: parse((widget.title).toString())
                                        .documentElement!
                                        .text,
                                  );
                                  print('share pressd');
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                parse((widget.title).toString()).documentElement!.text,
                style: TextStyle(
                  color: sa1,
                  decorationColor: sa4,
                  decorationThickness: 3,
                  fontStyle: FontStyle.normal,
                  fontFamily: 'NizarBBCKurdish',
                  fontWeight: FontWeight.bold,
                  fontSize: fSize,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                softWrap: true,
              ),
            ),
          ),
          // Container(
          //   child: AdmobBanner(
          //     adUnitId: getBannerAdUnitId(),
          //     adSize: bannerSize,
          //     listener: (AdmobAdEvent event, Map<String, dynamic> args) {
          //       // AdmobAdEvent.loaded;
          //       // AdmobAdEvent.opened;

          //       // handleEvent(event, args, 'Banner');
          //     },
          //   ),
          // ),
          Text(
            dateformat,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w400,
              fontFamily: 'Cairo',
            ),
            textAlign: TextAlign.right,
            softWrap: true,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    parse((widget.content).toString()).documentElement!.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'NizarBBCKurdish',
                    ),
                    textAlign: TextAlign.right,
                    // textDirection: TextDirection.RTL,
                    softWrap: true,
                  ),
                  // height: 560,
                  //     child: Html(
                  //       data: widget.content,
                  //       shrinkWrap: true,
                  //       // onLinkTap: (u) {
                  //       //   Navigator.push(
                  //       //       context,
                  //       //       MaterialPageRoute(
                  //       //         builder: (context) => WebScafoold(
                  //       //           url: u,
                  //       //         ),
                  //       //       ));
                  //       // },
                  //       // onImageTap: (u) {
                  //       //   Navigator.push(
                  //       //       context,
                  //       //       MaterialPageRoute(
                  //       //         builder: (context) => Scaffold(
                  //       //           body: Center(
                  //       //             child: Image.network(u),
                  //       //           ),
                  //       //         ),
                  //       //       ));
                  //       // },
                  //       style: {
                  //         "html": Style(
                  //           padding: EdgeInsets.all(8),
                  //           lineHeight: LineHeight.number(1.5),
                  //           backgroundColor: Colors.transparent,
                  //           alignment: Alignment.center,
                  //           // direction: TextDirection.rtl,
                  //           fontSize: FontSize.large,
                  //           margin: EdgeInsets.all(8),
                  //           markerContent: 'Golenci',
                  //           color: Colors.white,
                  //           fontStyle: FontStyle.normal,
                  //           display: Display.INLINE_BLOCK,
                  //           textAlign: TextAlign.right,
                  //           textDecorationThickness: 1,
                  //           verticalAlign: VerticalAlign.SUPER,
                  //           whiteSpace: WhiteSpace.NORMAL,
                  //           wordSpacing: 1.5,
                  //           textDecorationStyle: TextDecorationStyle.dashed,
                  //           border: Border.all(
                  //             color: white12Color,
                  //             style: BorderStyle.solid,
                  //             width: 3,
                  //           ),
                  //           fontWeight: FontWeight.bold,
                  //           after: 'Golenci',
                  //           textDecoration: TextDecoration.lineThrough,
                  //           textDecorationColor: Colors.greenAccent,
                  //           fontFamily: 'Cairo',
                  //         ),
                  //       },
                  //     ),
                ),

                // HtmlStyle(
                //   datahtml: widget.wppost['content']['rendered'],
                // ),
                ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     // ignore: unnecessary_new
                    //     new MaterialPageRoute(
                    //       builder: (context) => null(
                    //         url: widget.site,
                    //       ),
                    //     ));
                    // postNewsAsProduct(
                    //   widget.wppost['title']['rendered'],
                    //   widget.wppost['content']['rendered'],
                    //   widget.imageurl,
                    // );
                  },
                  child: const Text('‏‏قراءة المقال من المصدر'),
                ),
              ],
            )),
          ),
        ]),
      ),
      bottomNavigationBar: GlassContainer.frostedGlass(
          width: MediaQuery.of(context).size.width,
          height: 50,
          // color: nb1,
          child: Row(
            children: [
              IconButton(
                onPressed: () async {
                  List commentList = [];
                  bool isloading = true;
                  var res = await http.post(Uri.parse(spornewsUrl), body: {
                    'action': 'GET_COMMENTS',
                    'post_id': widget.postID.toString(),
                  });
                  final map = json.decode(res.body);
                  setState(() {
                    commentList = map;
                    // print(commentList);
                    isloading = false;
                  });

                  showDialog<String>(
                      context: context,
                      builder: (BuildContext ctx) => AlertDialog(
                            title: const Text('Commnets'),
                            content: Container(
                              width: 350,
                              height: 350,
                              color: const Color(0xff454667),
                              child: Center(
                                child: isloading
                                    ? const CircularProgressIndicator()
                                    : ListView.builder(
                                        itemCount: commentList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          var res = commentList[index];
                                          return Transform.rotate(
                                            angle: -.02,
                                            alignment: Alignment.center,
                                            child: Card(
                                              child: Column(
                                                children: [
                                                  Text(res['content']
                                                      .toString()),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Container(
                                                        color: news4
                                                            .withOpacity(.7),
                                                        child: Text(
                                                            res['publishing_date']
                                                                .toString()),
                                                      ),
                                                      CircleAvatar(
                                                        child: Text(
                                                            res['user_id']
                                                                .toString()),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              elevation: 4,
                                              color: nb4,
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ),
                          ));
                },
                icon: const CircleAvatar(child: Icon(Icons.show_chart)),
              ),
              GlassContainer.clearGlass(
                  height: 50,
                  width: MediaQuery.of(context).size.width * .73,
                  // color: news3,
                  child: TextFormField(
                    controller: comment,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Write Your Comments'),
                  )),
              IconButton(
                  onPressed: () async {
                    // print(widget.postID.toString());
                    await NewsProvider().postComments(
                      comment.text,
                      '1', //todo userID
                      widget.postID.toString(),
                    );
                    Fluttertoast.showToast(
                        msg: "Comment Added ",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 3,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        webShowClose: true,
                        fontSize: 16.0);
                    // NewsUserDB(widget.teamName.toString())
                    //     .update(widget.teamName, widget.id);
                  },
                  icon: const CircleAvatar(child: Icon(Icons.send))),
            ],
          )),
    );
  }
}

class HtmlScaafold extends StatelessWidget {
  const HtmlScaafold({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final NewsDetails widget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: nb1,
          centerTitle: true,
          title: Text(
            widget.title,
            style: titlestyle,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
          child: SizedBox(
            height: double.maxFinite,
            child: SingleChildScrollView(
              child: Html(
                data: widget.content,
                onImageTap: null,
                onLinkTap: null,
                // datahtml: widget.content,
                shrinkWrap: true,
                style: {
                  "html": Style(
                    padding: const EdgeInsets.all(8),
                    lineHeight: LineHeight.number(1.5),
                    backgroundColor: Colors.transparent,
                    alignment: Alignment.center,
                    // direction: TextDirection.rtl,
                    fontSize: FontSize.large,
                    margin: const EdgeInsets.all(8),
                    markerContent: Text('Golenci'),
                    color: Colors.white,
                    fontStyle: FontStyle.normal,
                    display: Display.INLINE_BLOCK,
                    textAlign: TextAlign.right,
                    textDecorationThickness: 1,
                    verticalAlign: VerticalAlign.SUPER,
                    whiteSpace: WhiteSpace.NORMAL,
                    wordSpacing: 1.5,
                    textDecorationStyle: TextDecorationStyle.dashed,
                    border: Border.all(
                      color: white12Color,
                      style: BorderStyle.solid,
                      width: 3,
                    ),
                    fontWeight: FontWeight.bold,
                    after: 'BeMalab',
                    textDecoration: TextDecoration.lineThrough,
                    textDecorationColor: Colors.greenAccent,
                    fontFamily: 'Cairo',
                  ),
                },
              ),
            ),
          ),
        )
        // Text('d'),

        );
  }
}
