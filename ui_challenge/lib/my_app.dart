import 'package:flutter/material.dart';
import 'package:ui_challenge/styles.dart';
import 'package:provider/provider.dart';
import 'main_page.dart';

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: mainBlack,
      ),
      home: MainPage(),
    );
  }
}

class PageIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(builder: (context, notifier, _) {
      return MapHider(
              child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: notifier.page.round() == 0 ? white : lightGrey,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  width: 6,
                  height: 6,
                  decoration:
                      BoxDecoration(
                        shape: BoxShape.circle, 
                        color: notifier.page.round() == 0 ? lightGrey : white),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class ShareButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 24,
      bottom: 16,
      child: Icon(Icons.share),
    );
  }
}

class VulturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: VultureCircle(),
    );

    // Center(child: Padding(
    //   padding: const EdgeInsets.only(bottom: 80.0),
    //   child: Image.asset('assets/vulture.png',
    //   height: MediaQuery.of(context).size.height / 2.30),
    // ));
  }
}
