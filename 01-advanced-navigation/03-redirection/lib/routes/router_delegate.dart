import 'package:declarative_navigation/model/page_configuration.dart';
import 'package:declarative_navigation/screen/register_screen.dart';
import 'package:declarative_navigation/screen/unknown_screen.dart';
import 'package:flutter/material.dart';

import '../db/auth_repository.dart';
import '../model/quote.dart';
import '../screen/login_screen.dart';
import '../screen/quote_detail_screen.dart';
import '../screen/quotes_list_screen.dart';
import '../screen/splash_screen.dart';

class MyRouterDelegate extends RouterDelegate<PageConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthRepository authRepository;
  bool? isUnknown;

  MyRouterDelegate(this.authRepository)
    : _navigatorKey = GlobalKey<NavigatorState>() {
    /// todo 9: create initial function to check user logged in.
    _init();
  }

  String? selectedQuote;
  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool isRegister = false;

  _init() async {
    isLoggedIn = await authRepository.isLoggedIn();
    notifyListeners();
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Widget build(BuildContext context) {
    /// todo 11: create conditional statement to declare historyStack based on  user logged in.
    if (isUnknown == true) {
      historyStack = _unknownStack;
    } else if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }
    return Navigator(
      key: navigatorKey,

      /// todo 10: change the list with historyStack
      pages: historyStack,
      onDidRemovePage: (page) {
        if (page.key == ValueKey(selectedQuote)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            selectedQuote = null;
            notifyListeners();
          });
        }
        if (page.key == const ValueKey("RegisterPage")) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            isRegister = false;
            notifyListeners();
          });
        }
      },
    );
  }

  List<Page> get _unknownStack => const [
    MaterialPage(key: ValueKey("UnknownPage"), child: UnknownScreen()),
  ];

  /// todo 12: add these variable to support history stack
  List<Page> get _splashStack => const [
    MaterialPage(key: ValueKey("SplashScreen"), child: SplashScreen()),
  ];

  List<Page> get _loggedOutStack => [
    MaterialPage(
      key: const ValueKey("LoginPage"),
      child: LoginScreen(
        /// todo 17: add onLogin and onRegister method to update the state
        onLogin: () {
          isLoggedIn = true;
          notifyListeners();
        },
        onRegister: () {
          isRegister = true;
          notifyListeners();
        },
      ),
    ),
    if (isRegister == true)
      MaterialPage(
        key: const ValueKey("RegisterPage"),
        child: RegisterScreen(
          onRegister: () {
            isRegister = false;
            notifyListeners();
          },
          onLogin: () {
            isRegister = false;
            notifyListeners();
          },
        ),
      ),
  ];

  List<Page> get _loggedInStack => [
    MaterialPage(
      key: const ValueKey("QuotesListPage"),
      child: QuotesListScreen(
        quotes: quotes,
        onTapped: (String quoteId) {
          selectedQuote = quoteId;
          notifyListeners();
        },

        /// todo 21: add onLogout method to update the state and
        /// create a logout button
        onLogout: () {
          isLoggedIn = false;
          notifyListeners();
        },
      ),
    ),
    if (selectedQuote != null)
      MaterialPage(
        key: ValueKey(selectedQuote),
        child: QuoteDetailsScreen(quoteId: selectedQuote!),
      ),
  ];

  // set new route path override method
  @override
  Future<void> setNewRoutePath(PageConfiguration configuration) async {
    switch (configuration) {
      case UnknownPageConfiguration():
        isUnknown = true;
        isRegister = false;
        break;
      case RegisterPageConfiguration():
        isRegister = true;
        break;
      case LoginPageConfiguration() ||
          SplashPageConfiguration() ||
          HomePageConfiguration():
        isUnknown = false;
        isRegister = false;
        selectedQuote = null;
        break;
      case DetailQuotePageConfiguration():
        isUnknown = false;
        isRegister = false;
        selectedQuote = configuration.quoteId.toString();
        break;
    }
    notifyListeners();
  }

  @override
  PageConfiguration? get currentConfiguration {
    if (isLoggedIn == null) {
      return SplashPageConfiguration();
    } else if (isRegister == true) {
      return RegisterPageConfiguration();
    } else if (isLoggedIn == false) {
      return LoginPageConfiguration();
    } else if (isUnknown == true) {
      return UnknownPageConfiguration();
    } else if (selectedQuote == null) {
      return HomePageConfiguration();
    } else if (selectedQuote != null) {
      return DetailQuotePageConfiguration(selectedQuote!);
    } else {
      return null;
    }
  }
}
