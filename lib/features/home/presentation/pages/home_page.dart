import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:muzic/features/home/domain/entities/song.dart';
import 'package:muzic/features/home/presentation/bloc/audio_bloc.dart';
import 'package:muzic/features/home/presentation/bloc/audio_state.dart';
import 'package:muzic/features/home/presentation/widgets/appbar.dart';
import 'package:muzic/features/home/presentation/widgets/drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const MyAppBar(title: "P L A Y L I S T"),
      drawer: const AppDrawer(),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      builder: (_, state) {
        if (state is AudioLoading) {
          return Center(
            child: SpinKitPianoWave(
              color: Theme.of(context)
                  .colorScheme
                  .inversePrimary, // Customize the color as needed
              size: 100.0, // Customize the size as needed
            ),
          );
        } else if (state is AudioLoaded) {
          return SongListView(songs: state.songs);
        } else if (state is AudioError) {
          return Center(child: Text(state.message));
        }
        return const Center(
            child: Text('Permission required to access music files'));
      },
    );
  }
}

class SongListView extends StatelessWidget {
  final List<Song> songs;

  const SongListView({super.key, required this.songs});

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
