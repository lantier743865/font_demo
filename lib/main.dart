import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission/permission.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
//https://bearbeargo.com/posts/flutter-web-async-load-font/
class _MyHomePageState extends State<MyHomePage> {
  String key = 'FZZJ-YGYTKJW';
  // 字体放在asset目录了，需要push到sd卡
  String value =
      '/storage/emulated/0/meituanwaimaibussiness/font/7fc81fa544398d4b5abbf97fa90554bd.ttf';

  @override
  void initState() {
    super.initState();
    getPermissionsStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            debugPrint('---->>重新加载');
          });
        },
        child: Center(
          child: Container(
            width: 100,
            height: 70,
            color: Colors.green,
            child: Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.center,
              runAlignment: WrapAlignment.center,
              alignment: WrapAlignment.center,
              children: <Widget>[
                Container(
                  color: Colors.yellow,
                  child: Text(
                    '年后',
                    style: TextStyle(fontFamily: key),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text('按钮'),
        onPressed: () {
          getPermissionsStatus();
        },
      ),
    );
  }

  /**
   *  读取字体数据
   */
  Future<void> readFont(String key, String value) {
    debugPrint('---->>key:$key,value:${value}');
    var fontLoader = FontLoader(key);
    fontLoader.addFont(getCustomFont(value));
    return fontLoader.load().catchError((e) {
      debugPrint('---->>load:$e');
    });
  }

  Future<ByteData> getCustomFont(String path) {
    File file = File(value);
    Future<Uint8List> future = file.readAsBytes().catchError((e) {
      debugPrint('---->>readAsBytes:$e');
    });
    Future<ByteData> data =
        future.then((value) => value.buffer.asByteData()).catchError((e) {
      debugPrint('---->>getCustomFont:$e');
    });
    return data;
//    return DefaultAssetBundle.of(context).load(path).catchError((e) {
//      debugPrint('---->>getCustomFont:$e');
//    });
  }

  getPermissionsStatus() async {
    List<PermissionName> permissionNames = [];
    permissionNames.add(PermissionName.Storage);
    String message = '';
    var permissions = await Permission.requestPermissions(permissionNames);
    permissions.forEach((permission) {
      message +=
          '${permission.permissionName}: ${permission.permissionStatus}\n';
      debugPrint('---->>message:$message');
      readFont(key, value).then((_) {
        debugPrint('---->>readFont   then:');
      }).catchError((e) {
        debugPrint('---->>catchError:$e');
      });
    });
  }
}
