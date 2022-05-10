import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

import 'colors.dart';

class HtmlStyle extends StatelessWidget {
  final String datahtml;

  const HtmlStyle({Key? key, required this.datahtml}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Html(
      data: datahtml,
      shrinkWrap: true,
      // onLinkTap: (url) {},
      // onImageTap: (url) {},
      style: {
        "html": Style(
          backgroundColor: Colors.transparent,
          alignment: Alignment.center,
          direction: TextDirection.rtl,
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
          // lineHeight: 3,
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
    );
  }
}
