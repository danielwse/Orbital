import 'dart:async';
import 'package:DaySpend/expenses/expense_db.dart';
import 'package:DaySpend/expenses/expense_model.dart';

class VariablesBloc {
  String maxSpend = "Not Set";
  VariablesBloc() {
    getVariables();
  }
  final _variableController =     StreamController<List<Variable>>.broadcast();
  get variables => _variableController.stream;

  dispose() {
    _variableController.close();
  }

  updateMaxSpend(String maxSpend) {   
    DBProvider.db.updateMaxSpend(maxSpend);
    getVariables();
  }

  getMaxSpend() {
    DBProvider.db.getMaxSpend();
    getVariables();
  }





  getVariables() async {
    _variableController.sink.add(await DBProvider.db.getAllVariables());
  }
}
