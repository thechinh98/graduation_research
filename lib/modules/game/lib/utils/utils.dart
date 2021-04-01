import 'package:game/utils/constant.dart';

class ClientUtils {
  factory ClientUtils() {
    if (_instance == null) {
      _instance = ClientUtils._getInstance();
    }
    return _instance!;
  }

  static ClientUtils? _instance;

  ClientUtils._getInstance();

  static String? checkUrl(String? content) {
    if (content == null || content.isEmpty) {
      return null;
    } else if (content.startsWith("http")) {
      return content;
    } else {
      if (content.startsWith("/")) {
        return GOOGLE_CLOUD_STORAGE_URL + content;
      } else {
        return GOOGLE_CLOUD_STORAGE_URL + "/" + content;
      }
    }
  }

  static String replaceQuestionContent(String content) {
    String url = content
        .replaceAll(
            "@PS@", "<img style={width:'100px', object-fit: contain} src=\"")
        .replaceAll("@PE@", "\"/>");
    return url;
  }
}
