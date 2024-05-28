import 'dart:io';
import 'dart:ui';

import 'package:csv/csv.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateRangePickerController _controller = DateRangePickerController();

  @override
  void initState() {
    _controller.view = DateRangePickerView.month;
    super.initState();
  }

  List<List<dynamic>>? tttt;
  Future<List<List<dynamic>>> processCsv(String result) async {
    return const CsvToListConverter().convert(result);
  }

  Map<String, List<dynamic>> result = {};
  ttt() async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'csv',
      extensions: <String>['csv'],
    );
    final XFile? file =
        await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);

    // #enddocregion MultiOpen
    if (file == null) {
      return;
    } else {
      tttt = await processCsv(await file.readAsString());
      setState(() {});
    }
    // Initialize the map

    if (tttt != null && tttt!.isNotEmpty) {
      List<String> headers = List<String>.from(tttt![0]);

      // Initialize the lists in the map for each header
      for (String header in headers) {
        result[header] = [];
      }

      for (int i = 1; i < tttt!.length; i++) {
        var row = tttt?[i];
        if (row != null) {
          for (int j = 0; j < headers.length; j++) {
            dynamic cell;
            if (j < row.length) {
              cell = row[j];
            } else {
              cell = "";
            }

            result[headers[j]]?.add(cell == "" ? "-1" : cell);
          }
        }
      }
    }

    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Data'),
      ),
      body: result == {}
          ? SizedBox()
          : ListView.builder(
              itemCount: result.keys.length,
              itemBuilder: (context, index) {
                String key = result.keys.elementAt(index);
                List<dynamic> values = result[key]!;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.grey[300],
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            key,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Column(
                          children: values.map((value) {
                            return ListTile(
                              title: Text(value.toString()),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ttt();
        },
        child: Text("Aaaa"),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';

// void main() => runApp(SelectionRadius());

// class SelectionRadius extends StatelessWidget {
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: SafeArea(
//           child:
//               //  Card(
//               //   margin: const EdgeInsets.fromLTRB(50, 150, 50, 150),
//               //   child:
//               SfDateRangePicker(
//             view: DateRangePickerView.month,
//             selectionMode: DateRangePickerSelectionMode.multiple,
//             selectionRadius: 20,
//             //  ),
//           ),
//         ),
//       ),
//     );
//   }
// }
