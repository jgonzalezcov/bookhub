import 'package:bookhub/src/models/book_model.dart';
import 'package:flutter/material.dart';

class BuildImage extends StatelessWidget {
  final Book book;
  final double width;
  final double height;

  const BuildImage({
    Key? key,
    required this.book,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        book.imagenUrl.toString() != 'errorImage'
            ? ClipRRect(
                borderRadius: BorderRadius.circular(7.0),
                child: FadeInImage(
                  fadeInDuration: const Duration(milliseconds: 100),
                  fadeOutDuration: const Duration(milliseconds: 100),
                  placeholder: const AssetImage('assets/imgs/loading_book.gif'),
                  image: NetworkImage(book.imagenUrl),
                  width: width,
                  height: height,
                  fit: BoxFit.cover,
                ),
              )
            : Image(
                image: const AssetImage(
                  'assets/imgs/libro2.png',
                ),
                width: width,
                height: height,
                fit: BoxFit.fill,
              ),
      ],
    );
  }
}
