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

    if (request == 'employee') {
      body = jsonEncode({
        'token': token.trim(),
      });
    } else if (request == 'asset') {
      body = jsonEncode({
        'token': token.trim(),
        //   "assetID": "at2",
        "eeID": key?.trim(),
        "SeqID": "1",
      });
    } else if (request == 'company') {
      body = jsonEncode({
        'token': token.trim(),
        'companyID': key?.trim(),
      });
    } else if (request == 'delete') {
      body = jsonEncode({
        'token': token.trim(),
        'empID': key?.trim(),
      });
    } else if (request == 'update') {
      body = jsonEncode({
        'token': token.trim(),
        'EmpID': employee?.employeeID,
        'EmpName': employee?.employeeName,
        'JobTitle': employee?.jobDesc,
        'ComID': employee?.companyID
      });
    } else if (request == 'Create') {
      body = jsonEncode({
        'token': token.trim(),
        'EmployeeID': employee?.employeeID,
        'EmployeeName': employee?.employeeName,
        'JobTitle': employee?.jobDesc,
        'CompanyID': employee?.companyID
      });
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
