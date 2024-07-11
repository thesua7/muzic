import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzic/core/usecases/usecase.dart';
import 'package:muzic/features/home/domain/usecases/get_songs_usecase.dart';
import 'package:muzic/features/home/presentation/bloc/audio_event.dart';
import 'package:muzic/features/home/presentation/bloc/audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final GetSongs getSongs;

  AudioBloc({required this.getSongs}) : super(AudioInitial()) {
    on<GetSongsEvent>(_onGetSongsEvent);
  }

  Future<void> _onGetSongsEvent(
      GetSongsEvent event, Emitter<AudioState> emit) async {
    emit(AudioLoading());
    try {
      final songs = await getSongs(NoParams());
      emit(AudioLoaded(songs: songs));
    } catch (e) {
      emit(AudioError(message: e.toString()));
    }
  }
}
