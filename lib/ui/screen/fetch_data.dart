import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:fnm_hr/config/constant.dart';

Future<Album> fetchAlbum() async {
  final response =
  //await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  await http.post(Uri.parse(LOGIN_API),body:{'email': 'robert.steven@ijteknologi.com', 'password': 'devkit'});
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}




class Album {
  //final int userId;
  //final int id;
  String msg;
  int status;
  List<Data> data;

  Album({
    //required this.userId,
    //required this.id,
    required this.msg,
    required this.status,
    required this.data
  });

  factory Album.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;
    List<Data> data = list.map((i) => Data.fromJson(i)).toList();

    return Album(
      //
      //userId: json['userId'],
      //id: json['id'],
      msg: parsedJson['msg'],
      status: parsedJson['status'],
      data: data
      //logindatas: Logindata_List
    );
  }

}


class Data{
  String email;
  String fullName;
  String phoneNumber;
  String sessionId;

  Data({
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.sessionId
  });

  factory Data.fromJson(Map<String, dynamic> parsedJson){
    return Data(
      email: parsedJson['email'],
      fullName: parsedJson['fullName'],
      phoneNumber: parsedJson['phoneNumber'].toString(),
      sessionId: parsedJson['sessionId'].toString()
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print('has data');
                print(snapshot.data!.data.first.email);
                print(snapshot.data!.data.first.fullName);
                print(snapshot.data!.data.first.phoneNumber);
                print(snapshot.data!.data.first.sessionId);
                if (snapshot.data!.msg == "Success") {
                  return Text(snapshot.data!.data.first.email);
                } else {
                  return Text(snapshot.data!.msg);
                }
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}