import 'package:bookhub/src/helpers/database_helpers.dart';
import 'package:bookhub/src/providers/view_state_provider.dart';
import 'package:bookhub/src/screens/book_screen/book_screen.dart';
import 'package:bookhub/src/widgets/background_widget.dart';
import 'package:bookhub/src/widgets/build_book_text_widget.dart';
import 'package:bookhub/src/widgets/title_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<Map<String, dynamic>>> _favoriteBooks;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _favoriteBooks = DatabaseHelper().getFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ViewStateProvider>(
      builder: (context, provider, _) {
        if (provider.reloadFavorite) {
          _loadFavorites();
          provider.setReloadFavorite(false);
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 5, 65, 120),
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Row(
              children: [
                TitleTextWidget(text1: 'Book', text2: 'Hub', fontSize: 25),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Favoritos',
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'DMSerif', fontSize: 23),
                ),
              ],
            ),
          ),
          body: Stack(
            children: [
              const BackgroundWidget(),
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _favoriteBooks,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No hay libros favoritos.',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      );
                    } else {
                      List<Map<String, dynamic>> favoriteBooks = snapshot.data!;
                      return ListView.builder(
                        itemCount: favoriteBooks.length,
                        itemBuilder: (context, index) {
                          String bookId = favoriteBooks[index]['bookId'];
                          String title = favoriteBooks[index]['title'];
                          String autor = favoriteBooks[index]['autor'];
                          String imagenUrl = favoriteBooks[index]['imagenUrl'];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BookScreen(bookId: bookId),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 5, right: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.white),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          const Color.fromARGB(255, 14, 64, 104)
                                              .withOpacity(0.7)
                                              .withOpacity(0.7),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    imagenUrl.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10)),
                                            child: FadeInImage(
                                              fadeInDuration: const Duration(
                                                  milliseconds: 100),
                                              fadeOutDuration: const Duration(
                                                  milliseconds: 100),
                                              placeholder: const AssetImage(
                                                'assets/imgs/loading_book.gif',
                                              ),
                                              image: NetworkImage(imagenUrl),
                                              width: 150,
                                              height: 220,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const Image(
                                            image: AssetImage(
                                              'assets/imgs/libro2.png',
                                            ),
                                            width: 150,
                                            height: 220,
                                            fit: BoxFit.fill,
                                          ),
                                    Container(
                                      width: 1,
                                      height: 220,
                                      decoration: const BoxDecoration(
                                          color: Colors.white),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Align(
                                                alignment: Alignment.topCenter,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 110,
                                                  width: 50,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.red),
                                                  child: const Text(
                                                    ' Libro: ',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: BuildText(
                                                  text: title,
                                                  maxLength: 39,
                                                  fontsizeBook: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 1,
                                            decoration: const BoxDecoration(
                                                color: Colors.white),
                                          ),
                                          Row(
                                            children: [
                                              Align(
                                                alignment: Alignment.topCenter,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 110,
                                                  width: 50,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.green),
                                                  child: const Text(
                                                    ' Autor: ',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: BuildText(
                                                  text: autor,
                                                  maxLength: 39,
                                                  fontsizeBook: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
