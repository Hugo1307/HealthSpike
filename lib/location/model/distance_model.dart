import 'package:objectbox/objectbox.dart';

@Entity()
class DistanceModel {

  @Id()
  int id;

  DateTime timestamp;
  double distance;

  DistanceModel({this.id=0, required this.timestamp, required this.distance});

}