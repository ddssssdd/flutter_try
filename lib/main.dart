import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';


void main() => runApp(new ImagesApp());

class ImagesApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      title: 'Search for images',
      home:new ImagesHome(title:'Good for eyes'),
    );
  }
}
class ImagesHome extends StatefulWidget{
  ImagesHome({Key key, this.title}):super(key:key);
  final String title;
  @override
  _StateImagesHome createState() => new _StateImagesHome();
}
/*
"webSearchUrl": "https://www.bing.com/images/search?view=detailv2&FORM=OIIRPO&q=tom+hanks&id=4C492277847F473D55B56EF0046740CEDBAFF8BF&simid=608000073702966800",
"name": "Tom Hanks Net Worth ,Money and More - Rich Glare",
"thumbnailUrl": "https://tse4.mm.bing.net/th?id=OIP.TPxDKhCQfiednpudsuDMmwHaLE&pid=Api",
"datePublished": "2018-02-15T21:36:00.0000000Z",
"contentUrl": "http://richglare.com/wp-content/uploads/2014/02/tom-hanks-sag-awards-2014.jpg",
"hostPageUrl": "http://richglare.com/tom-hanks-net-worth-money/",
"contentSize": "185103 B",
"encodingFormat": "jpeg",
"hostPageDisplayUrl": "richglare.com/tom-hanks-net-worth-money",
"width": 817,
"height": 1222,
"thumbnail": {
"width": 474,
"height": 708
},
"imageInsightsToken": "ccid_TPxDKhCQ*mid_4C492277847F473D55B56EF0046740CEDBAFF8BF*simid_608000073702966800*thid_OIP.TPxDKhCQfiednpudsuDMmwHaLE",
"insightsMetadata": {
"pagesIncludingCount": 6,
"availableSizesCount": 1
},
"imageId": "4C492277847F473D55B56EF0046740CEDBAFF8BF",
"accentColor": "AD1227"
*/
class ImageItem{
  String imageId;
  String name;
  String contentUrl;
  String thumbnailUrl;
  String contentFormat;
  int width;
  int height;
  int thumbnailWidth;
  int thumbnailHeight;
  bool isFavorite;
  ImageItem(Map json){
    this.imageId = json["imageId"];
    this.name = json['name'];
    this.contentUrl = json['contentUrl'];
    this.thumbnailUrl = json['thumbnailUrl'];
    this.contentFormat= json['contentFormat'];
    this.width = json['width'];
    this.height = json['height'];
    this.thumbnailWidth = json['thumbnail']['width'];
    this.thumbnailHeight = json['thumbnail']['height'];
    //print (this.thumbnailUrl);
    this.isFavorite = false;
  }
}
class GridDemoPhotoItem extends StatelessWidget {
  GridDemoPhotoItem({
    Key key,
    this.photo
  }) : super(key: key);

  final ImageItem photo;


  void showPhoto(BuildContext context) {
    Navigator.push(context, new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new Scaffold(
            appBar: new AppBar(
                title: new Text(photo.name)
            ),
            body: new SizedBox.expand(
              child: new Hero(
                tag: photo.imageId,
                child: new Image.network(photo.contentUrl,fit: BoxFit.cover,),

              ),
            ),
          );
        }
    ));
  }

  @override
  Widget build(BuildContext context) {
    final Widget image = new GestureDetector(
        onTap: () { showPhoto(context); },
        child: new Hero(
            key: new Key(photo.imageId),
            tag: photo.imageId,
            child:
            new Image.network(photo.thumbnailUrl,fit: BoxFit.cover,)

        )
    );

    final IconData icon = photo.isFavorite ? Icons.star : Icons.star_border;
    return image;

  }
}
class _StateImagesHome extends State<ImagesHome>{

