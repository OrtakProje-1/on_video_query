import 'package:flutter/material.dart';
import 'dart:async';
import 'package:on_video_query/on_video_query.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<FolderVideos> folderVideos = [];
  @override
  void initState() {
    super.initState();
    getVideos();
  }

  Future<void> getVideos() async {
    List<FolderVideos> folderVideos = [];
    try {
      folderVideos = (await OnVideoQuery.getVideos) ?? [];
    } on PermissionException catch (e) {
      debugPrint(e.errorMessage);
    }

    if (!mounted) return;

    setState(() {
      this.folderVideos = folderVideos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: folderVideos.isEmpty
            ? const Center(
                child: Text("Nothing to show here"),
              )
            : ListView.builder(
                itemCount: folderVideos.length,
                itemBuilder: (_, index) {
                  FolderVideos folder = folderVideos[index];
                  return ListTile(
                    title: Text(folder.name),
                    subtitle:
                        Text(folder.videos.length.toString() + " video found"),
                  );
                },
              ),
      ),
    );
  }
}
