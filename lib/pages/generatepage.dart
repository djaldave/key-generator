import 'package:flutter/material.dart';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:clipboard/clipboard.dart';

class GeneratePage extends StatefulWidget {
  final Function addPassList;
  GeneratePage(this.addPassList);
  State createState() {
    return _GeneratePageState();
  }
}

class _GeneratePageState extends State<GeneratePage> {
  Random rnd = Random();
  bool _lowercase = true;
  bool _uppercase = true;
  bool _digits = true;
  bool _characters = true;
  double _currentSliderValue = 12;
  String outputGenerated = "";
  @override
  build(context) {
    return Scaffold(
      backgroundColor: Colors.orange[300],
      appBar: AppBar(
        title: Text("KeyMate", style: Theme.of(context).textTheme.headline1),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/favorite");
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/");
            },
          ),
        ],
        leading: IconButton(
          icon: Image.asset('assets/keygif2.gif'),
          onPressed: null,
        ),
      ),
      body: Builder(builder: (BuildContext context1) {
        return Card(
            margin: EdgeInsets.all(10),
            elevation: 3,
            child: Container(
              width: double.infinity,
              decoration: boxDecoration(),
              child: listView(context1),
            ));
      }),
    );
  }

  //methods..

  String getRandomString(int length, var chars) =>
      String.fromCharCodes(Iterable.generate(
          length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));

  BoxDecoration boxDecoration() {
    return BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
          Colors.orange[100],
          Colors.orange[300],
          Colors.orange[900]
        ]));
  }

  ListView listView(context1) {
    return ListView(
      children: [
        Card(
          color: Colors.orange[300],
          child: CheckboxListTile(
            title:
                Text('Lowercase', style: Theme.of(context).textTheme.bodyText2),
            value: _lowercase,
            activeColor: Colors.deepOrange,
            onChanged: (bool value) {
              setState(() {
                _lowercase = value;
              });
            },
          ),
        ),
        Card(
          color: Colors.orange[300],
          child: CheckboxListTile(
            title:
                Text('Uppercase', style: Theme.of(context).textTheme.bodyText2),
            value: _uppercase,
            activeColor: Colors.deepOrange,
            onChanged: (bool value) {
              setState(() {
                _uppercase = value;
              });
            },
          ),
        ),
        Card(
          color: Colors.orange[300],
          child: CheckboxListTile(
            title: Text('Digits', style: Theme.of(context).textTheme.bodyText2),
            value: _digits,
            activeColor: Colors.deepOrange,
            onChanged: (bool value) {
              setState(() {
                _digits = value;
              });
            },
          ),
        ),
        Card(
          color: Colors.orange[300],
          child: CheckboxListTile(
            title: Text('Special Characters',
                style: Theme.of(context).textTheme.bodyText2),
            value: _characters,
            activeColor: Colors.deepOrange,
            onChanged: (bool value) {
              setState(() {
                _characters = value;
              });
            },
          ),
        ),
        Card(
          color: Colors.orange[300],
          child: ListTile(
            title: Row(children: [
              Text("Length", style: Theme.of(context).textTheme.bodyText2),
              Slider(
                value: _currentSliderValue,
                min: 12,
                max: 64,
                divisions: 64,
                activeColor: Colors.deepOrange,
                label: _currentSliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue = value;
                  });
                },
              ),
            ]),
            trailing: Container(
                width: 35,
                height: 30,
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  border: Border.fromBorderSide(
                      BorderSide(color: Colors.deepOrange, width: 2)),
                ),
                child: Text(
                  ' ${_currentSliderValue.round()} ',
                  style: Theme.of(context).textTheme.bodyText2,
                )),
          ),
        ),
        Container(
            margin: EdgeInsets.only(top: 35),
            child: Card(
                elevation: 5,
                color: Colors.orange[300],
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(
                        margin: EdgeInsets.only(top: 20, bottom: 10),
                        width: 200,
                        height: 40,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.fromBorderSide(
                              BorderSide(color: Colors.black, width: 2)),
                        ),
                        child: AutoSizeText(
                          outputGenerated,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 30.0),
                          maxLines: 2,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.content_copy, size: 40),
                        color: Colors.deepOrange,
                        onPressed: () {
                          if (outputGenerated != "") {
                            FlutterClipboard.copy(outputGenerated)
                                .then((value) {
                              Scaffold.of(context1).hideCurrentSnackBar();
                              Scaffold.of(context1).showSnackBar(SnackBar(
                                content: Text(
                                  "COPIED",
                                ),
                                duration: Duration(seconds: 2),
                              ));
                            });
                          } else {
                            showDialog<Null>(
                                context: context1,
                                builder: (ctx) => AlertDialog(
                                      title: Text("An error occured!"),
                                      content:
                                          Text("Please Generate Password."),
                                      actions: [
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Text("Okay"),
                                        ),
                                      ],
                                    ));
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.archive, size: 40),
                        color: Colors.red,
                        onPressed: () {
                          if (outputGenerated != "") {
                            widget.addPassList(outputGenerated);
                            Scaffold.of(context1).hideCurrentSnackBar();
                            Scaffold.of(context1).showSnackBar(SnackBar(
                              content: Text(
                                "SAVED!!",
                              ),
                              duration: Duration(seconds: 2),
                            ));
                            outputGenerated = "";
                          } else {
                            showDialog<Null>(
                                context: context1,
                                builder: (ctx) => AlertDialog(
                                      title: Text("An error occured!"),
                                      content:
                                          Text("Please Generate Password."),
                                      actions: [
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Text("Okay"),
                                        ),
                                      ],
                                    ));
                          }
                        },
                      ),
                    ]),
                    Container(
                        margin: EdgeInsets.only(bottom: 30),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                  color: Colors.orange[500],
                                  onPressed: () {
                                    setState(() {
                                      String letters =
                                          "abcdefghijlmnopqrstqvwxyz";
                                      if (_lowercase) {
                                        outputGenerated = getRandomString(
                                            _currentSliderValue.round(),
                                            letters);
                                      }
                                      if (_characters) {
                                        outputGenerated = getRandomString(
                                            _currentSliderValue.round(),
                                            "!@#&()–[{}]:;',?/*~^+=<>");
                                      }
                                      if (_digits) {
                                        outputGenerated = getRandomString(
                                            _currentSliderValue.round(),
                                            "0123456789");
                                      }
                                      if (_uppercase) {
                                        outputGenerated = getRandomString(
                                            _currentSliderValue.round(),
                                            letters.toUpperCase());
                                      }
                                      if (_lowercase && _uppercase) {
                                        outputGenerated = getRandomString(
                                            _currentSliderValue.round(),
                                            letters.toUpperCase() + letters);
                                      }
                                      if (_lowercase && _digits) {
                                        outputGenerated = getRandomString(
                                            _currentSliderValue.round(),
                                            letters + "0123456789");
                                      }
                                      if (_lowercase && _characters) {
                                        outputGenerated = getRandomString(
                                            _currentSliderValue.round(),
                                            letters +
                                                "!@#&()–[{}]:;',?/*~^+=<>");
                                      }
                                      if (_uppercase && _characters) {
                                        outputGenerated = getRandomString(
                                            _currentSliderValue.round(),
                                            letters.toUpperCase() +
                                                "!@#&()–[{}]:;',?/*~^+=<>");
                                      }
                                      if (_uppercase && _digits) {
                                        outputGenerated = getRandomString(
                                            _currentSliderValue.round(),
                                            letters.toUpperCase() +
                                                "0123456789");
                                      }
                                      if (_digits && _characters) {
                                        outputGenerated = getRandomString(
                                            _currentSliderValue.round(),
                                            "0123456789!@#&()–[{}]:;',?/*~^+=<>");
                                      }
                                      if (_uppercase &&
                                          _digits &&
                                          _characters) {
                                        outputGenerated = getRandomString(
                                            _currentSliderValue.round(),
                                            letters.toUpperCase() +
                                                "0123456789!@#&()–[{}]:;',?/*~^+=<>");
                                      }
                                      if (_lowercase &&
                                          _digits &&
                                          _characters) {
                                        outputGenerated = getRandomString(
                                            _currentSliderValue.round(),
                                            letters +
                                                "0123456789!@#&()–[{}]:;',?/*~^+=<>");
                                      }
                                      if (_lowercase && _uppercase && _digits) {
                                        outputGenerated = getRandomString(
                                            _currentSliderValue.round(),
                                            letters +
                                                letters.toUpperCase() +
                                                "0123456789");
                                      }
                                      if (_lowercase &&
                                          _uppercase &&
                                          _characters) {
                                        outputGenerated = getRandomString(
                                            _currentSliderValue.round(),
                                            letters +
                                                letters.toUpperCase() +
                                                "0123456789!@#&()–[{}]:;',?/*~^+=<>");
                                      }
                                      if (_lowercase &&
                                          _uppercase &&
                                          _digits &&
                                          _characters) {
                                        outputGenerated = getRandomString(
                                            _currentSliderValue.round(),
                                            letters +
                                                letters.toUpperCase() +
                                                "0123456789!@#&()–[{}]:;',?/*~^+=<>");
                                      }
                                    });
                                  },
                                  child: Text("GENERATE",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5)),
                            ])),
                  ],
                ))),
      ],
    );
  }
}
