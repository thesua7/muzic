import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muzic/features/home/domain/entities/song.dart';
import 'package:muzic/features/home/presentation/widgets/appbar.dart';
import 'package:muzic/features/home/presentation/widgets/neu_box.dart';

class SongPage extends StatefulWidget {
  final Song song;

  const SongPage({super.key, required this.song});

  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  late AudioPlayer _audioPlayer;
  bool _isRepeating = false;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.durationStream.listen((duration) {
      setState(() {
        _duration = duration ?? Duration.zero;
      });
    });

    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed && _isRepeating) {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.play();
      }
    });

    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      await _audioPlayer
          .setAudioSource(AudioSource.uri(Uri.parse(widget.song.audioPath)));
    } catch (e) {
      print('Error initializing audio: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playPause() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  void _stop() async {
    await _audioPlayer.stop();
  }

  void _toggleRepeat() {
    setState(() {
      _isRepeating = !_isRepeating;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  Uint8List? _convertToBytes(String data) {
    try {
      List<int> intValues = data
          .replaceAll('[', '')
          .replaceAll(']', '')
          .split(',')
          .map(int.tryParse)
          .where((value) => value != null)
          .cast<int>()
          .toList();
      return Uint8List.fromList(intValues);
    } catch (e) {
      print('Error converting to bytes: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new),
                    ),
                    const Text("P L A Y L I S T"),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.menu_rounded),
                    ),
                  ],
                ),
              ),
              FutureBuilder<String>(
                future: widget.song
                    .getAlbumArtworkPath(widget.song.albumArtImagePath),
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
                    Uint8List? bytes = _convertToBytes(snapshot.data!);

                    return Column(
                      children: [
                        NeuBox(
                          child: Column(
                            children: [
                              bytes!.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.memory(bytes,
                                          width:
                                              300, // Specify your desired width
                                          height: 230,
                                          fit: BoxFit.cover),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child:
                                          Image.asset('assets/images/heda.jpg',
                                              width: 300,
                                              // Specify your desired width
                                              height: 230,
                                              fit: BoxFit.cover),
                                    ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.song.displayNameWOExt
                                              .split(" ")[3],
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(widget.song.artist),
                                      ],
                                    ),
                                    const Icon(
                                      Icons.monitor_heart,
                                      color: Colors.cyan,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        StreamBuilder<Duration>(
                            stream: _audioPlayer.positionStream,
                            builder: (context, snapshot) {
                              final position = snapshot.data ?? Duration.zero;

                              return Column(
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(_formatDuration(position)),
                                        const Icon(Icons.shuffle_rounded),
                                        IconButton(
                                          icon: Icon(
                                            _isRepeating
                                                ? Icons.repeat_rounded
                                                : Icons.repeat,
                                            color: _isRepeating
                                                ? Colors.cyan
                                                : Colors.grey,
                                          ),
                                          onPressed: _toggleRepeat,
                                        ),
                                        Text(_formatDuration(_duration)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                        thumbShape: const RoundSliderThumbShape(
                                            enabledThumbRadius: 0)),
                                    child: Slider(
                                      value: position.inSeconds.toDouble(),
                                      max: _duration.inSeconds.toDouble(),
                                      onChanged: (value) async {
                                        final newPosition =
                                            Duration(seconds: value.toInt());
                                        await _audioPlayer.seek(newPosition);
                                        if (!_audioPlayer.playing) {
                                          await _audioPlayer.play();
                                        }
                                      },
                                      activeColor: Colors.cyan,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: const NeuBox(
                                            child: Icon(
                                                Icons.skip_previous_rounded),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        flex: 2,
                                        child: GestureDetector(
                                          onTap: _playPause,
                                          child: NeuBox(
                                            child: Icon(_audioPlayer.playing
                                                ? Icons.pause
                                                : Icons.play_arrow),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: const NeuBox(
                                            child:
                                                Icon(Icons.skip_next_rounded),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
