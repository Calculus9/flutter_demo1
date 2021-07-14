import 'package:flutter/material.dart';

typedef SearchInputOnFocusCallback = void Function();
typedef SearchInputOnSubmittedCallback = void Function(String value);

// ignore: must_be_immutable
class SearchInputWidget extends StatelessWidget {
  TextEditingController textController;

  SearchInputOnFocusCallback onTap;
  SearchInputOnSubmittedCallback onSubmitted;

  SearchInputWidget({this.onSubmitted, this.onTap, this.textController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: onSubmitted,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: "搜索",
        filled: true,
        fillColor: Color.fromARGB(255, 240, 240, 240),
        contentPadding: EdgeInsets.only(left: 10),
        prefixIcon: Icon(
          Icons.search,
          color: Colors.black26,
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none),
      ),
    );
  }
}
