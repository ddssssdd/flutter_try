import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'drawer.dart';
import 'http/http.dart' as http;


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'This is title',
      theme: new ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Scan anything'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title,this.onMenuSelected}) : super(key: key);

  final String title;

  final ValueChanged<String> onMenuSelected;


  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _access_token;
  http.JsonResult _result;
  String scan_result='';


  void _doActionNew(){
    setState((){
      _result = null;
    });

  }
  Future scan() async {
    try {
      _result = null;
      String barcode = await BarcodeScanner.scan();
      _doSearch(barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.scan_result = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.scan_result = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.scan_result = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.scan_result = 'Unknown error: $e');
    }
  }
  void _doMenuSelected(String menuKey){
    Navigator.of(context).pop();
    _doSearch(menuKey);
  }
  void _doSearch(String key) async{
    if (_access_token == null){
      await http.initGetToken((result){
        setState((){
          _access_token=result;
        });
      });
    }

    await http.getData(_access_token, key, (json){
      setState((){
        _result =json;
      });
    });
  }
  Widget _buildBody(){
    if (_result==null || _result.status==false){
      return  new TextField(onSubmitted: _doSearch,);
    }
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i){
        if (i.isOdd) return new Divider();

        final index = i ~/2;
        if (index==_result.searchResult.items.length){
          //need more data,so fetch from backend;
        }else{
          return _buildRow(_result.searchResult.items[index],index+1);
        }


      },
    );
  }
  Widget _buildRow(http.SearchItem item,index){
    final alreadySaved = item.hasChild==1?true:false;
    return new ListTile(
      leading: new Text("$index"),
      title: new Text(item.title),
      subtitle: new Text(item.createdDate+":"+item.content,softWrap: true,),
      trailing: new Icon(
          alreadySaved?Icons.check_box:Icons.check_box_outline_blank,
          color: alreadySaved?Colors.red:null
      ),
      onTap: (){
        setState((){

        });
      },
    );
  }
  List<Widget> _createSearchResult(){
    List<Widget> results = new List<Widget>();
    if (_result==null || _result.status==false){
      results.add(new ListTile( title: new Text("No data found")));
    }else{

      for(http.SearchItem item in _result.searchResult.items){
        results.add(new ListTile(
          title: new Text(item.title),
          subtitle: new Text(item.createdDate),
          trailing: new Icon(item.hasChild==1?Icons.show_chart:Icons.star_border),
        ));
      }
    }
    return results;
  }

  String _username;
  String _password;
  void _loginWithPass(String password){

  }
  void _doLogin() async{
    _formKey.currentState.save();
    http.HttpConst.username = _username.trim().toLowerCase();
    http.HttpConst.password = _password.toLowerCase().trim();

    await http.initGetToken((result){
      setState((){
        _access_token=result;
        http.HttpConst.isLogin = true;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    if (http.HttpConst.isLogin){
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: _buildBody(),
        drawer: new GalleryDrawer(
          onMenuSelected: _doMenuSelected,

        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: _doActionNew,
          tooltip: 'Scan',
          child: new Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
    }else{

      return new Scaffold(
        appBar: new AppBar(
          title: new Text('Login'),
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.fingerprint), onPressed: _doLogin)
          ],
        ),
        body: new SafeArea(
            top:false,
            bottom: false,
            child: new Form(
              key: _formKey,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'username',
                      labelText: 'Username'
                    ),
                    onSaved: (username){_username=username;},
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.title),
                      hintText: 'password',
                      labelText: 'Password'
                    ),
                    onSaved: (password){_password=password;},
                    onFieldSubmitted: _loginWithPass,
                  ),
                  new Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: new RaisedButton(
                      child: new Text("Login"),
                      onPressed: _doLogin,
                    )
                  )
                ],
              ),
            ))
      );
    }

  }
}
