// lib/help_page.dart
import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Help / உதவி")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Help (English)",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "• 🗓️ Daily Kural: Shows one random Kural every day (excluding 'Love' section).\n"
              "• 🔎 Search by Section / Chapter / Number:\n"
              "   - 📚 Section: Pick from Virtue, Wealth, or Love. After selecting Section, you can see all the chapters in that section and choose one.\n"
              "   - 🏷️ Chapter: Type chapter name and Tap the 🔍 search icon.\n"
              "   - 🔢 Number: Enter Kural number (1–1330) and Tap the 🔍 search icon.\n"
              "• 💡 Search by Hint:\n"
              "   - Enter a keyword (e.g., Truth, Friendship) or use the 🎤 mic to speak after selecting the language and Tap the 🔍 search icon to show results.\n"
              "   - Each result displays all related Kurals.\n"
              "• To listen to the content in English or Tamil, tap the Speaker buttons (🔊) when available\n"
              "• If notifications are enabled, the app will deliver one Kural each day as a notification."
              "• 🎯 Quiz:\n"
              "   - Displays five different questions and answers. You can click refresh button and get new set of questions\n",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 25),
            Text(
              "உதவி (Tamil)",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "• 🗓️ தினம் ஒரு குறள்: காதல் பாகம் தவிர்த்து தினமும் ஒரு குறளை காட்டும்.\n"
              "• 🔎 பால் / அதிகாரம் / எண் தேடல்:\n"
              "   - 📚 பால்: அறம், பொருள், காதல் ஆகியவற்றில் ஒன்றைத் தேர்ந்தெடுத்து அதிலுள்ள அதிகாரங்க்களைதைப் பார்த்து தேர்வு செய்யலாம்.\n"
              "   - 🏷️ அதிகாரம்: அதிகாரத்தின் பெயரை உள்ளிடவும். பின்பு தேடல் ஐகானை அழுத்தவும்\n"
              "   - 🔢 குறள் எண்: 1 முதல் 1330 வரை உள்ள எண்களில் ஒன்றை உள்ளிடலாம்.\n"
              "• 💡 குறிப்பால் தேடல்:\n"
              "   - ஒரு முக்கிய சொல்லை உள்ளிடவும் (எ.கா., உண்மை, நட்பு) அல்லது  மைக்கைப்  பயன்படுத்தி 🎤,  முடிவுகளைக் காண்பிக்க தேடல் ஐகானைத் தட்டவும் 🔍.\n"
              "   - முடிவில் குறள் எண், தமிழ் விளக்கம், ஆங்கில விளக்கம் ஆகியவை காட்டப்படும்.\n"
              "• ஆங்கிலம் அல்லது தமிழில் உள்ளடக்கத்தைக் கேட்க, ஸ்பீக்கர் பொத்தான்கள் 🔊 இருந்தால் தட்டவும்.\n"
              "• அறிவிப்புகள் இயக்கப்பட்டிருந்தால், பயன்பாடு ஒவ்வொரு நாளும் ஒரு குறளை அறிவிப்பாக வழங்கும்.\n"
              "• 🎯 வினாடி வினா:\n"
              "   - ஐந்து வெவ்வேறு கேள்விகள் மற்றும் பதில்களைக் காட்டுகிறது. நீங்கள் புதுப்பிப்பு பொத்தானைக் கிளிக் செய்து புதிய கேள்விகளின் தொகுப்பைப் பெறலாம்.\n",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
