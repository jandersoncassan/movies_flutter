
import 'package:flutter/material.dart';

Future push(BuildContext context, Widget page) {
  return Navigator.push(context, MaterialPageRoute(builder: (context){
    return page;
  }));
}

Future pushReplacement(BuildContext context, Widget page) {
  return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
    return page;
  }));
}

void pop<T extends Object>(context, [ T result ]) {
   Navigator.pop(context, result);
}