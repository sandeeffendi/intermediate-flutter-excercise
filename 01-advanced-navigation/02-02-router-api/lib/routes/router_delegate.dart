import 'package:declarative_navigation/db/auth_repository.dart';
import 'package:declarative_navigation/screen/form_screen.dart';
import 'package:declarative_navigation/screen/login_screen.dart';
import 'package:declarative_navigation/screen/register_screen.dart';
import 'package:declarative_navigation/screen/splash_screen.dart';
import 'package:flutter/material.dart';

import '../model/quote.dart';
import '../screen/quote_detail_screen.dart';
import '../screen/quotes_list_screen.dart';

/// todo 1: create new class router-delegate
class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthRepository authRepository;

  MyRouterDelegate(this.authRepository)
    : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  void _init() async {
    final loggedIn = await authRepository.isLoggedIn();

    Future.microtask(() {
      isLoggedin = loggedIn;
      notifyListeners();
    });
  }

  String? selectedQuote;

  /// todo-02-delegate-01: add form page state
  bool isForm = false;

  List<Page> historyStack = [];
  bool? isLoggedin;
  bool isRegister = false;

  // splash stack page
  List<Page> get _splashStack => const [
    MaterialPage(key: ValueKey('SplashPage'), child: SplashScreen()),
  ];

  // logged out stack page
  List<Page> get _loggedOutStack => [
    MaterialPage(
      key: const ValueKey('LoginPage'),
      child: LoginScreen(
        onLogin: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            isLoggedin = true;
            notifyListeners();
          });
        },
        onRegister: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            isRegister = true;
            notifyListeners();
          });
        },
      ),
    ),
    if (isRegister == true)
      MaterialPage(
        key: const ValueKey("RegisterPage"),
        child: RegisterScreen(
          onLogin: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              isLoggedin = false;
              notifyListeners();
            });
          },
          onRegister: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              isRegister = false;
              notifyListeners();
            });
          },
        ),
      ),
  ];

  // logged in stack page
  List<Page> get _loggedInStack => [
    MaterialPage(
      child: QuotesListScreen(
        key: const ValueKey('QuotesListPage'),
        quotes: quotes,
        onTapped: (String quoteId) {
          selectedQuote = quoteId;
        },
        toFormScreen: () {
          isForm = true;
          notifyListeners();
        },
        onLogout: () {
          isLoggedin = false;
          notifyListeners();
        },
      ),
    ),
    if (selectedQuote != null)
      MaterialPage(
        child: QuoteDetailsScreen(
          key: ValueKey(selectedQuote),
          quoteId: selectedQuote!,
        ),
      ),
    if (isForm)
      MaterialPage(
        key: const ValueKey('FormPage'),
        child: FormScreen(
          onSend: () {
            isForm = false;
            notifyListeners();
          },
        ),
      ),
  ];

  @override
  Widget build(BuildContext context) {
    if (isLoggedin == null) {
      historyStack = _splashStack;
    } else if (isLoggedin == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }

    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      onDidRemovePage: (page) {
        if (page.key == ValueKey(selectedQuote)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            selectedQuote = null;
            notifyListeners();
          });
        }
        if (page.key == const ValueKey("FormPage")) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            isForm = false;
            notifyListeners();
          });
        }
        if (page.key == const ValueKey("RegisterPage")) {
          WidgetsBinding.instance.addPostFrameCallback((_){
            isRegister = false;
          notifyListeners();
          });
        }
      },
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* Do Nothing */
  }
}
