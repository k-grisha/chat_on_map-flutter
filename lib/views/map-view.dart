import 'dart:async';
import 'dart:ui';

import 'package:chat_on_map/model/chat-user.dart';
import 'package:chat_on_map/service/position-service.dart';
import 'package:chat_on_map/service/preferences-service.dart';
import 'package:chat_on_map/service/user-service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:sqlite_viewer/sqlite_viewer.dart';

import '../model/map-point.dart';
import '../service/marker-service.dart';
import 'dialog/custom_info_window.dart';

class MapWidget extends StatefulWidget {
  final MarkerService _markerService;
  final PreferencesService _preferences;
  final PositionService _positionService;
  final UserService _userService;
  final CameraPosition _initCameraPosition = CameraPosition(target: LatLng(52.479099, 13.373282), zoom: 9.0);

  MapWidget(this._markerService, this._preferences, this._positionService, this._userService);

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> with WidgetsBindingObserver {
  var logger = Logger();
  ClusterManager _clusterManager;

  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> markers = Set();

  AppLifecycleState _notification;

  void _startUpdateMarkers() async {
    while (true) {
      if (isActive()) {
        await widget._markerService.doUpdate();
        _clusterManager.setItems(widget._markerService.getItems());
      }
      await new Future.delayed(const Duration(milliseconds: 3000));
    }
  }

  void _startUpdateMyPoint() async {
    while (true) {
      await widget._positionService.updateMyPoint();
      await new Future.delayed(const Duration(milliseconds: 3000));
    }
  }

  bool isActive() {
    return (_notification == null || _notification.index == 0) && ModalRoute.of(context).isCurrent;
  }

  @override
  void initState() {
    super.initState();
    _clusterManager = _initClusterManager();
    Future.delayed(Duration.zero, () {
      _checkIfRegistered();
      _startUpdateMarkers();
      _startUpdateMyPoint();
    });
    WidgetsBinding.instance.addObserver(this);
  }

  void _checkIfRegistered() async {
    String myUuid = await widget._preferences.getUuid();
    if (myUuid == null) {
      Navigator.pushNamed(context, '/registration');
    }
  }

  @override
  // fixme: it doesn't work
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    setState(() {
      _notification = state;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  ClusterManager _initClusterManager() {
    return ClusterManager<MapPoint>([], _updateMarkers,
        markerBuilder: _markerBuilder, initialZoom: widget._initCameraPosition.zoom, stopClusteringZoom: 17.0);
  }

  void _updateMarkers(Set<Marker> markers) {
    print('Markers Updated ${markers.length} ');
    setState(() {
      this.markers = markers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Stack(children: <Widget>[
      GoogleMap(
          mapToolbarEnabled: false,
          mapType: MapType.normal,
          initialCameraPosition: widget._initCameraPosition,
          markers: markers,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            _clusterManager.setMapController(controller);
          },
          onCameraMove: _clusterManager.onCameraMove,
          onCameraIdle: _clusterManager.updateMap),
      Padding(
        padding: const EdgeInsets.all(40.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: FloatingActionButton(
            heroTag: null,
            onPressed: () => Navigator.pushNamed(context, '/chat-list'),
            materialTapTargetSize: MaterialTapTargetSize.padded,
            backgroundColor: Colors.orange,
            child: const Icon(Icons.forum, size: 36.0),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(40.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            heroTag: null,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DatabaseList())),
            materialTapTargetSize: MaterialTapTargetSize.padded,
            backgroundColor: Colors.orange,
            child: const Icon(Icons.gradient_sharp, size: 36.0),
          ),
        ),
      ),
    ]));
  }

  Future<Marker> Function(Cluster<MapPoint>) get _markerBuilder => (cluster) async {
        var markerUuid = cluster.isMultiple ? cluster.getId() : cluster.items.first.uuid;
        var isMe = markerUuid == await widget._preferences.getUuid();
        return Marker(
          markerId: MarkerId(markerUuid),
          position: cluster.location,
          infoWindow: cluster.isMultiple ? null : await getInfoWindow(cluster, isMe),
          consumeTapEvents: true,
          onTap: () {
            print("Im tapped");
            _animateCamera(cluster.location);
            if (!cluster.isMultiple && !isMe) {
              _showInfoWindow(markerUuid);
            }
          },
          icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75,
              text: cluster.isMultiple ? cluster.count.toString() : null),
        );
      };

  _animateCamera(LatLng location) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(location));
  }

  _showInfoWindow(String markerUuid) async {
    ChatUser chatUser = await widget._userService.getUser(markerUuid);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Align(
              alignment: Alignment.topCenter,
              child: CustomInfoWindow(
                chatUser: chatUser,
              ));
        });
  }

  Future<InfoWindow> getInfoWindow(Cluster<MapPoint> cluster, bool isMe) async {
    MapPoint point = cluster.items.first;
    if (isMe) {
      return InfoWindow(title: "It is me " + point.uuid, snippet: '*');
    }
    ChatUser user = await widget._userService.getUser(point.uuid);
    return InfoWindow(
        title: "My Name is " + user.name,
        snippet: '*',
        onTap: () {
          Navigator.pushNamed(context, '/chat', arguments: user);
        });
  }

  Future<BitmapDescriptor> _getMarkerBitmap(int size, {String text}) async {
    assert(size != null);

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = Colors.orange;
    final Paint paint2 = Paint()..color = Colors.white;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(fontSize: size / 3, color: Colors.white, fontWeight: FontWeight.normal),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }
}
