import 'package:flutter/material.dart';
import 'package:ui_challenge/my_app.dart';
import 'package:provider/provider.dart';
import 'leopard_page.dart';
import 'dart:math' as math;
import 'styles.dart';

class PageOffsetNotifier with ChangeNotifier {
  double _offset = 0;
  double _page = 0;

  PageOffsetNotifier(PageController pageController) {
    pageController.addListener(() {
      _offset = pageController.offset;
      _page = pageController.page;
      notifyListeners();
    });
  }

  double get page => _page;
  double get offset => _offset;
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (_) => PageOffsetNotifier(_pageController),
      child: Scaffold(
          body: SafeArea(
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            PageView(
              controller: _pageController,
              physics: ClampingScrollPhysics(),
              children: <Widget>[LeopardPage(), VulturePage()],
            ),
            AppBar(),
            LeopardImage(),
            VultureImage(),
            SizedBox(
              height: 70,
            ),
            ShareButton(),
            PageIndicator(),
            ArrowIcon(),
            TravelDetailLabel(),
            StartCampLabel(),
            StartTimeLabel(),
            BaseCampLabel(),
            BaseTimeLabel(),
            DistanceLabel(),
            TravelDots()
          ],
        ),
      )),
    );
  }
}

class AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Row(
          children: <Widget>[
            Text(
              'SY',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Icon(Icons.menu),
          ],
        ),
      ),
    );
  }
}

class TravelDetailLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Positioned(
          left: MediaQuery.of(context).size.width - notifier.offset,
          top: 16.0 + 24 + 16 + 400 + 38,
          child: Opacity(
            opacity: math.max(0, 4 * notifier.page - 3),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Text(
          'Travel Details',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class StartCampLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        double opacity = math.max(0, 4 * notifier.page - 3);
        return Positioned(
          width: (MediaQuery.of(context).size.width - 48) / 3,
          left: opacity * 24.0,
          top: 90.0 + 400 + 24 + 32,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          'Start camp',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}

class StartTimeLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        double opacity = math.max(0, 4 * notifier.page - 3);
        return Positioned(
          width: (MediaQuery.of(context).size.width - 48) / 3,
          left: opacity * 24.0,
          top: 90.0 + 400 + 24 + 32 + 40,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          '02:40 pm',
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w300, color: lighterGrey),
        ),
      ),
    );
  }
}

class BaseCampLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        double opacity = math.max(0, 4 * notifier.page - 3);
        return Positioned(
          width: (MediaQuery.of(context).size.width - 48) / 3,
          right: opacity * 24.0,
          top: 90.0 + 400 + 24 + 32,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Base camp',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}

class BaseTimeLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        double opacity = math.max(0, 4 * notifier.page - 3);
        return Positioned(
          width: (MediaQuery.of(context).size.width - 48) / 3,
          right: opacity * 24.0,
          top: 90.0 + 400 + 24 + 32 + 40,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '07:30 am',
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w300, color: lighterGrey),
        ),
      ),
    );
  }
}

class DistanceLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        double opacity = math.max(0, 4 * notifier.page - 3);
        return Positioned(
          width: MediaQuery.of(context).size.width,
          top: 90.0 + 400 + 24 + 32 + 40,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: Center(
        child: Text(
          '72 km.',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: white),
        ),
      ),
    );
  }
}

class TravelDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        double opacity = math.max(0, 4 * notifier.page - 3);
        return Positioned(
          top: 90.0 + 400 + 24 + 32,
          left: 0,
          right: 0,
          child: Center(
            child: Opacity(
              opacity: opacity,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                                    Container(
                    color: lightGrey,
                    height: 1,
                    width: opacity * 40,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: opacity * 40),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: white,
                    ),
                    width: 8,
                    height: 8,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: opacity * 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: lightGrey,
                    ),
                    width: 4,
                    height: 4,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: opacity * 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: lightGrey,
                    ),
                    width: 4,
                    height: 4,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: opacity * 40),                    
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: white)
                    ),
                    width: 8,
                    height: 8,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class LeopardImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Positioned(
          left: notifier.offset == null ? 0 : -0.85 * notifier.offset,
          width: MediaQuery.of(context).size.width * 1.6,
          child: child,
        );
      },
      child: IgnorePointer(
        child:Image.asset("assets/leopard.png",)
      ),
    );
  }
}

class VultureImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        print(notifier.offset);
        return Positioned(
          left: notifier.offset == null
              ? 0
              : 1.2 * MediaQuery.of(context).size.width -
                  0.85 * notifier.offset,
          child: child,
        );
      },
      child: IgnorePointer(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 90.0),
          child: Image.asset(
            'assets/vulture.png',
            height: MediaQuery.of(context).size.height / 2.5,
          ),
        ),
      ),
    );
  }
}
