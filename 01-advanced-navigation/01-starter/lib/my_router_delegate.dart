import 'package:declarative_navigation/model/quote.dart';
import 'package:declarative_navigation/screen/quote_detail_screen.dart';
import 'package:declarative_navigation/screen/quotes_list_screen.dart';
import 'package:flutter/material.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  String? selectedQuote;

  MyRouterDelegate() : _navigatorKey = GlobalKey<NavigatorState>();

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      pages: [
        // list page navigator
        MaterialPage(
          key: const ValueKey('QuotesListPage'),
          child: QuotesListScreen(
            quotes: quotes,
            onTapped: (String quoteId) {
              selectedQuote = quoteId;
              notifyListeners();
            },
          ),
        ),

        // detail page navigator
        if (selectedQuote != null)
          _QuotesDetailsPage(
            key: ValueKey('QuotesDetailPage-$selectedQuote'),
            child: QuoteDetailsScreen(quoteId: selectedQuote!),
          ),
      ],

      // on did remove page param
      onDidRemovePage: (page) {
        if (page.key == ValueKey('QuotesDetailPage-$selectedQuote')) {
          selectedQuote = null;
          notifyListeners();
        }
      },
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) {
    throw UnimplementedError();
  }
}

class _QuotesDetailsPage extends Page {
  final Widget child;

  const _QuotesDetailsPage({LocalKey? key, required this.child})
    : super(key: key);

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, animation2) {
        final tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero);

        final curveTween = CurveTween(curve: Curves.easeInOut);

        return SlideTransition(
          position: animation.drive(curveTween).drive(tween),
          child: child,
        );
      },
    );
  }
}
