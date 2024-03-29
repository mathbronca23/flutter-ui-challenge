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

class MapAnimationNotifier with ChangeNotifier {
  final AnimationController _animationController;

  MapAnimationNotifier(this._animationController) {
    _animationController.addListener(_onAnimationControllerChanged);
  }

  double get value => _animationController.value;

  void forward() => _animationController.forward();

  void _onAnimationControllerChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _animationController.removeListener(_onAnimationControllerChanged);
    super.dispose();
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _mapAnimationController;
  final PageController _pageController = PageController();

  double get maxHeight => 400;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 800));

    _mapAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 800));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _mapAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        builder: (_) => PageOffsetNotifier(_pageController),
        child: ListenableProvider.value(
          value: _animationController,
          child: ChangeNotifierProvider(
            builder: (_) => MapAnimationNotifier(_mapAnimationController),
            child: Scaffold(
                body: Stack(
              children: <Widget>[
                BackgroundImage(),
                SafeArea(
                  child: GestureDetector(
                    onVerticalDragUpdate: _handleDragUpdate,
                    onVerticalDragEnd: _handleDragEnd,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: <Widget>[
                        PageView(
                          controller: _pageController,
                          onPageChanged: (num) {

                           _mapAnimationController.isCompleted ? 
                           _mapAnimationController.reverse(from: 0.45)
                           : _mapAnimationController.reset();

                           _animationController.isCompleted ?
                           _animationController.reverse(from: 0.35)
                           : _animationController.reset();

                          },
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
                        HorizontalTravelDots(),
                        MapButton(),
                        VerticalTravelDots(),
                        VultureIcon(),
                        LeopardIcon(),
                      ],
                    ),
                  ),
                ),
              ],
            )),
          ),
        ));
  }

  bool verifyActualPage(){

    return _pageController.page.round() != 0;

  }

  void _handleDragUpdate(DragUpdateDetails details) {
            
           if(verifyActualPage())
             _animationController.value -= details.primaryDelta / maxHeight;
           else
            return;
  }

  void _handleDragEnd(DragEndDetails details) {

      if(verifyActualPage())
      {
        if (_animationController.isAnimating ||
        _animationController.status == AnimationStatus.completed) return;

    final double flingVelocity =
        (details.velocity.pixelsPerSecond.dy / maxHeight);

    if (flingVelocity < 0.0)
      _animationController.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _animationController.fling(velocity: math.min(-2.0, -flingVelocity));
    else
      _animationController.fling(
          velocity: _animationController.value < 0.5 ? -2.0 : 2.0);
      }
      else
        return;
  }
}

class AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: MapHider(
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
      ),
    );
  }
}

class ArrowIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AnimationController>(
      builder: (context, animation, child) {
        return Positioned(
            top: 80 + (1 - animation.value) * (400 + 38 - 24),
            right: 24,
            child: child);
      },
      child: MapHider(
              child: Icon(
          Icons.keyboard_arrow_down,
          color: lighterGrey,
          size: 28,
        ),
      ),
    );
  }
}

class TravelDetailLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        return Positioned(
          left: MediaQuery.of(context).size.width - notifier.offset,
          top: 80 + (1 - animation.value) * (400 + 38 - 24),
          child: Opacity(
            opacity: math.max(0, 4 * notifier.page - 3),
            child: child,
          ),
        );
      },
      child: MapHider(
              child: Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Text(
            'Travel details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
          ),
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
      child: MapHider(
              child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            '02:40 pm',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w300, color: lighterGrey),
          ),
        ),
      ),
    );
  }
}

class BaseCampLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        double opacity = math.max(0, 4 * notifier.page - 3);
        return Positioned(
          width: (MediaQuery.of(context).size.width - 48) / 3,
          right: opacity * 24.0,
          top: 90.0 + (1 - animation.value) * 400 + 24 + 32,
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
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        double opacity = math.max(0, 4 * notifier.page - 3);
        return Positioned(
          width: (MediaQuery.of(context).size.width - 48) / 3,
          right: opacity * 24.0,
          top: 90.0 + (1 - animation.value) * 400 + 24 + 32 + 40,
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
      child: MapHider(
              child: Center(
            child: Text(
              '72 km.',
              style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: white),
            ),
          ),
      ),
    );
  }
}

