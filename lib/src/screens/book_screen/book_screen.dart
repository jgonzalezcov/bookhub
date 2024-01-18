import 'package:bookhub/src/helpers/database_helpers.dart';
import 'package:bookhub/src/models/book_model.dart';
import 'package:bookhub/src/providers/view_state_provider.dart';
import 'package:bookhub/src/services/book_service.dart';
import 'package:bookhub/src/widgets/background_widget.dart';
import 'package:bookhub/src/widgets/title_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookScreen extends StatefulWidget {
  final String bookId;

  const BookScreen({Key? key, required this.bookId}) : super(key: key);

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  late Future<Book> _bookDetails;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _bookDetails = BookService.getBookDetails(widget.bookId);
    checkIfFavorite();
  }

  void checkIfFavorite() async {
    bool result = await DatabaseHelper().isFavorite(widget.bookId);
    setState(() {
      isFavorite = result;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              'Detalles del Libro',
              style: TextStyle(
                  color: Colors.white, fontFamily: 'DMSerif', fontSize: 23),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: _bookDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final Book book = snapshot.data as Book;

            return Stack(
              children: [
                const BackgroundWidget(),
                SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 14, 64, 104)
                                    .withOpacity(0.7)
                                    .withOpacity(0.7),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Stack(
                              children: [
                                Hero(
                                  tag: 'bookImage${widget.bookId}',
                                  child: book.imagenUrl.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(7.0),
                                          child: FadeInImage(
                                            fadeInDuration: const Duration(
                                                milliseconds: 100),
                                            fadeOutDuration: const Duration(
                                                milliseconds: 100),
                                            placeholder: const AssetImage(
                                              'assets/imgs/loading_book.gif',
                                            ),
                                            image: NetworkImage(book.imagenUrl),
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
                                ),
                                Positioned(
                                  bottom: 1,
                                  right: 1,
                                  child: CircleAvatar(
                                    backgroundColor:
                                        isFavorite ? Colors.red : Colors.white,
                                    radius: 27,
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundColor: isFavorite
                                          ? Colors.yellow
                                          : const Color.fromARGB(
                                              255, 7, 65, 126),
                                      child: IconButton(
                                        onPressed: () async {
                                          BuildContext context = this.context;
                                          if (isFavorite) {
                                            await DatabaseHelper()
                                                .removeFromFavorites(
                                                    widget.bookId);
                                          } else {
                                            await DatabaseHelper()
                                                .addToFavorites(
                                              widget.bookId,
                                              book.titulo,
                                              book.autor,
                                              book.imagenUrl,
                                              book.description,
                                            );
                                            // ignore: use_build_context_synchronously
                                            Provider.of<ViewStateProvider>(
                                              context,
                                              listen: false,
                                            ).setReloadFavorite(false);
                                          }

                                          // ignore: use_build_context_synchronously
                                          Provider.of<ViewStateProvider>(
                                            context,
                                            listen: false,
                                          ).setReloadFavorite(true);

                                          checkIfFavorite();
                                        },
                                        icon: Icon(
                                          Icons.favorite,
                                          color: isFavorite
                                              ? Colors.red
                                              : Colors.white,
                                          size: 25,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 14, 64, 104)
                                    .withOpacity(0.7)
                                    .withOpacity(0.7),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Card(
                            color: const Color.fromARGB(255, 31, 134, 212),
                            margin: const EdgeInsets.all(15),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(255, 14, 64, 104)
                                            .withOpacity(0.7),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Text(
                                      'Título: ${book.titulo}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Autores: ${book.autor}',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Descripción:',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      book.description,
                                      textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
