import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/tracked_ride.dart';

class RideStorage {
  static const _key = 'tracked_rides';

  Future<List<TrackedRide>> loadRides() async {
    final preferences = await SharedPreferences.getInstance();
    final rawRides = preferences.getStringList(_key) ?? <String>[];
    return rawRides
        .map(
          (rawRide) =>
              TrackedRide.fromJson(jsonDecode(rawRide) as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> saveRide(TrackedRide ride) async {
    final rides = await loadRides();
    rides.insert(0, ride);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      _key,
      rides.map((item) => jsonEncode(item.toJson())).toList(),
    );
  }
}
