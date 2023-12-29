import 'package:audio_player/providers/playback_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaybackBottomBar extends ConsumerWidget {
  const PlaybackBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(playbackProvider.notifier);
    final track = ref.watch(playbackProvider);

    if (track == null) {
      return const SizedBox.shrink();
    }

    return ValueListenableBuilder(
      valueListenable: provider.isPlayingNotifier,
      builder: (context, isPlaying, _) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 12.0),
            ],
          ),
          child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StreamBuilder<PositionData>(
                      stream: provider.positionDataStream,
                      builder: (context, snapshot) {
                        final positionData = snapshot.data;
                        if (positionData == null) {
                          return const SizedBox(
                            height: 4,
                          );
                        }

                        final width = (positionData.position.inMilliseconds /
                                positionData.duration.inMilliseconds) *
                            MediaQuery.of(context).size.width;

                        return Container(
                          width: double.infinity,
                          height: 4,
                          color: Colors.white54,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: width,
                              height: 4,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      }),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (isPlaying) {
                            provider.player.pause();
                          } else {
                            provider.player.play();
                          }
                        },
                        color: Colors.white,
                        iconSize: 38,
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              track.title,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              track.artist,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          provider.stopAndClear();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ],
              )),
        );
      },
    );
  }
}
