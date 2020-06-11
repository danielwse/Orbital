//contains models for database tables

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
  int id;
  String description;
  String category;
  double amount;
  String date;

  Expense({
    this.id,
    this.description,
    this.category,
    this.amount,
    this.date,
  });

  factory Expense.fromMap(Map<String, dynamic> json) => new Expense(
        id: json["id"],
        description: json["description"],
        category: json["category"],
        amount: json["amount"],
        date: json["date"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "description": description,
        "category": category,
        "amount": amount,
        "date": date,
      };
}

class Variable {
  String type;
  String value;

  Variable({
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

class Categories {
  int id;
  String name;
  double amount;
  double budget;

  Categories({this.id, this.name, this.amount, this.budget});

  factory Categories.fromMap(Map<String, dynamic> json) => new Categories(
        id: json["id"],
        name: json["name"],
        amount: json["amount"],
        budget: json["budget"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "amount": amount,
        "budget": budget,
      };
}
