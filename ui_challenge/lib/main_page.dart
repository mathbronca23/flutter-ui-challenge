import 'package:flutter/material.dart';
import 'package:ui_challenge/my_app.dart';
import 'package:provider/provider.dart';
import 'leopard_page.dart';

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
                  children: <Widget>[
                    LeopardPage(),
                    VulturePage()
                  ],
                ),
                AppBar(),               
                LeopardImage(),
                VultureImage(),
                SizedBox(height: 70,),
                ShareButton(),
                PageIndicator(),
                ArrowIcon(),
              ],
            ),
          )       
      ),
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
            Text('SY',
            style: TextStyle(fontWeight: FontWeight.bold),),
            Spacer(),
            Icon(Icons.menu),
          ],
          
        ),
      ),
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
        child: Image.asset('assets/leopard.png'),
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
        left: notifier.offset == null ? 0 : 1.2 * MediaQuery.of(context).size.width -0.85 * notifier.offset,
        child: child,
        );
      },
      child: IgnorePointer(
        child: Padding(
          padding: const EdgeInsets.only(bottom:90.0),
          child: Image.asset('assets/vulture.png',
            height: MediaQuery.of(context).size.height / 2.5,),
        ),
        ),
    );
  }
}

