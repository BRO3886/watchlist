import 'package:hive/hive.dart';

part 'movie.g.dart';

@HiveType(typeId: 1)
class Movie extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? director;
  @HiveField(4)
  String? imgPath;
  @HiveField(5)
  DateTime? createdAt;
  @HiveField(6)
  DateTime? updatedAt;

  Movie({
    this.id,
    this.title,
    this.director,
    this.imgPath,
    this.createdAt,
    this.updatedAt,
  });
}
