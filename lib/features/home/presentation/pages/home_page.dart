import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:muzic/features/home/domain/entities/song.dart';
import 'package:muzic/features/home/presentation/bloc/audio_bloc.dart';
import 'package:muzic/features/home/presentation/bloc/audio_state.dart';
import 'package:muzic/features/home/presentation/widgets/appbar.dart';
import 'package:muzic/features/home/presentation/widgets/drawer.dart';
import 'package:muzic/features/home/presentation/widgets/song_list_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar:AppBar(title: const Text("P L A Y L I S T")),
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
          return MySongsListView(songs: state.songs);
        } else if (state is AudioError) {
          return Center(child: Text(state.message));
        }
        return const Center(
            child: Text('Permission required to access music files'));
      },
    );
  }
}

