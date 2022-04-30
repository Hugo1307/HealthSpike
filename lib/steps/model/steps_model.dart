import 'package:objectbox/objectbox.dart';

@Entity()
class Steps {

  @Id()
  int id;

  DateTime timestamp;
  int count;

  Steps({this.id=0, required this.timestamp, required this.count});

}