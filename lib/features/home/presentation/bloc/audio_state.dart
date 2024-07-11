import 'package:equatable/equatable.dart';
import 'package:muzic/features/home/domain/entities/song.dart';

abstract class AudioState extends Equatable {
  @override
  List<Object> get props => [];
}

class AudioInitial extends AudioState {}

class AudioLoading extends AudioState {}

class AudioLoaded extends AudioState {
  final List<Song> songs;

  AudioLoaded({required this.songs});

  @override
  List<Object> get props => [songs];
}

class AudioError extends AudioState {
  final String message;

  AudioError({required this.message});

  @override
  List<Object> get props => [message];
}
