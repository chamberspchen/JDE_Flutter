import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/api_service.dart';
import '../model/JDE_model.dart';
import 'package:get/get.dart';

//bool isApiCallProcess = false;

class EditEmpPage extends StatelessWidget {
  String token;
  int index;
  EditEmpPage(this.token);

  EditEmpPage.withIndex(this.token, this.index);

//  String token;
  APIService apiService = new APIService();

  JDERequestModel requestMD;
  String dropdownValue;
  Employee employee = new Employee.initValues();
  // String companyName = null;

  EmployeeModel employeeModel;
  static GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  UDCController udcController;
  DrawMenuController drawMenuController;
//check for gits
  bool validateAndSave() {
    if (globalFormKey.currentState.validate()) {
      globalFormKey.currentState.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    requestMD = new JDERequestModel(token);

    employeeModel = Provider.of<EmployeeModel>(context, listen: false);
    dropdownValue = employeeModel.employees[index].companyID;

    //Controler initial

    udcController = Get.put(UDCController(requestMD));
    drawMenuController = Get.put(DrawMenuController());
    udcController.loadCompanyName(dropdownValue, context);

    return new MaterialApp(
        home: new Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
                          initialValue:
                              employeeModel.employees[index].employeeName,
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
                            initialValue:
                                employeeModel.employees[index].jobDesc,
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
                            enabled: false,
                            initialValue:
                                employeeModel.employees[index].employeeID,
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
                        builder: (drawMenuController) {
                          return DropdownButton<String>(
                            value: dropdownValue,
                            icon: const Icon(Icons.arrow_drop_down_outlined),
                            elevation: 16,
                            onChanged: (String value) {
                              drawMenuController.refreshDropdown(value);
                              udcController.loadCompanyName(value, context);
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
                    GetBuilder<UDCController>(builder: (udcController) {
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
                    _updateEmployee(employee.employeeID, context);
                  }
                },
                child: Text('Confirm'),
                //     style: flatButtonStyle,
              ))
            ],
          ))),
    ));
  }

  _updateEmployee(String key, BuildContext context) {
    runZoned(() {
      requestMD.setEmployee = employee;
      apiService.updateEmployee(requestMD).then((value) {
        if (value) {
          employeeModel.updateEmployee(
              index, employee.jobDesc, employee.employeeName, dropdownValue);
          Navigator.of(context).pop(ModalRoute.withName("/ShowEMPPage"));
        }
      });
      // ignore: deprecated_member_use
    }, onError: (dynamic e, StackTrace stack) {
      //  return false;
    });
  }
}

class UDCController extends GetxController {
  var companyName = ''.obs;

  APIService apiService = new APIService();
  JDERequestModel requestMD;
  List<Company> companyList = [];

  UDCController(this.requestMD);

  loadCompanyName(String key, BuildContext context) {
    runZoned(() {
      requestMD.setKey = key;
      apiService.getCompany(requestMD).then((value) {
        this.companyList = value.getCompanyData();
        companyName = companyList.first.companyName.obs;
        if (companyList.length != 0) update();
      });
      // ignore: deprecated_member_use
    }, onError: (dynamic e, StackTrace stack) {
      Navigator.of(context).popUntil(ModalRoute.withName("/"));
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
