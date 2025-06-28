import 'package:flutter/material.dart';
import 'package:all_in_one_dropdown/all_in_one_dropdown.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DropDownDataModel selectedItem = DropDownDataModel();

  final items = <DropDownDataModel>[
    DropDownDataModel(id: '1', title: 'Apple'),
    DropDownDataModel(id: '2', title: 'Banana'),
    DropDownDataModel(id: '3', title: 'Cherry'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: CustomDropdown(
              items: items,
              selectedItem: selectedItem.id == null ? null : selectedItem,
              hintText: 'Choose a fruit',
              isSearch: true,
              onChanged: (value) {
                setState(() {
                  selectedItem = value;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
