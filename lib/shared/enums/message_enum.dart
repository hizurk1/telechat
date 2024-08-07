enum MessageEnum {
  text,
  image,
  audio,
  video,
  gif;

  static MessageEnum fromString(String type) {
    return switch (type) {
      "text" => MessageEnum.text,
      "image" => MessageEnum.image,
      "audio" => MessageEnum.audio,
      "video" => MessageEnum.video,
      "gif" => MessageEnum.gif,
      String() => MessageEnum.text,
    };
  }
}
