import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/TrojanTrackModel.dart';
import '../provider/horse_provider.dart';
import '../models/VideoModel.dart';
import '../screens/video_player_screen.dart';
import '../utils/custom_extension.dart';

class VideoDetailScreen extends StatefulWidget {
  final TrojanTrackModel trojantrackModel;
  final int videoIndex;
  const VideoDetailScreen(
      {Key? key, required this.trojantrackModel, required this.videoIndex})
      : super(key: key);

  @override
  State<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  String? recordedStatus;
  final TextEditingController _commentController = TextEditingController();
  List<VideoModel> convertToVideo = [];
  @override
  void initState() {
    convertToVideo = widget.trojantrackModel.videosJson
            ?.map((e) => VideoModel.fromJson(jsonDecode(e)))
            .toList() ??
        [];
    recordedStatus = convertToVideo[widget.videoIndex].recordedStatus;
    _commentController.text = convertToVideo[widget.videoIndex].comment ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Video Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            _buildVideoView(context),
            const SizedBox(height: 30),
            DropdownButtonFormField<String>(
              items: ['Pre-work', 'Post-work', 'Resting', 'Injured']
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (value) {
                recordedStatus = value;
              },
              dropdownColor: Color(0xFFA4DAF3),
              value: recordedStatus,
              decoration: const InputDecoration(
                hintText: 'Recording status of horse',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
              validator: (value) => (value?.isEmpty ?? true)
                  ? 'Please enter select the time'
                  : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _commentController,
              maxLines: 5,
              decoration: const InputDecoration(
                  hintText: 'Comment (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  )),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
                onPressed: () async {
                  try {
                    List<VideoModel> videoList = [];

                    for (var element in convertToVideo) {
                      if (element.id == convertToVideo[widget.videoIndex].id) {
                        videoList.add(VideoModel(
                            id: element.id,
                            createdDate: element.createdDate,
                            recordedStatus: recordedStatus ?? element.recordedStatus,
                            comment: _commentController.text.isEmpty
                                ? element.comment
                                : _commentController.text,
                            videoThumbnail: element.videoThumbnail,
                            videoUrl: element.videoUrl));
                      } else {
                        videoList.add(element);
                      }
                    }

                    // _videoList.add(VideoModel(
                    //   videoThumbnail: thumbnail,
                    //   videoUrl: widget.video!.path,
                    // ));

                    Provider.of<TrojanTrackProvider>(context, listen: false).addHorse(
                        widget.trojantrackModel.preview,
                        videoList,
                        widget.trojantrackModel.horseName,
                        widget.trojantrackModel.id,
                        widget.trojantrackModel.sireName,
                        widget.trojantrackModel.yearofBirth,
                        widget.trojantrackModel.damName,
                        null,
                        widget.trojantrackModel.userName ?? "");
                    Navigator.of(context).pop();
                    Navigator.of(context).maybePop();
                  } catch (e) {
                    context.showSnackBar(e);
                  }
                },
                child: const Text('Submit'))
          ],
        ),
      ),
    );
  }

  Widget _buildVideoView(BuildContext context) {
    return InkWell(
      onTap: () {
        if (convertToVideo[widget.videoIndex].videoUrl?.isEmpty ?? true) {
          return;
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => VideoPlayerScreen(
                url: convertToVideo[widget.videoIndex].videoUrl ?? ""),
          ),
        );
      },
      child: Center(
        child: Stack(
          children: [
            convertToVideo[widget.videoIndex]
                    .videoThumbnail
                    .toString()
                    .isNetworkImage
                ? CachedNetworkImage(
                    imageUrl:
                        convertToVideo[widget.videoIndex].videoThumbnail ?? "",
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: MediaQuery.of(context).size.height / 3,
                    placeholder: (context, imageProvider) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, error, stackTrace) => Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: MediaQuery.of(context).size.height / 3,
                      color: Colors.grey.withOpacity(0.2),
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Image.asset(
                          'assets/default_img.jpeg',
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: MediaQuery.of(context).size.height / 3,
                        ),
                      ),
                    ),
                  )
                : Image.file(
                    File(
                        convertToVideo[widget.videoIndex].videoThumbnail ?? ""),
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: MediaQuery.of(context).size.height / 3,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: MediaQuery.of(context).size.height / 3,
                      color: Colors.grey.withOpacity(0.2),
                      padding: const EdgeInsets.all(10),
                      child: Center(
                          child: Image.asset(
                        'assets/default_img.jpeg',
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: MediaQuery.of(context).size.height / 3,
                      )),
                    ),
                  ),
            Container(
              color: Colors.grey.withOpacity(0.2),
              width: MediaQuery.of(context).size.width / 1.2,
              height: MediaQuery.of(context).size.height / 3,
              child: const Center(
                child: Icon(
                  Icons.play_arrow,
                  size: 30,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
