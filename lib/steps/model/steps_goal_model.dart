import 'package:objectbox/objectbox.dart';

@Entity()
class StepsGoal {

  @Id()
  int id;
  int stepsGoal;

  StepsGoal({this.id=0, required this.stepsGoal});

}