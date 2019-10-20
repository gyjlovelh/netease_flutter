import 'package:flutter/material.dart';

class NeteaseSearchResult extends StatefulWidget {

  @override
  _NeteaseSearchResultState createState() => _NeteaseSearchResultState();
}

class _NeteaseSearchResultState extends State<NeteaseSearchResult> {
  TextEditingController _searchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    String searchWord = ModalRoute.of(context).settings.arguments;
    _searchController.text = searchWord;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'abcde'
          ),
        ),
      ),
    );
  }
}