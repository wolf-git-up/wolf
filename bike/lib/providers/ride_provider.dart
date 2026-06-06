import 'package:flutter/foundation.dart';
import '../models/rider_model.dart';

class RideSetup extends ChangeNotifier {
  // Ride setup data
  bool _isSoloRide = false;
  String? _selectedSquadId;
  RiderRole? _selectedRole;
  String? _fromLocation;
  String? _toLocation;

  // Getters
  bool get isSoloRide => _isSoloRide;
  String? get selectedSquadId => _selectedSquadId;
  RiderRole? get selectedRole => _selectedRole;
  String? get fromLocation => _fromLocation;
  String? get toLocation => _toLocation;

  // Setters
  void setRideType(bool solo) {
    _isSoloRide = solo;
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
    _isSoloRide = false;
    _selectedSquadId = null;
    _selectedRole = null;
    _fromLocation = null;
    _toLocation = null;
    notifyListeners();
  }

  // Check if ride setup is complete
  bool get isComplete {
    if (_isSoloRide) {
      return _fromLocation != null && _toLocation != null;
    } else {
      return _selectedSquadId != null &&
          _selectedRole != null &&
          _fromLocation != null &&
          _toLocation != null;
    }
  }
}
