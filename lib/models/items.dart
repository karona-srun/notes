class Item {
  String? type;
  String? category;
  String? amount;
  String? pickUpDate;
  String? remark;

  Item({this.type, this.category, this.amount, this.pickUpDate, this.remark});

  factory Item.fromJson(Map<String, dynamic> json) => Item(
      type: json['type'],
      category: json['category'],
      amount: json['amount'],
      pickUpDate: json['pickUpDate'],
      remark: json['remark']);

  Map<String, dynamic> toJson() => {
        "type": type,
        "category": category,
        "amount": amount,
        "pickUpDate": pickUpDate,
        "remark": remark,
      };
}
