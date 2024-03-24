import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_http_post_request/pages/edit_employee_page.dart';
import 'package:provider/provider.dart';
import '../model/JDE_model.dart';
import '../api/api_service.dart';
import '../ProgressHUD.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

enum MenuItem { delete, company }

class ShowEmpPage extends StatefulWidget {
  String token;
  ShowEmpPage(this.token);

//  const ShowEmpPage({super.key});

  @override
  State<ShowEmpPage> createState() => _ShowEmpPageState(token);
}

class _ShowEmpPageState extends State<ShowEmpPage> {
  String token;

  EmployeeModel employeeModel;

  bool isApiCallProcess = true;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _Flag = true;
  APIService apiService;
  Map<int, String> empKey = {};

  _ShowEmpPageState(this.token);

  @override
  void initState() {
    employeeModel = new EmployeeModel();
    super.initState();
    runZoned(() {
      _loadEmployeeData();
    }, onError: (dynamic e, StackTrace stack) {
      Navigator.of(context).popUntil(ModalRoute.withName("/"));
    });
  }

  _loadEmployeeData() {
    apiService = new APIService();
    apiService.getEmployee(new JDERequestModel(token)).then((value) {
      employeeModel.employees = value.getEmployeeData();
      if (employeeModel.employees.length != 0) {
        setState(() {
          isApiCallProcess = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EmployeeModel>(
        create: (context) => employeeModel,
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: new Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              key: scaffoldKey,
              // backgroundColor: Theme.of(context).colorScheme.background,
              appBar: new AppBar(
                  title: new Text('Employee Master List'),
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // 返回操作
                    },
                    child: Icon(Icons.arrow_back),
                  )),
              body: new Center(
                  child: employeeModel.employees.length == 0
                      ? new CircularProgressIndicator()
                      : showMyUI(context)),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          settings: RouteSettings(name: "/EMPPage"),
                          builder: (context) {
                            return EditEmpPage(token);
                          }));
                },
              ),
            )));
  }

  Widget showMyUI(BuildContext context) {
    bool _customTileExpanded = false;
    var employee;

    if (employeeModel.employees.length == 0) {
      setState(() {
        isApiCallProcess = false;
      });
    }

    return ListView.builder(
        itemCount: employeeModel.employees.length,
        itemBuilder: (_, index) {
          return new Container(
            margin: new EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
            child: Slidable(
              key: const ValueKey(0),
              endActionPane: ActionPane(
                motion: ScrollMotion(),
                children: [
                  SlidableAction(
                    flex: 2,
                    onPressed: (context) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              settings: RouteSettings(name: "/EMPPage"),
                              builder: (context) {
                                return EditEmpPage.withIndex(token, index);
                              }));
                    },
                    backgroundColor: Color(0xFF7BC043),
                    foregroundColor: Color.fromARGB(255, 227, 21, 21),
                    icon: Icons.edit,
                    label: 'Modify',
                  ),
                ],
              ),
              child: new Card(
                elevation: 10.0,
                child: new Container(
                  padding: new EdgeInsets.all(12.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Padding(
                          padding: new EdgeInsets.symmetric(vertical: 3.0)),
                      ExpansionTile(
                        title: Builder(builder: (context) {
                          employee = Provider.of<EmployeeModel>(context);
                          return RichText(
                              text: TextSpan(
                                  text: 'Employee:  ',
                                  style: TextStyle(
                                      //  fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 12, 13, 13)),
                                  children: <TextSpan>[
                                TextSpan(
                                    text:
                                        '${employee.employees[index].employeeName}',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.blue)),
                              ])

                              //${employeeList[index].employeeName}
                              );
                        }),
                        //     subtitle: const Text('Custom expansion arrow icon'),
                        trailing: Icon(
                          _customTileExpanded
                              ? Icons.arrow_drop_down_circle
                              : Icons.arrow_drop_down,
                        ),
                        children: <Widget>[
                          Builder(builder: (context) {
                            employee = Provider.of<EmployeeModel>(context);
                            return ListTile(
                              tileColor: Color.fromARGB(255, 221, 237, 245),
                              title: Text(
                                'Job:    ${employeeModel.employees[index].jobDesc}',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 93, 33, 243)),
                              ),
                              //    trailing: Icon(Icons.more_vert)
                              trailing: _menu(
                                  context,
                                  employeeModel.employees[index].employeeID,
                                  index),
                              onTap: () {
                                var selectedItem =
                                    employeeModel.employees[index];
                                var selectedIndex = index;
                              },
                            );
                          }),
                        ],
                        onExpansionChanged: (bool expanded) {
                          setState(() {
                            _customTileExpanded = expanded;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget _menu(BuildContext context, String empID, int index) {
    empKey[index] = empID;

    return PopupMenuButton<String>(
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'Delete',
          child: Text('Delete'),
        ),
        const PopupMenuItem<String>(
          value: 'Assets',
          child: Text('Fixed Assets'),
        )
      ],
      onSelected: (String menuItem) {
        if (menuItem == 'Company') {
          scaffoldKey.currentState.showBottomSheet<void>(
            (BuildContext context) {
              return Container(
                height: 82,
                color: Color.fromARGB(255, 191, 206, 183),
                child: Center(
                    child: Column(children: <Widget>[
                  Text('Employee company Detail',
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 93, 33, 243))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // ElevatedButton(
                      //   child: const Text('Yes'),
                      //   onPressed: () {
                      //     Navigator.pop(context);
                      //   },
                    ],
                  ),
                ])),
              );
            },
          );
          //      print(MenuItem);
        } else if (menuItem == 'Delete') {
          runZoned(() {
            _deleteConfirm(context, index);
          }, onError: (dynamic e, StackTrace stack) {
            Navigator.of(context).popUntil(ModalRoute.withName("/"));
          });
        }
      },
    );
  }

  void _deleteConfirm(BuildContext context, int listIndex) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Please Confirm'),
            content: const Text('Are you sure to remove the box?'),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      try {
                        apiService = new APIService();
                        apiService
                            .deleteEmployee(new JDERequestModel.withKey(
                                token, empKey[listIndex]))
                            .then((value) {
                          setState(() {
                            _loadEmployeeData();
                          });
                          if (value) {
                            final snackBar =
                                SnackBar(content: Text("Delete Success"));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        });
                      } on Exception catch (e) {
                        Navigator.of(context)
                            .popUntil(ModalRoute.withName("/"));
                      }
                    });

                    Navigator.of(context).pop();
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }
}
