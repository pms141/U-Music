import 'package:audioplayer/audioplayer.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

final AudioPlayer audioPlayer = AudioPlayer();
final FlutterAudioQuery audioQuery = FlutterAudioQuery();

int nowPlayingSongIndex = 0 ;
void setnowPlayingSongIndex(int data){
  nowPlayingSongIndex = data;
}

int nowPossition = 0;
void setnowPossition(int data){
  nowPossition = data;
}

double progress = 0.0;
void setProgress(){
  progress = nowPossition/audioPlayer.duration.inMilliseconds;
  progress = ((progress.isNaN) || (progress.isInfinite) || (progress > 1)) ? 0: progress;
  
}

List musicList = [];
List musicPathsList = [];
List musicAlbemArtsList = [];

void getMusicList() async{
  musicList.clear();
  musicPathsList.clear();
  musicList =  await audioQuery.getSongs();
  musicList.forEach((song){
    musicPathsList.add(song.toString().split('_data:').last.split(',').first.trim());
    musicAlbemArtsList.add(song.toString().split('album_artwork:').last.split(',').first.trim());
  });
}

Stream audioplayerstatestream(){
  return audioPlayer.onPlayerStateChanged.asBroadcastStream();
}

Stream audioplayerpositionstream(){
  return audioPlayer.onAudioPositionChanged.asBroadcastStream();
}

String timeEngine(int inMilliseconds) {
    var min = Duration(milliseconds: inMilliseconds);
    var timeslices = min.toString().split('.').first.split(':');
    var time = (timeslices[1].toString() + ':' + timeslices[2].toString());

    return time;
  }

void play(int songindex) async{
  await audioPlayer.stop();
  nowPlayingSongIndex = songindex;
  audioPlayer.play(musicPathsList[songindex]);
}

void seek(double seconds){
  seconds = seconds*audioPlayer.duration.inSeconds;
  audioPlayer.seek(double.parse(seconds.toString()));
}

void playpause(int possition){

  double playpauseposition = double.parse(Duration(milliseconds: possition).inSeconds.toString());

  if (audioPlayer.state == AudioPlayerState.PLAYING) {
    audioPlayer.pause();
  } else if (audioPlayer.state == AudioPlayerState.PAUSED){
    audioPlayer.play(musicPathsList[nowPlayingSongIndex]);
    audioPlayer.seek(playpauseposition);
  }
}


void dullfunction(){
}