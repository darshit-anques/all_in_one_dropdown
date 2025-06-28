# all_in_one_dropdown

A powerful and customizable Flutter package for creating dropdowns with multiple modes:  
🔹 Normal dropdown  
🔹 Searchable dropdown  
🔹 Multi-select dropdown

This package is designed to be reusable and flexible, making dropdown integration seamless for any Flutter project.

---

## ✨ Features

- ✅ Normal dropdown
- 🔍 Searchable dropdown
- ✅ Multi-select dropdown
- 🎨 Highly customizable appearance
- 📱 Responsive design with smooth keyboard handling
- ⚡ Easy integration and reusable components

---

## 🚀 Installation

Add the following line to your `pubspec.yaml`:

## 📸 Screenshot

<p align="center">
  <img src="https://github.com/darshit-anques/all_in_one_dropdown/blob/main/assets/Screenshot1.png?raw=true" width="30%" />
  <br/>Normal Dropdown
</p>

<p align="center">
  <img src="https://github.com/darshit-anques/all_in_one_dropdown/blob/main/assets/Screenshot2.png?raw=true" width="30%" />
  <br/>Searchable Dropdown
</p>

<p align="center">
  <img src="https://github.com/darshit-anques/all_in_one_dropdown/blob/main/assets/Screenshot3.png?raw=true" width="30%" />
  <br/>Multi-Select Dropdown
</p>

```yaml
dependencies:
  all_in_one_dropdown: ^1.0.0


import 'package:flutter/material.dart';
import 'package:all_in_one_dropdown/all_in_one_dropdown.dart';

final selectedItems = DropDownDataModel();
final items = <DropDownDataModel>[
  DropDownDataModel(id: '1', title: 'Apple'),
  DropDownDataModel(id: '2', title: 'Banana'),
  DropDownDataModel(id: '3', title: 'Cherry'),
  DropDownDataModel(id: '4', title: 'Watermelon fruit'),
  DropDownDataModel(id: '5', title: 'Grapes'),
  DropDownDataModel(id: '6', title: 'Guava'),
  DropDownDataModel(id: '7', title: 'Orange'),
  DropDownDataModel(id: '8', title: 'Strawberry'),
  DropDownDataModel(id: '9', title: 'Coconut'),
  DropDownDataModel(id: '10', title: 'Pineapple'),
];

...

Container( 
  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  child: CustomDropdown(
    items: items,
    selectedItem: selectedItems.id == null ? null : selectedItems,
    hintText: 'Choose a fruit',
    isSearch: true, // Enable or disable search field
    onChanged: (value) {
      selectedItems.id = value.id;
      selectedItems.title = value.title;
    },
    buttonBackgroundColor: Color(0xFF171717),
    borderColor: Color(0xFF292929),
    dropdownIconColor: Colors.white,
    hintTextColor: Color(0xFF707070),
    dropdownBackgroundColor: Color(0xFF171717),
    dropdownTextColor: Colors.white,
    searchBackgroundColor: Color(0xFF252525),
    searchTextColor: Colors.white,
    searchIconColor: Colors.white,
    textColor: Colors.white,
  ),
),
