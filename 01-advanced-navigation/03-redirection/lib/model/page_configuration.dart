sealed class PageConfiguration {}

class SplashPageConfiguration extends PageConfiguration {}

class HomePageConfiguration extends PageConfiguration {}

class LoginPageConfiguration extends PageConfiguration {}

class RegisterPageConfiguration extends PageConfiguration {}

class DetailQuotePageConfiguration extends PageConfiguration {
  final String? quoteId;
  DetailQuotePageConfiguration(this.quoteId);
}

class UnknownPageConfiguration extends PageConfiguration {}
