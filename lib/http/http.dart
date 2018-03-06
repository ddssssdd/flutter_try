import 'dart:convert';
import 'dart:io';
import 'dart:async';

class JsonResult {
  final bool status;
  final String message;
  final SearchResult searchResult;
  JsonResult(this.status,this.message,this.searchResult);
  static JsonResult parseJsonResult(String response){
    Map json = JSON.decode(response);
    List<SearchItem> items = new List<SearchItem>();
    for(var item in json["result"]){
      items.add(new SearchItem(item["id"], item["title"], item["type"], item["content"], item["createdDate"], item["hasChild"],
          item["childTitle"], item["childType"]));
    }
    JsonResult jsonResult = new JsonResult(json['status'], json['message'], new SearchResult(items));
    return jsonResult;
  }
}
class SearchResult{
  final List<SearchItem> items;
  const SearchResult(this.items);
}
class SearchItem{
  final String id;
  final String title;
  final String type;
  final String content;
  final String createdDate;
  final int hasChild;
  final String childTitle;
  final String childType;
  const SearchItem(this.id,this.title,this.type,this.content,this.createdDate,this.hasChild,this.childTitle,this.childType);
}

class HttpConst{
  //static const String SERVER_URL= 'http://172.16.55.33:9080/';
  static const String SERVER_URL= 'http://192.168.125.117:9080/';

  static const String CLIENT_SECRET ='123456';
  static const String CLIENT_ID ='pls-backend';
  static String accessToken;
  static String refreshToken;
  static String username='fuxy';
  static String password='aaa123';
  static bool isLogin=false;

}

typedef void HandleJsonResult(JsonResult json);


Future<Null> getData(String accessToken,String code, HandleJsonResult handleJsonResult) async {
  var url = '${HttpConst.SERVER_URL}api/search?code=$code';
  var httpClient = new HttpClient();
  try{

    print("begin fetch data.");
    var request = await httpClient.getUrl(Uri.parse(url));
    request.headers.add("Authorization", "Bearer $accessToken");
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var json = await response.transform(UTF8.decoder).join();
      JsonResult jsonResult =JsonResult.parseJsonResult(json);
      if (handleJsonResult!=null)
        handleJsonResult(jsonResult);

    } else {
      print('Error auth:Http status ${response.statusCode}');
    }

  }catch(exception){
    print(exception);
  }
}
typedef void HandleResult(String result);
Future<Null> initGetToken(HandleResult handleResult) async {
  String access_token;
  var url = '${HttpConst.SERVER_URL}oauth/token?password=${HttpConst.password}&username=${HttpConst.username}&grant_type=password&scope=write&client_secret=${HttpConst.CLIENT_SECRET}&client_id=${HttpConst.CLIENT_ID}';
  var httpClient = new HttpClient();
  String result;
  try {
    print("begin authorization...");
    httpClient.addCredentials(Uri.parse(url), "realm", new HttpClientBasicCredentials(HttpConst.CLIENT_ID, HttpConst.CLIENT_SECRET));
    var request = await httpClient.postUrl(Uri.parse(url));

    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var json = await response.transform(UTF8.decoder).join();
      var data = JSON.decode(json);
      result = data['access_token'];
      access_token = result;
      HttpConst.accessToken = result;
      HttpConst.refreshToken = data["refresh_token"];
      print("end authorization: ${access_token}");
      if (handleResult!=null){
        handleResult(access_token);
      }
    } else {
      result =
      'Error auth:\nHttp status ${response.statusCode}';
    }
  } catch (exception) {
    result = 'Failed authorization.';
  }
}

