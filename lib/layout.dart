import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {



  void changeMenu(v){
      new AlertDialog(
        title: new Text("test alert $v")
      );
  }
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "app",
      home: new Scaffold(
        drawer: new MyDrawer((v){
          print(v);
          changeMenu(v);
        }),
        appBar: new AppBar(
          title: new Text("title"),
        ),
        body: new ListView(
          children: <Widget>[
            new Image.asset(
              'images/lake.jpg',
              width: 640.0,
              height: 240.0,
              fit: BoxFit.cover,
            ),
            new TitleSection(),
            new ButtonSection(),
            new TextSection(),
          ]

        ),
      ),
    );
  }
}


class TextSection extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new Container(
      padding: const EdgeInsets.all(32.0),
      child: new Text(
        '''
Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese Alps. Situated 1,578 meters above sea level, it is one of the larger Alpine Lakes. A gondola ride from Kandersteg, followed by a half-hour walk through pastures and pine forest, leads you to the lake, which warms to 20 degrees Celsius in the summer. Activities enjoyed here include rowing, and riding the summer toboggan run.
        ''',
        softWrap: true,),
    );
  }
}
class ButtonSection extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    Column buildButtonColumn(IconData icon,String label){
      Color color = Theme.of(context).primaryColor;
      return new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Icon(icon,color: color),
          new Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: new Text(
              label,
              style: new TextStyle(
                fontWeight: FontWeight.w400,
                color: color,
                fontSize: 12.0
              ),
            ),
          )
        ],
      );
    }
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        buildButtonColumn(Icons.call, 'CALL'),
        buildButtonColumn(Icons.near_me, 'NEAR ME'),
        buildButtonColumn(Icons.share, "SHARE")
      ],
    );
  }

}

class TitleSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: const EdgeInsets.all(32.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
              child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: new Text(
                  'Oeschinen Lake Campground',
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              new Text(
                'Kandersteg, Switzerland',
                style: new TextStyle(color: Colors.green[500]),
              )
            ],
          )),
          /*
          new Icon(
            Icons.star,
            color: Colors.red[500],
          ),
          new Text("41")*/
          new FavoriteWidget()
        ],
      ),
    );
  }
}

class FavoriteWidget extends StatefulWidget{
  @override
  _StateFavoriteWidget createState() => new _StateFavoriteWidget();

}
class _StateFavoriteWidget extends State<FavoriteWidget>{
  bool _isFavorite = true;
  int _countFavorite = 41;
  void _pressFavoriteButton(){
    setState((){
      if (_isFavorite){
        _isFavorite = false;
        _countFavorite--;
      }else{
        _isFavorite = true;
        _countFavorite ++;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new IconButton(
            icon: new Icon(_isFavorite?Icons.star:Icons.star_border,color: Colors.red,),
            onPressed: _pressFavoriteButton),
        new Text('$_countFavorite')
      ],
    );
  }

}

class MyDrawer extends StatefulWidget{
  /*MyDrawer({Key key,this.app_title, this.onChange})
      :super(key:key);*/
  MyDrawer(this.onChange):super();


  final ValueChanged<String> onChange;
  @override
  _StateDrawer createState() => new _StateDrawer(this.onChange);

}

class _StateDrawer extends State<MyDrawer>{
  _StateDrawer(this.onChange)
     :super();

  ValueChanged<String> onChange;

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          //new DrawerHeader(child: new Text("Header")),
          new ListTile(leading: new Icon(Icons.add), title: new Text("add"),onTap: (){
            this.onChange("add");
            Navigator.of(context).pop();
          },),
          new AboutListTile(icon: new Icon(Icons.add), child: new Text("add")),
          new AboutListTile(icon: new Icon(Icons.add), child: new Text("add")),
          new AboutListTile(icon: new Icon(Icons.add), child: new Text("add")),
          new AboutListTile(icon: new Icon(Icons.add), child: new Text("add")),
          new AboutListTile(icon: new Icon(Icons.add), child: new Text("add")),
          new AboutListTile(icon: new Icon(Icons.add), child: new Text("add")),
          new AboutListTile(icon: new Icon(Icons.add), child: new Text("add")),
          new AboutListTile(icon: new Icon(Icons.add), child: new Text("add")),
          new AboutListTile(icon: new Icon(Icons.add), child: new Text("remove")),
          new AboutListTile(icon: new Icon(Icons.add), child: new Text("remove")),
          new AboutListTile(
            icon: new Icon(Icons.add),
            child: new Text("about"),
          applicationName: "test",
          applicationIcon: new Icon(Icons.vertical_align_bottom),
          applicationVersion: "1.0",
          applicationLegalese: "ds ads sdfs fsd fsf s df sf sdf ",),
        ],
      ),
    );
  }

}
