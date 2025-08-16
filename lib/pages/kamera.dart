import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isyarat_kita/util/color.dart';
import 'package:isyarat_kita/component/text.dart';
import 'package:isyarat_kita/widget/card.dart';
import 'package:permission_handler/permission_handler.dart';

class KameraPage extends StatefulWidget {
  const KameraPage({Key? key}) : super(key: key);

  @override
  State<KameraPage> createState() => _KameraPageState();
}

class _KameraPageState extends State<KameraPage> {
  List<CameraDescription> cameras = [];
  CameraController? controller;
  bool isAndroidBelow10 = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    bool permissionGranted = await _requestPermissions();
    if (!permissionGranted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Izin Diperlukan"),
          content: const Text("Izin kamera diperlukan untuk menggunakan fitur ini."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt < 29) {
        isAndroidBelow10 = true;
      }
    }

    List<CameraDescription> _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      setState(() {
        cameras = _cameras;
        controller = CameraController(
          _cameras.first,
          ResolutionPreset.max,
        );
      });

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      await controller?.initialize();
      setState(() {});
    }
  }

  Future<bool> _requestPermissions() async {
    var cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isGranted) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildCameraView(),
    );
  }

  Widget _buildCameraView() {
    final mediaQuery = MediaQuery.of(context);
    if (controller == null || controller!.value.isInitialized == false) {
      return const Center(child: CircularProgressIndicator());
    }

    Widget cameraPreview = CameraPreview(controller!);

    if (Platform.isAndroid) {
      if (!isAndroidBelow10) {
        cameraPreview = RotatedBox(
          quarterTurns: 1,
          child: cameraPreview,
        );
      }
    } else {
      cameraPreview = RotatedBox(
        quarterTurns: 1,
        child: cameraPreview,
      );
    }

    return SafeArea(
      child: Column(
        children: [
          Container(
            height: mediaQuery.size.height * 0.75,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Center(
              child: ClipRect(
                child: OverflowBox(
                  maxWidth: double.infinity,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: cameraPreview,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: MyCard(
              title: "Hasil: ",
              subtitle: "A",
              color: primaryColor,
              textColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
