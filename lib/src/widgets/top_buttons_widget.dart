import 'package:bookhub/src/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:bookhub/src/screens/main_screen/main_screen_model.dart';

class TopButtonsWidget extends StatefulWidget {
  final MainScreenModel mainScreenModel;

  const TopButtonsWidget({
    Key? key,
    required this.mainScreenModel,
  }) : super(key: key);

  @override
  State<TopButtonsWidget> createState() => _TopButtonsWidgetState();
}

class _TopButtonsWidgetState extends State<TopButtonsWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritesScreen()),
            );
          },
          icon: const Icon(
            Icons.favorite,
            color: Colors.red,
          ),
        ),
        IconButton(
          onPressed: () {
            widget.mainScreenModel.setViewPreferenceTrue();
          },
          icon: const Icon(
            Icons.settings,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}
