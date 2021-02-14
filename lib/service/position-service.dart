import 'package:chat_on_map/dto/point-dto.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

import '../client/map-client.dart';
import 'preferences-service.dart';

class PositionService {
  final PreferencesService _preferences;
  final MapClient _mapClient;
  var logger = Logger();

  PositionService(this._preferences, this._mapClient);

  updateMyPoint() async {
    String myUuid = await _preferences.getUuid();
    if (myUuid != null) {
      try {
        // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        Position position = await _determinePosition();
        await _mapClient.updatePosition(
            myUuid, PointDto(null, (position.latitude * 1000000).toInt(), (position.longitude * 1000000).toInt()));
      } catch (e) {
        logger.w("Unable to update position ", e);
      }
    }
  }


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

}
