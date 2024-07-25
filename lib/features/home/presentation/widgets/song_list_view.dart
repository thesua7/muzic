import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:muzic/core/utils/conversion_utils.dart';
import 'package:muzic/features/home/domain/entities/song.dart';

class SongsListView extends StatelessWidget {
  final List<Song> songs;

  const SongsListView({super.key, required this.songs});

  @override
  Widget build(BuildContext context) {
    if (songs.isEmpty) {
      return const Center(child: Text("No songs found"));
    }

    // Cache future results
    final Map<int, Future<String>> futureCache = {};

    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        final future = futureCache.putIfAbsent(index, () => song.getAlbumArtworkPath(song.albumArtImagePath));

        return FutureBuilder<String>(
          future: future,
          builder: (context, snapshot) {
            Widget imageWidget;

            if (snapshot.connectionState == ConnectionState.waiting) {
              imageWidget = Container(
                width: 50,
                height: 50,
                color: Colors.grey.shade300,
                child: const Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError || !snapshot.hasData) {
              imageWidget = Image.asset(
                'assets/images/heda.jpg',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              );
            } else {
              Uint8List? bytes = ConversionUtils.convertToBytes(snapshot.data!);
              imageWidget = bytes != null && bytes.isNotEmpty
                  ? Image.memory(
                bytes,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
                  : Image.asset(
                'assets/images/heda.jpg',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              );
            }

            return ListTile(
              leading: imageWidget,
              title: Text(song.displayNameWOExt),
              subtitle: Text(song.artist),
              trailing: const Icon(Icons.more_horiz),
              onTap: () {
                Navigator.pushNamed(context, '/song', arguments: {
                  'songs': songs,
                  'currentIndex': index,
                });
              },
            );
          },
        );
      },
    );
  }
}
