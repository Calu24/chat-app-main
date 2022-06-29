import 'dart:convert';

List<Chat> chatFromJson(String str) => List<Chat>.from(json.decode(str).map((x) => Chat.fromJson(x)));

String chatToJson(List<Chat> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Chat {
    Chat({
        required this.text,
        required this.uid,
    });

    String text;
    String uid;

    factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        text: json["text"],
        uid: json["uid"],
    );

    Map<String, dynamic> toJson() => {
        "text": text,
        "uid": uid,
    };
}