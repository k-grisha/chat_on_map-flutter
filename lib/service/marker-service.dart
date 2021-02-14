import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

import '../client/map-client.dart';
import '../dto/point-dto.dart';
import '../model/map-point.dart';
import 'preferences-service.dart';

class MarkerService {
  final List<ClusterItem<MapPoint>> _items = [];
  var logger = Logger();
  final MapClient _mapClient;
  final PreferencesService _preferences;

  MarkerService(this._mapClient, this._preferences);

  Future<void> doUpdate() async {
    var myUuid = await _preferences.getUuid();
    if (myUuid == null) {
      return;
    }
    try {
      List<PointDto> dtos = await _mapClient.getPoints();
      var newItems = dtos
          .map((dto) => ClusterItem(LatLng(dto.lat / 1000000, dto.lon / 1000000), item: MapPoint(dto.uuid)))
          .toList();
      //fixme
      _items.clear();
      _items.addAll(newItems);
      // Set<Marker> markers = dtos
      //     .map((dto) => Marker(markerId: MarkerId(dto.id), position: LatLng(dto.lat / 1000000, dto.lon / 1000000)))
      //     .toSet();
      // _markers.addAll(markers);
    } catch (e) {
      logger.w("Point Service is unreachable ", e);
    }
  }

  // Set<Marker> getMarkers() {
  //   return new HashSet<Marker>.from(_markers);
  // }

  List<ClusterItem<MapPoint>> getItems() {
    return new List<ClusterItem<MapPoint>>.from(_items);
  }
}
