import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mis/providers/comments.dart';
import 'package:flutter_mis/providers/user.dart';
import 'package:provider/provider.dart';

class AddCommentDialog extends StatefulWidget {
  final String workOrderId;
  final BuildContext ctx;

  AddCommentDialog(this.ctx, this.workOrderId);
  @override
  _AddCommentDialogState createState() => _AddCommentDialogState();
}

class _AddCommentDialogState extends State<AddCommentDialog> {
  int employeeId;
  bool _isLoading = false;
  String _comment;
  String errorMessage;

  @override
  void initState() {
    employeeId = Provider.of<User>(context, listen: false).empolyeeID;
    super.initState();
  }

  void _submitNewComment() async {
    if (_comment == null || _comment.isEmpty) {
      setState(() {
        errorMessage = AppLocalizations.of(context).error_comment;
      });
      return;
    }
    FocusScope.of(context).unfocus();

    setState(() {
      errorMessage = null;
      _isLoading = true;
    });

    final scafolld = ScaffoldMessenger.of(widget.ctx);

    try {
      final success = await Comments()
          .addNewComment(widget.workOrderId, _comment, employeeId);
      if (success) {
        scafolld.showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(widget.ctx).new_comment_add),
            backgroundColor: Colors.green[500],
          ),
        );
        Navigator.of(widget.ctx).pop();
        return;
      }
      throw ('failed');
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      scafolld.showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Theme.of(widget.ctx).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        AppLocalizations.of(context).add_comments,
        style: Theme.of(context).textTheme.headline6,
      ),
      titlePadding: const EdgeInsets.all(8),
      contentPadding: const EdgeInsets.all(16),
      children: [
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            label: Text(AppLocalizations.of(context).comment),
            errorText: errorMessage,
          ),
          onChanged: (value) {
            _comment = value.trim();
          },
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: _submitNewComment,
              child: _isLoading
                  ? Center(
                      child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ))
                  : Text(AppLocalizations.of(context).confirm),
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
    );
  }
}
