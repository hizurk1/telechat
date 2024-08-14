enum MessageEnum {
  text,
  image,
  audio,
  video,
  gif,
  call;

  static MessageEnum fromString(String type) {
    return switch (type) {
      "text" => MessageEnum.text,
      "image" => MessageEnum.image,
      "audio" => MessageEnum.audio,
      "video" => MessageEnum.video,
      "gif" => MessageEnum.gif,
      "call" => MessageEnum.call,
      String() => MessageEnum.text,
    };
  }

  String get message {
    return switch (this) {
      MessageEnum.text => "Message",
      MessageEnum.image => "📷 Photo",
      MessageEnum.audio => "🔉 Audio",
      MessageEnum.video => "📽️ Video",
      MessageEnum.gif => "✨ GIF",
      MessageEnum.call => "📞 Call",
    };
  }
}
