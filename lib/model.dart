class Item {
  final String id;
  final String item;

  Item({required this.id, required this.item});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(id: json['_id'], item: json['item']);
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'item': item,
    };
  }
}
