import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class KameraPage extends StatefulWidget {
  const KameraPage({super.key});

  @override
  State<KameraPage> createState() => _KameraPageState();
}

class _KameraPageState extends State<KameraPage> {
  List<CameraDescription> cameras = [];
  CameraController? controller;

  @override
  void initState() {
    super.initState();
    // requestStoragePermission();
    _setupCameraController();
  }

  Future<void> _setupCameraController() async {
    List<CameraDescription> _cameras = await availableCameras();
    if(_cameras.isNotEmpty){
      setState(() {
        cameras = _cameras;
        controller = CameraController(
            _cameras.first,
            ResolutionPreset.max,
        );
      });
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ]);
      await controller?.initialize();
        setState(() {

        });
    }
  }


  void requestStoragePermission() async {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      var cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
        await Permission.camera.request();
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _build(),
    );
  }

  Widget _build(){
    print("Controller $controller");
    if (controller == null || controller?.value.isInitialized == false) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SafeArea(
      child: RotatedBox(
        quarterTurns: 1,
        child: SizedBox.expand(child: CameraPreview(controller!)),
      ),
    );
  }
}
