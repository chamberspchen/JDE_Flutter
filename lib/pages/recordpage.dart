import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class Record {
  String? name;
  String? details;

  Record({this.name, this.details});
}

class RecordProvider extends ChangeNotifier {
  List<Record> _records = [
    Record(name: "Record 1", details: "Details for Record 1"),
    Record(name: "Record 2", details: "Details for Record 2"),
    // Add more records as needed
  ];

  List<Record> get records => _records;

  void updateDetails(int index, String newDetails) {
    _records[index].details = newDetails;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RecordProvider(),
      child: MaterialApp(
        home: RecordListPage(),
      ),
    );
  }
}

class RecordListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var recordProvider = Provider.of<RecordProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Record List"),
      ),
      body: ListView.builder(
        itemCount: recordProvider.records.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(recordProvider.records[index].name!),
            subtitle: Text(recordProvider.records[index].details!),
            onTap: () {
              // Navigate to the detail page when a record is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Builder(
                    builder: (BuildContext context) =>
                        RecordDetailPage(index: index),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class RecordDetailPage extends StatelessWidget {
  final int? index;

  RecordDetailPage({this.index});

  @override
  Widget build(BuildContext context) {
    var recordProvider = Provider.of<RecordProvider>(context);
    var record = recordProvider.records[index!];

    return Scaffold(
      appBar: AppBar(
        title: Text("Record Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${record.name}"),
            SizedBox(height: 8),
            Text("Details: ${record.details}"),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: "New Details"),
              onChanged: (value) {
                // Update details in the provider when text field changes
                recordProvider.updateDetails(index!, value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
