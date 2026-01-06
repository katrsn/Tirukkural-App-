import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About / அறிமுகம்'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [    
            // English Content
            Text(
              'About this App',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "This application was created with the heartfelt aim that everyone can easily access and benefit from the timeless wisdom of the poet Tiruvalluvar. His guidance, compiled over a millennium ago in the Tirukkural, remains profoundly relevant, offering universal principles for living a fulfilling life.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),

            Text(
              "This application is designed to provide easy access to the Tirukkural for educational and reference purposes.",
              style: TextStyle(fontSize: 16),
            ),

            Divider(height: 32, thickness: 1),

            Text(
              'இந்த பயன்பாட்டை பற்றி',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "இந்தப் பயன்பாடு, புலவர் திருவள்ளுவரின் காலத்தால் அழியாத ஞானத்தை அனைவரும் எளிதில் அணுகிப் பயனடைய வேண்டும் என்ற இதயப்பூர்வமான நோக்கத்துடன் உருவாக்கப்பட்டது. மனித வாழ்க்கையின் வழிகாட்டுதலைத் திருக்குறள் மூலம் வழங்கிய அவரது வழிகாட்டுதல்கள் இன்றும் குறிப்பிடத்தக்க பொருத்தத்துடன் விளங்குகின்றன.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "கல்வி மற்றும் குறிப்பு நோக்கங்களுக்காக திருக்குறளை எளிதாக அணுகும் வகையில் இந்த பயன்பாடு வடிவமைக்கப்பட்டுள்ளது.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
