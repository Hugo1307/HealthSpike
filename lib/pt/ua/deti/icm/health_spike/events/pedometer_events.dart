class StepsUpdatedEvent {

  DateTime timestamp;
  int stepsCount;
  
  StepsUpdatedEvent(this.stepsCount);

}

class PedestrianStatusUpdatedEvent {

  DateTime timestamp;
  String newStatus;

  PedestrianStatusUpdatedEvent(this.newStatus);

}
