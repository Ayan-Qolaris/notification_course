import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:notification_course/get_it.dart';
import 'package:notification_course/notifiers/play_button_notifier.dart';
import 'package:notification_course/notifiers/progress_notifier.dart';
import 'package:notification_course/services/playlist_repository.dart';

class PageManager {
  // Listeners: Updates going to the UI
  final currentSongTitleNotifier = ValueNotifier<String>('');
  final playListNotifier = ValueNotifier<List<String>>([]);
  final progressNotifier = ProgressNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();

  final _audioHandler = getIt<AudioHandler>();

  // Events: calls coming from the UI
  void init() async {
    await _loadPlayList();
    _listenToChangesInPlaylist();
    _listenToPlaybackState();
  }

  Future<void> _loadPlayList() async {
    final songRepository = getIt<PlaylistRepository>();
    final playList = await songRepository.fetchInitialPlaylist();
    final mediaItems = playList
        .map(
          (song) => MediaItem(
            id: song['id'] ?? "",
            album: song['album'] ?? "",
            title: song['title'] ?? "",
            extras: {
              'url': song['url'],
            },
          ),
        )
        .toList();
    _audioHandler.addQueueItems(mediaItems);
  }

  void _listenToChangesInPlaylist() {
    _audioHandler.queue.listen((playList) {
      if (playList.isEmpty) {
        return;
      }
      final newList = playList.map((item) => item.title).toList();
      playListNotifier.value = newList;
    });
  }

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playBackState) {
      final isPlaying = playBackState.playing;
      final processingState = playBackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        playButtonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = ButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        playButtonNotifier.value = ButtonState.playing;
      } else {
        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
      }
    });
  }

  void play() => _audioHandler.play();
  void pause() => _audioHandler.pause();
  void seek(Duration position) {}
  void previous() {}
  void next() {}
  // void repeat() {}
  // void shuffle() {}
  // void add() {}
  // void remove() {}
  void dispose() {}
}
