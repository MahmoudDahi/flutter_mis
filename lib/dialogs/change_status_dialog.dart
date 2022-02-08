import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mis/providers/lookups.dart';
import 'package:flutter_mis/providers/work_orders.dart';
import 'package:provider/provider.dart';

class ChangeStatusDialog extends StatefulWidget {
  final String workOrderId;
  final BuildContext ctx;

  ChangeStatusDialog(this.ctx, this.workOrderId);

  @override
  State<ChangeStatusDialog> createState() => _ChangeStatusDialogState();
}

class _ChangeStatusDialogState extends State<ChangeStatusDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _updateStatus = false;
  int _statusId;

  Future<void> _confirmChangeStatus() async {
    bool valid = _formKey.currentState.validate();
    if (valid) {
      setState(() {
        _updateStatus = true;
      });
      try {
        await Provider.of<WorkOrders>(context, listen: false)
            .updateWorkOrderStatus(_statusId, widget.workOrderId);

        Navigator.of(widget.ctx).pop();
      } catch (error) {
        ScaffoldMessenger.of(widget.ctx).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(widget.ctx).errorColor,
          ),
        );
        setState(() {
          _updateStatus = false;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      titlePadding:const EdgeInsets.all(8),
      title: Text(AppLocalizations.of(context).change_status),
      children: [
        FutureBuilder(
            future: Provider.of<Lookups>(context).fatchAndSetStatusList(),
            builder: (ctx, futureSnap) {
              if (futureSnap.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              return Consumer<Lookups>(builder: (context, Lookups, _) {
                final statusList = Lookups.statusList;
                statusList.removeWhere((element) => element.statusId == 10);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: DropdownButtonFormField<String>(
                          key: ValueKey('drop'),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return AppLocalizations.of(context)
                                  .error_change_status;
                            return null;
                          },
                          isExpanded: true,
                          decoration:
                              InputDecoration(border: OutlineInputBorder()),
                          hint: Text(AppLocalizations.of(context).status),
                          items: statusList
                              .map((value) => DropdownMenuItem<String>(
                                    child: Text(value.statusTitle),
                                    value: value.statusId.toString(),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            _statusId = int.parse(value);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ElevatedButton(
                          onPressed: _confirmChangeStatus,
                          child: _updateStatus
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : Text(AppLocalizations.of(context).confirm),
                        ),
                      ),
                    ],
                  ),
                );
              });
            }),
      ],
    );
  }
}