  @override
  void initState(){
    super.initState();
    getHistory();
  }
  bool _inSearch= true;
  List<SearchItem> _searchItems = new List<SearchItem>();
  String _search;
  int _offset =0;
  List<ImageItem> _items = new List<ImageItem>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  void _doSearch() async {
    _formKey.currentState.save();
    _doSearchWithKey(_search);
  }
  void _doSearchWithKey(String key) async{
    setState((){ _inSearch = false;});

    var url = 'https://api.cognitive.microsoft.com/bing/v7.0/images/search?q=$key&count=150&offset=$_offset';
    var httpClient = new HttpClient();
    try{

      print("begin fetch data[$key]...");
      var request = await httpClient.getUrl(Uri.parse(url));
      request.headers.add("Ocp-Apim-Subscription-Key", "38b88a5cdf4947a2b591fa091fa6a330");
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var result = await response.transform(UTF8.decoder).join();
        Map json = JSON.decode(result);
        //print(json);
        _items.clear();
        if (json["value"]!=null){
          for(var item in json["value"]){
            _items.add(new ImageItem(item));

          }
          addSearchKey(key);
        }
        setState((){ _inSearch = false;});
        print("end fetch data[$key].");
      } else {
        print('Error auth:Http status ${response.statusCode}');
      }

    }catch(exception){
      print(exception);
    }
  }
  Widget _buildBody(){
    final Orientation orientation = MediaQuery.of(context).orientation;
    return new Column(
      children: <Widget>[
        new Expanded(
          child: new SafeArea(
            top: false,
            bottom: false,
            child: new GridView.count(
              crossAxisCount: 1,//(orientation == Orientation.portrait) ? 2 : 3,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(4.0),
              //childAspectRatio: 1.0,// (orientation == Orientation.portrait) ? 1.0 : 1.3,
              children: _items.map((ImageItem photo) {
                //return new Image.network(photo.thumbnailUrl,);

                return new GridDemoPhotoItem(
                    photo: photo
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBody(){
    List<Widget> listItems = new List<Widget>();
    listItems.add(new TextFormField(
      decoration: const InputDecoration(
          icon: const Icon(Icons.search),
          hintText: 'search',
          labelText: 'Search'
      ),
      onSaved: (key){_search=key;},
      onFieldSubmitted: (key){
        _search = key;
        _doSearch();
      },
    ));
    listItems.add(new Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: new RaisedButton(
          child: new Text("Search"),
          onPressed: _doSearch,
        )
    ));
    _searchItems.sort(sortSearchItem);
    for(SearchItem item in _searchItems){
      listItems.add(new ListTile(
        leading: new Text(item.count.toString()),
        title: new Text(item.key),
        onTap: (){
          _doSearchWithKey(item.key);
        },
        onLongPress: (){
          _doRemoveSearchItem(item);
        },
      ));
    }
    return new ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: listItems
    );
  }
  int sortSearchItem(SearchItem a,SearchItem b){
    return b.count - a.count;
  }
  @override
  Widget build(BuildContext context){
    if (_inSearch){
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("input to search"),
        ),
        body: new Center(
          child:
            new SafeArea(
                top:false,
                bottom: false,
                child: new Form(
                  key: _formKey,
                  child: _buildSearchBody(),
                ))
        ),
      );
    }else{
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: _buildBody(),
        floatingActionButton: new FloatingActionButton(
          onPressed: (){
            setState((){_inSearch = true;});
            },
          tooltip: "search",
          child: new Icon(Icons.search),

        ),
      );
    }

  }

  void getHistory() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String searchHist = prefs.get("search_history");
    _searchItems.clear();
    if (searchHist!=null){
      var json = JSON.decode(searchHist);
      for(var item in json){
        _searchItems.add(new SearchItem.fromJson(item));
      }
    }
    setState((){

    });
  }
  void addSearchKey(String key) async{
    bool found= false;
    for(var item in _searchItems){
      if (item.key==key){
        item.count ++;
        found = true;
      }
    }
    if (!found){
      _searchItems.add(new SearchItem(key:key,count:1));
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("search_history",JSON.encode(_searchItems));
    prefs.commit();


  }
  void _doRemoveSearchItem(SearchItem item) async{
    _searchItems.remove(item);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("search_history",JSON.encode(_searchItems));
    prefs.commit();
    setState((){});
  }
}
class SearchItem extends Object{
  String key;
  int count;
  SearchItem({this.key,this.count});
  Map<String,dynamic> toJson() => { 'key':key, 'count':count};
  SearchItem.fromJson(Map<String,dynamic> json)
    :key=json['key'],count=json['count'];
}