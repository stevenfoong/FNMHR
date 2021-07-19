
class LoginResponseModel {
  //final int userId;
  //final int id;
  final String msg;
  final String status;
  final List<Data> data;

  LoginResponseModel({
    //required this.userId,
    //required this.id,
    required this.msg,
    required this.status,
    required this.data
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;
    List<Data> data = list.map((i) => Data.fromJson(i)).toList();

    return LoginResponseModel(
      //
      //userId: json['userId'],
      //id: json['id'],
        msg: parsedJson['msg'],
        status: parsedJson['status'].toString(),
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

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
        email: json['email'] ?? '',
        fullName: json['fullName'] ?? '',
        phoneNumber: json['phoneNumber'] ?? '',
        sessionId: json['sessionId'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['fullName'] = this.fullName;
    data['phoneNumber'] = this.phoneNumber.toString();
    data['sessionId'] = this.sessionId.toString();
    return data;
  }
}


class LoginRequestModel {
  String email;
  String password;

  LoginRequestModel({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'email': email.trim(),
      'password': password.trim(),
    };

    return map;
  }
}
