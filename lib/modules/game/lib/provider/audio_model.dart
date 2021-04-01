import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:game/utils/constant.dart';

class AudioModel extends ChangeNotifier {
  late AudioPlayer audioPlayer;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerErrorSubscription;
  StreamSubscription? _playerStateSubscription;
  List<NewSoundData> sounds = [];
  List<NewSoundData> speakingPracticeSounds = [];

  NewSoundData? currentSound;
  double speed = 1.0;
  bool isLoading = false;
  bool isPlaylistMode = false;
  bool isSpeakingPracticeMode = false;
  bool callBackToSpeakingPractice = false;
  AudioModel() {
    audioPlayer = AudioPlayer();
    if (Platform.isIOS) {
      audioPlayer.startHeadlessService();
    }
    initAudio();
  }
  initAudio() async {
    _durationSubscription = audioPlayer.onDurationChanged.listen((duration) {
      // setState(() => _duration = duration);
      if (currentSound != null) {
        if (currentSound?.duration == null ||
            currentSound!.duration == Duration(seconds: 0)) {
          print("SET DURATION:");
          currentSound!.updateDuration(duration);
          notifyListeners();
        }
      }
    });

    _positionSubscription = audioPlayer.onAudioPositionChanged.listen((p) {
      if (currentSound != null &&
          currentSound!.playerState == AudioPlayerState.PLAYING) {
        // print("SET POSITION:");
        currentSound!.updatePosition(p);
        notifyListeners();
      }
    });

    _playerCompleteSubscription =
        audioPlayer.onPlayerCompletion.listen((event) {
          if (currentSound != null && currentSound!.playerState == AudioPlayerState.PLAYING) {
            // print("SET COMPLETE:");
            currentSound!.complete();
            // print("VLLLLLLLL $isSpeakingPracticeMode");

            if (isPlaylistMode) {
              NewSoundData? nextSound = sounds.firstWhereOrNull(
                      (element) => element.orderIndex > currentSound!.orderIndex);
              if (nextSound != null) {
                play(nextSound);
              } else {
                sounds.forEach((element) {
                  element.reset();
                });
                currentSound = sounds.first;
                notifyListeners();
              }
            } else if (isSpeakingPracticeMode) {
              // Mode for User Speaking
              print("SET COMPLETE: isSpeakingPracticeMode");
              speakingPracticeSounds.forEach((element) {
                print("vkl: ${element.questionId} ====== ${element.sound}");
              });
              NewSoundData? nextSound = speakingPracticeSounds.firstWhereOrNull(
                      (element) => (element.orderIndex > currentSound!.orderIndex));
              if (nextSound != null) {
                print("${nextSound.sound}");
                if (nextSound.isHintSound) {
                  //call back to speaking
                  print("SET COMPLETE: call back to speaking");

                  callBackToSpeakingPractice = true;
                  notifyListeners();
                  callBackToSpeakingPractice = false;
                } else {
                  print("vcccccccccc@@@@@@@@");

                  play(nextSound);
                }
              } else {
                print("vcccccccccc333333333");

                speakingPracticeSounds.forEach((element) {
                  element.reset();
                });
                // currentSound = sounds.first;
                notifyListeners();
              }
            } else {
              notifyListeners();
            }
          }
        });
    _playerErrorSubscription = audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
    });

    audioPlayer.onPlayerStateChanged.listen((state) {
      print('onPlayerStateChanged : $state');
    });

    audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      print('onNotificationPlayerStateChanged : $state');
    });
  }

  cancel() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
  }

  resetSpeakingPracticeMode() {
    isPlaylistMode = true;
    isSpeakingPracticeMode = false;
  }

  resetList() async {
    await audioPlayer.stop();
    currentSound = null;
    sounds.forEach((element) {
      element.reset();
    });
  }

  loadData(List<NewSoundData> _sounds) {
    // sounds = [];
    sounds = _sounds;
    currentSound = sounds.first;
    // print(_sounds.length);
    notifyListeners();
  }

  changeToSpeakingPracticeMode() {
    isPlaylistMode = false;
    isSpeakingPracticeMode = true;
  }

  setSpeed(double _speed) async {
    speed = _speed;
    try {
      await audioPlayer.setPlaybackRate(playbackRate: _speed);
    } catch (e) {}
    notifyListeners();
  }

  reset() {
    sounds = [];
    currentSound = null;
    isLoading = false;
    isPlaylistMode = false;
    speed = 1.0;
    try {
      stop();
    } catch (e) {}
  }

  play(NewSoundData? _soundData, [bool isLocal = false]) async {
    isLoading = true;
    if (_soundData != null && _soundData != currentSound) {
      currentSound = _soundData;
    }
    if (currentSound!.playerState == AudioPlayerState.PAUSED) {
      resume();
    } else {
      currentSound!.play();

      int result = await audioPlayer.play(
        currentSound!.sound,
        isLocal: isLocal,
      );
      if (result == 1) {
        if (speed != 1.0) {
          await audioPlayer.setPlaybackRate(playbackRate: speed);
        }
      }
    }

    isLoading = false;
    notifyListeners();
  }

  pause() async {
    int result = await audioPlayer.pause();
    if (result == 1) {
      print('pause done');
    }
    notifyListeners();
  }

  stop() async {
    int result = await audioPlayer.stop();
  }

  seek() async {
    int result = await audioPlayer.seek(Duration(milliseconds: 1200));
  }

  resume() async {
    int result = await audioPlayer.resume();
  }

  playInSpeakingPractice(List<NewSoundData> speakingSoundList, bool questionClicked) {
    speakingPracticeSounds = speakingSoundList;
    if (questionClicked) {
      NewSoundData? questionSound = speakingPracticeSounds
          .firstWhereOrNull((element) => element.isQuestion);
      if (questionSound != null) {
        play(questionSound);
      }
    }
  }

}

