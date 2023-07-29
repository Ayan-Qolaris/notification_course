import 'dart:developer';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.media.notification.demo',
      androidNotificationChannelName: 'Media Notification Demo',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
}

class MyAudioHandler extends BaseAudioHandler {
  // Override needed methods
  final _player = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(children: []);

  MyAudioHandler() {
    _loadEmptyPlaylist();
    _notifyAudioHandlerAboutPlaybackEvents();
  }

  Future<void> _loadEmptyPlaylist() async {
    try {
      await _player.setAudioSource(_playlist);
    } catch (e) {
      log("e -> $e");
    }
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    // manage the audio player - Just Audio
    final audioSource = mediaItems.map(_createAudioSource);
    _playlist.addAll(audioSource.toList());

    // notify the system
    final newQueue = queue.value..addAll(mediaItems);
    queue.add(newQueue);
  }

  UriAudioSource _createAudioSource(MediaItem mediaItem) {
    return AudioSource.uri(
      Uri.parse(mediaItem.extras!['uri']),
      tag: mediaItem,
    );
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen(
      (event) {
        final playing = _player.playing;
        playbackState.add(
          playbackState.value.copyWith(
            controls: [
              MediaControl.skipToPrevious,
              if (playing) MediaControl.pause else MediaControl.play,
              MediaControl.stop,
              MediaControl.skipToNext
            ],
            systemActions: const {
              MediaAction.seek,
            },
            androidCompactActionIndices: [0, 1, 3],
            // processingState: {
            //   ProcessingState.idle = AudioProcessingState.idle,
            //   ProcessingState.loading = AudioProcessingState.loading,
            //   ProcessingState.buffering = AudioProcessingState.buffering,
            //   ProcessingState.ready = AudioProcessingState.ready,
            //   ProcessingState.completed = AudioProcessingState.completed,
            // }[_player.processingState]!,
            playing: playing,
            updatePosition: _player.position,
            bufferedPosition: _player.bufferedPosition,
            speed: _player.speed,
            queueIndex: event.currentIndex,
          ),
        );
      },
    );
  }
}
