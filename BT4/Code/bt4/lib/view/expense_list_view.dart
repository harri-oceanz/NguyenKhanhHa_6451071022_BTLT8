import 'package:bt4/controller/category_controller.dart';
import 'package:bt4/controller/expense_controller.dart';
import 'package:bt4/data/models/category.dart';
import 'package:bt4/data/models/expense.dart';
import 'package:bt4/view/expense_form_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExpenseListView extends StatefulWidget {
  const ExpenseListView({super.key});

  @override
  State<ExpenseListView> createState() => _ExpenseListViewState();
}

class _ExpenseListViewState extends State<ExpenseListView> {
  final controller = ExpenseController();
  List<Expense> expenses = [];
  List<Map<String, dynamic>> summary = [];

  @override
  void initState() {
    super.initState();
    initData();
  }
  void initData() async {
    await seedCategories(); 
    await load();          
  }
  Future<void> seedCategories() async {
    final list = await CategoryController().getAll();

    if (list.isEmpty) {
      await CategoryController().add(Category(name: "Ăn uống"));
      await CategoryController().add(Category(name: "Di chuyển"));
      await CategoryController().add(Category(name: "Giải trí"));
      await CategoryController().add(Category(name: "Mua sắm"));
      await CategoryController().add(Category(name: "Khác"));
    }
  }

  Future<void> load() async {
    final data = await controller.getAll();
    final sum = await controller.getSummary();

    setState(() {
      expenses = data;
      summary = sum;
    });
  }

  void goToForm({Expense? e}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ExpenseFormView(expense: e)),
    );
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Expenses", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), backgroundColor: Colors.teal, actions: [Padding(padding: const EdgeInsets.all(16), child: Text("6451071022", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),)],),
      body: Column(
        children: [
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: summary.map((s) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text(s['name']),
                        Text("${s['total']}"),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          /// LIST
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (_, i) {
                final e = expenses[i];
                return Card(
                  child: ListTile(
                    title: Text("${e.amount} VND"),
                    subtitle: Text("${e.note} - ${e.categoryName}"),
                    onTap: () => goToForm(e: e),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await controller.delete(e.id!);
                        load();
                      },
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => goToForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}