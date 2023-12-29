import 'package:audio_player/models/track.dart';
import 'package:audio_player/providers/playback_provider.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrackProgressBar extends ConsumerWidget {
  final Track track;
  const TrackProgressBar({
    super.key,
    required this.track,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(playbackProvider.notifier);

    final currentTrack = ref.watch(playbackProvider);

    if (currentTrack?.id != track.id) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () {
              Duration newPosition =
                  provider.player.position - const Duration(seconds: 10);
              if (newPosition.isNegative) {
                newPosition = Duration.zero;
              }
              provider.player.seek(newPosition);
            },
            icon: const Icon(
              Icons.replay_10,
              size: 32,
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<PositionData>(
              stream: provider.positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;

                return ProgressBar(
                  progress: positionData?.position ?? Duration.zero,
                  buffered: positionData?.buffered ?? Duration.zero,
                  total: positionData?.duration ?? Duration.zero,
                  timeLabelTextStyle: Theme.of(context).textTheme.bodySmall,
                  onSeek: (duration) {
                    provider.player.seek(duration);
                  },
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () {
              provider.player
                  .seek(provider.player.position + const Duration(seconds: 10));
            },
            icon: const Icon(
              Icons.forward_10,
              size: 32,
            ),
          ),
        ),
      ],
    );
  }
}
