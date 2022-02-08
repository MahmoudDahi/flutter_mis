import 'package:flutter/material.dart';
import 'package:flutter_mis/models/attachment_storage.dart';
import 'package:provider/provider.dart';

import 'package:flutter_mis/providers/attachments.dart';
import 'package:flutter_mis/remote/constant.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AttachmentItem extends StatelessWidget {
  final int id;
  AttachmentItem(this.id);

  void _openAttachment(BuildContext context, Attachment attachment) async {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    try {
      await AttachmentStorage().openFile(
        context: context,
        attachId: id,
        name: attachment.name,
        extention: '.${attachment.attachmentUrl.split('.').last}',
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).download_failed,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'arabicFont',
            ),
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Attachments>(
      builder: (context, data, _) {
        final attachment = data.findByID(id);
        return InkWell(
          onTap: () => _openAttachment(context, attachment),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: Card(
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      Constant.setIconMimeType(attachment.mimeType),
                      height: 30,
                      width: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(attachment.name,
                              style: Theme.of(context).textTheme.headline6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                attachment.typeTitle,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              if (attachment.clientName != null)
                                Text(
                                  ' | ${attachment.clientName}',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                            ],
                          ),
                          if (attachment.comment != null)
                            Text(
                              attachment.comment,
                              style: TextStyle(color: Colors.grey),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.download,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
