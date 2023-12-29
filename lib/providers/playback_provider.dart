import 'package:audio_player/models/track.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

class PositionData {
  final Duration position;
  final Duration buffered;
  final Duration duration;

  PositionData({
    required this.position,
    required this.buffered,
    required this.duration,
  });
}

class PlayBackProvider extends StateNotifier<Track?> {
  PlayBackProvider() : super(null) {
    init();
  }

  late final AudioSession session;
  final player = AudioPlayer();

  final isPlayingNotifier = ValueNotifier<bool>(false);

  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        player.positionStream,
        player.bufferedPositionStream,
        player.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position: position,
          buffered: bufferedPosition,
          duration: duration ?? Duration.zero,
        ),
      );

  init() async {
    session = await AudioSession.instance;
    await session.configure(
      const AudioSessionConfiguration.music(),
    );

    ///A stream that will react to any action
    player.playerStateStream.listen((event) {
      if (event.playing) {
        isPlayingNotifier.value = true;
      } else {
        isPlayingNotifier.value = false;
      }
    });
  }

  Future<void> load(Track track) async {
    state = track;
    final source = AudioSource.uri(
      Uri.parse(track.audioUrl),
      tag: MediaItem(
        id: track.id,
        title: track.title,
        artUri: Uri.parse(track.imageUrl),
        artist: track.artist,
      ),
    );

    await player.setAudioSource(source);
  }
  //to stop and clear
  Future<void> stopAndClear() async {
    player.stop();
    state = null;
  }
}

final playbackProvider = StateNotifierProvider<PlayBackProvider, Track?>((ref) {
  return PlayBackProvider();
});
