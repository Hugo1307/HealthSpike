class StepsUpdatedEvent {

  DateTime timestamp;
  int stepsCount;
  
  StepsUpdatedEvent(this.stepsCount, this.timestamp);

}

class PedestrianStatusUpdatedEvent {

  DateTime timestamp;
  String pedestrianStatus;

  PedestrianStatusUpdatedEvent(this.pedestrianStatus, this.timestamp);

}
