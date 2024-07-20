import 'package:flutter/material.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/widgets/no_border_text_field.dart';

class AddContactPage extends StatefulWidget {
  static const String route = "/add-contact";
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.white),
        title: NoBorderTextField(
          controller: searchController,
          hintText: "Search for your contacts",
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
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
