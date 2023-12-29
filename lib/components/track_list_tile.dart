import 'package:audio_player/models/track.dart';
import 'package:audio_player/screens/track_detail_screen.dart';
import 'package:flutter/material.dart';

class TrackListTile extends StatelessWidget {
  final Track track;
  const TrackListTile({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Card(
        child: ListTile(
          title: Text(track.title),
          subtitle: Text(track.artist),
          leading: Image.network(
            track.imageUrl,
            fit: BoxFit.cover,
            width: 40,
            height: 40,
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => TrackDetailScreen(track: track),
              ),
            );
          },
        ),
      ),
    );
  }
}
