import 'package:flutter/foundation.dart';
import '../models/rider_model.dart';

enum RideMode { solo, duo, squad }

class RideSetup extends ChangeNotifier {
  // Ride setup data
  String? _rideName;
  RideMode _rideMode = RideMode.solo;
  String? _selectedSquadId;
  RiderRole? _selectedRole;
  String? _fromLocation;
  String? _toLocation;

  // Getters
  String? get rideName => _rideName;
  RideMode get rideMode => _rideMode;
  bool get isSoloRide => _rideMode == RideMode.solo;
  bool get isGroupRide => _rideMode != RideMode.solo;
  String? get selectedSquadId => _selectedSquadId;
  RiderRole? get selectedRole => _selectedRole;
  String? get fromLocation => _fromLocation;
  String? get toLocation => _toLocation;

  // Setters
  void setTripName(String name) {
    _rideName = name;
    notifyListeners();
  }

  void setRideMode(RideMode mode) {
    _rideMode = mode;
    notifyListeners();
  }

  void setSelectedSquad(String squadId) {
    _selectedSquadId = squadId;
    notifyListeners();
  }

  void setSelectedRole(RiderRole role) {
    _selectedRole = role;
    notifyListeners();
  }

  void setFromLocation(String location) {
    _fromLocation = location;
    notifyListeners();
  }

  void setToLocation(String location) {
    _toLocation = location;
    notifyListeners();
  }

  // Reset for new ride
  void reset() {
    _rideName = null;
    _rideMode = RideMode.solo;
    _selectedSquadId = null;
    _selectedRole = null;
    _fromLocation = null;
    _toLocation = null;
    notifyListeners();
  }

  /// Whether a ride is currently active and visible on the map.
  bool get hasActiveRide {
    return _rideName != null && _fromLocation != null && _toLocation != null;
  }

  /// Ends the active ride and clears ride setup data.
  void endRide() {
    reset();
  }

  // Check if ride setup is complete
  bool get isComplete {
    if (_rideName == null || _rideName!.isEmpty) {
      return false;
    }
    if (_fromLocation == null || _toLocation == null) {
      return false;
    }
    if (isGroupRide) {
      return _selectedSquadId != null && _selectedRole != null;
    }
    return true;
  }
}
