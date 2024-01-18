import 'package:bookhub/src/helpers/database_helpers.dart';
import 'package:bookhub/src/providers/books_provider.dart';
import 'package:bookhub/src/screens/main_screen/main_screen_model.dart';
import 'package:bookhub/src/widgets/loading_widget.dart';
import 'package:bookhub/src/widgets/title_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreferenceModificationWidget extends StatefulWidget {
  final MainScreenModel? mainScreenModel; // Modelo opcional

  const PreferenceModificationWidget({Key? key, this.mainScreenModel})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PreferenceModificationWidgetState createState() =>
      _PreferenceModificationWidgetState();
}

class _PreferenceModificationWidgetState
    extends State<PreferenceModificationWidget> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  bool isKeyboardVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _databaseHelper.getThemes(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: LoadingWidget());
          }

          final preferences = snapshot.data!;

          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.7),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: isKeyboardVisible,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 5, 65, 120)
                            .withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.white),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(3),
                        child: Center(
                          child: TitleTextWidget(
                              text1: 'Configura tus ',
                              text2: 'Preferencias',
                              fontSize: 25.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    height: 2,
                    width: double.infinity,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: preferences.length,
                    itemBuilder: (context, index) {
                      final preference = preferences[index];
                      final preferenceId = preference['id'] as int;
                      final currentPreference = preference['theme'] as String;

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                        ),
                        height: 115,
                        child: Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          color: const Color.fromARGB(255, 5, 65, 120)
                              .withOpacity(0.9),
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Text(
                                'Tema $preferenceId',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'DMSerif',
                                    color: Colors.white),
                              ),
                            ),
                            subtitle: SizedBox(
                              height: 55,
                              child: TextFormField(
                                style: const TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                                initialValue: currentPreference,
                                onChanged: (newPreference) {
                                  _databaseHelper.updateTheme(
                                      preferenceId, newPreference);
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Tema de interés',
                                  labelStyle: TextStyle(
                                      color: Colors.yellow,
                                      fontFamily: 'DMSerif'),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.yellow,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 5, 120, 13),
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Colors.white, width: 2.0),
        ),
        child: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 5, 120, 13),
          onPressed: () async {
            if (widget.mainScreenModel != null) {
              widget.mainScreenModel!.setViewPreferenceFalse();
              await Provider.of<BooksProvider>(context, listen: false)
                  .reloadBooks();
            }
          },
          child: const Icon(Icons.save, size: 45, color: Colors.white),
        ),
      ),
    );
  }
}
