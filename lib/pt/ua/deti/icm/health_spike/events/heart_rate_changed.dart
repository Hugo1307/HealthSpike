class HeartRateChangedEvent {
  final double heartRate;
  final DateTime timestamp;

  HeartRateChangedEvent(this.heartRate, this.timestamp);

  factory HeartRateChangedEvent.fromJson(Map<dynamic, dynamic> json) {
    if (!json.containsKey('heartRate') || !json.containsKey('timestamp')) {
      return HeartRateChangedEvent(0, DateTime.fromMicrosecondsSinceEpoch(0));
    }
    return HeartRateChangedEvent(
        json['heartRate'], DateTime.parse(json['timestamp'].toString()));
  }

  Map<String, dynamic> toJson() => {
        'heartRate': heartRate,
        'timestamp': timestamp,
      };
}
