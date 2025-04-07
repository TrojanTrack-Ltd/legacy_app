import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About us'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Card(
              elevation: 5,
              child: Column(
                children: [
                  ListTile(
                    onTap: () async {
                      if (!await launchUrl(Uri.parse('https://www.trojantrack.ie/blog'),mode: LaunchMode.externalApplication)) {}
                    },
                    title: const Text('Blog'),
                    leading: const Icon(Icons.book_rounded),
                  ),
                  ListTile(
                    onTap: () async {
                      if (!await launchUrl(Uri.parse('http://www.trojantrack.ie/'), mode: LaunchMode.externalApplication)) {}
                    },
                    title: const Text('Website'),
                    leading: const Icon(Icons.webhook_sharp),
                  ),
                  ListTile(
                    onTap: () async {
                      if (!await launchUrl(Uri.parse('https://twitter.com/TrojanTrack2'), mode: LaunchMode.externalApplication)) {}
                    },
                    title: const Text('Follow us on Twitter'),
                    leading: const Icon(Icons.share),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(),
            ),
            // const SizedBox(height: 20),
            ListTile(
                title: Center(child: Text('Software Version: 1.0.0',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Color(0xFF2C2C2C))))),
          ],
        ),
      ),
    );
  }
}