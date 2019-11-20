import 'package:flutter/material.dart';
import 'package:ui_challenge/styles.dart';
import 'package:provider/provider.dart';
import 'main_page.dart';
import 'dart:math' as math;

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
      return Align(
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
      );
    });
  }
}

class ArrowIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: (16 + 24 + 16 + 400 + 38).toDouble() ,
      right: 24,
      child: Icon(Icons.keyboard_arrow_down,
      color: lighterGrey,
      size: 28,),
      
    );
  }
}

class LeopardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 70),
        BackgroundText(),
        SizedBox(height: 32),
        TravelDescriptionLabel(),
        SizedBox(
          height: 32,
        ),
        LeopardDescription(),
      ],
    );
  }
}

class TravelDescriptionLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Opacity(
          opacity: math.max(0, 1 - 4 * notifier.page),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Text(
          'Travel Description',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
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

class LeopardDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Opacity(
          opacity: math.max(0, 1 - 4 * notifier.page),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 24, 0),
        child: Text(
          'The leopard is distinguished by its well-camouflaged fur, opportunistic hunting behaviour, broad diet, and strength.',
          style:
              TextStyle(letterSpacing: 0.8, fontSize: 13.4, color: lightGrey),
        ),
      ),
    );
  }
}

class BackgroundText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Transform.translate(
          offset: Offset(-52 - 0.5 * notifier.offset, 0),
          child: child,
        );
      },
      child: Container(
        alignment: Alignment.centerLeft,
        child: RotatedBox(
          quarterTurns: 1,
          child: Text(
            '72',
            style: TextStyle(fontSize: 340, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class VulturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();

    // Center(child: Padding(
    //   padding: const EdgeInsets.only(bottom: 80.0),
    //   child: Image.asset('assets/vulture.png',
    //   height: MediaQuery.of(context).size.height / 2.30),
    // ));
  }
}
