import 'package:audio_player/components/play_button.dart';
import 'package:audio_player/components/track_progress_bar.dart';
import 'package:audio_player/models/track.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrackDetailScreen extends ConsumerWidget {
  final Track track;
  const TrackDetailScreen({
    super.key,
    required this.track,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracks'),
      ),
      body: Center(
        child: Column(
          children: [
            Image.network(
              track.imageUrl,
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            ),
            Text(
              track.title,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              track.artist,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TrackPlayButton(track: track),
            TrackProgressBar(track: track)
          ],
        ),
      ),
    );
  }
}
