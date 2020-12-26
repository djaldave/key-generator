import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../model/passlist.dart';
import 'package:http/http.dart' as http;
import "dart:convert";
import 'package:auto_size_text_field/auto_size_text_field.dart';

class FavoritePage extends StatefulWidget {
  final List<PassList> passList;

  final Function deletePass;
  FavoritePage(this.passList, this.deletePass);
  State createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<PassList> _passList = [];
  bool isLoading = false;
  int _passIndex;
  final TextEditingController _textController = new TextEditingController();
  initState() {
    fetchPassList();
    super.initState();
  }

  int get selectedPassIndex {
    return _passIndex;
  }

  void selectPass(int index) {
    _passIndex = index;
  }

  PassList get selectedPassword {
    if (selectedPassIndex == null) {
      return null;
    }
    return _passList[selectedPassIndex];
  }

  void fetchPassList() {
    isLoading = true;
    final List<PassList> tempList = [];
    http
        .get(
            "https://pass-generator-cfa32-default-rtdb.firebaseio.com/password.json")
        .then((http.Response response) {
      final Map<String, dynamic> passwordListData = json.decode(response.body);
      //output:  {-MPSDcGb3h_qhM3GcFHT: {pass: EN5FpW}Qs8–O}, -MPSINMzH5HB8cUwn_Cp: {pass: xrcdv@r/T4GF}}
      if (passwordListData == null) {
        setState(() {
          isLoading = false;
          return;
        });
      } else {
        passwordListData.forEach((passId, passData) {
          isLoading = false;
          final PassList pstlst = PassList(id: passId, text: passData['pass']);

          tempList.add(pstlst);
        });
        setState(() {
          isLoading = false;
          _passList = tempList;
        });
      }
    });
  }

  void updatePass(int index, String pass) {
    final Map<String, dynamic> updateData = {"pass": pass};

    http
        .put(
            "https://pass-generator-cfa32-default-rtdb.firebaseio.com/password/${selectedPassword.id}.json",
            body: json.encode(updateData))
        .then((http.Response response) {
      final PassList pstlst = PassList(id: selectedPassword.id, text: pass);
      setState(() {
        _passList[selectedPassIndex] = pstlst;
      });
    });
  }

  void deleteProduct() {
    http
        .delete(
            "https://pass-generator-cfa32-default-rtdb.firebaseio.com/password/${selectedPassword.id}.json")
        .then((http.Response response) {
      setState(() {
        _passList.removeAt(selectedPassIndex);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[300],
      appBar: AppBar(
        title: Text("KeyMate", style: Theme.of(context).textTheme.headline1),
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.key),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/generate");
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
        return condition(context1);
      }),
    );
  }

  condition(context1) {
    Widget content = Center(child: Text("No Password Added"));
    if (_passList.length > 0) {
      content = Card(
          margin: EdgeInsets.all(10),
          elevation: 3,
          child: Container(
            width: double.infinity,
            decoration: boxDecoration(),
            child: ListView.builder(
                itemBuilder: (ctx, index) {
                  return Card(
                      color: Colors.orange[300],
                      child: Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 20, bottom: 10),
                                width: 200,
                                height: 40,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.fromBorderSide(BorderSide(
                                      color: Colors.black, width: 2)),
                                ),
                                child: AutoSizeText(
                                  _passList[index].text,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 30.0),
                                  maxLines: 2,
                                ),
                              ),
                              IconButton(
                                icon: FaIcon(FontAwesomeIcons.edit, size: 35),
                                color: Colors.deepOrange,
                                onPressed: () {
                                  if (_passList != null) {
                                    selectPass(index);
                                    print(index);
                                    _textController.text =
                                        _passList[index].text;
                                    _startAddNewTransaction(context1);
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, size: 40),
                                color: Colors.red,
                                onPressed: () {
                                  selectPass(index);
                                  deleteProduct();
                                },
                              ),
                            ]),
                      ]));
                },
                itemCount: _passList.length),
          ));
    } else if (isLoading) {
      content = Center(child: CircularProgressIndicator());
    }
    return content;
  }

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

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: Card(
              elevation: 5,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    AutoSizeTextField(
                      style: TextStyle(fontSize: 20.0),
                      controller: _textController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        suffixIcon: CircleIconButton(onPressed: () {
                          setState(() {
                            _textController.clear();
                          });
                        }),
                      ),
                      onSubmitted: (_) {},
                    ),
                    RaisedButton(
                      onPressed: () {
                        updatePass(selectedPassIndex, _textController.text);
                        Navigator.pop(ctx);
                        Scaffold.of(ctx).hideCurrentSnackBar();
                        Scaffold.of(ctx).showSnackBar(SnackBar(
                          content: Text(
                            "UPDATED",
                          ),
                          duration: Duration(seconds: 2),
                        ));
                      },
                      child: Text("Update"),
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).textTheme.button.color,
                    ),
                  ],
                ),
              ),
            ),
            behavior: HitTestBehavior.opaque,
            onTap: () {},
          );
        });
  }
}

class CircleIconButton extends StatelessWidget {
  final double size;
  final Function onPressed;
  final IconData icon;
  CircleIconButton({this.size = 30.0, this.icon = Icons.clear, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: this.onPressed,
        child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment(0.0, 0.0), // all centered
              children: <Widget>[
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.deepOrange),
                ),
                Icon(
                  icon,
                  size: size * 0.6, // 60% width for icon
                )
              ],
            )));
  }
}
