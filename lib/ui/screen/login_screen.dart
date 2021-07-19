// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fnm_hr/ui/screen/fetch_data.dart';

import 'package:fnm_hr/config/constant.dart';
import 'package:fnm_hr/models/login_model.dart';
import 'package:fnm_hr/main.dart';

// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class SignInHttpDemo extends StatefulWidget {

  @override
  _SignInHttpDemoState createState() => _SignInHttpDemoState();
}

class _SignInHttpDemoState extends State<SignInHttpDemo> {

  TextEditingController _etEmail = TextEditingController();
  TextEditingController _etPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in Form'),
      ),
      body: Form(
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ...[
                  TextFormField(
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    controller: _etEmail,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Your email address',
                      labelText: 'Email',
                    ),
                  ),
                  TextFormField(
                    controller: _etPassword,
                    decoration: const InputDecoration(
                      filled: true,
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  TextButton(
                    child: const Text('Sign in'),
                    onPressed: () async {
                      final response =
                      //await http.post(Uri.parse(LOGIN_API),body:{'email': 'robert.steven@ijteknologi.com', 'password': 'devkit'});
                      await http.post(Uri.parse(LOGIN_API),body:{'email': _etEmail.text, 'password': _etPassword.text});
                      print('Response status: ${response.statusCode}');
                      print('Response body: ${response.body}');

                      if (response.statusCode == 200) {
                        //print (Album.fromJson(jsonDecode(response.body)));
                        final body = json.decode(response.body);
                        print (body);
                        print (body['status']);
                        if (body['status'] == 200) {

                          print (Album.fromJson(jsonDecode(response.body)).data.first.sessionId);
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString('email', Album.fromJson(jsonDecode(response.body)).data.first.email);
                          prefs.setString('fullName', Album.fromJson(jsonDecode(response.body)).data.first.fullName);
                          prefs.setString('phoneNumber', Album.fromJson(jsonDecode(response.body)).data.first.phoneNumber);
                          prefs.setString('sessionId', Album.fromJson(jsonDecode(response.body)).data.first.sessionId);
                          prefs.setString('token', Album.fromJson(jsonDecode(response.body)).data.first.sessionId);
                          _showLoginDialog('Succesfully signed in.');

                        } else if (body['status'] == 400){
                          _showDialog(body['msg']);
                        }
                      } else {
                        _showDialog('Something went wrong. Please try again.');
                      }
                    },
                  ),
                ].expand(
                      (widget) => [
                    widget,
                    const SizedBox(
                      height: 24,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showLoginDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(title: APP_NAME)
                  )
              );
            },
          ),
        ],
      ),
    );
  }

}
