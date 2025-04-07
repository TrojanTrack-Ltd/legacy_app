import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../provider/ModelProvider.dart';
import '../screens/add_horse_screen.dart';
import '../screens/video_detail_screen.dart';
import '../utils/custom_extension.dart';
import '../widgets/rich_text.dart';
import '../models/TrojanTrackModel.dart';


class HorseDetailScreen extends StatefulWidget {
  final TrojanTrackModel trojantrackModel;
  const HorseDetailScreen({Key? key, required this.trojantrackModel})
      : super(key: key);

  @override
  State<HorseDetailScreen> createState() => _HorseDetailScreenState();
}

class _HorseDetailScreenState extends State<HorseDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Horse Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Color(0xFF1264AC),
                      width: double.infinity,
                      child: Row(
                        children: [
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              widget.trojantrackModel.horseName ?? "",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => AddHorseScreen(
                                        trojantrackModel: widget.trojantrackModel),
                                  ),
                                );
                              },
                              child: const Icon(Icons.edit)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  _buildContentCard('Sire Name', widget.trojantrackModel.sireName ?? ""),
                  const SizedBox(height: 5),
                  _buildContentCard('Dam Name', widget.trojantrackModel.damName ?? ""),
                  const SizedBox(height: 5),
                  _buildContentCard('Year Of Birth', widget.trojantrackModel.yearofBirth ?? ""),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Videos:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                textAlign: TextAlign.left
            ),
            const SizedBox(height: 10),
            Wrap(
              children: List.generate(
                widget.trojantrackModel.videosJson?.length ?? 0,
                (index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => VideoDetailScreen(
                              trojantrackModel: widget.trojantrackModel, videoIndex: index),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          (jsonDecode(widget.trojantrackModel.videosJson![index])[
                                      'videoThumbnail']
                                  .toString()
                                  .isNetworkImage)
                              ? CachedNetworkImage(
                                  imageUrl: jsonDecode(widget.trojantrackModel
                                      .videosJson![index])['videoThumbnail'],
                                  fit: BoxFit.cover,
                                  width: 120,
                                  height: 70,
                                  placeholder: (context, imageProvider) =>
                                      const Center(
                                          child: CircularProgressIndicator()),
                                  errorWidget: (context, error, stackTrace) =>
                                      Center(
                                          child: Image.asset(
                                    'assets/default_img.jpeg',
                                    height: 70,
                                    width: 120,
                                  )),
                                )
                              : Image.file(
                                  File(jsonDecode(widget.trojantrackModel
                                      .videosJson![index])['videoThumbnail']),
                                  fit: BoxFit.cover,
                                  width: 120,
                                  height: 70,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    height: 70,
                                    width: 120,
                                    color: Colors.grey.withOpacity(0.2),
                                    padding: const EdgeInsets.all(10),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/default_img.jpeg',
                                        height: 70,
                                        width: 120,
                                      ),
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 8),
                          CustomRichText(
                            normalTextStyle: const TextStyle(
                                fontSize: 15, color: Colors.black87),
                            fancyTextStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                            title:
                                "#Recorded #Status: ${jsonDecode(widget.trojantrackModel.videosJson![index])['recordedStatus']}",
                          ),
                          CustomRichText(
                            normalTextStyle: const TextStyle(
                                fontSize: 15, color: Colors.black87),
                            fancyTextStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                            title:
                                "#Created #Date: ${DateFormat('MMM dd, yyyy hh:mm a').format((DateTime.tryParse(jsonDecode(widget.trojantrackModel.videosJson![index])['createdDate'].toString()) ?? DateTime.now().toUtc()).toLocal())}",
                          ),
                          CustomRichText(
                            normalTextStyle: TextStyle(
                                fontSize: 15,
                                color: (jsonDecode(
                                            widget.trojantrackModel.videosJson![
                                                index])['videoThumbnail']
                                        .toString()
                                        .isNetworkImage)
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.w500),
                            fancyTextStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                            title:
                                "#Sync #Status: ${(jsonDecode(widget.trojantrackModel.videosJson![index])['videoThumbnail'].toString().isNetworkImage) ? "Uploaded" : "Pending"}",
                          ),
                          CustomRichText(
                            normalTextStyle: const TextStyle(
                                fontSize: 15, color: Colors.black87),
                            fancyTextStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                            title:
                                "#Comment: ${jsonDecode(widget.trojantrackModel.videosJson![index])['comment'] ?? ""}",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "$title: ",
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
      ],
    );
  }
}
