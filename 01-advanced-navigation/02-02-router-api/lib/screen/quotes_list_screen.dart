import 'package:declarative_navigation/routes/page_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/quote.dart';

class QuotesListScreen extends StatelessWidget {
  final List<Quote> quotes;
  final Function(String) onTapped;
  final Function() toFormScreen;

  const QuotesListScreen({
    Key? key,
    required this.quotes,
    required this.onTapped,
    required this.toFormScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quotes App"),
        actions: [
          IconButton(
            onPressed: () async {
              final scaffoldStateManager = ScaffoldMessenger.of(context);
              toFormScreen();
              final dataString =
                  await context.read<PageManager>().waitForResult();

              scaffoldStateManager.showSnackBar(
                SnackBar(content: Text(dataString)),
              );
            },
            icon: const Icon(Icons.input),
          ),
        ],
      ),
      body: ListView(
        children: [
          for (var quote in quotes)
            ListTile(
              title: Text(quote.author),
              subtitle: Text(quote.quote),
              isThreeLine: true,
              onTap: () => onTapped(quote.id),
            ),
        ],
      ),
    );
  }
}
