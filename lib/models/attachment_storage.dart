import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_mis/providers/attachments.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../remote/constant.dart';

class AttachmentStorage {
  Future<String> getFilePath(String name, String extention) async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String filePath = '${appDocumentsDirectory.path}/$name$extention';

    return filePath;
  }

  Future<void> openFile(
      {BuildContext context,
      int attachId,
      String name,
      String extention}) async {
    final result = await OpenFile.open(await getFilePath(name, extention));
    if (result.type != ResultType.done)
      try {
        await saveInStorage(context, attachId);
      } catch (error) {
        throw error;
      }
  }

  Future<void> saveInStorage(
    BuildContext context,
    int attachId,
  ) async {
    try {
      final attach = await showDialog<DownloadAttachmentItem>(
          barrierDismissible: false,
          useRootNavigator: false,
          useSafeArea: true,
          context: context,
          builder: (ctx) => SimpleDialog(
                children: [
                  FutureBuilder<DownloadAttachmentItem>(
                      future: Provider.of<Attachments>(context, listen: false)
                          .downloadAttatchment(attachId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done)
                          Navigator.of(ctx).pop(snapshot.data);

                        return Constant.loadingProgress(context);
                      }),
                ],
              ));
      Uint8List bytes = base64.decode(attach.data);
      File file = File(await getFilePath(attach.name, attach.extension));
      await file.writeAsBytes(bytes);
      openFile(name: attach.name, extention: attach.extension);
    } catch (error) {
      throw error;
    }
  }

  // Future<bool> _checkPermission() async {
  //   final status = await Permission.storage.status;
  //   if (status.isGranted) return true;
  //   // You can can also directly ask the permission about its status.
  //   if (await Permission.storage.isRestricted) return true;
  //   return false;
  // }
}
