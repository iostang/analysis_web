
import 'package:flutter_web/material.dart';

import 'package:flutter_web/foundation.dart';
import 'package:analysis_web/detail_page.dart';
import 'package:analysis_web/home_page_model.dart';
import 'package:analysis_web/menu_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.onTapDrawer}) : super(key: key);

  final String title;
  final ValueChanged<bool> onTapDrawer;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> items = List<String>();

  List<Color> colors = [
    Color(0xFF4B89D8),
    Color(0xFFE35BA0),
    Color(0xFF33C3C8),
    Color(0xFF915CE3),
    Color(0xFFFFBA00),
    Color(0xFF90C224)
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HomePageModel>(
      future: fetchDatas(context),
      builder: (BuildContext context, AsyncSnapshot<HomePageModel> snapshot) {
        return buildScaffoldView(snapshot.data);
      },
    );
  }

  Widget buildScaffoldView(HomePageModel model) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFFAFAFA),
      drawer: MenuPage(onTapMenu: (tap) {
        _scaffoldKey.currentState.openEndDrawer();
        widget.onTapDrawer(true);
      }),
      appBar: AppBar(
        leading: MaterialButton(
          onPressed: () {
            if (_scaffoldKey.currentState != null) {
              _scaffoldKey.currentState.openDrawer();
            }
          },
          child: Icon(Icons.mail),
        ),
        title: Text(
          "Analysis",
          style: TextStyle(
              fontFamily: "Avenir-Black",
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: buildRootView(model),
      ),
    );
  }

  Widget buildRootView(HomePageModel model) {
    return ListView(
      children: <Widget>[
        buildMenuView(model),
        buildAppListView(model),
      ],
    );
  }

  Widget buildMenuView(HomePageModel model) {
    var size = MediaQuery.of(context).size;

    final double itemWidth = size.width / 2;
    final double itemHeight = 120;
    
    return Container(
      color: Colors.transparent,
      child: GridView.builder(
        controller: ScrollController(keepScrollOffset: false),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: model.data.menuList.length,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: (itemWidth / itemHeight),
        ),
        itemBuilder: (BuildContext context, int index) {
          return buildCell(context, model, index);
        },
      ),
    );
  }

  Widget buildCell(BuildContext context, HomePageModel model, int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0.0),
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: Container(
                          color: colors[index % colors.length],
                          width: 6,
                          height: 16),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        model.data.menuList[index].title,
                        style: TextStyle(
                            color: colors[index],
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                child: Text("${model.data.menuList[index].value}",
                    maxLines: 1,
                    textScaleFactor: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Color(0xFF55565F),
                        fontSize: 24,
                        fontFamily: "Avenir-Black")),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAppListView(HomePageModel model) {
    double h = model.data.appList.length * 100.0;
    return Container(
      height: h,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: model.data.appList.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return GestureDetector(
            onTap: () {
              pushDetail();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                    height: 50,
                    color: Color(0xFF7D8DFF),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            model.data.appList[index].title,
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          Image.asset("images/btn_more.png")
                        ],
                      ),
                    )),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<HomePageModel> fetchDatas(BuildContext context) async {
    HomePageModel model = HomePageModel();
    HomePageData data = HomePageData();
    data.menuList = [
      MenuList(name: "1", value: "88866699333", title: "订单数量"),
      MenuList(name: "2", value: "33333333", title: "有效订单数量"),
      MenuList(name: "3", value: "999999999", title: "订单金额"),
      MenuList(name: "4", value: "99999999", title: "有效订单金额"),
      MenuList(name: "5", value: "8888888888", title: "订单间夜"),
      MenuList(name: "6", value: "66666666666", title: "有效订单间夜")
    ];
    data.appList = [
      AppList(title: "订单")
    ];
    model.data = data;
    return model;
    // String value = await DefaultAssetBundle.of(context).loadString("data/homepage.json");
    // print(value);
    // HomePageModel model = HomePageModel.fromJson(json.decode(value));
    // return model;
  }

  void pushDetail() {
    MaterialPageRoute route = MaterialPageRoute(builder: (page) {
        return DetailPage();
    });
    Navigator.of(context).push(route);
  }

}
