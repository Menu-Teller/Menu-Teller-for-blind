import 'package:flutter/material.dart';
import 'http.dart';

class MenuList extends StatefulWidget {
  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: Text('주변 식당 List'),
      ),
      body: _buildSuggestions(),
    );
  }
  Widget _buildSuggestions() {
    return ListView.separated(
      padding: EdgeInsets.all(5),
      itemCount : json["menus"].length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height:50,
          color: Colors.amber[100],
          child: RaisedButton(
            child: Text('${json["menus"][index]["title"]}'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MenuDetail(index: index)),
              );
            },
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}

class MenuDetail extends StatelessWidget {
  final int index;
  MenuDetail({Key key, @required this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu List'),
      ),
      body: _buildSuggestions(),
    );
  }
  Widget _buildSuggestions() {
    return ListView.separated(
      padding: EdgeInsets.all(3),
      itemCount : json["menus"].length - 2,
      itemBuilder: (BuildContext context, int i) {
        return Container(
          height:50,
          color: Colors.amber[100],
          child: Center(
            child: Text('${json["menus"][index]["menu${i+1}"]}'),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}