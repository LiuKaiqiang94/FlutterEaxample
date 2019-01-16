import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class I18nRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _getLocale() {
      Locale locale = Localizations.localeOf(context);
      Fluttertoast.showToast(
          msg:
              "countryCode:${locale.countryCode}--languageCode:${locale.languageCode}");
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("国际化"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            RaisedButton(
              child: Text("获取当前区域"),
              onPressed: _getLocale,
            ),
          ],
        ),
      ),
    );
  }
}
