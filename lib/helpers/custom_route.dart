import 'package:flutter/material.dart';

// MaterialPageRoute is use to create on the the navigation
class CustomRoute<T> extends MaterialPageRoute<T> {
  // This is animation class is use for single route on fly creation.
  // All the CustomRoute constructor param data forward to Parent class "MaterialPageRoute" using ": super()"
  CustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(
    builder: builder,
    settings: settings,
  );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // isInitialRoute == first route that load in the app
    if (settings.isInitialRoute) {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

// This is animation class is use  for general theme.
class CustomPageTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(PageRoute<T> pageRoute,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    // isInitialRoute == first route that load in the app
    if (pageRoute.settings.isInitialRoute) {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
