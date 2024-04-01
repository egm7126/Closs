import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(
      const GeolocatorWidget()
  );
}

/// Example [Widget] showing the functionalities of the geolocator plugin
class GeolocatorWidget extends StatefulWidget {
  /// Creates a new GeolocatorWidget.
  const GeolocatorWidget({Key? key}) : super(key: key);

  @override
  State<GeolocatorWidget> createState() => _GeolocatorWidgetState();
}
+
class _GeolocatorWidgetState extends State<GeolocatorWidget> {

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final List<_PositionItem> _positionItems = <_PositionItem>[];
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
  bool positionStreamStarted = false;

  @override
  void initState() {
    super.initState();
    _toggleServiceStatusStream();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        body: ListView.builder(
          itemCount: _positionItems.length,
          itemBuilder: (context, index) {
            final positionItem = _positionItems[index];

            if (positionItem.type == _PositionItemType.log) {
              return ListTile(
                title: Text(positionItem.displayValue,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
              );
            } else {
              return Card(
                child: ListTile(
                  title: Text(
                    positionItem.displayValue,
                  ),
                ),
              );
            }
          },
        ),
        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                positionStreamStarted = !positionStreamStarted;
                _toggleListening();
              },
              tooltip: (_positionStreamSubscription == null)
                  ? 'Start position updates'
                  : _positionStreamSubscription!.isPaused
                  ? 'Resume'
                  : 'Pause',
              child: (_positionStreamSubscription == null ||
                  _positionStreamSubscription!.isPaused)
                  ? const Icon(Icons.play_arrow)
                  : const Icon(Icons.pause),
            ),
          ],
        ),
      ),
    );
  }

  void _updatePositionList(_PositionItemType type, String displayValue) {
    _positionItems.add(_PositionItem(type, displayValue));
    setState(() {});
  }

  void _toggleServiceStatusStream() {
    if (_serviceStatusStreamSubscription == null) {
      final serviceStatusStream = _geolocatorPlatform.getServiceStatusStream();
      _serviceStatusStreamSubscription =
          serviceStatusStream.handleError((error) {
        _serviceStatusStreamSubscription?.cancel();
        _serviceStatusStreamSubscription = null;
      }).listen((serviceStatus) {
        String serviceStatusValue;
        if (serviceStatus == ServiceStatus.enabled) {
          if (positionStreamStarted) {
            _toggleListening();
          }
          serviceStatusValue = 'enabled';
        } else {
          if (_positionStreamSubscription != null) {
            setState(() {
              _positionStreamSubscription?.cancel();
              _positionStreamSubscription = null;
              _updatePositionList(
                  _PositionItemType.log, 'Position Stream has been canceled');
            });
          }
          serviceStatusValue = 'disabled';
        }
        _updatePositionList(
          _PositionItemType.log,
          'Location service has been $serviceStatusValue',
        );
      });
    }
  }

  void _toggleListening() {
    if (_positionStreamSubscription == null) {
      final positionStream = _geolocatorPlatform.getPositionStream();
      _positionStreamSubscription = positionStream.handleError((error) {
        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = null;
      }).listen((position) => _updatePositionList(
            _PositionItemType.position,
            position.toString(),
          ));
      _positionStreamSubscription?.pause();
    }

    setState(() {
      if (_positionStreamSubscription == null) {
        return;
      }

      String statusDisplayValue;
      if (_positionStreamSubscription!.isPaused) {
        _positionStreamSubscription!.resume();
        statusDisplayValue = 'resumed';
      } else {
        _positionStreamSubscription!.pause();
        statusDisplayValue = 'paused';
      }

      _updatePositionList(
        _PositionItemType.log,
        'Listening for position updates $statusDisplayValue',
      );
    });
  }

  @override
  void dispose() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription!.cancel();
      _positionStreamSubscription = null;
    }

    super.dispose();
  }
}

enum _PositionItemType {
  log,
  position,
}

class _PositionItem {
  _PositionItem(this.type, this.displayValue);

  final _PositionItemType type;
  final String displayValue;
}