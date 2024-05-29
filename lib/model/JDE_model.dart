import 'dart:convert';
import 'package:flutter/material.dart';

//main Git
class JDERequestModel {
  String token;
  String? key;
  Employee? employee;

  JDERequestModel(
    this.token,
  );

  JDERequestModel.withKey(
    this.token,
    this.key,
  );

  set setKey(String str) {
    this.key = str;
  }

  set setToken(String str) {
    this.token = str;
  }

  set setEmployee(Employee employee) {
    this.employee = employee;
  }

  toJson(String request) {
    var body;

    //Query Data Key
    switch (request) {
      case 'employee':
        {
          body = jsonEncode({
            'token': token.trim(),
          });
          break;
        }
      case 'asset':
        {
          body = jsonEncode({
            'token': token.trim(),
            "employeeID": key?.trim(),
          });
          break;
        }
      case 'newKey':
        {
          body = jsonEncode({
            'token': token.trim(),
            "table": key?.trim(),
          });
          break;
        }
      case 'company':
        {
          body = jsonEncode({
            'token': token.trim(),
            'companyID': key?.trim(),
          });
          break;
        }

      //Actions
      case 'delete':
        {
          body = jsonEncode({
            'token': token.trim(),
            'empID': key?.trim(),
          });
          break;
        }
      case 'update':
        {
          body = jsonEncode({
            'token': token.trim(),
            'EmpID': employee?.employeeID,
            'EmpName': employee?.employeeName,
            'JobTitle': employee?.jobDesc,
            'ComID': employee?.companyID
          });
          break;
        }
      case 'create':
        {
          body = jsonEncode({
            'token': token.trim(),
            'EmployeeID': employee?.employeeID,
            'EmployeeName': employee?.employeeName,
            'JobTitle': employee?.jobDesc,
            'CompanyID': employee?.companyID
          });
          break;
        }
    }

    return body;
  }
}

/***Return Response***/
class CompanyResponseModel {
  List<Company> companylist = [];
  String? companyName;
  CompanyResponseModel({required this.companylist});

  factory CompanyResponseModel.fromJson(Map<String, dynamic> json) {
    List<Company> complist = [];
    List jsonlist = json["Company"]["rowset"];
    for (int i = 0; i < jsonlist.length; i++) {
      complist.add(new Company(
        jsonlist[i]["Company Name"],
        jsonlist[i]["Country Name"],
        jsonlist[i]["City Name"],
        jsonlist[i]["Employee Name"],
      ));
    }

    return CompanyResponseModel(
      companylist: complist,
    );
  }

  getCompanyData() {
    return companylist;
  }
}

class ImageResponseModel {
  List<ImageValue> imagelist = [];
  ImageResponseModel({required this.imagelist});

  factory ImageResponseModel.fromJson(Map<String, dynamic> json) {
    List<ImageValue> imglist = [];
    List jsonlist = json["AssetArray"];
    for (int i = 0; i < jsonlist.length; i++) {
      imglist.add(new ImageValue(
        jsonlist[i]["AssetID"],
        jsonlist[i]["AssetName"],
        jsonlist[i]["Amount"],
      ));
    }

    return ImageResponseModel(
      imagelist: imglist,
    );
  }

  getImageData() {
    return imagelist;
  }
}

class EmployeeResponseModel {
  List<Employee> employeelist = [];
  String? employeeName;
  EmployeeResponseModel({required this.employeelist});

  factory EmployeeResponseModel.fromJson(Map<String, dynamic> json) {
    List<Employee> complist = [];
    List jsonlist = json["Employee"]["rowset"];
    for (int i = 0; i < jsonlist.length; i++) {
      complist.add(new Employee(
        jsonlist[i]["Company ID"],
        jsonlist[i]["Employee ID"],
        jsonlist[i]["Job Desc"],
        jsonlist[i]["Employee Name"],
      ));
    }

    return EmployeeResponseModel(
      employeelist: complist,
    );
  }

  getEmployeeData() {
    return employeelist;
  }
}

/*****Value Object ******/
class Company {
  String companyName;
  String countryName;
  String cityName;
  String employeeName;
  String? error;

  Company(this.companyName, this.countryName, this.cityName, this.employeeName);
}

class Employee {
  String? companyID;
  String? jobDesc;
  String? employeeName;
  String? employeeID;

  Employee(this.companyID, this.employeeID, this.jobDesc, this.employeeName);
  Employee.initValues();
}

class ImageValue {
  String? assetID;
  String? assetName;
  int? amount;
  Image? image;

  ImageValue(this.assetID, this.assetName, this.amount);
}

/********************* */

/**Provider*/
class EmployeeModel extends ChangeNotifier {
  List<Employee> _employees = [];

  List<Employee> get employees => _employees;

  set employees(List<Employee> employees) => _employees = employees;

  void updateEmployee(
      int index, String jodDesc, String employeeName, String companyID) {
    _employees[index].jobDesc = jodDesc;
    _employees[index].employeeName = employeeName;
    _employees[index].companyID = companyID;
    notifyListeners();
  }

  void deleteEmployee(int index) {
    _employees.removeAt(index);

    notifyListeners();
  }

  void createEmployee(
    String employeeID,
    String jodDesc,
    String employeeName,
    String companyID,
  ) {
    Employee employee = new Employee.initValues();
    employee.employeeID = employeeID;
    employee.jobDesc = jodDesc;
    employee.employeeName = employeeName;
    employee.companyID = companyID;

    _employees.add(employee);

    notifyListeners();
  }
}
