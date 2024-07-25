import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muzic/core/utils/conversion_utils.dart';
import 'package:muzic/features/home/domain/entities/song.dart';
import 'package:muzic/features/home/presentation/widgets/neu_box.dart';

class SongPage extends StatefulWidget {
  final List<Song> songs;
  final int currentIndex;

  const SongPage({super.key, required this.songs, required this.currentIndex});

  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> with SingleTickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  bool _isRepeating = false;
  Duration _duration = Duration.zero;
  late int _currentIndex;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  Offset _slideDirection = Offset.zero; // Initialize with a default value

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _audioPlayer = AudioPlayer();

    // Listen for duration changes
    _audioPlayer.durationStream.listen((duration) {
      if (mounted) {
        setState(() {
          _duration = duration ?? Duration.zero;
        });
      }
    });

    // Listen for player state changes
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed && _isRepeating) {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.play();
      }
    });

    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Load the audio and artwork immediately
    _loadAndPlayAudio(widget.songs[_currentIndex].audioPath);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final song = widget.songs[_currentIndex];

    // Define the slide animation based on the current index
    _slideAnimation = Tween<Offset>(
      begin: _slideDirection,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              _buildHeader(),
              SlideTransition(
                position: _slideAnimation,
                child: _buildArtwork(song),
              ),
              const SizedBox(height: 25),
              _buildPlaybackControls(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadAndPlayAudio(String audioPath) async {
    try {
      await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(audioPath)));
      await _audioPlayer.play();
    } catch (e) {
      print('Error initializing or playing audio: $e');
    }
  }

  void _playPause() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  void _toggleRepeat() {
    setState(() {
      _isRepeating = !_isRepeating;
    });
  }

  void _changeSong(int index) {
    if (index < 0 || index >= widget.songs.length) return;

    // Determine the direction of the slide animation
    _slideDirection = index > _currentIndex ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0);

    setState(() {
      _currentIndex = index;
    });

    // Reset and play the animation
    _animationController.reset();
    _animationController.forward();

    // Load and play the new audio after the animation
    _loadAndPlayAudio(widget.songs[_currentIndex].audioPath);
  }

  void _nextSong() {
    _changeSong(_currentIndex + 1);
  }

  void _previousSong() {
    _changeSong(_currentIndex - 1);
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          const Text("P L A Y L I S T"),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildArtwork(Song song) {
    return FutureBuilder<String>(
      future: song.getAlbumArtworkPath(song.albumArtImagePath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        } else if (snapshot.hasError || !snapshot.hasData) {
          return _buildDefaultArtwork();
        } else {
          Uint8List? bytes = ConversionUtils.convertToBytes(snapshot.data!);
          return NeuBox(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: bytes!.isNotEmpty
                      ? Image.memory(
                    bytes,
                    width: 300,
                    height: 230,
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                    'assets/images/heda.jpg',
                    width: 300,
                    height: 230,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            song.displayNameWOExt.split(" ")[3],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(song.artist),
                        ],
                      ),
                      const Icon(
                        Icons.monitor_heart,
                        color: Colors.cyan,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildDefaultArtwork() {
    return NeuBox(
      child: CircleAvatar(
        child: Image.asset('assets/images/heda.jpg'),
      ),
    );
  }

  Widget _buildPlaybackControls() {
    return StreamBuilder<Duration>(
      stream: _audioPlayer.positionStream,
      builder: (context, snapshot) {
        final position = snapshot.data ?? Duration.zero;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(ConversionUtils.formatDuration(position)),
                  const Icon(Icons.shuffle_rounded),
                  IconButton(
                    icon: Icon(
                      _isRepeating ? Icons.repeat_rounded : Icons.repeat,
                      color: _isRepeating ? Colors.cyan : Colors.grey,
                    ),
                    onPressed: _toggleRepeat,
                  ),
                  Text(ConversionUtils.formatDuration(_duration)),
                ],
              ),
            ),
            const SizedBox(height: 4),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
              ),
              child: Slider(
                value: position.inSeconds.toDouble(),
                max: _duration.inSeconds.toDouble(),
                onChanged: (value) async {
                  final newPosition = Duration(seconds: value.toInt());
                  await _audioPlayer.seek(newPosition);
                  if (!_audioPlayer.playing) {
                    await _audioPlayer.play();
                  }
                },
                activeColor: Colors.cyan,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _previousSong,
                    child: const NeuBox(
                      child: Icon(Icons.skip_previous_rounded),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: _playPause,
                    child: NeuBox(
                      child: Icon(
                        _audioPlayer.playing ? Icons.pause : Icons.play_arrow,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: GestureDetector(
                    onTap: _nextSong,
                    child: const NeuBox(
                      child: Icon(Icons.skip_next_rounded),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}