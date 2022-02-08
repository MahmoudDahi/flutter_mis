import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'
    show AppLocalizations;
import 'package:flutter_mis/providers/expenses.dart';
import 'package:intl/intl.dart';

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class AddExpensesDialog extends StatefulWidget {
  final String workOrderId;
  final BuildContext ctx;

  AddExpensesDialog(this.ctx, this.workOrderId);

  @override
  _AddExpensesDialogState createState() => _AddExpensesDialogState();
}

class _AddExpensesDialogState extends State<AddExpensesDialog> {
  DateTime _selectedDate;
  String _description;
  double _cost;
  final formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  bool _isLoading = false;

  Future<void> _showDataPickerAndSetDate() async {
    final newSelectDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (newSelectDate != null) {
      _selectedDate = newSelectDate;
      _dateController.text = DateFormat.yMMMd().format(_selectedDate);
    }
  }

  Future<void> _submitNewExpenses() async {
    final valid = formKey.currentState.validate();
    if (valid) {
      setState(() {
        _isLoading = true;
      });
      formKey.currentState.save();
      try {
        await Expenses().addNewExpenses(
          widget.workOrderId,
          _description,
          _cost,
          _selectedDate,
        );
        ScaffoldMessenger.of(widget.ctx).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(widget.ctx).new_expenses_add),
          backgroundColor: Colors.green[500],
        ));

        Navigator.of(widget.ctx).pop();
      } catch (error) {
        print('add expenses ${error.toString()}');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(16),
      titlePadding: const EdgeInsets.all(8),
      title: Text(AppLocalizations.of(context).add_expenses),
      children: [
        Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  label: Text(AppLocalizations.of(context).description),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value.isEmpty)
                    return AppLocalizations.of(context).error_description;
                  return null;
                },
                onSaved: (value) {
                  _description = value.trim();
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  label: Text(AppLocalizations.of(context).cost),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final validRegex = RegExp(r'^[0-9.]+$');
                  if (value.isEmpty || !validRegex.hasMatch(value))
                    return AppLocalizations.of(context).error_cost;

                  return null;
                },
                onSaved: (value) {
                  _cost = double.tryParse(value.trim());
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  label: Text(AppLocalizations.of(context).choose_date),
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value.isEmpty)
                    return AppLocalizations.of(context).error_date;
                  return null;
                },
                controller: _dateController,
                focusNode: AlwaysDisabledFocusNode(),
                onTap: _showDataPickerAndSetDate,
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _submitNewExpenses,
                    child:_isLoading? Center(child: CircularProgressIndicator(color: Colors.white,)) : Text(AppLocalizations.of(context).confirm),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                    ),
                    onPressed: () {
                      Navigator.of(widget.ctx).pop();
                    },
                    child: Text(AppLocalizations.of(context).cancel),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
