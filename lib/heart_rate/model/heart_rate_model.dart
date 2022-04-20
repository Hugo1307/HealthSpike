import 'package:objectbox/objectbox.dart';

@Entity()
class HeartRate {

  @Id()
  int id;

  DateTime timestamp;
  double heartRateValue;

  HeartRate({this.id=0, required this.timestamp, required this.heartRateValue});

}