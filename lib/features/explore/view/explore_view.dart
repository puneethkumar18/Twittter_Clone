import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/features/explore/controller/explore_controller.dart';
import 'package:twitter_clone/features/explore/widgets/search_tile.dart';
import 'package:twitter_clone/theme/pallete.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  final searchControler = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    searchControler.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final appBarTextFieldBorder = OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(
                  color: Pallete.searchBarColor,
                )
              );
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: TextField(
            controller: searchControler,
            onSubmitted: (value){
              setState(() {
                 isShowUsers = true;
              });
             
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10).copyWith(left: 20),
              fillColor: Pallete.searchBarColor,
              filled: true,
              enabledBorder: appBarTextFieldBorder,
              focusedBorder: appBarTextFieldBorder,
              hintText: "Search Twitter",
            ),
          ),
      ),
    ),
    body: isShowUsers ? ref.watch(searchUserProvider(searchControler.text)).when(
      data: (users){
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context ,int index){
              final user = users[index];
              return SearchTile(userModel: user);
            },
            );
      }, 
      error: (erorr,st) =>  ErorrText(
        erorrtext: erorr.toString()
        ), 
      loading: () => const Loader(),
      ): const SizedBox(),
    );
  }
}