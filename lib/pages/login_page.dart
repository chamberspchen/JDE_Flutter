//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_http_post_request/api/api_service.dart';
import 'package:flutter_http_post_request/model/login_model.dart';
import 'package:flutter_http_post_request/pages/employee_page.dart';

import '../ProgressHUD.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hidePassword = true;
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  LoginRequestModel loginRequestModel;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  get flatButtonStyle => null;
  @override
  void initState() {
    super.initState();
    loginRequestModel = new LoginRequestModel();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  margin: EdgeInsets.symmetric(vertical: 85, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).primaryColor,
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).hintColor.withOpacity(0.2),
                          offset: Offset(0, 10),
                          blurRadius: 20)
                    ],
                  ),
                  child: Form(
                    key: globalFormKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 25),
                        Text(
                          "E1 9.2 Login",
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        SizedBox(height: 20),
                        new TextFormField(
                          //"eve.holt@reqres.in"
                          textAlign: TextAlign.left,
                          initialValue: "JDE", //user id
                          keyboardType: TextInputType.name,
                          onSaved: (input) => loginRequestModel.user = input,
                          validator: (input) =>
                              input.isEmpty ? "User Id should be valid" : null,
                          decoration: new InputDecoration(
                            hintText: "User ID",
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2))),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor)),
                            prefixIcon: Icon(
                              Icons.chat,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        new TextFormField(
                          textAlign: TextAlign.left,
                          initialValue: "JDE", //password
                          //          style:
                          //             TextStyle(color: Theme.of(context).accentColor),
                          keyboardType: TextInputType.text,
                          onSaved: (input) =>
                              loginRequestModel.password = input,
                          //elve.holt@reqres.in
                          validator: (input) => input.isEmpty
                              ? "Password should not be blank"
                              : null,
                          obscureText: hidePassword,
                          decoration: new InputDecoration(
                            hintText: "Password",
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2))),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor)),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Theme.of(context).accentColor,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.4),
                              icon: Icon(hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        new TextFormField(
                          textAlign: TextAlign.left,
                          initialValue: "JDV920",
                          // style:
                          //     TextStyle(color: Theme.of(context).accentColor),
                          keyboardType: TextInputType.text,
                          onSaved: (input) => loginRequestModel.env = input,
                          //elve.holt@reqres.in
                          validator: (input) => input.isEmpty
                              ? "Environment should not be blank"
                              : null,

                          decoration: new InputDecoration(
                            hintText: "Environment",
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2))),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor)),
                            prefixIcon: Icon(
                              Icons.library_books,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        new TextFormField(
                          initialValue: "*ALL",
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.text,
                          onSaved: (input) => loginRequestModel.role = input,
                          validator: (input) =>
                              input.isEmpty ? "Role should not be blank" : null,
                          decoration: new InputDecoration(
                            hintText: "Role",
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2))),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor)),
                            prefixIcon: Icon(
                              Icons.man,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          //      padding: EdgeInsets.symmetric(
                          //          vertical: 12, horizontal: 80),
                          onPressed: () {
                            if (validateAndSave()) {
                              //         print(loginRequestModel.toJson());

                              setState(() {
                                isApiCallProcess = true;
                              });

                              APIService apiService = new APIService();
                              apiService.login(loginRequestModel).then((value) {
                                if (value != null) {
                                  setState(() {
                                    isApiCallProcess = false;
                                  });

                                  if (value.token.isNotEmpty) {
                                    final snackBar = SnackBar(
                                        content: Text("Login Successful"));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    //           scaffoldKey.currentState
                                    //               .showSnackBar(snackBar);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            settings: RouteSettings(
                                                name: "/ShowEMPPage"),
                                            builder: (context) {
                                              return ShowEmpPage(value.token);
                                            }));
                                  } else {
                                    final snackBar =
                                        SnackBar(content: Text(value.error));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    //          scaffoldKey.currentState
                                    //              .showSnackBar(snackBar);
                                  }
                                } else {
                                  final snackBar =
                                      SnackBar(content: Text("Login Failure!"));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  setState(() {
                                    isApiCallProcess = false;
                                  });
                                }
                              });
                            }
                          },
                          child: Text(
                            "Login",
                            //        style: TextStyle(color: Colors.blue),
                          ),
                          // color: Theme.of(context).accentColor,
                          // shape: StadiumBorder(),
                          style: flatButtonStyle,
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    if (globalFormKey.currentState.validate()) {
      globalFormKey.currentState.save();
      return true;
    }
    return false;
  }
}
