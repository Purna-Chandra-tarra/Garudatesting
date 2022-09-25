import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showLoaderDialog(BuildContext context) {
  AlertDialog alert = const AlertDialog(
    title: Text('Loading'),
    content: CupertinoActivityIndicator(),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
