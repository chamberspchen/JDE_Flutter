import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyController extends GetxController {
  var message = "Loading...".obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() async {
    // Simulate a delay for loading data
    //  await Future.delayed(Duration(seconds: 50));
    message.value = "Data loaded successfully!";
    update();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Getx Example"),
        ),
        body: Center(
          child: GetBuilder<MyController>(
            init: MyController(),
            builder: (controller) {
              return Text(controller.message.value);
            },
          ),
        ),
      ),
    );
  }
}
