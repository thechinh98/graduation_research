// Flutter imports:
import 'package:audioplayers/audioplayers.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:game/provider/audio_model.dart';

// Package imports:
import 'package:provider/provider.dart';

class NewGameSound extends StatefulWidget {
  final String questionId;
  final int? type; // type = 1: only volume icon to replay the sound
  final bool? disabled;
  NewGameSound({Key? key, required this.questionId, this.type, this.disabled})
      : super(key: key);

  @override
  _NewGameSoundState createState() => _NewGameSoundState();
}

class _NewGameSoundState extends State<NewGameSound> {
  NewSoundData? soundData;
  late AudioModel soundsModel;
  int? get type => widget.type;
  bool get disabled => widget.disabled ?? false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (disabled) {
      return;
    }
    soundsModel = context.read<AudioModel>();
    soundData = soundsModel.sounds.firstWhereOrNull(
        (element) => element.questionId == widget.questionId);
    if (soundsModel.isPlaylistMode) {
      // che do playlist thi ko cho phep auto play tu day
      return;
    }
    if (soundData != null) {
      if (mounted) {
        soundsModel.play(soundData);
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer(builder: (_, AudioModel _soundModel, ___) {
      NewSoundData? soundData = _soundModel.sounds.firstWhereOrNull(
          (element) => element.questionId == widget.questionId);
      Color soundDeviceColor = Colors.grey;
      if (soundData == null ||
          soundData.sound.isEmpty) {
        return Container();
      }

      // check whether audioPlayer.state is initialized or not
      try {
        final tmp = _soundModel.audioPlayer.state;
      } catch (e) {
        print('Phungtd: access _soundModel.audioPlayer.state failed -> $e');
        return Container();
      }

      if (_soundModel.audioPlayer.state == AudioPlayerState.PLAYING) {
        soundDeviceColor = Color(0xffBF710F);
      } else {
        soundDeviceColor = Colors.grey;
      }
      if (type == 1) {
        return Container(
          child: InkWell(
            onTap: () => _soundModel.play(soundData),
            child: Container(
              width: 30,
              height: 30,
              child: Icon(Icons.volume_up, color: soundDeviceColor),
            ),
          ),
        );
      }

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap:
                      _soundModel.audioPlayer.state == AudioPlayerState.PLAYING
                          ? () {
                              if (mounted) {
                                _soundModel.pause();
                              }
                            }
                          : () {
                              if (mounted) {
                                if (_soundModel.isPlaylistMode) {
                                  // _soundModel.playList();
                                } else {
                                  _soundModel.play(soundData);
                                }
                              }
                            },
                  child: Container(
                    width: 30,
                    height: 30,
                    // color: Colors.red,
                    child: Center(
                      child: _soundModel.audioPlayer.state ==
                              AudioPlayerState.PLAYING
                          ? Icon(Icons.pause,
                              color: Color(0xffBF710F))
                          : Icon(Icons.play_arrow,
                              color: Color(0xffBF710F)),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    // color: Colors.amber,
                    child: Slider(
                      value:
                          soundData.position.inMilliseconds.toDouble(),
                      activeColor: Color(0xffBF710F),
                      onChanged: (double value) {},
                      min: 0.0,
                      max:
                          soundData.duration.inMilliseconds.toDouble(),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: _buildProgressView(soundData),
                )
              ],
            ),
          ],
        ),
      );
    });
  }

  Row _buildProgressView(NewSoundData soundData) {
    String currentText = soundData.positionText.toString();
    String durationText1 = soundData.durationText.toString();
    currentText = currentText.substring(3, currentText.length);
    durationText1 = durationText1.substring(3, durationText1.length);
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text(
        "$currentText / $durationText1",
      )
    ]);
  }
}
