import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_http_post_request/pages/edit_employee_page.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../model/JDE_model.dart';
import '../api/api_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

enum MenuItem { delete, company }

// ignore: must_be_immutable
class ShowEmpPage extends StatefulWidget {
  String token;
  ShowEmpPage(this.token);

  @override
  State<ShowEmpPage> createState() => _ShowEmpPageState(token);
}

class _ShowEmpPageState extends State<ShowEmpPage> {
  String token;
  EmployeeModel employeeModel = new EmployeeModel();
  bool isApiCallProcess = true;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  APIService apiService = new APIService();

  _ShowEmpPageState(this.token);

  @override
  void initState() {
    super.initState();
    runZoned(() {
      _loadEmployeeData();
      // ignore: deprecated_member_use
    }, onError: (dynamic e, StackTrace stack) {
      Navigator.of(context).popUntil(ModalRoute.withName("/"));
    });
  }

  _loadEmployeeData() {
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
        create: (_) => employeeModel,
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: new Scaffold(
              backgroundColor: const Color.fromARGB(255, 103, 158, 254),
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
                    onPressed: (_) {
                      runZoned(() {
                        _deleteConfirm(context, index);
                        // ignore: deprecated_member_use
                      }, onError: (dynamic e, StackTrace stack) {
                        Navigator.of(context)
                            .popUntil(ModalRoute.withName("/"));
                      });
                    },
                    backgroundColor: Color(0xFF7BC043),
                    foregroundColor: Color.fromARGB(255, 227, 21, 21),
                    icon: Icons.edit,
                    label: 'Delete',
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
                              text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text:
                                    '${employee.employees[index].employeeName}',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.blue)),
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
                              tileColor: Color.fromARGB(255, 242, 242, 231),
                              title: Text(
                                'Job:    ${employee.employees[index].jobDesc}',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 93, 33, 243)),
                              ),
                              //    trailing: Icon(Icons.more_vert)
                              trailing: _menu(
                                  context,
                                  employeeModel.employees[index].employeeID ??
                                      '',
                                  index),
                              onTap: () {},
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
    return PopupMenuButton<String>(
      color: Color.fromARGB(255, 250, 243, 247),
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'Modify',
          child: Text('Modify'),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'Assets',
          child: Text('Assets'),
        )
      ],
      onSelected: (String menuItem) {
        Image _image = Image.memory(Uint8List.fromList(kTransparentImage));

        if (menuItem == 'Assets') {
          apiService
              .getAssetImage((new JDERequestModel.withKey(
                  token, employeeModel.employees[index].employeeID)))
              .then((value) {
            _image = value;
          });

          scaffoldKey.currentState?.showBottomSheet(
            (BuildContext context) {
              return Container(
                height: 82,
                color: Color.fromARGB(255, 235, 242, 245),
                child: Center(
                    child: Column(children: <Widget>[
                  _image,
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
        } else if (menuItem == 'Modify') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  settings: RouteSettings(name: "/EMPPage"),
                  builder: (context) {
                    return EditEmpPage.withIndex(token, index);
                  }));
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
                    try {
                      apiService
                          .deleteEmployee(new JDERequestModel.withKey(token,
                              employeeModel.employees[listIndex].employeeID))
                          .then((value) {
                        if (value) {
                          employeeModel.deleteEmployee(listIndex);
                          final snackBar = SnackBar(
                            content: Text("Delete Success"),
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.only(
                                top: 100), // Adjust the top margin as needed
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          //    Future.delayed(Duration(seconds: 5));
                          //    _loadEmployeeData();
                        }
                      });
                    } on Exception {
                      Navigator.of(context).popUntil(ModalRoute.withName("/"));
                    }

                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }
}
