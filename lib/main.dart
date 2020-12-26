import 'package:flutter/material.dart';
import 'pages/homepage.dart';
import 'pages/generatepage.dart';
import 'package:flutter/rendering.dart';
import 'pages/favoritepage.dart';
import 'package:http/http.dart' as http;
import "dart:convert";
import 'model/passlist.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintPointersEnabled = true;
  return runApp(MyApp());
}

class MyApp extends StatefulWidget {
  State createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<PassList> _passList = [];

  void _addPassList(String passList) {
    final Map<String, dynamic> psslstUp = {"pass": passList};
    http
        .post(
            "https://pass-generator-cfa32-default-rtdb.firebaseio.com/password.json",
            body: json.encode(psslstUp))
        .then((http.Response response) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final PassList psslst =
          PassList(id: responseData["name"], text: passList);
      _passList.add(psslst);
    });
    setState(() {});
  }

  void _deletePass(int index) {
    setState(() {
      _passList.removeAt(index);
    });
  }

  @override
  Widget build(context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.orange[400],
          fontFamily: 'Gemunu Libre',
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
            bodyText2: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
        routes: {
          "/": (BuildContext ctx) => HomePage(),
          "/generate": (BuildContext ctx) => GeneratePage(_addPassList),
          "/favorite": (BuildContext ctx) =>
              FavoritePage(_passList, _deletePass),
        });
  }
}
