// ignore_for_file: non_constant_identifier_names

import 'package:clonetwit/common/common.dart';
import 'package:clonetwit/features/explore/controller/explore_controller.dart';
import 'package:clonetwit/features/explore/widgets/search_tile.dart';
import 'package:clonetwit/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExplorView extends ConsumerStatefulWidget {
  const ExplorView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExplorViewState();
}

class _ExplorViewState extends ConsumerState<ExplorView> {
  final Searchcontroller = TextEditingController();
  bool isShowuser = false;
  @override
  void dispose() {
    super.dispose();

    Searchcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBarTextfieldBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Pallete.searchBarColor));
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: TextField(
            controller: Searchcontroller,
            onSubmitted: (Value) {
              setState(() {
                isShowuser = true;
              });
            },
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10).copyWith(left: 30),
                fillColor: Pallete.searchBarColor,
                filled: true,
                enabledBorder: appBarTextfieldBorder,
                focusedBorder: appBarTextfieldBorder,
                hintText: 'Search Tweet:'),
          ),
        ),
      ),
      body: isShowuser
          ? ref.watch(searchUserProvider(Searchcontroller.text)).when(
              data: (users) {
                return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return SearchTile(userModel: user);
                    });
              },
              error: (error, st) {
                return ErrorText(
                  error: error.toString(),
                );
              },
              loading: () => const Loader())
          : const SizedBox(),
    );
  }
}
