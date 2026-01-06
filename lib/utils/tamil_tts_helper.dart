import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';

class TamilTtsHelper {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  /// This method calls AI4Bharat API to speak Tamil text.
  static Future<void> speakTamil(BuildContext context, String text) async {
    try {
      final url = Uri.parse('https://bhashini-api.ai4bharat.org/tts/indic/parler');
      final headers = {'Content-Type': 'application/json'};
      final body = json.encode({
        "input": {"source": text},
        "config": {
          "gender": "female",
          "language": {"sourceLanguage": "ta"}
        }
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final audioBase64 = responseData['audio'][0]['audioContent'];
        final audioBytes = base64Decode(audioBase64);
        final Uint8List audioUint8List = Uint8List.fromList(audioBytes);

        await _audioPlayer.play(BytesSource(audioUint8List));
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Audio Error"),
            content: Text("Tamil audio is not available. Check internet connection."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text("OK"),
              )
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Error"),
          content: Text("Failed to fetch Tamil audio.\n$e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }

  /// Call this on dispose to stop any audio playing
  static void stop() {
    _audioPlayer.stop();
  }
}
