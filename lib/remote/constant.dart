import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum FilterBy {
  none,
  Status,
  Priority,
  Location,
  Client,
  Employee,
  RangeDate,
  Unassigned
}

class Constant {
  static const Api = 'http://192.168.1.130:8080/MISApi/api/v1';
  static const DateFormatAPI = "yyyy-MM-dd'T'HH:mm:ss";
  static const String MIME_WORD =
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
  static const String MIME_POWER_POINT =
      "application/vnd.openxmlformats-officedocument.presentationml.presentation";
  static const String MIME_EXCEL =
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
  static const String MIME_PDF = "application/pdf";

  static Color setColor(int statusId) {
    if (statusId == 10) return Colors.grey;
    if (statusId == 20) return Colors.lightBlue;
    if (statusId == 30) return Colors.orange;
    return Colors.green[700];
  }

  static String setIconMimeType(String mimeType) {
    if (mimeType.contains('image')) return 'assets/images/ic_picture.PNG';
    switch (mimeType) {
      case MIME_PDF:
        return 'assets/images/ic_pdf.PNG';
       case MIME_WORD:
        return 'assets/images/ic_word.PNG';
        case MIME_EXCEL:
        return 'assets/images/ic_excel.PNG';
        case MIME_POWER_POINT:
        return 'assets/images/ic_powerpoint.PNG'; 
         default:
        return 'assets/images/ic_picture.PNG';
    }
  }

  static Widget loadingProgress(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
            ),
            child: Text(
              AppLocalizations.of(context).please_wait,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
