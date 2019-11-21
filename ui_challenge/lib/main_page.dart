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

class _MainPageState extends State<MainPage>  with SingleTickerProviderStateMixin {

  AnimationController _animationController;
  final PageController _pageController = PageController();
  
  double get maxHeight => 400;

  @override
  void initState() {
    super.initState();
      _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000)
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (_) => PageOffsetNotifier(_pageController),
      child: ListenableProvider.value(
              value: _animationController,
              child: Scaffold(
            body: SafeArea(
              child: GestureDetector(
                onVerticalDragUpdate: _handleDragUpdate,
                onVerticalDragEnd: _handleDragEnd,
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
                HorizontalTravelDots(),
                MapButton(),
                VerticalTravelDots(),
              ],
            ),
              ),
            )),
      ),
    );
  }

void _handleDragUpdate(DragUpdateDetails details) {
  _animationController.value -= details.primaryDelta / maxHeight;
}

void _handleDragEnd(DragEndDetails details) {
  if(_animationController.isAnimating || _animationController.status == AnimationStatus.completed) return;

  
  final double flingVelocity = details.velocity.pixelsPerSecond.dy / maxHeight;

  if(flingVelocity < 0.0)
    _animationController.fling(velocity: math.max(2.0, -flingVelocity));
  else if(flingVelocity > 0.0)
    _animationController.fling(velocity: math.min(-2.0, -flingVelocity));
  else
    _animationController.fling(velocity: _animationController.value < 0.5 ? -2.0 : 2.0);
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

class ArrowIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AnimationController>(
      builder: (context, animation, child){
        return Positioned(
        top: 80 + (1 - animation.value) * (400 + 38 -24),
        right: 24,
        child: child
        );
      },
          child: Icon(Icons.keyboard_arrow_down,
        color: lighterGrey,
        size: 28,),
        
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
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Text(
          'Travel details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
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
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        double opacity = math.max(0, 4 * notifier.page - 3);
        return Positioned(
          width: (MediaQuery.of(context).size.width - 48) / 3,
          right: opacity * 24.0,
          top: 90.0 + (1 -animation.value) * 400 + 24 + 32,
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
          top: 90.0  + (1 - animation.value) * 400 + 24 + 32 + 40,
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

class MapButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 8,
        bottom: 2,
          child: Consumer<PageOffsetNotifier>(
        builder: (context, notifier, child){
          double opacity = math.max(0, 4 * notifier.page - 3);
          return Opacity(
                opacity:  opacity,
                child: child,
          );
        },
            child: FlatButton(
            child: Text("ON MAP",
            style: TextStyle(fontSize: 12),),
            onPressed: (){
              Provider.of<AnimationController>(context).forward();
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
      builder: (context, notifier, animation, child){

        double multiplier;

        if(animation.value == 0){
          multiplier = math.max(0, 4 * notifier.page - 3);
        } else {
          multiplier = math.max(0, 1 - 3 * animation.value);
        }
        
        double size = MediaQuery.of(context).size.width * 0.52 * multiplier;
        return Container(
          margin: EdgeInsets.only(bottom: 250),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: lightGrey
        ),
        width: size,
        height: size,
      );
      }
    );
  }
}

class HorizontalTravelDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        double opacity =  math.max(0, 4 * notifier.page - 3);
        double multiplier;

        if(animation.value == 0){
          multiplier =  math.max(0, 4 * notifier.page - 3);
        }
        else {
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
                      border: Border.all(color: white)
                    ),
                    width: 8,
                    height: 8,
                  ),                  
                  Container(
                    margin: EdgeInsets.only(left: multiplier * 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: lightGrey,
                    ),
                    width: 4,
                    height: 4,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: multiplier * 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: lightGrey,
                    ),
                    width: 4,
                    height: 4,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: multiplier * 40),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: white,
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

class VerticalTravelDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AnimationController>(
      builder: (context, animation, child) {
        double multiplier;

        if(animation.value < 1/3)
          multiplier = 0;
        else
          multiplier = math.max(0, 1.5 * (animation.value - 1/3));

        return Stack(
          children: <Widget>[
            Center(                
                child: Transform(
                  transform: Matrix4.diagonal3Values(1.0,multiplier, 1.0),
                  origin: Offset(0, 440),
                  child: Container(
                  margin: EdgeInsets.only(top: 40),
                  width: 2,
                  height: 400,
                  color: white,
          ),
                ),
            )],

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
                      child: Opacity(
              opacity: 1 - 0.65 * animation.value,
              child: child),
          ),
        );
      },
      child: IgnorePointer(
        child: Stack(
          children: <Widget>[
            Image.asset('assets/leopard_shadow.png', colorBlendMode: BlendMode.hue,),
            Image.asset('assets/leopard.png')
          ],
        )
    ));
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
