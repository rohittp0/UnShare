import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:external_path/external_path.dart';
import 'package:open_file_manager/open_file_manager.dart';


void main() => runApp(const FileReceiverApp());

class FileReceiverApp extends StatefulWidget {
  const FileReceiverApp({super.key});

  @override
  State<FileReceiverApp> createState() => _FileReceiverAppState();
}

class _FileReceiverAppState extends State<FileReceiverApp> {
  StreamSubscription? _sub;
  bool _receivedShare = false;

  @override
  void initState() {
    super.initState();

    // Listen for new shares while app is in foreground
    _sub = ReceiveSharingIntent
        .instance
        .getMediaStream()
        .listen(_onSharedFiles);

    // Handle the case where the app was launched by a share intent
    ReceiveSharingIntent
        .instance
        .getInitialMedia()
        .then(_onSharedFiles);
  }

  /// Called whenever files are shared to us
  Future<void> _onSharedFiles(List<SharedMediaFile> files) async {
    if (files.isEmpty) return;

    // Avoid re-opening on multiple chunks
    if (_receivedShare) return;
    _receivedShare = true;

    await _openDownloadsFolder();

    // After launching the file explorer, exit the app
    SystemNavigator.pop();
  }

  /// Fires an Android Intent to open the Downloads folder in the file manager.
  Future<void> _openDownloadsFolder() async {
    if (!Platform.isAndroid) {
      return;
    }

    try {
      final downloadsDir = await ExternalPath
          .getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOAD);

      openFileManager(
        androidConfig: AndroidConfig(
          folderType: AndroidFolderType.download,
        ),
        iosConfig: IosConfig(
          // Path is case-sensitive here.
          folderPath: downloadsDir,
        ),
      );
    } on PlatformException catch (e) {
      debugPrint('Error launching file manager: $e');
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If we've already handled a share, render nothing (we're exiting)
    if (_receivedShare) {
      return const SizedBox.shrink();
    }

    // Otherwise show the welcome/instruction screen
    return MaterialApp(
      title: 'UnShare',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('UnShare'),
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.file_download_outlined,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Save Files with One Tap',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tap “Share” in any app, choose “UnShare”, and we’ll drop your file straight into Downloads.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
