import 'package:dicoding_subscriptions/classes/localization.dart';
import 'package:dicoding_subscriptions/common.dart';
import 'package:dicoding_subscriptions/provider/localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlagIconWidget extends StatelessWidget {
  const FlagIconWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
        child: DropdownButton(
            items: AppLocalizations.supportedLocales.map((locale) {
              final flag = Localization.getFlag(locale.languageCode);
              return DropdownMenuItem(
                  value: locale,
                  onTap: () {
                    final provider = context.read<LocalizationProvider>();
                    provider.setLocale(locale);
                  },
                  child: Center(
                    child: Text(
                      flag,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ));
            }).toList(),
            onChanged: (_) {}));
  }
}
