import 'package:declarative_navigation/model/page_configuration.dart';
import 'package:flutter/material.dart';

class MyRouteInformationParser
    extends RouteInformationParser<PageConfiguration> {
  @override
  Future<PageConfiguration> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;

    if (uri.pathSegments.isEmpty) {
      return HomePageConfiguration();
    } else if (uri.pathSegments.length == 1) {
      final first = uri.pathSegments[0].toLowerCase();
      if (first == 'home') {
        return HomePageConfiguration();
      } else if (first == 'login') {
        return LoginPageConfiguration();
      } else if (first == 'register') {
        return RegisterPageConfiguration();
      } else if (first == 'splash') {
        return SplashPageConfiguration();
      } else {
        return UnknownPageConfiguration();
      }
    } else if (uri.pathSegments.length == 2) {
      final first = uri.pathSegments[0].toLowerCase();
      final second = uri.pathSegments[0].toLowerCase();
      final quoteId = int.tryParse(second) ?? 0;

      if (first == 'quote' && (quoteId >= 1 && quoteId <= 5)) {
        return DetailQuotePageConfiguration(second);
      } else {
        return UnknownPageConfiguration();
      }
    } else {
      return UnknownPageConfiguration();
    }
  }

  @override
  RouteInformation? restoreRouteInformation(PageConfiguration configuration) {
    return switch (configuration) {
      UnknownPageConfiguration() => RouteInformation(
        uri: Uri.parse('/unknown'),
      ),
      SplashPageConfiguration() => RouteInformation(uri: Uri.parse('/splash')),
      LoginPageConfiguration() => RouteInformation(uri: Uri.parse('/login')),
      RegisterPageConfiguration() => RouteInformation(
        uri: Uri.parse('/register'),
      ),
      HomePageConfiguration() => RouteInformation(uri: Uri.parse('/')),
      DetailQuotePageConfiguration() => RouteInformation(
        uri: Uri.parse('/detail/${configuration.quoteId}'),
      ),
    };
  }
}
