import 'items.dart';

class Notes {
  String? id;
  // List<Item> items;

  Notes({required this.id});

  factory Notes.fromJson(Map<String, dynamic> json) => Notes(
    id: json["id"]
    // items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    // "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}
