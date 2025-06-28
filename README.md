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

## Platform Support

| Android | iOS | MacOS | Web | Linux | Windows |
| :-----: | :-: | :---: | :-: | :---: | :-----: |
|   ✅    | ✅  |  ✅   | ✅  |  ✅   |   ✅    |

## Requirements

- Flutter >=3.18.0-18.0.pre.54
- Dart >=3.8.0 <4.0.0
- iOS >=12.0
- MacOS >=10.14
- Android `compileSDK` 34
- Java 17
- Android Gradle Plugin >=8.7.3
- Gradle wrapper >=8.12

## 📸 Screenshot

<table>
  <tr>
    <td>
        <img src="https://github.com/darshit-anques/all_in_one_dropdown/blob/master/assets/Screenshot1.png?raw=true"/>
        <br/>
        <b>Normal Dropdown</b>
    </td>
    <td>
        <img src="https://github.com/darshit-anques/all_in_one_dropdown/blob/master/assets/Screenshot2.png?raw=true"/>
        <br/>
        <b>Searchable Dropdown</b>
    </td>
    <td>
        <img src="https://github.com/darshit-anques/all_in_one_dropdown/blob/master/assets/Screenshot3.png?raw=true" alt=""/>
        <br/>
        <b>Multi-Select Dropdown</b>
    </td>
  </tr>
</table>

## 🚀 Installation

Add the following line to your `pubspec.yaml`:
```yaml
dependencies:
  all_in_one_dropdown: ^1.0.0
```

### Import library in your file
```dart
import 'package:all_in_one_dropdown/all_in_one_dropdown.dart';
```

### Create below variables
```dart
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
```

### This is how we can used
```dart
Container(
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
```

### Here is full example
```dart
class ExampleDropdownScreen extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CustomDropdown(
          items: items,
          selectedItem: selectedItems.id == null ? null : selectedItems,
          hintText: 'Choose a fruit',
          isSearch: true,
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
    );
  }
}
```
## LICENSE!

**drop_down_list**
is [MIT-licensed.](https://github.com/Mindinventory/drop_down_list/blob/main/LICENSE)