class MapButton extends StatelessWidget {

  bool isPageTwo(int page){
    return page == 0;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 8,
      bottom: 2,
      child: Consumer<PageOffsetNotifier>(
        builder: (context, notifier, child) {
          double opacity = math.max(0, 4 * notifier.page - 3);
          return Opacity(
            opacity: opacity,
            child: IgnorePointer(
              ignoring: isPageTwo(notifier.page.round()),
              child: child,
            ),
          );
        },
        child: FlatButton(            
            child: Text(
              "ON MAP",
              style: TextStyle(fontSize: 12),
            ),
            onPressed: () {
              
              final animatedPathController = Provider.of<AnimationController>(context);
              final mapNotifier = Provider.of<MapAnimationNotifier>(context);

              if(mapNotifier.value == 0 && animatedPathController.value == 0){
                mapNotifier.forward();
                animatedPathController.forward();
              }
              else if(mapNotifier._animationController.value == 0 && animatedPathController.isCompleted){
                mapNotifier.forward();
              }
              else if(mapNotifier._animationController.isCompleted && animatedPathController.isCompleted){
                mapNotifier._animationController.reverse();
                animatedPathController.reverse();
              } 
            },
          ),
      ),
    );
  }
}

class VultureCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
        builder: (context, notifier, animation, child) {
      double multiplier;

      if (animation.value == 0) {
        multiplier = math.max(0, 4 * notifier.page - 3);
      } else {
        multiplier = math.max(0, 1 - 3 * animation.value);
      }

      double size = MediaQuery.of(context).size.width * 0.52 * multiplier;
      return Container(
        margin: EdgeInsets.only(bottom: 250),
        decoration: BoxDecoration(shape: BoxShape.circle, color: lightGrey),
        width: size,
        height: size,
      );
    });
  }
}

class HorizontalTravelDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        double opacity = math.max(0, 4 * notifier.page - 3);
        double multiplier;

        if (animation.value == 0) {
          multiplier = math.max(0, 4 * notifier.page - 3);
        } else {
          multiplier = math.max(0, 1 - 4 * animation.value);
        }

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
                    margin: EdgeInsets.only(right: multiplier * 40),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: white)),
                    width: 8,
                    height: 8,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: multiplier * 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: multiplier < 0.4 ? Colors.transparent : lightGrey,
                    ),
                    width: 4,
                    height: 4,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: multiplier * 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: multiplier < 0.4 ? Colors.transparent : lightGrey,
                    ),
                    width: 4,
                    height: 4,
                  ),
                  Opacity(
                    opacity: multiplier.ceilToDouble(),
                    child: Container(
                      margin: EdgeInsets.only(left: multiplier * 40),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: white,
                      ),
                      width: 8,
                      height: 8,
                    ),
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

class VultureIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AnimationController>(
      builder: (context, animation, _) {
        double multiplier = 0;

        if (animation.value < 1 / 1.5)
          multiplier = 0;
        else {
          multiplier = (4 * (animation.value - 1 / 1.5)).clamp(0, 1.0);
        }

        return Positioned(
          width: (MediaQuery.of(context).size.width - 48) / 2,
          right: multiplier * 35,
          bottom: 234,
          child: Opacity(
            opacity: multiplier,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: 24, top: 50),
                  width: 12,
                  height: 1,
                  color: white,
                ),
                Column(
                  children: <Widget>[
                    Container(
                        width: 30,
                        padding: EdgeInsets.only(bottom: 14),
                        child: Image.asset('assets/vultures.png')),
                    Text(
                      'Vultures',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class LeopardIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AnimationController>(
      builder: (context, animation, _) {
        double multiplier = 0;

        if (animation.value < 1 / 1.5)
          multiplier = 0;
        else {
          multiplier = (4 * (animation.value - 1 / 1.5)).clamp(0, 1.0);
        }

        return Positioned(
          width: (MediaQuery.of(context).size.width - 48) / 2,
          left: multiplier * 35,
          top: 245,
          child: Opacity(
            opacity: multiplier,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                        width: 30,
                        padding: EdgeInsets.only(bottom: 14),
                        child: Image.asset('assets/leopards.png')),
                    Text(
                      'Leopards',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 24, top: 31),
                  width: 12,
                  height: 1,
                  color: white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class VerticalTravelDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AnimationController>(
      builder: (context, animation, child) {
        double multiplier = 0;

        if (animation.value < 1 / 3)
          multiplier = 0;
        else
          multiplier = math.max(0, 1.5 * (animation.value - 1 / 3));

        print(multiplier);

        return Stack(
          children: <Widget>[
            Center(
              child: Transform(
                transform: Matrix4.diagonal3Values(1.0, multiplier, 1.0),
                origin: Offset(0, 435),
                child: Container(
                  margin: EdgeInsets.only(top: 35),
                  width: 1,
                  height: 400,
                  color: white,
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 440),
                transform: Matrix4.translationValues(
                    0, -400 / 3 * multiplier.ceilToDouble(), 0),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: multiplier <= 1 / 3 ? Colors.transparent : white,
                      width: 2),
                  shape: BoxShape.circle,
                  color: multiplier <= 1 / 3 ? Colors.transparent : mainBlack,
                ),
                width: 8,
                height: 8,
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 440),
                transform: Matrix4.translationValues(
                    0, -400 / 1.5 * multiplier.ceilToDouble(), 0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: multiplier <= 1 / 1.5 ? Colors.transparent : white,
                      width: 2),
                  color: multiplier <= 1 / 1.5 ? Colors.transparent : mainBlack,
                ),
                width: 8,
                height: 8,
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 440),
                transform: Matrix4.translationValues(0, -400 * multiplier, 0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: multiplier == 0 ? Colors.transparent : white,
                ),
                width: 8,
                height: 8,
              ),
            ),
          ],
        );
      },
    );
  }
}

class LeopardImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
        builder: (context, notifier, animation, child) {
          return Positioned(
            left: notifier.offset == null ? 0 : -0.85 * notifier.offset,
            width: MediaQuery.of(context).size.width * 1.6,
            child: Transform.scale(
              alignment: Alignment(0.65, 0),
              scale: 1 - 0.1 * animation.value,
              child: Opacity(opacity: 1 - 0.65 * animation.value, child: child),
            ),
          );
        },
        child: IgnorePointer(
            child: MapHider(
                          child: Stack(
          children: <Widget>[
              Image.asset(
                'assets/leopard_shadow.png',
                colorBlendMode: BlendMode.hue,
              ),
              Image.asset(
                'assets/leopard.png',
              )
          ],
        ),
            )));
  }
}

class VultureImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        print(notifier.offset);
        return Positioned(
          left: notifier.offset == null
              ? 0
              : 1.2 * MediaQuery.of(context).size.width -
                  0.85 * notifier.offset,
          child: Transform.scale(
            scale: 1 - 0.1 * animation.value,
            child: Opacity(
              opacity: 1 - 0.65 * animation.value,
              child: child,
            ),
          ),
        );
      },
      child: IgnorePointer(
        child: MapHider(
                  child: Padding(
            padding: const EdgeInsets.only(bottom: 90.0),
            child: Image.asset(
              'assets/vulture.png',
              height: MediaQuery.of(context).size.height / 2.5,
            ),
          ),
        ),
      ),
    );
  }
}

class BackgroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MapAnimationNotifier>(
      builder: (context, notifier, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..scale(1 + 0.2 * (notifier.value + 1), 1 + 0.2 * (notifier.value + 1))
            ..rotateZ(-0.05 * math.pi * (1 - notifier.value))            ,
          child: Opacity(
                opacity: notifier.value,
                      child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                "assets/map.png",
                fit: BoxFit.cover,
                color: mainBlack,
                colorBlendMode: BlendMode.hardLight,
              ),
            ),
          ),
        );
      },
    );
  }
}

class MapHider extends StatelessWidget {

  final Widget child;

  const MapHider({Key key,@required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MapAnimationNotifier>(
      child: child,
      builder: (context, notifier, child){
        return Opacity(
          opacity: 1.0 - notifier.value,
          child: child,
        );
      },
    );
  }
}