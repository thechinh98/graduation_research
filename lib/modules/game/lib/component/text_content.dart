import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:game/component/image_zoom.dart';
import 'package:game/model/core/face.dart';
import 'package:game/utils/utils.dart';

import 'package:flutter/material.dart';

class TextContent extends StatefulWidget {
  final Face face;
  final TextStyle? textStyle;
  final bool? imageInChoice;

  TextContent({required this.face, this.textStyle, this.imageInChoice});

  @override
  _TextContentState createState() => _TextContentState();
}

class _TextContentState extends State<TextContent> {
  Face get face => widget.face;

  TextStyle get textStyle => widget.textStyle ?? TextStyle();

  bool get imageInChoice => widget.imageInChoice ?? false;

  @override
  Widget build(BuildContext context) {
    return renderText();
  }

  renderText() {
    return _htmlWidget(face);
  }

  _htmlWidget(Face face) {
    face.content = ClientUtils.replaceQuestionContent(face.content!);
    return HtmlWidget(
      face.content!,
      textStyle: textStyle,

      // ignore: missing_return
      customWidgetBuilder: (element) {
        if (element.toString().contains("img")) {
          String image = element.attributes['src']!;
          Face face2 = new Face.fromImageUrl(imgUrl: image, idImage: face.id);
          return Column(
            children: [
              InkWell(
                onTap: !imageInChoice
                    ? () {
                        showImageZoom(context, face2.image!);
                      }
                    : null,
                child: LimitedBox(
                  maxHeight: imageInChoice
                      ? MediaQuery.of(context).size.height * .15
                      : MediaQuery.of(context).size.height * .25,
                  child: Container(
                    width: double.infinity - 50,
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: face2.image!,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        width: MediaQuery.of(context).size.width * .98,
                        fit: BoxFit.contain,
                        errorWidget: (context, url, error) => Center(
                          child: Text("You are offline"),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  void showImageZoom(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: false,
        pageBuilder: (BuildContext context, _, __) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: ImageZoomWidget(imageUrl: imageUrl, questionId: "xxx"),
          );
        },
      ),
    );
  }
}
