import 'package:bookhub/src/screens/screens.dart';
import 'package:bookhub/src/screens/main_screen/main_screen_model.dart';
import 'package:bookhub/src/widgets/background_widget.dart';
import 'package:bookhub/src/widgets/list_book_widget.dart';
import 'package:bookhub/src/widgets/loading_widget.dart';
import 'package:bookhub/src/widgets/message_widget.dart';
import 'package:bookhub/src/widgets/preference_modification_widget.dart';
import 'package:bookhub/src/widgets/title_text_widget.dart';
import 'package:bookhub/src/widgets/top_buttons_widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainScreenModel>.reactive(
      onViewModelReady: (model) async {
        await model.updateViewPreference();
      },
      viewModelBuilder: () => MainScreenModel(),
      builder: (context, model, child) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                const BackgroundWidget(),
                !model.isLoader
                    ? !model.viewPreference
                        ? const ListBook()
                        : Container()
                    : Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          child: const Center(
                            child: LoadingWidget(),
                          ),
                        ),
                      ),
                Visibility(
                  visible: model.isLoader,
                  child: Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: LoadingWidget(),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: model.viewPreference,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Expanded(
                        child: PreferenceModificationWidget(
                          mainScreenModel: model,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: Visibility(
                    visible: model.showMessage != '',
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: MessageWidget(
                          message: model.showMessage,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color:
                        const Color.fromARGB(255, 5, 65, 120).withOpacity(0.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TitleTextWidget(
                        text1: 'Book',
                        text2: 'Hub',
                        fontSize: 35.0,
                      ),
                      TopButtonsWidget(mainScreenModel: model),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: !model.viewPreference
              ? FloatingActionButton(
                  backgroundColor: Colors.blue,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchScreen(),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                )
              : null,
        );
      },
    );
  }
}
