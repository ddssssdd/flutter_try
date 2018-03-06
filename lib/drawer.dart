// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/foundation.dart' show defaultTargetPlatform, required;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

//import 'package:url_launcher/url_launcher.dart';

class LinkTextSpan extends TextSpan {

  // Beware!
  //
  // This class is only safe because the TapGestureRecognizer is not
  // given a deadline and therefore never allocates any resources.
  //
  // In any other situation -- setting a deadline, using any of the less trivial
  // recognizers, etc -- you would have to manage the gesture recognizer's
  // lifetime and call dispose() when the TextSpan was no longer being rendered.
  //
  // Since TextSpan itself is @immutable, this means that you would have to
  // manage the recognizer from outside the TextSpan, e.g. in the State of a
  // stateful widget that then hands the recognizer to the TextSpan.

  LinkTextSpan({ TextStyle style, String url, String text }) : super(
      style: style,
      text: text ?? url,
      recognizer: new TapGestureRecognizer()..onTap = () {
        //launch(url);
      }
  );
}

class GalleryDrawerHeader extends StatefulWidget {
  const GalleryDrawerHeader({ Key key, this.light }) : super(key: key);

  final bool light;

  @override
  _GalleryDrawerHeaderState createState() => new _GalleryDrawerHeaderState();
}

class _GalleryDrawerHeaderState extends State<GalleryDrawerHeader> {
  bool _logoHasName = true;
  bool _logoHorizontal = true;
  MaterialColor _logoColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    final double systemTopPadding = MediaQuery.of(context).padding.top;

    return new Semantics(
      label: 'Flutter',
      child: new DrawerHeader(
        decoration: new FlutterLogoDecoration(
          margin: new EdgeInsets.fromLTRB(12.0, 12.0 + systemTopPadding, 12.0, 12.0),
          style: _logoHasName ? _logoHorizontal ? FlutterLogoStyle.horizontal
              : FlutterLogoStyle.stacked
              : FlutterLogoStyle.markOnly,
          lightColor: _logoColor.shade400,
          darkColor: _logoColor.shade900,
          textColor: widget.light ? const Color(0xFF616161) : const Color(0xFF9E9E9E),
        ),
        duration: const Duration(milliseconds: 750),
        child: new GestureDetector(
            onLongPress: () {
              setState(() {
                _logoHorizontal = !_logoHorizontal;
                if (!_logoHasName)
                  _logoHasName = true;
              });
            },
            onTap: () {
              setState(() {
                _logoHasName = !_logoHasName;
              });
            },
            onDoubleTap: () {
              setState(() {
                final List<MaterialColor> options = <MaterialColor>[];
                if (_logoColor != Colors.blue)
                  options.addAll(<MaterialColor>[Colors.blue, Colors.blue, Colors.blue, Colors.blue, Colors.blue, Colors.blue, Colors.blue]);
                if (_logoColor != Colors.amber)
                  options.addAll(<MaterialColor>[Colors.amber, Colors.amber, Colors.amber]);
                if (_logoColor != Colors.red)
                  options.addAll(<MaterialColor>[Colors.red, Colors.red, Colors.red]);
                if (_logoColor != Colors.indigo)
                  options.addAll(<MaterialColor>[Colors.indigo, Colors.indigo, Colors.indigo]);
                if (_logoColor != Colors.pink)
                  options.addAll(<MaterialColor>[Colors.pink]);
                if (_logoColor != Colors.purple)
                  options.addAll(<MaterialColor>[Colors.purple]);
                if (_logoColor != Colors.cyan)
                  options.addAll(<MaterialColor>[Colors.cyan]);
                _logoColor = options[new math.Random().nextInt(options.length)];
              });
            }
        ),
      ),
    );
  }
}

class GalleryDrawer extends StatelessWidget {
  const GalleryDrawer({
    Key key,
    this.onMenuSelected

  }) : super(key: key);

  final ValueChanged<String> onMenuSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextStyle aboutTextStyle = themeData.textTheme.body2;
    final TextStyle linkStyle = themeData.textTheme.body2.copyWith(color: themeData.accentColor);

    final Widget aboutItem = new AboutListTile(
        icon: const FlutterLogo(),
        applicationVersion: 'April 2017 Preview',
        applicationIcon: const FlutterLogo(),
        applicationLegalese: '© 2017 The Chromium Authors',
        aboutBoxChildren: <Widget>[
          new Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: new RichText(
                  text: new TextSpan(
                      children: <TextSpan>[
                        new TextSpan(
                            style: aboutTextStyle,
                            text: 'Flutter is an early-stage, open-source project to help developers'
                                'build high-performance, high-fidelity, mobile apps for '
                                '${defaultTargetPlatform == TargetPlatform.iOS ? 'multiple platforms' : 'iOS and Android'} '
                                'from a single codebase. This gallery is a preview of '
                                "Flutter's many widgets, behaviors, animations, layouts, "
                                'and more. Learn more about Flutter at '
                        ),
                        new LinkTextSpan(
                            style: linkStyle,
                            url: 'https://flutter.io'
                        ),
                        new TextSpan(
                            style: aboutTextStyle,
                            text: '.\n\nTo see the source code for this app, please visit the '
                        ),
                        new LinkTextSpan(
                            style: linkStyle,
                            url: 'https://goo.gl/iv1p4G',
                            text: 'flutter github repo'
                        ),
                        new TextSpan(
                            style: aboutTextStyle,
                            text: '.'
                        )
                      ]
                  )
              )
          )
        ]
    );

    final List<Widget> allDrawerItems = <Widget>[
      //new GalleryDrawerHeader(light: useLightTheme),
      aboutItem,
      const Divider(),

      new ListTile(
        title: const Text("ASN"),
        subtitle: const Text("Get all asns from system"),
        trailing: const Icon(Icons.time_to_leave,color: Colors.red,),
        onTap: (){onMenuSelected('asn');},
      ),
      new ListTile(
        title: const Text("SO"),
        subtitle: const Text("Get all asns from system"),
        trailing: const Icon(Icons.beach_access,color: Colors.green,),
        onTap: (){onMenuSelected('so');},
      ),
      new ListTile(
        title: const Text("PO"),
        subtitle: const Text("Get all asns from system"),
        trailing: const Icon(Icons.show_chart,color: Colors.blue,),
        onTap: (){onMenuSelected('po');},
      ),
      new ListTile(
        title: const Text("APS"),
        subtitle: const Text("Get all asns from system"),
        trailing: const Icon(Icons.code,color: Colors.purple,),
        onTap: (){onMenuSelected('aps');},
      ),

    ];

    return new Drawer(child: new ListView(primary: false, children: allDrawerItems));
  }
}
