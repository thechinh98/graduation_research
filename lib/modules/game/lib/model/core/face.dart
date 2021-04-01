import 'package:game/model/core/question.dart';
import 'package:game/utils/utils.dart';

class Face {
  String? id;
  String? content;
  String? image;
  String? sound;
  String? hint;

  Face({this.id, this.content, this.image, this.sound, this.hint});

  Face.fromQuestion(Question question) {
    id = question.id;
    content = question.content;
    image = (question.image != null && question.image!.isNotEmpty)
        ? ClientUtils.checkUrl(question.image)
        : null;
    sound = question.sound;
  }

  Face.fromImageUrl({String? imgUrl, String? idImage}) {
    image = (imgUrl != null && imgUrl.isNotEmpty)
        ? ClientUtils.checkUrl(imgUrl)
        : null;
    id = idImage ?? "-1";
  }
}
