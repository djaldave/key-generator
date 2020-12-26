import "package:flutter/material.dart";

class HomePage extends StatelessWidget {
  @override
  Widget build(context) {
    return Scaffold(
      body: Center(
          child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
              Colors.orange[100],
              Colors.orange[300],
              Colors.orange[900]
            ])),
        alignment: Alignment.center,
        child: Card(
          elevation: 3,
          color: Colors.orange[100],
          child: Container(
              padding: EdgeInsets.all(30),
              width: 280,
              height: 400,
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("KeyMate",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Gemunu Libre',
                          fontSize: 37,
                          fontWeight: FontWeight.bold)),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('assets/keygif2.gif'),
                        fit: BoxFit.fill,
                      ))),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  FlatButton(
                      minWidth: 200.0,
                      color: Colors.orange[900],
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "/generate");
                      },
                      child: Text("GENERATE",
                          style: Theme.of(context).textTheme.headline5))
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  FlatButton(
                      minWidth: 200.0,
                      color: Colors.orange[900],
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "/favorite");
                      },
                      child: Text("FAVORITES",
                          style: Theme.of(context).textTheme.headline5)),
                ]),
              ])),
        ),
      )),
    );
  }
}
