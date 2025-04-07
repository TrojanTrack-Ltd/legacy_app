import 'dart:convert';
import 'dart:io';

import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../models/TrojanTrackModel.dart';
import '../models/VideoModel.dart';
import '../provider/horse_provider.dart';
import '../screens/video_player_screen.dart';
import '../utils/custom_extension.dart';
import '../widgets/loading_indicator_overlay.dart';

class RecordVideoScreen extends StatefulWidget {
  PickedFile? video;
  RecordVideoScreen({Key? key, required this.video}) : super(key: key);

  @override
  State<RecordVideoScreen> createState() => _RecordVideoScreenState();
}

class _RecordVideoScreenState extends State<RecordVideoScreen> {
  final LoadingIndicatorNotifier _loadingIndicatorNotifier =
      LoadingIndicatorNotifier();
  String? thumbnail;
  TrojanTrackModel? _trojantrackModel;
  List<VideoModel> _videoList = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Select Horse & Submit"),
      ),
      body: LoadingIndicator(
        loadingStatusNotifier: _loadingIndicatorNotifier.statusNotifier,
        indicatorType: LoadingIndicatorType.Spinner,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder<List<TrojanTrackModel>>(
                  future: Provider.of<TrojanTrackProvider>(context, listen: false)
                      .fetchAllToDoFuture(""),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done ||
                        snapshot.connectionState == ConnectionState.active) {
                      return DropdownButtonFormField<TrojanTrackModel>(
                        items: _addDividersAfterItems(snapshot.data ?? []),
                        onChanged: (value) {
                          _trojantrackModel = value;
                        },
                        hint: const Text(
                          'Select the horse',
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Select the horse',
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                        validator: (value) => (value == null)
                            ? 'Please enter select the horse'
                            : null,
                      );
                    } else {
                      return Container();
                    }
                  }),
              const SizedBox(height: 30),
              InkWell(
                onTap: () {
                  if (widget.video != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) =>
                            VideoPlayerScreen(url: widget.video!.path),
                      ),
                    );
                  }
                },
                child: Center(
                  child: Stack(
                    children: [
                      Image.file(
                        File(thumbnail ?? ""),
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: MediaQuery.of(context).size.height / 3,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: MediaQuery.of(context).size.height / 3,
                          color: Colors.grey.withOpacity(0.2),
                          padding: const EdgeInsets.all(10),
                          child:  Center(
                            child: Image.asset(
                              'assets/default_img.jpeg',
                              width: MediaQuery.of(context).size.width / 1.2,
                              height: MediaQuery.of(context).size.height / 3,
                            ),
                          ),
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
                        )),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      _loadingIndicatorNotifier.show();
                      if (_trojantrackModel == null) {
                        throw 'Please select the horse first!';
                      }
                      _videoList = _trojantrackModel?.videosJson
                              ?.map((e) => VideoModel.fromJson(jsonDecode(e)))
                              .toList() ??
                          [];
                      _videoList.add(VideoModel(
                        videoThumbnail: thumbnail,
                        videoUrl: widget.video!.path,
                      ));

                      Provider.of<TrojanTrackProvider>(context, listen: false)
                          .addHorse(
                          _trojantrackModel!.preview,
                              _videoList,
                          _trojantrackModel!.horseName,
                          _trojantrackModel!.id,
                          _trojantrackModel!.sireName,
                          _trojantrackModel!.yearofBirth,
                          _trojantrackModel!.damName,
                              null,
                          _trojantrackModel!.userName ?? "");
                      Navigator.of(context).pop();
                    } catch (e) {
                      context.showSnackBar(e);
                    } finally {
                      _loadingIndicatorNotifier.hide();
                    }
                  },
                  child: const Text('Submit',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    try {
      _loadingIndicatorNotifier.show();
      thumbnail = await VideoThumbnail.thumbnailFile(video: widget.video!.path);
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      context.showSnackBar(e);
    } finally {
      _loadingIndicatorNotifier.hide();
    }
  }

  List<DropdownMenuItem<TrojanTrackModel>> _addDividersAfterItems(
      List<TrojanTrackModel> items) {
    try {
      List<DropdownMenuItem<TrojanTrackModel>> menuItems = [];
      for (var i = 0; i < items.length; i++) {
        menuItems.addAll(
          [
            DropdownMenuItem<TrojanTrackModel>(
              value: items[i],
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("${i + 1}. ${items[i].horseName ?? ""}")),
            ),
            //If it's last item, we will not add Divider after it.
            // if (items[i].id != items.last.id)
            const DropdownMenuItem<TrojanTrackModel>(
              enabled: false,
              child: Divider(),
            ),
          ],
        );
      }

    return menuItems;
  } catch (e) {
      return [];
  }
 }
}
