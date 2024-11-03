
import 'dart:convert';
import 'package:flutter/services.dart';

import '../model/song.dart';
import 'package:http/http.dart' as http;

abstract interface class DataSource {
  Future<List<Song>?> loadData();
}
class RemoteDataSource implements DataSource {
  @override
  Future<List<Song>?> loadData() async {
    const url = 'https://thantrieu.com/resources/braniumapis/songs.jsons';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if(response.statusCode == 200){
      final bodyContent = utf8.decode(response.bodyBytes);
      var songWrapper = jsonDecode(bodyContent) as Map;
      var songList = songWrapper['songs'] as List;
      List<Song> songs = songList.map((song) => Song.fromJson(song)).toList();
      return songs;
    }else {
      // List<Song> song = [Song.fromJson({
      //   "id": "1",
      //   "title": "Song Title 1",
      //   "album": "Album Name 1",
      //   "artist": "Artist Name 1",
      //   "source": "Source Link 1",
      //   "image": "Image Link 1",
      //   "duration": 180
      // })];
      // return song;
      return null;
    }
  }

}

class LocalDataSource implements DataSource {
  @override
  Future<List<Song>?> loadData() async{
    final String response = await rootBundle.loadString('assets/songs.json');
    final jsonBody = jsonDecode(response) as Map;
    final songList = jsonBody['songs'] as List;
    List<Song> songs = songList.map((song) => Song.fromJson(song)).toList();
    return songs;
  }

}