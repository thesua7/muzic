import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:muzic/features/home/presentation/bloc/audio_bloc.dart';
import 'package:muzic/features/home/presentation/bloc/audio_state.dart';
import 'package:muzic/features/home/presentation/widgets/custom_loading_indicator.dart';
import 'package:muzic/features/home/presentation/widgets/drawer.dart';
import 'package:muzic/features/home/presentation/widgets/song_list_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: const Text("P L A Y L I S T")),
      drawer: const AppDrawer(),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      builder: (_, state) {
        if (state is AudioLoading) {
          return Center(
            child: CustomLoadingIndicator(
              color: Theme.of(context).colorScheme.inversePrimary,
              size: 100.0,
            ),
          );
        } else if (state is AudioLoaded) {
          return SongsListView(songs: state.songs);
        } else if (state is AudioError) {
          return Center(child: Text(state.message));
        }
        return const Center(
            child: Text('Permission required to access music files'));
      },
    );
  }
}
