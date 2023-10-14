import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo JSON API'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final String url = 'http://www.omdbapi.com/?i=tt3322940&apikey=6363e229';
  late Map<String, dynamic> film;
  bool dataOK = false;

  @override
  void initState() {
    recupFilm();
    super.initState();
  }

  Future<void> recupFilm() async {

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      film = convert.jsonDecode(response.body);
      setState(() {
        dataOK = !dataOK;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
      ),
      body: dataOK ? visualizacion() : espera(),
      backgroundColor: Colors.blueGrey[900],
    );
  }
  Widget espera() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Esperando datos',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold)),
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget visualizacion() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          film != null
              ? Text(
            '${film['Title']}',
            style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.bold),
          )
              : Text('Ningún dato'),
          film != null
              ? Text(
            '${film['Year']}',
            style: TextStyle(color: Colors.white),
          )
              : Text('Ningún dato'),
          Padding(padding: EdgeInsets.all(20.0)),
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  offset: Offset(0.0, 7.0),
                  spreadRadius: 3.0,
                  blurRadius: 15.0)
            ]),
            child: film != null
                ? Image.network('${film['Poster']}')
                : Text('Ningún dato'),
          ),
          Padding(padding: EdgeInsets.all(20.0)),
          film != null
              ? Text(
            '${film['Plot']}',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          )
              : Text('Ningún dato'),
        ],
      ),
    );
  }
}