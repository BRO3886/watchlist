import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:watchlist/src/di/di.dart';
import 'package:watchlist/src/navigation/router.gr.dart';
import 'package:watchlist/src/persistence/models/movie.dart';
import 'package:watchlist/src/persistence/persistence.dart';
import 'package:watchlist/src/presentation/bloc/auth/auth_bloc.dart';
import 'package:watchlist/src/presentation/theme/theme.dart';
import 'package:watchlist/src/presentation/wigets/movie_tile.dart';
import 'package:watchlist/src/presentation/wigets/snackbars.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _userDAO = getIt<UserDAO>();
  final _movieDAO = getIt<MovieDAO>();
  late final AuthBloc _authBloc;
  late final String _photoURL;
  String _savedFilePath = '';
  String _savedFileName = '';

  @override
  void initState() {
    _photoURL = _userDAO.getPhoto() ?? 'https://katb.in/tail8728';
    _authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Watchlist',
          style: headingText.copyWith(fontSize: 22),
        ),
        actions: [
          logoutButton(context),
        ],
        backgroundColor: Colors.grey[100],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
        elevation: 2,
        icon: const Icon(Icons.add),
        onPressed: () => _openSheet(context),
        label: const Text('Add'),
      ),
      body: ValueListenableBuilder<Box<Movie>>(
        valueListenable: _movieDAO.box.listenable(),
        builder: (context, box, _) {
          if (box.values.isEmpty) {
            return Center(
              child: Text(
                'No movies added.\nTap + to add movies',
                style: subtitleText.copyWith(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            // padding: const EdgeInsets.all(16),
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              final Movie movie = box.getAt(index)!;
              return MovieTile(
                movie: movie,
                index: index,
              );
            },
          );
        },
      ),
    );
  }

  IconButton logoutButton(BuildContext context) {
    return IconButton(
      tooltip: 'Profile',
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Profile'),
            content: ListTile(
              title: Text(_userDAO.user?.name ?? 'Anon'),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(_photoURL),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => _authBloc.add(LogoutEvent()),
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is LogoutSucces) {
                      ScaffoldMessenger.of(context).showSnackBar(successSnackbar('Logged out!'));
                      context.router.replace(const AuthScreen());
                    }
                    if (state is LogoutError) {
                      ScaffoldMessenger.of(context).showSnackBar(errorSnackbar(state.message));
                    }
                  },
                  builder: (context, state) {
                    if (state is LogoutLoading) {
                      return Container(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(brownOnYellow),
                        ),
                      );
                    }
                    return Text(
                      'Logout'.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      icon: CircleAvatar(
        backgroundImage: NetworkImage(_photoURL),
      ),
    );
  }

  void _openSheet(BuildContext context) {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _directorController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (context) => buildModalSheet(
        context,
        formKey,
        _titleController,
        _directorController,
      ),
    );
  }

  Widget buildModalSheet(
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController _titleController,
    TextEditingController _directorController,
  ) {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return SingleChildScrollView(
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              margin: const EdgeInsets.all(20),
              // height: 300,
              child: Form(
                key: formKey,
                child: Column(
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
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () async {
                            final XFile? image = await ImagePicker().pickImage(
                              source: ImageSource.gallery,
                            );
                            if (image != null) {
                              final split = image.name.split('.');
                              final String name = split.first;
                              final String ext = split.last;
                              final dirPath = (await getApplicationDocumentsDirectory()).path;
                              final tId = DateTime.now().millisecond.toString();
                              final fileName = '$name-$tId.$ext';
                              final path = '$dirPath/$fileName';
                              image.saveTo(path).then((_) {
                                setModalState(() {
                                  _savedFilePath = path;
                                  _savedFileName = fileName;
                                });
                              });
                            }
                          },
                          style: TextButton.styleFrom(
                            primary: darkBlue,
                          ),
                          icon: const Icon(Icons.upload_file),
                          label: const Text('ADD IMAGE'),
                        ),
                        if (_savedFileName.isNotEmpty)
                          Flexible(
                            child: Text(
                              _savedFileName,
                              style: subtitleText,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    ButtonBar(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            context.router.pop();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                          ),
                          icon: const Icon(Icons.cancel),
                          label: const Text('CANCEL'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            if (formKey.currentState?.validate() ?? false) {
                              final ts = DateTime.now();
                              final Movie m = Movie(
                                id: ts.millisecondsSinceEpoch.toString(),
                                createdAt: ts,
                                updatedAt: ts,
                                title: _titleController.text,
                                director: _directorController.text,
                                imgPath: _savedFilePath,
                              );
                              await _movieDAO.box.add(m);
                              _savedFileName='';
                              _savedFilePath='';
                              context.router.pop();
                            }
                          },
                          icon: const Icon(Icons.save),
                          label: const Text('SAVE'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _chooseImage(BuildContext context) async {}
}
