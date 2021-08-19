import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:watchlist/src/di/di.dart';
import 'package:watchlist/src/persistence/models/movie.dart';
import 'package:watchlist/src/persistence/persistence.dart';
import 'package:watchlist/src/presentation/wigets/snackbars.dart';

class MovieTile extends StatelessWidget {
  MovieTile({
    Key? key,
    required this.movie,
    required this.index,
  }) : super(key: key);

  final Movie movie;
  final int index;
  final _movieDAO = getIt<MovieDAO>();

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(movie.id!),
      onDismissed: (direction) {
        deleteMovie(context);
      },
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.redAccent,
        child: Row(
          children: const [
            Icon(Icons.delete),
          ],
        ),
      ),
      confirmDismiss: (direction) {
        switch (direction) {
          case DismissDirection.startToEnd:
            return showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete'),
                content: const Text('Are you sure you wanted to delete this movie?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      context.router.pop(false);
                    },
                    child: const Text('NO'),
                  ),
                  TextButton(
                    onPressed: () {
                      context.router.pop(true);
                    },
                    child: const Text('YES'),
                  )
                ],
              ),
            );
          case DismissDirection.endToStart:
          default:
            return Future.value(false);
        }
      },
      child: ExpansionTile(
        // backgroundColor: Colors.grey[100],
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(10),
        // ),
        leading: CircleAvatar(
          backgroundImage: movie.imgPath != null || movie.imgPath!.isNotEmpty
              ? FileImage(File.fromUri(Uri.parse(movie.imgPath!)))
              : null,
        ),
        title: Text(movie.title ?? 'Unknown title'),
        subtitle: Text(movie.director ?? 'Unknown director'),
        trailing: IconButton(
          tooltip: 'Edit',
          icon: const Icon(Icons.edit),
          onPressed: () => _showEditDialog(context),
        ),
        children: [
          movie.imgPath != null || movie.imgPath != ''
              ? Image.file(File.fromUri(Uri.parse(movie.imgPath!)))
              : Container(),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (context) {
        final TextEditingController _titleController = TextEditingController(text: movie.title);
        final TextEditingController _directorController =
            TextEditingController(text: movie.director);
        final formKey = GlobalKey<FormState>();
        return AlertDialog(
          title: const Text('Edit Movie'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'Title of the movie',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'This field is required';
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _directorController,
                  decoration: const InputDecoration(
                    hintText: 'Director of the movie',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'This field is required';
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.router.pop();
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  final ts = DateTime.now();
                  movie.updatedAt = ts;
                  movie.title = _titleController.text;
                  movie.director = _directorController.text;
                  movie.save();
                  context.router.pop();
                }
              },
              child: const Text('SUBMIT'),
            )
          ],
        );
      },
    );
  }

  void deleteMovie(BuildContext context) {
    _movieDAO.box.deleteAt(index);
    ScaffoldMessenger.of(context).showSnackBar(
      successSnackbar('Deleted: ${movie.title ?? ''}'),
    );
  }
}
