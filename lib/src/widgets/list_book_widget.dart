import 'package:bookhub/src/models/book_model.dart';
import 'package:bookhub/src/providers/books_provider.dart';
import 'package:bookhub/src/widgets/build_book_image_widget.dart';
import 'package:bookhub/src/widgets/build_book_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListBook extends StatelessWidget {
  const ListBook({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BooksProvider>(
      builder: (context, booksProvider, _) {
        final orientation = MediaQuery.of(context).orientation;
        final double paddingValue =
            orientation == Orientation.portrait ? 0 : 50.0;
        final double widthBook =
            orientation == Orientation.portrait ? 130.0 : 100.0;
        final double heightBook =
            orientation == Orientation.portrait ? 210.0 : 150.0;
        final double fontsizeBook =
            orientation == Orientation.portrait ? 15.0 : 13.0;
        final double boxText =
            orientation == Orientation.portrait ? 70.0 : 40.0;

        return Padding(
          padding: EdgeInsets.only(top: paddingValue),
          child: ListView.builder(
            controller: booksProvider.scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: booksProvider.listBooks.length,
            itemBuilder: (context, index) {
              return _buildBookItem(
                context,
                booksProvider.listBooks[index],
                widthBook: widthBook,
                heightBook: heightBook,
                boxText: boxText,
                fontsizeBook: fontsizeBook.toInt(),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBookItem(
    BuildContext context,
    Book book, {
    required double widthBook,
    required double heightBook,
    required int fontsizeBook,
    required double boxText,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          'Book',
          arguments: {'bookId': book.id},
        );
      },
      child: Center(
        child: Container(
          height: 410,
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 14, 64, 104).withOpacity(0.7),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              BuildImage(book: book, width: widthBook, height: heightBook),
              SizedBox(
                height: boxText,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          'Libro: ',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: BuildText(
                        text: book.titulo,
                        maxLength: 39,
                        fontsizeBook: fontsizeBook,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Container(
                decoration: const BoxDecoration(color: Colors.white),
                height: 1,
                width: 200,
              ),
              const SizedBox(
                height: 2,
              ),
              SizedBox(
                height: boxText,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          'Autor: ',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: BuildText(
                        text: book.autor,
                        maxLength: 39,
                        fontsizeBook: fontsizeBook,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
