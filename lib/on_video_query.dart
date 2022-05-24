import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class OnVideoQuery {
  static const MethodChannel _channel = MethodChannel('on_video_query');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<List<FolderVideos>?> get getVideos async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      final Map<String, List<Map<String, dynamic>>>? videos = await _channel
          .invokeMethod<Map<String, List<Map<String, dynamic>>>>('getVideos');
      if (videos != null) {
        return videos.entries.map<FolderVideos>((map) {
          return FolderVideos(
            path: map.key,
            videos: map.value.map((e) => Video.fromMap(e)).toList(),
          );
        }).toList();
      } else {
        return [];
      }
    } else {
      throw PermissionException("Permission denied");
    }
  }
}

class PermissionException implements Exception {
  PermissionException(this.errorMessage);
  String errorMessage;

  @override
  String toString() {
    return errorMessage;
  }
}

class FolderVideos {
  String path;
  List<Video> videos;
  FolderVideos({
    required this.path,
    required this.videos,
  });

  FolderVideos copyWith({
    String? path,
    List<Video>? videos,
  }) {
    return FolderVideos(
      path: path ?? this.path,
      videos: videos ?? this.videos,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'videos': videos.map((x) => x.toMap()).toList(),
    };
  }

  factory FolderVideos.fromMap(Map<String, dynamic> map) {
    return FolderVideos(
      path: map['path'] ?? '',
      videos: List<Video>.from(map['videos']?.map((x) => Video.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory FolderVideos.fromJson(String source) =>
      FolderVideos.fromMap(json.decode(source));

  @override
  String toString() => 'Folder(path: $path, videos: $videos)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FolderVideos &&
        other.path == path &&
        listEquals(other.videos, videos);
  }

  @override
  int get hashCode => path.hashCode ^ videos.hashCode;
}

class Video {
  String path;
  int id;
  String name;

  // millisecond
  int duration;
  Video({
    required this.path,
    required this.id,
    required this.name,
    required this.duration,
  });

  Video copyWith({
    String? url,
    int? mediaid,
    String? name,
    int? duration,
  }) {
    return Video(
      path: url ?? this.path,
      id: mediaid ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': path,
      'mediaid': id,
      'name': name,
      'duration': duration,
    };
  }

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      path: map['url'] ?? '',
      id: map['mediaid']?.toInt() ?? 0,
      name: map['name'] ?? '',
      duration: map['duration']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Video.fromJson(String source) => Video.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Video(url: $path, mediaid: $id, name: $name, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Video &&
        other.path == path &&
        other.id == id &&
        other.name == name &&
        other.duration == duration;
  }

  @override
  int get hashCode {
    return path.hashCode ^ id.hashCode ^ name.hashCode ^ duration.hashCode;
  }
}
