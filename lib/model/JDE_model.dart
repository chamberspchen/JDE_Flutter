import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class JDERequestModel {
  String token;
  String key;
  Employee employee;

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

  set setEmployee(Employee employee) {
    this.employee = employee;
  }

  toJson(String request) {
    var body;

    if (request == 'employee') {
      body = jsonEncode({
        'token': token.trim(),
      });
    } else if (request == 'company') {
      body = jsonEncode({
        'token': token.trim(),
        'companyID': key.trim(),
      });
    } else if (request == 'delete') {
      body = jsonEncode({
        'token': token.trim(),
        'empID': key.trim(),
      });
    } else if (request == 'update') {
      body = jsonEncode({
        'token': token.trim(),
        'EmpID': employee.employeeID,
        'EmpName': employee.employeeName,
        'JobTitle': employee.jobDesc,
        'ComID': employee.companyID
      });
    }

    return body;
  }
}

/***Return Response***/
class CompanyResponseModel {
  List<Company> companylist = [];
  String companyName;
  CompanyResponseModel({this.companylist});

  factory CompanyResponseModel.fromJson(Map<String, dynamic> json) {
    List<Company> complist = [];
    if (json != null) {
      List jsonlist = json["Company"]["rowset"];
      for (int i = 0; i < jsonlist.length; i++) {
        complist.add(new Company(
          jsonlist[i]["Company Name"],
          jsonlist[i]["Country Name"],
          jsonlist[i]["City Name"],
          jsonlist[i]["Employee Name"],
        ));
      }
    }

    return CompanyResponseModel(
      companylist: complist,
    );
  }

  getCompanyData() {
    return companylist;
  }
}

class EmployeeResponseModel {
  List<Employee> employeelist = [];
  String employeeName;
  EmployeeResponseModel({this.employeelist});

  factory EmployeeResponseModel.fromJson(Map<String, dynamic> json) {
    List<Employee> complist = [];
    if (json != null) {
      List jsonlist = json["Employee"]["rowset"];
      for (int i = 0; i < jsonlist.length; i++) {
        complist.add(new Employee(
          jsonlist[i]["Company ID"],
          jsonlist[i]["Employee ID"],
          jsonlist[i]["Job Desc"],
          jsonlist[i]["Employee Name"],
        ));
      }
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
  String error;

  Company(this.companyName, this.countryName, this.cityName, this.employeeName);
}

class Employee {
  String companyID;
  String jobDesc;
  String employeeName;
  String employeeID;

  Employee(this.companyID, this.employeeID, this.jobDesc, this.employeeName);
  Employee.initValues();
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
}
