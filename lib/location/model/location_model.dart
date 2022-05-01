import 'package:objectbox/objectbox.dart';

@Entity()
class LocationModel {

  @Id()
  int id;

  DateTime timestamp;
  double latitude;
  double longitude;

  LocationModel({this.id=0, required this.timestamp, required this.latitude, required this.longitude});

}