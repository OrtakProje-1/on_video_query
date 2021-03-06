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
      final Map? videos = await _channel.invokeMethod<Map>('getVideos');
      if (videos != null) {
        return videos.entries.map((map) {
          return FolderVideos(
              name: map.key,
              videos: (map.value as List<dynamic>)
                  .map((e) => Video.fromMap(e as Map))
                  .toList(growable: false));
        }).toList(growable: false);
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
  String name;
  List<Video> videos;
  FolderVideos({
    required this.name,
    required this.videos,
  });

  FolderVideos copyWith({
    String? name,
    List<Video>? videos,
  }) {
    return FolderVideos(
      name: name ?? this.name,
      videos: videos ?? this.videos,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'videos': videos.map((x) => x.toMap()).toList(),
    };
  }

  factory FolderVideos.fromMap(Map map) {
    return FolderVideos(
      name: map['name'] ?? '',
      videos: List<Video>.from(map['videos']?.map((x) => Video.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory FolderVideos.fromJson(String source) =>
      FolderVideos.fromMap(json.decode(source));

  @override
  String toString() => 'Folder(name: $name, videos: $videos)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FolderVideos &&
        other.name == name &&
        listEquals(other.videos, videos);
  }

  @override
  int get hashCode => name.hashCode ^ videos.hashCode;
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
    String? path,
    int? id,
    String? name,
    int? duration,
  }) {
    return Video(
      path: path ?? this.path,
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'id': id,
      'name': name,
      'duration': duration,
    };
  }

  factory Video.fromMap(Map map) {
    return Video(
      path: map['path'] ?? '',
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      duration: map['duration']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Video.fromJson(String source) => Video.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Video(path: $path, id: $id, name: $name, duration: $duration)';
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
