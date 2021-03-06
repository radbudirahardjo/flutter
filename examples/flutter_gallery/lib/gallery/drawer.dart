// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/foundation.dart' show defaultTargetPlatform, required;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LinkTextSpan extends TextSpan {
  LinkTextSpan({ TextStyle style, String url, String text }) : super(
    style: style,
    text: text ?? url,
    recognizer: new TapGestureRecognizer()..onTap = () {
      UrlLauncher.launch(url);
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

    return new DrawerHeader(
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
      )
    );
  }
}

class GalleryDrawer extends StatelessWidget {
  GalleryDrawer({
    Key key,
    this.useLightTheme,
    @required this.onThemeChanged,
    this.timeDilation,
    @required this.onTimeDilationChanged,
    this.showPerformanceOverlay,
    this.onShowPerformanceOverlayChanged,
    this.checkerboardRasterCacheImages,
    this.onCheckerboardRasterCacheImagesChanged,
    this.onPlatformChanged,
    this.onSendFeedback,
  }) : super(key: key) {
    assert(onThemeChanged != null);
    assert(onTimeDilationChanged != null);
  }

  final bool useLightTheme;
  final ValueChanged<bool> onThemeChanged;

  final double timeDilation;
  final ValueChanged<double> onTimeDilationChanged;

  final bool showPerformanceOverlay;
  final ValueChanged<bool> onShowPerformanceOverlayChanged;

  final bool checkerboardRasterCacheImages;
  final ValueChanged<bool> onCheckerboardRasterCacheImagesChanged;

  final ValueChanged<TargetPlatform> onPlatformChanged;

  final VoidCallback onSendFeedback;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextStyle aboutTextStyle = themeData.textTheme.body2;
    final TextStyle linkStyle = themeData.textTheme.body2.copyWith(color: themeData.accentColor);

    final Widget lightThemeItem = new ListTile(
      leading: const Icon(Icons.brightness_5),
      title: const Text('Light'),
      trailing: new Radio<bool>(
        value: true,
        groupValue: useLightTheme,
        onChanged: onThemeChanged,
      ),
      selected: useLightTheme,
      onTap: () {
        onThemeChanged(true);
      },
    );

    final Widget darkThemeItem = new ListTile(
      leading: const Icon(Icons.brightness_7),
      title: const Text('Dark'),
      trailing: new Radio<bool>(
        value: false,
        groupValue: useLightTheme,
        onChanged: onThemeChanged
      ),
      selected: !useLightTheme,
      onTap: () {
        onThemeChanged(false);
      },
    );

    final Widget mountainViewItem = new ListTile(
      // on iOS, we don't want to show an Android phone icon
      leading: new Icon(defaultTargetPlatform == TargetPlatform.iOS ? Icons.star : Icons.phone_android),
      title: const Text('Android'),
      trailing: new Radio<TargetPlatform>(
        value: TargetPlatform.android,
        groupValue: Theme.of(context).platform,
        onChanged: onPlatformChanged,
      ),
      selected: Theme.of(context).platform == TargetPlatform.android,
      onTap: () {
        onPlatformChanged(TargetPlatform.android);
      },
    );

    final Widget cupertinoItem = new ListTile(
      // on iOS, we don't want to show the iPhone icon
      leading: new Icon(defaultTargetPlatform == TargetPlatform.iOS ? Icons.star_border : Icons.phone_iphone),
      title: const Text('iOS'),
      trailing: new Radio<TargetPlatform>(
        value: TargetPlatform.iOS,
        groupValue: Theme.of(context).platform,
        onChanged: onPlatformChanged,
      ),
      selected: Theme.of(context).platform == TargetPlatform.iOS,
      onTap: () {
        onPlatformChanged(TargetPlatform.iOS);
      },
    );

    final Widget animateSlowlyItem = new ListTile(
      leading: const Icon(Icons.hourglass_empty),
      title: const Text('Animate Slowly'),
      trailing: new Checkbox(
        value: timeDilation != 1.0,
        onChanged: (bool value) {
          onTimeDilationChanged(value ? 20.0 : 1.0);
        },
      ),
      selected: timeDilation != 1.0,
      onTap: () {
        onTimeDilationChanged(timeDilation != 1.0 ? 1.0 : 20.0);
      },
    );

    final Widget sendFeedbackItem = new ListTile(
      leading: const Icon(Icons.report),
      title: const Text('Send feedback'),
      onTap: onSendFeedback ?? () {
        UrlLauncher.launch('https://github.com/flutter/flutter/issues/new');
      },
    );

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
                  text: "Flutter is an early-stage, open-source project to help "
                  "developers build high-performance, high-fidelity, mobile "
                  "apps for iOS and Android from a single codebase. This "
                  "gallery is a preview of Flutter's many widgets, behaviors, "
                  "animations, layouts, and more. Learn more about Flutter at "
                ),
                new LinkTextSpan(
                  style: linkStyle,
                  url: 'https://flutter.io'
                ),
                new TextSpan(
                  style: aboutTextStyle,
                  text: ".\n\nTo see the source code for this app, please visit the "
                ),
                new LinkTextSpan(
                  style: linkStyle,
                  url: 'https://goo.gl/iv1p4G',
                  text: 'flutter github repo'
                ),
                new TextSpan(
                  style: aboutTextStyle,
                  text: "."
                )
              ]
            )
          )
        )
      ]
    );

    final List<Widget> allDrawerItems = <Widget>[
      new GalleryDrawerHeader(light: useLightTheme),
      lightThemeItem,
      darkThemeItem,
      const Divider(),
      mountainViewItem,
      cupertinoItem,
      const Divider(),
      animateSlowlyItem,
      // index 8, optional: Performance Overlay
      sendFeedbackItem,
      aboutItem
    ];

    if (onShowPerformanceOverlayChanged != null) {
      allDrawerItems.insert(8, new ListTile(
        leading: const Icon(Icons.assessment),
        title: const Text('Performance Overlay'),
        trailing: new Checkbox(
          value: showPerformanceOverlay,
          onChanged: (bool value) {
            onShowPerformanceOverlayChanged(!showPerformanceOverlay);
          },
        ),
        selected: showPerformanceOverlay,
        onTap: () {
          onShowPerformanceOverlayChanged(!showPerformanceOverlay);
        },
      ));
    }

    if (onCheckerboardRasterCacheImagesChanged != null) {
      allDrawerItems.insert(8, new ListTile(
        leading: const Icon(Icons.assessment),
        title: const Text('Checkerboard Raster Cache Images'),
        trailing: new Checkbox(
          value: checkerboardRasterCacheImages,
          onChanged: (bool value) {
            onCheckerboardRasterCacheImagesChanged(!checkerboardRasterCacheImages);
          },
        ),
        selected: checkerboardRasterCacheImages,
        onTap: () {
          onCheckerboardRasterCacheImagesChanged(!checkerboardRasterCacheImages);
        },
      ));
    }

    return new Drawer(child: new ListView(primary: false, children: allDrawerItems));
  }
}
