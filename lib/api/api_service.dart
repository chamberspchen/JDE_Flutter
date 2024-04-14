import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/JDE_model.dart';
import '../model/login_model.dart';

class APIService {
  // String url = "http://192.168.12.128:8305/jderest/defaultconfig";

/**Login Response */
  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    final uri = Uri.parse('http://192.168.12.128:8305/jderest/v2/tokenrequest');

    http.Response? response;
    try {
      response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: requestModel.toJson());
    } on FormatException {
      print('AIS Server could not return token!');
    }
    // if (response!.statusCode == 200 || response.statusCode == 400) {
    return LoginResponseModel.fromJson(json.decode(response!.body));
  }

/**Company Response */
  Future<CompanyResponseModel> getCompany(JDERequestModel requestModel) async {
    final uri = Uri.parse(
        'http://192.168.12.128:8305/jderest/orchestrator/Orch_FlutterCompany');

    http.Response? response;
    try {
      response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: requestModel.toJson('company'));
    } on FormatException catch (e) {
      print(e);
    }
    if (response!.statusCode == 200 || response.statusCode == 400) {
      return CompanyResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception('Failed to load data!');
    }
  }

  /**Employee Response */
  Future<EmployeeResponseModel> getEmployee(
      JDERequestModel requestModel) async {
    final uri = Uri.parse(
        'http://192.168.12.128:8305/jderest/orchestrator/Orch_FlutterEmployee');

    http.Response? response;
    try {
      response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: requestModel.toJson('employee'));
    } on FormatException catch (e) {
      print(e);
    }
    if (response!.statusCode == 200 || response.statusCode == 400) {
      return EmployeeResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception('Failed to load data!');
    }
  }

/**Delete Employee*/
  Future<bool> deleteEmployee(JDERequestModel requestModel) async {
    final uri = Uri.parse(
        'http://192.168.12.128:8305/jderest/orchestrator/Orch_DeleteEmployee');

    http.Response? response;
    try {
      response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: requestModel.toJson('delete'));
    } on FormatException catch (e) {
      print(e);
    }
    if (response!.statusCode == 200 || response.statusCode == 400) {
      return true;
    } else {
      throw Exception('Failed to delete data!');
    }
  }

  /**Update Employee*/
  Future<bool> updateEmployee(JDERequestModel requestModel) async {
    final uri = Uri.parse(
        'http://192.168.12.128:8305/jderest/orchestrator/Orch_UpdateEmployee');

    http.Response? response;
    try {
      response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: requestModel.toJson('update'));
    } on FormatException catch (e) {
      print(e);
      return false;
    }
    if (response.statusCode == 200 || response.statusCode == 400) {
      Map<String, dynamic> jsonmap = json.decode(response.body);

      return jsonmap['IOFlag'].toString().toLowerCase() == 'true'
          ? true
          : false;
    } else {
      throw Exception('Failed to update data!');
    }
  }

  /**Retrieve Image */
  Future<Image> getAssetImage(JDERequestModel requestModel) async {
    final uri = Uri.parse(
        'http://192.168.12.128:8305/jderest/orchestrator/GetImageFile');

    http.Response? response;
    try {
      response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/octet-stream'
          },
          body: requestModel.toJson('asset'));
    } on FormatException catch (e) {
      print(e);
    }
    if (response!.statusCode == 200 || response.statusCode == 400) {
      // final decodedData = json.decode(response.body);

      // var file = File('C:\\Share\\laptop.jpg');
      // await file.writeAsBytes();
      return Image.memory(response.bodyBytes);
    } else {
      throw Exception('Failed to load data!');
    }
  }

  /**Create Employee*/
  Future<bool> createEmployee(JDERequestModel requestModel) async {
    final uri = Uri.parse(
        'http://192.168.12.128:8305/jderest/orchestrator/Orch_CreateEmployee');

    http.Response? response;
    try {
      response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: requestModel.toJson('Create'));
    } on FormatException catch (e) {
      print(e);
      return false;
    }
    if (response.statusCode == 200 || response.statusCode == 400) {
      Map<String, dynamic> jsonmap = json.decode(response.body);

      return jsonmap['IOFlag'].toString().toLowerCase() == 'true'
          ? true
          : false;
    } else {
      throw Exception('Failed to update data!');
    }
  }
}
