import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/api_service.dart';
import '../model/JDE_model.dart';
import 'package:get/get.dart';

//bool isApiCallProcess = false;

// ignore: must_be_immutable
class EditEmpPage extends StatelessWidget {
  String token;
  int index = 0;
  late JDERequestModel requestMD;
  String? dropdownValue;
  EmployeeModel? employeeModel;
  Employee employee = new Employee.initValues();
  String mode = "";

  APIService apiService = new APIService();
  static GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  EditEmpPage(this.token, this.mode);
  EditEmpPage.withIndex(this.token, this.index, this.mode);

  bool validateAndSave() {
    if (globalFormKey.currentState != null &&
        globalFormKey.currentState!.validate()) {
      globalFormKey.currentState?.save();
      return true;
    }
    return false;
  }

  void initState() {}

  @override
  Widget build(BuildContext context) {
    requestMD = new JDERequestModel(token);
    employeeModel = Provider.of<EmployeeModel>(context, listen: false);

    if (mode == "create") {
      dropdownValue = 'c1';
    } else if (mode == 'modify') {
      dropdownValue = employeeModel?.employees[index].companyID;
    }

    //Controler initial

    UDCController udcController = Get.put(UDCController());
    DrawMenuController drawMenuController = Get.put(DrawMenuController());
    udcController.loadCompanyName(dropdownValue!, context, token);

    return new MaterialApp(
        home: new Scaffold(
      backgroundColor: Color.fromARGB(255, 154, 190, 253),
      appBar: new AppBar(
          title: new Text('Employee Detail Input'),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context); // 返回操作
            },
            child: Icon(Icons.arrow_back),
          )),
      body: Form(
          key: globalFormKey,
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              ListTile(
                  //  tileColor: Color.fromARGB(255, 221, 237, 245),
                  title: Text(
                    'Employee Name',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Color.fromARGB(255, 2, 61, 108)),
                  ),
                  subtitle: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(
                            12)), // Set border radius if you want rounded corners
                      ),
                      child: TextFormField(
                          initialValue: mode == "modify"
                              ? employeeModel!.employees[index].employeeName
                              : '',
                          onSaved: (input) {
                            employee.employeeName = input;
                          },
                          decoration: InputDecoration(
                            hintText: "Full Name",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                          )))),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                        //      tileColor: Color.fromARGB(255, 221, 237, 245),
                        title: Text(
                          'Jot Title',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Color.fromARGB(255, 2, 61, 108)),
                        ),
                        subtitle: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(
                                12)), // Set border radius if you want rounded corners
                          ),
                          child: TextFormField(
                            initialValue: mode == "modify"
                                ? employeeModel!.employees[index].jobDesc
                                : '',
                            onSaved: (input) {
                              employee.jobDesc = input;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              hintText: ' Job',
                            ),
                          ),
                        )),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: ListTile(
                        //     tileColor: Color.fromARGB(255, 221, 237, 245),
                        title: Text(
                          'ID Number',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Color.fromARGB(255, 2, 61, 108)),
                        ),
                        subtitle: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(
                                12)), // Set border radius if you want rounded corners
                          ),
                          child: TextFormField(
                            enabled: mode == "modify" ? false : true,
                            initialValue: mode == "modify"
                                ? employeeModel!.employees[index].employeeID
                                : '',
                            onSaved: (input) {
                              employee.employeeID = input;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              hintText: '  ID',
                            ),
                          ),
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              ListTile(
                title: Text(
                  'Company',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Color.fromARGB(255, 2, 61, 108)),
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Row(
                  //crossAxisAlignment,

                  children: [
                    SizedBox(width: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 236, 249, 186),
                        borderRadius: BorderRadius.all(Radius.circular(
                            12)), // Set border radius if you want rounded corners
                      ),

                      padding: EdgeInsets.only(left: 20),
                      //     alignment: Alignment.topLeft,

                      //        crossAxisAlignment: CrossAxisAlignment.start,
                      child: GetBuilder<DrawMenuController>(
                        builder: (_) {
                          return DropdownButton<String>(
                            value: dropdownValue,
                            icon: const Icon(Icons.arrow_drop_down_outlined),
                            elevation: 16,
                            onChanged: (String? value) {
                              drawMenuController.refreshDropdown(value!);
                              udcController.loadCompanyName(
                                  value, context, token);
                              employee.companyID = value;
                              dropdownValue = value;
                            },
                            style: const TextStyle(
                                color: Color.fromARGB(255, 42, 4, 119),
                                fontSize: 20),
                            items: drawMenuController.dropdownItems
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                  value: value, child: Text(value));
                            }).toList(),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    GetBuilder<UDCController>(builder: (_) {
                      return Text(
                        '${udcController.companyName.value}',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 18,
                            color: Color.fromARGB(255, 2, 61, 108)),
                        textAlign: TextAlign.left,
                      );
                    }),
                  ]),
              SizedBox(
                height: 10,
              ),
              Container(
                  child: ElevatedButton(
                onPressed: () {
                  if (validateAndSave()) {
                    if (mode == "modify")
                      _updateEmployee(context);
                    else if (mode == "create") _addEmployee(context);
                  }
                },
                child: Text('Confirm'),
                //     style: flatButtonStyle,
              ))
            ],
          ))),
    ));
  }

  _updateEmployee(BuildContext context) {
    runZoned(() {
      if (employee.companyID == null) employee.companyID = dropdownValue;
      requestMD.setEmployee = employee;
      apiService.updateEmployee(requestMD).then((value) {
        if (value) {
          employeeModel!.updateEmployee(
              index, employee.jobDesc!, employee.employeeName!, dropdownValue!);
          Navigator.of(context).pop(ModalRoute.withName("/ShowEMPPage"));
        }
      });
      // ignore: deprecated_member_use
    }, onError: (dynamic e, StackTrace stack) {
      //  return false;
    });
  }

  _addEmployee(BuildContext context) {
    runZoned(() {
      if (employee.companyID == null) employee.companyID = dropdownValue;
      requestMD.setEmployee = employee;
      apiService.createEmployee(requestMD).then((value) {
        if (value) {
          employeeModel!.createEmployee(employee.employeeID!, employee.jobDesc!,
              employee.employeeName!, dropdownValue!);
          Navigator.of(context).pop(ModalRoute.withName("/ShowEMPPage"));
        }
      });
      // ignore: deprecated_member_use
    }, onError: (dynamic e, StackTrace stack) {});
  }
}

class UDCController extends GetxController {
  var companyName = ''.obs;

  APIService apiService = new APIService();
  late JDERequestModel requestMD;
  List<Company> companyList = [];

  loadCompanyName(String key, BuildContext context, String token) {
    runZoned(() {
      requestMD = new JDERequestModel(token);
      requestMD.setKey = key;
      apiService.getCompany(requestMD).then((value) {
        this.companyList = value.getCompanyData();
        companyName = companyList.first.companyName.obs;
        if (companyList.length != 0) update();
      });
      // ignore: deprecated_member_use
    }, onError: (dynamic e, StackTrace stack) {
      Future.delayed(Duration.zero, () {
        Get.back();
      });
      //  Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }
}

class DrawMenuController extends GetxController {
  List<String> dropdownItems = ['c1', 'c2', 'c3', 'c4', 'c5', 'c6', 'c7'];
  var selectedValue = 'c1'.obs;

  void refreshDropdown(String newValue) {
    selectedValue.value = newValue;
    update();
  }
}
