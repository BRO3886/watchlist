import 'package:hive/hive.dart';

part 'user.g.dart';

/*
* Don't change the field numbers for any existing fields.
* If you add new fields, any objects written by the "old" adapter can still be read by the new adapter. 
These fields are just ignored. Similarly, objects written by your new code can be read by your old code: 
the new field is ignored when parsing.
* Fields can be renamed and even changed from public to private or vice versa as long as the field number
 stays the same.
* Fields can be removed, as long as the field number is not used again in your updated class.
* Changing the type of a field is not supported. You should create a new one instead.
*/

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? photoURL;
  @HiveField(2)
  bool? isSignedIn;

  User({
    this.name,
    this.photoURL,
    this.isSignedIn,
  });
}
