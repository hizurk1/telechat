import 'package:flutter/material.dart';

class AddContactPage extends StatefulWidget {
  static const String route = "/add-contact";
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        title: const Expanded(
          child: TextField(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 3),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
