import 'package:declarative_navigation/routes/page_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormScreen extends StatefulWidget {
  final Function onSend;

  const FormScreen({super.key, required this.onSend});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Controller')),
      body: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: 'Your name'),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              final name = _nameController.text;

              widget.onSend;

              context.read<PageManager>().returnData(name);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
