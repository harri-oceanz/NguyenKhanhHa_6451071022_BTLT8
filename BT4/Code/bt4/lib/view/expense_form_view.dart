import 'package:bt4/controller/category_controller.dart';
import 'package:bt4/controller/expense_controller.dart';
import 'package:bt4/data/models/category.dart';
import 'package:bt4/data/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpenseFormView extends StatefulWidget {
  final Expense? expense;

  const ExpenseFormView({super.key, this.expense});

  @override
  State<ExpenseFormView> createState() => _ExpenseFormViewState();
}

class _ExpenseFormViewState extends State<ExpenseFormView> {
  final controller = ExpenseController();
  final categoryController = CategoryController();
  final amountCtrl = TextEditingController();
  final noteCtrl = TextEditingController();

  List<Category> categories = [];
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    loadCategories();

    if (widget.expense != null) {
      amountCtrl.text = widget.expense!.amount.toString();
      noteCtrl.text = widget.expense!.note;
      selectedCategoryId = widget.expense!.categoryId;
    }
  }

  void loadCategories() async {
    final data = await categoryController.getAll();
    setState(() => categories = data);
  }

  void save() async {
    try {
      final e = Expense(
        id: widget.expense?.id,
        amount: double.parse(amountCtrl.text),
        note: noteCtrl.text,
        categoryId: selectedCategoryId!,
      );

      if (widget.expense == null) {
        await controller.add(e);
      } else {
        await controller.update(e);
      }
      Navigator.pop(context);

    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Expense")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<int>(
              value: selectedCategoryId,
              hint: const Text("Category"),
              items: categories.map((c) {
                return DropdownMenuItem(
                  value: c.id,
                  child: Text(c.name),
                );
              }).toList(),
              onChanged: (v) => setState(() => selectedCategoryId = v),
            ),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Amount"),
            ),
            TextField(
              controller: noteCtrl,
              decoration: const InputDecoration(labelText: "Note"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: save, child: const Text("Save"))
          ],
        ),
      ),
    );
  }
}