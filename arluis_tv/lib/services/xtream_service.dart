import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/channel.dart';
import '../models/vod.dart';

class XtreamService {
  // Servidor hardcodeado - invisible para el usuario
  static const String _server = '172.16.20.6:8000';
  static const String _baseUrl = 'http://$_server';

  String _username = '';
  String _password = '';

  static final XtreamService _instance = XtreamService._internal();
  factory XtreamService() => _instance;
  XtreamService._internal();

  Future<bool> login(String username, String password) async {
    try {
      final url = '$_baseUrl/player_api.php?username=$username&password=$password';
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['user_info'] != null && data['user_info']['auth'] == 1) {
          _username = username;
          _password = password;
          return true;
        }
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<List<Channel>> getLiveChannels() async {
    try {
      final url = '$_baseUrl/player_api.php?username=$_username&password=$_password&action=get_live_streams';
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => Channel.fromJson(e)).toList();
      }
    } catch (e) {
      return [];
    }
    return [];
  }

  Future<List<VodItem>> getVod() async {
    try {
      final url = '$_baseUrl/player_api.php?username=$_username&password=$_password&action=get_vod_streams';
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => VodItem.fromJson(e)).toList();
      }
    } catch (e) {
      return [];
    }
    return [];
  }

  Future<List<VodItem>> getSeries() async {
    try {
      final url = '$_baseUrl/player_api.php?username=$_username&password=$_password&action=get_series';
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => VodItem.fromJson(e)).toList();
      }
    } catch (e) {
      return [];
    }
    return [];
  }

  String getLiveStreamUrl(String streamId) {
    return '$_baseUrl/live/$_username/$_password/$streamId.m3u8';
  }

  String getVodStreamUrl(String streamId) {
    return '$_baseUrl/movie/$_username/$_password/$streamId.mp4';
  }

  void logout() {
    _username = '';
    _password = '';
  }
}
