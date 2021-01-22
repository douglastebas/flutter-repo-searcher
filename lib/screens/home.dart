import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:repo_searcher/models/repository.dart';
import 'package:repo_searcher/components/form_repository.dart';
import 'package:repo_searcher/components/list_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _scrollController = new ScrollController();

  var _repositories = new List<Repository>.empty();
  var _loading = false;
  var _finishScroll = false;
  var _currentPage = 1;
  var _repo = '';

  @override
  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      var pixels = _scrollController.position.pixels;
      var scrollSize = _scrollController.position.maxScrollExtent;

      if (pixels == scrollSize && !_finishScroll) {
        searchRepositories(page: _currentPage + 1);
      }
    });
  }

  Future<void> searchRepositories({int page = 1}) async {
    if (_loading) return;

    if (page == 1 && _repositories.isNotEmpty) {
      _repositories.clear();
      _scrollController.animateTo(0,
          duration: Duration(seconds: 1), curve: Curves.easeInOut);
    }

    setState(() {
      _loading = true;
      _finishScroll = false;
    });

    var response = await http.get(
        "https://api.github.com/search/repositories?q=$_repo&page=$page&per_page=10");
    var data = jsonDecode(response.body);
    var items = data['items'] as List;

    setState(() {
      _loading = false;
      _currentPage = page;

      if (items.isEmpty) {
        _finishScroll = true;
        return;
      }

      _repositories += items.map((e) => Repository.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Repositórios no Github"),
        ),
        body: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10.0),
            child: Column(children: <Widget>[
              FormRepository(
                repo: _repo,
                changeRepo: (value) => setState(() => {_repo = value}),
                onSearch: searchRepositories,
                loading: _loading,
              ),
              if (_repositories.isNotEmpty)
                Expanded(
                  child: ListRepository(
                      controller: _scrollController,
                      repositories: _repositories),
                ),
              if (_loading)
                Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator()),
            ])));
  }
}
