import 'dart:convert';

Expense expenseFromJson(String str) {
  final jsonData = json.decode(str);
  return Expense.fromMap(jsonData);
}

String expenseToJson(Expense data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Expense {
  String description;
  String category;
  String amount;
  String date;

  Expense({
    this.description,
    this.category,
    this.amount,
    this.date,
  });

  factory Expense.fromMap(Map<String, dynamic> json) => new Expense(
        description: json["description"],
        category: json["category"],
        amount: json["amount"],
        date: json["date"],
      );

  Map<String, dynamic> toMap() => {
        "description": description,
        "category": category,
        "amount": amount,
        "date": date,
      };
}

class Variable {
  String type;
  String value;

  Variable( {
    this.type,
    this.value,
  });

  factory Variable.fromMap(Map<String, dynamic> json) => new Variable(
        type: json["type"],
        value: json["value"],
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        "value": value,
      };
}

