//CONTAINS ALL THE BLoCS
import 'dart:async';
import 'package:DaySpend/database/db_models.dart';
import 'package:DaySpend/database/categories_db.dart';
import 'package:DaySpend/database/variables_db.dart';
import 'package:DaySpend/database/expenses_db.dart';
import 'package:DaySpend/planner/task.dart';

import 'allTasks_db.dart';

abstract class Bloc {
  void dispose();
}

class ExpensesBloc implements Bloc {
  final _expensesRepository = ExpensesRepository();
  final _expensesController = StreamController<List<Expense>>.broadcast();
  final CategoryBloc categoryBloc = CategoryBloc();

  get expenses => _expensesController.stream;

  ExpensesBloc() {
    getExpenses();
  }

  getExpenses() async {
    _expensesController.sink.add(await _expensesRepository.getAllExpenses());
  }

  newExpense(
      String description, String category, double amount, String date) async {
    await _expensesRepository.newExpense(description, category, amount, date);
    getExpenses();
  }

  deleteExpense(int id, double amount, String category) async {
    await _expensesRepository.deleteExpense(id, amount, category);
    getExpenses();
  }

  Future<List<Expense>> getExpensesByCategory(String category) async {
    var res = await _expensesRepository.getExpensesByCategory(category);
    getExpenses();
    return res;
  }

  changeExpenseCategory(int categoryID, int id) async {
    await _expensesRepository.changeExpenseCategory(categoryID, id);
    getExpenses();
  }

  changeDescription(String newDescription, int id) async {
    await _expensesRepository.changeDescription(newDescription, id);
    getExpenses();
  }

  changeAmount(double newAmount, int id) async {
    await _expensesRepository.changeAmount(newAmount, id);
    getExpenses();
  }

  changeDate(String newDate, int id) async {
    await _expensesRepository.changeDate(newDate, id);
    getExpenses();
  }

  dispose() {
    _expensesController.close();
  }
}

class VariablesBloc implements Bloc {
  //Get instance of the Repository
  final _variablesRepository = VariablesRepository();
  //Stream controller is the 'Admin' that manages
  //the state of our stream of data like adding
  //new data, change the state of the stream
  //and broadcast it to observers/subscribers
  final _variablesController = StreamController<List<Variable>>.broadcast();

  get variables => _variablesController.stream;

  VariablesBloc() {
    getVariables();
  }

  getVariables() async {
    //sink is a way of adding data reactively to the stream by registering
    //a new event
    _variablesController.sink.add(await _variablesRepository.getAllVariables());
  }

  Future<dynamic> getMaxSpend() async {
    var res = await _variablesRepository.getMaxSpend();
    getVariables();
    return res;
  }

  updateMaxSpend(String maximumSpend) async {
    await _variablesRepository.updateMaxSpend(maximumSpend);
    getVariables();
  }

  dispose() {
    _variablesController.close();
  }
}

class CategoryBloc implements Bloc {
  final _categoryRepository = CategoryRepository();
  final _categoryController = StreamController<List<Categories>>.broadcast();
  final _categoriesWithBudgetController =
      StreamController<Categories>.broadcast();

  get categoriesWithBudget => _categoriesWithBudgetController.stream
      .where((event) => event.budgetPercentage != "Not Set");
  get categories => _categoryController.stream;

  CategoryBloc() {
    getCategories();
  }

  getCategories() async {
    //sink is a way of adding data reactively to the stream by registering
    //a new event
    _categoryController.sink.add(await _categoryRepository.getAllCategories());
  }

  addCategory(Categories category) async {
    await _categoryRepository.newCategory(category);
    getCategories();
  }

  deleteCategory(int id) async {
    await _categoryRepository.deleteCategory(id);
    getCategories();
  }

  addAmountToCategory(double addAmount, String category) async {
    await _categoryRepository.addAmountToCategory(addAmount, category);
    getCategories();
  }

  calculateCategoryAmount(String category) async {
    await _categoryRepository.calculateCategoryAmount(category);
    getCategories();
  }

  removeAmountFromCategory(double deleteAmount, String category) async {
    await _categoryRepository.removeAmountFromCategory(deleteAmount, category);
    getCategories();
  }

  Future<List<Categories>> getAllCategories() async {
    var res = await _categoryRepository.getAllCategories();
    getCategories();
    return res;
  }

  Future<String> getCategoryColor(String categoryName) async {
    var res = await _categoryRepository.getCategoryColor(categoryName);
    getCategories();
    return res;
  }

  renameCategory(String oldName, String newName) async {
    await _categoryRepository.renameCategory(oldName, newName);
    getCategories();
  }

  Future<int> categoriesCount() async {
    var res = await _categoryRepository.categoriesCount();
    getCategories();
    return res;
  }

  Future<double> getTotalBudgets() async {
    var res = await _categoryRepository.getTotalBudgets();
    getCategories();
    return res;
  }

  changeBudget(String newBudget, int categoryID) async {
    await _categoryRepository.changeBudget(newBudget, categoryID);
    getCategories();
  }

  Future<List<String>> categoryNameList() async {
    var res = await _categoryRepository.categoryNameList();
    getCategories();
    return res;
  }

  dispose() {
    _categoryController.close();
    _categoriesWithBudgetController.close();
  }
}

class TasksBloc implements Bloc {
  final _tasksRepository = TasksRepository();
  final _tasksController = StreamController<List<Task>>.broadcast();

  get tasks => _tasksController.stream;

  TasksBloc() {
    getTasks();
  }

  getTasks() async {
    _tasksController.sink.add(await _tasksRepository.getAllTasks());
  }

  Future<int> addTaskToDatabase(Task task) async {
    var k = await _tasksRepository.newTask(task);
    getTasks();
    return k;
  }

  Future removeTaskFromDatabase(int id) async {
    await _tasksRepository.removeTask(id);
    getTasks();
  }

  updateTask(Task task, String index, String name, String time,
      String description, bool notify, DateTime dt, Duration duration) async {
    await _tasksRepository.updateTask(
        task, index, name, time, description, notify, dt, duration);
    getTasks();
  }

  rescheduleTask(Task task, DateTime dt, Duration duration) async {
    await _tasksRepository.rescheduleOverdue(task, dt, duration);
    getTasks();
  }

  Future<List<Task>> getAllTasks() async {
    var res = await _tasksRepository.getAllTasks();
    getTasks();
    return res;
  }

  toggleNotification(Task task) async {
    await _tasksRepository.toggleNotification(task);
    getTasks();
  }

  toggleComplete(Task task) async {
    await _tasksRepository.toggleComplete(task);
    getTasks();
  }

  toggleOverdue(Task task) async {
    await _tasksRepository.toggleOverdue(task);
    getTasks();
  }

  toggleArchived(Task task) async {
    await _tasksRepository.toggleArchived(task);
    getTasks();
  }

  toggleExpired(Task task) async {
    await _tasksRepository.toggleExpired(task);
    getTasks();
  }

  removeExpired() async {
    await _tasksRepository.removeExpired();
    getTasks();
  }

  dispose() {
    _tasksController.close();
  }
}
