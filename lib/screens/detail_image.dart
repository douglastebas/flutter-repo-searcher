import 'package:repo_searcher/components/cached_image.dart';
import 'package:flutter/material.dart';

class DetailImage extends StatelessWidget {
  const DetailImage({Key key, this.id, this.avatarUrl}) : super(key: key);

  final int id;
  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Imagem'),
        ),
        body: Center(
            child: Hero(
                tag: id,
                child: CachedImage(
                  url: avatarUrl,
                ))));
  }
}
