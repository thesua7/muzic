

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:muzic/features/home/domain/entities/song.dart';

class MySongsListView extends StatelessWidget {
  final List<Song> songs;
  const MySongsListView({super.key,required this.songs});

  @override
  Widget build(BuildContext context) {
    if (songs.isEmpty) {
      return const Center(child: Text("No songs found"));
    }
    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context, index) {
        return FutureBuilder<String>(
          future:
          songs[index].getAlbumArtworkPath(songs[index].albumArtImagePath),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox();
            } else if (snapshot.hasError || !snapshot.hasData) {
              return CircleAvatar(
                child: Image.asset(
                  'assets/images/heda.jpg',
                ),
              );
            } else {
              String artworkPath =
                  snapshot.data ?? ''; // Ensure snapshot.data is not null

// Default values for Uint8List and bytes
              Uint8List bytes = Uint8List(0);

              if (artworkPath.isNotEmpty) {
                artworkPath =
                    artworkPath.replaceAll('[', '').replaceAll(']', '');
                List<int> intValues = artworkPath
                    .split(',')
                    .map(int.tryParse)
                    .where((value) => value != null)
                    .cast<int>()
                    .toList();
                bytes = Uint8List.fromList(intValues);
              }

              return ListTile(
                leading: bytes.isNotEmpty
                    ? Image.memory(bytes,
                    width: 50, // Specify your desired width
                    height: 50,
                    fit: BoxFit.cover)
                    : Image.asset('assets/images/heda.jpg',
                    width: 50,
                    // Specify your desired width
                    height: 50,
                    fit: BoxFit.cover),
                title: Text(songs[index].displayNameWOExt),
                subtitle: Text(songs[index].artist),
                trailing: const Icon(Icons.more_horiz),
                onTap: () {
                  Navigator.pushNamed(context, '/song', arguments: songs[index]);
                  // Handle onTap for song selection
                },
              );
            }
          },
        );
      },
    );
  }
}