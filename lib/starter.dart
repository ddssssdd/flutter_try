import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget{
  //final wordPair = new WordPair.random();
  @override
  /*
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Starter name",
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("this is appbar title"),
        ),
        body: new Center(
          //child:new Text("this is center")
          //child:new Text(wordPair.asPascalCase)
          child: new RandomWords(),
        ),
      )
    );
  }*/
  Widget build(BuildContext context){
    return new MaterialApp(
      title: "starter anme",
      home: new RandomWords(),
    );
  }

}
class RandomWords extends StatefulWidget{
  @override
  createState() => new RandomWordsState();
}
class RandomWordsState extends State<RandomWords>{
  final _suggestions = <WordPair>[];
  final _saved = new Set<WordPair>();
  final _biggerFont = new TextStyle(fontSize :18.0);
  @override
  Widget build(BuildContext context) {
    //final wordPair = new WordPair.random();
    //return new Text(wordPair.asPascalCase);
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("word list"),
        actions: <Widget>[new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved)],
      ),
      body: _buildSuggestions(),
    );
  }
  void _pushSaved(){
    Navigator.of(context).push(
      new MaterialPageRoute(builder: (context){
        final tiles = _saved.map(
          (pair){
            return new ListTile(
              title: new Text(pair.asPascalCase,style: _biggerFont),

            );
          }
        );
        final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles)
        .toList();
        return new Scaffold(
          appBar: new AppBar(
            title:new Text("Suggestions words"),
          ),
          body: new ListView(children: divided,),
        );
      })
    );
  }
  Widget _buildSuggestions(){
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i){
          if (i.isOdd) return new Divider();

          final index = i ~/2;
          if (index == _suggestions.length){
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        },
    );
  }
  Widget _buildRow(WordPair wordPair){
    final alreadySaved = _saved.contains(wordPair);
    return new ListTile(
      title: new Text(wordPair.asPascalCase,style:_biggerFont),
      trailing: new Icon(
          alreadySaved?Icons.favorite:Icons.favorite_border,
          color: alreadySaved?Colors.red:null
      ),
      onTap: (){
        setState((){
          if (alreadySaved){
            _saved.remove(wordPair);
          }else{
            _saved.add(wordPair);
          }
        });
      },
    );
  }
}