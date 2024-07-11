import 'dart:convert';
import 'dart:typed_data';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:muzic/features/home/domain/entities/song.dart';
import 'package:muzic/features/home/presentation/bloc/audio_bloc.dart';
import 'package:muzic/features/home/presentation/bloc/audio_event.dart';
import 'package:muzic/features/home/presentation/bloc/audio_state.dart';
import 'package:muzic/features/home/presentation/widgets/appbar.dart';
import 'package:muzic/features/home/presentation/widgets/drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const MyAppBar(title: "P L A Y L I S T"),
      drawer: const AppDrawer(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<AudioBloc, AudioState>(
      builder: (_, state) {
        if (state is AudioLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AudioLoaded) {
          return SongListView(songs: state.songs);
        } else if (state is AudioError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('Permission required to access music files'));
      },
    );
  }
}

class SongListView extends StatelessWidget {
  final List<Song> songs;

  const SongListView({Key? key, required this.songs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (songs.isEmpty) {
      return const Center(child: Text("No songs found"));
    }
    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context, index) {
        return FutureBuilder<String>(
          future: songs[index].getAlbumArtworkPath(songs[index].albumArtImagePath),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircleAvatar(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
              return  CircleAvatar(
                child: Image.asset('assets/images/heda.jpg',),
              );
            } else {


              String artworkPath = snapshot.data!;


              artworkPath = artworkPath.replaceAll('[', '').replaceAll(']', '');
              List<String> byteValues = artworkPath.split(',');

              // Convert the list of strings to a list of integers
              List<int> intValues = byteValues.map((value) => int.parse(value.trim())).toList();

              // Convert the list of integers to a Uint8List
              Uint8List bytes = Uint8List.fromList(intValues);


              return ListTile(
                leading: CircleAvatar(
                  child: Image.memory(bytes,),
                ),
                title: Text(songs[index].displayNameWOExt),
                subtitle: Text(songs[index].artist ?? 'Unknown Artist'),
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
