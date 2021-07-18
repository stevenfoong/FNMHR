import 'package:flutter/material.dart';

import 'package:fnm_hr/config/constant.dart';


import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'dart:async';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<LoginPage> {
  //TextEditingController nameController = TextEditingController();
  //TextEditingController passwordController = TextEditingController();
  TextEditingController _etEmail = TextEditingController();
  TextEditingController _etPassword = TextEditingController();

  late LoginBloc _loginBloc;
  CancelToken apiToken = CancelToken(); // used to cancel fetch data from API

  @override
  void initState() {
    _etEmail.text = 'robert.steven@ijteknologi.com';
    _etPassword.text = 'devkit';
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(WEB_TITLE),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      ORG_NAME,
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    //controller: nameController,
                    controller: _etEmail,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Name',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    //controller: passwordController,
                    controller: _etPassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: (){
                    //forgot password screen
                  },
                  textColor: Colors.blue,
                  child: Text('Forgot Password'),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Login'),
                      onPressed: () {
                        //print(nameController.text);
                        //print(passwordController.text);
                        print(_etEmail.text);
                        print(_etPassword.text);
                        _loginBloc.add(Login(email: _etEmail.text, password: _etPassword.text, apiToken: apiToken));
                        //_loginBloc.add(Login(email: _etEmail.text, password: _etPassword.text));

                      },
                    )),
                /*
                Container(
                    child: Row(
                      children: <Widget>[
                        Text('Does not have account?'),
                        FlatButton(
                          textColor: Colors.blue,
                          child: Text(
                            'Sign UP',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            //signup screen
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ))
                 */
              ],
            )));
  }
}

Stream<LoginState> _login(String email, password, apiToken) async* {
//Stream<LoginState> _login(String email, password) async* {
  ApiProvider _apiProvider = ApiProvider();

  yield LoginWaiting();
  try {
    List<LoginModel> data = await _apiProvider.login(email, password, apiToken);
    //List<LoginModel> data = await _apiProvider.login(email, password);
    yield LoginSuccess(loginData: data);
  } catch (ex){
    if(ex != 'cancel'){
      yield LoginError(errorMessage: ex.toString());
    }
  }
}


//login bloc section

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
      LoginEvent event,
      ) async* {
    if(event is Login){
      yield* _login(event.email, event.password, event.apiToken);
      //yield* _login(event.email, event.password);
    }
  }
}

//part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class InitialLoginState extends LoginState {}

class LoginError extends LoginState {
  final String errorMessage;

  LoginError({
    required this.errorMessage,
  });
}

class LoginWaiting extends LoginState {}

class LoginSuccess extends LoginState {
  final List<LoginModel> loginData;
  LoginSuccess({required this.loginData});
}

//part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class Login extends LoginEvent {
  final String email;
  final String password;
  final apiToken;
  Login({required this.email, required this.password, required this.apiToken});
  //Login({required this.email, required this.password});
}

class LoginModel {
  late String email;
  late String fullName;
  late String phoneNumber;
  late String sessionId;

  LoginModel({required this.email, required this.fullName, required this.phoneNumber, required this.sessionId});

  LoginModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    fullName = json['fullName'];
    phoneNumber = json['phoneNumber'];
    sessionId = json['sessionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['fullName'] = this.fullName;
    data['phoneNumber'] = this.phoneNumber;
    data['sessionId'] = this.sessionId;
    return data;
  }
}

//API Provider

class ApiProvider {
  //late String response;
  Dio dio = Dio();
  late Response response;
  String connErr = 'Please check your internet connection and try again';

  Future<Response> postConnect(url, data, apiToken) async{
    //var client = http.Client();
    print('url : '+url.toString());
    print('postData : '+data.toString());
    try{
      dio.options.headers['content-Type'] = 'application/x-www-form-urlencoded';
      dio.options.connectTimeout = 30000; //5s
      dio.options.receiveTimeout = 25000;

      return await dio.post(url, data: data, cancelToken: apiToken);
    } on DioError catch (e){
      print(e.toString()+' | '+url.toString());
      if(e.type == DioErrorType.response){
        int? statusCode = e.response!.statusCode;
        print(statusCode);
        if(statusCode == STATUS_NOT_FOUND){
          throw "Api not found";
        } else if(statusCode == STATUS_INTERNAL_ERROR){
          throw "Internal Server Error";
        } else {
          throw e.error.message.toString();
        }
      } else if(e.type == DioErrorType.connectTimeout){
        throw e.message.toString();
      } else if(e.type == DioErrorType.cancel){
        throw 'cancel';
      }
      throw connErr;
    } finally{
      dio.close();
    }
  }

  Future<List<LoginModel>> login(String email, String password, apiToken) async {
    var postData = {
      'email': email,
      'password': password,
    };
    response = await postConnect(LOGIN_API, postData, apiToken);
    if(response.data['status'] == STATUS_OK){
      List responseList = response.data['data'];
      List<LoginModel> listData = responseList.map((f) => LoginModel.fromJson(f)).toList();
      return listData;
    } else {
      throw response.data['msg'];
    }
  }
}