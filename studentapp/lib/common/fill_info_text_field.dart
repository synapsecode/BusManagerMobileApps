import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

Widget fillInfoTextField({TextEditingController controller, String hintName}) {
  return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10),
      child: TextField(
        controller: controller,
        decoration: inputDecoration(hintName: hintName),
      ));
}

InputDecoration inputDecoration({String hintName}) {
  return InputDecoration(
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.black)),
      border: OutlineInputBorder(),
      hintText: hintName,
      hintStyle: TextStyle(color: Colors.black54));
}

Widget suggestionTextInfoField({
  TextEditingController controller,
  List suggestions,
  String hint,
  Function(dynamic) onSelect,
  bool isEditMode = false,
}) {
  if (isEditMode) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0, top: 12, bottom: 3),
            child: Text(
              hint,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TypeAheadField(
            hideOnEmpty: true,
            textFieldConfiguration: TextFieldConfiguration(
              controller: controller,
              decoration: inputDecoration(hintName: hint),
            ),
            suggestionsCallback: (pattern) {
              return suggestions.where((e) => e.startsWith(pattern));
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                leading: Icon(Icons.location_city),
                title: Text(suggestion),
              );
            },
            onSuggestionSelected: (suggestion) {
              controller.text = suggestion;
              if (onSelect != null) onSelect(suggestion);
            },
          ),
        ],
      ),
    );
  } else {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10),
      child: TypeAheadField(
        hideOnEmpty: true,
        textFieldConfiguration: TextFieldConfiguration(
          controller: controller,
          decoration: inputDecoration(hintName: hint),
        ),
        suggestionsCallback: (pattern) {
          return suggestions.where((e) => e.startsWith(pattern));
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            leading: Icon(Icons.location_city),
            title: Text(suggestion),
          );
        },
        onSuggestionSelected: (suggestion) {
          controller.text = suggestion;
          if (onSelect != null) onSelect(suggestion);
        },
      ),
    );
  }
}