class NewSoundData {
  String? id;
  String? questionId;
  String sound = "";
  double orderIndex = 0;
  Duration duration = Duration(seconds: 0);
  Duration position = Duration(seconds: 0);
  bool isLocal = false;
  bool isQuestion = true;
  bool isHintSound = false;
  AudioPlayerState? playerState;
  // NewSoundData();
  get isPlaying => playerState == AudioPlayerState.PLAYING;
  get isPaused => playerState == AudioPlayerState.PAUSED;
  get durationText => duration.toString().split('.').first;
  get positionText => position.toString().split('.').first;

  NewSoundData.fromGameObject(
      {required String? questionId, required String? sound, bool? isLocal}) {
    this.questionId = questionId;
    if (sound == null) {
      return;
    }
    if (sound.startsWith("http")) {
      this.sound = sound;
    } else {
      if (sound.startsWith("/")) {
        this.sound = '$GOOGLE_CLOUD_STORAGE_URL' + sound;
      } else {
        this.sound = '$GOOGLE_CLOUD_STORAGE_URL/' + sound;
      }
    }
    if (isLocal != null && isLocal) {
      this.isLocal = isLocal;
    }
  }

  updateDuration(Duration _duration) {
    duration = _duration;
    if (duration.inSeconds < 1) {
      duration = Duration(seconds: 1);
    }
  }

  updatePosition(Duration _position) {
    position = _position;
    if (position.inMilliseconds > duration.inMilliseconds) {
      position = duration;
    }
  }

  pause() {
    playerState = AudioPlayerState.PAUSED;
  }

  stop() {
    playerState = AudioPlayerState.STOPPED;
    resetDuration();
  }

  play() {
    playerState = AudioPlayerState.PLAYING;
  }

  complete() {
    playerState = AudioPlayerState.COMPLETED;
    position = duration;
  }

  onError() {
    duration = Duration(seconds: 0);
    position = Duration(seconds: 0);
  }

  reset() {
    duration = Duration(seconds: 0);
    position = Duration(seconds: 0);
    playerState = null;
  }

  resetDuration() {
    duration = Duration(seconds: 0);
    position = Duration(seconds: 0);
  }
}