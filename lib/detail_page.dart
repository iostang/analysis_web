import 'package:flutter_web/material.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order"),),
      body: Container(
      child: Text("测试页面"),
    ),
    );
  }
}