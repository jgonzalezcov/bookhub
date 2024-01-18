import 'package:bookhub/src/screens/book_screen/book_screen.dart';
import 'package:bookhub/src/screens/search_screen/searh_screen_model.dart';
import 'package:bookhub/src/widgets/background_widget.dart';
import 'package:bookhub/src/widgets/build_book_text_widget.dart';
import 'package:bookhub/src/widgets/title_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchScreenModel>.reactive(
      viewModelBuilder: () => SearchScreenModel(),
      builder: (context, model, child) {
        return _SearchScreen(model: model);
      },
    );
  }
}

class _SearchScreen extends StatefulWidget {
  final SearchScreenModel model;

  const _SearchScreen({required this.model});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<_SearchScreen> {
  @override
  void initState() {
    super.initState();
    widget.model.scrollController = ScrollController()
      ..addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.model.scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (widget.model.scrollController.position.pixels ==
            widget.model.scrollController.position.maxScrollExtent &&
        !widget.model.isLoading) {
      widget.model.buscarLibros();
    }
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
                'Buscar Libros',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'DMSerif',
                  fontSize: 23,
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            const BackgroundWidget(),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      widget.model.startIndex = 0;
                      widget.model.books.clear();
                      widget.model.uniqueBookIds.clear();
                      widget.model.buscarLibros();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(239, 43, 43, 180),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: widget.model.searchController,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                        cursorColor: Colors.white,
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();

                          widget.model.startIndex = 0;
                          widget.model.books.clear();
                          widget.model.uniqueBookIds.clear();
                          widget.model.buscarLibros();
                        },
                        decoration: InputDecoration(
                          labelText: 'Buscar',
                          hintText: 'Ingrese el título del libro',
                          hintStyle: const TextStyle(
                            color: Colors.white54,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search, color: Colors.white),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              widget.model.startIndex = 0;
                              widget.model.books.clear();
                              widget.model.uniqueBookIds.clear();
                              widget.model.buscarLibros();
                            },
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 15,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                          labelStyle: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: widget.model.scrollController,
                    itemCount: widget.model.books.length,
                    itemBuilder: (context, index) {
                      final book = widget.model.books[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookScreen(bookId: book.id),
                            ),
                          );
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 20, left: 5, right: 5),
                          child: Container(
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
                            child: Row(
                              children: [
                                book.imagenUrl != 'errorImage'
                                    ? ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                        child: FadeInImage(
                                          fadeInDuration:
                                              const Duration(milliseconds: 100),
                                          fadeOutDuration:
                                              const Duration(milliseconds: 100),
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
                                Container(
                                  width: 1,
                                  height: 220,
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
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
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                              ),
                                              child: const Text(
                                                ' Libro: ',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: BuildText(
                                              text: book.titulo,
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
                                              decoration: const BoxDecoration(
                                                color: Colors.green,
                                              ),
                                              child: const Text(
                                                ' Autor: ',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: BuildText(
                                              text: book.autor,
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
                  ),
                ),
                if (widget.model.isLoading)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ],
        ));
  }
}
