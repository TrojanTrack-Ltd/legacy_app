import 'dart:convert';
import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wakelock/wakelock.dart';

import '../models/TrojanTrackModel.dart';
import '../models/VideoModel.dart';
import '../utils/custom_extension.dart';

class QueueData{
  String? horseName;
  VideoModel? videoModel;

  QueueData(String? h, VideoModel? v){
    horseName = h;
    videoModel = v;
  }

  // String? getVideoUrl(){
  //   return videoModel.videoUrl;
  // }

  String? getHorseName(){
    return horseName;
  }


  VideoModel? getVideoModel() {
    return videoModel;
  }

    void updateHorseName(String h){
      horseName = h;
    }




    String toString() {
      return("Horse Name = $horseName \n Video Model = $videoModel \n");
    }
  }

List<QueueData> UploadQueue = [];
class TrojanTrackProvider with ChangeNotifier {

  final Connectivity _connectivity = Connectivity();

  Future<void> clearData(String userId) async {
    List<TrojanTrackModel> horses = await Amplify.DataStore.query<TrojanTrackModel>(
        TrojanTrackModel.classType,
        where: TrojanTrackModel.USERID.eq(userId),
        sortBy: [
          const QuerySortBy(order: QuerySortOrder.ascending, field: 'horseName')
        ]);
    List<TrojanTrackModel> localImageHorse = horses.where((horse) {
      List<VideoModel> convertToVideo = horse.videosJson
              ?.map((e) => VideoModel.fromJson(jsonDecode(e)))
              .toList() ??
          [];
      return ((!(horse.preview?.isNetworkImage ?? true)) ||
          convertToVideo.any((video) => !video.videoUrl.isNetworkImage));
    }).toList();

    if (localImageHorse.isEmpty) {
      var appDir = (await getTemporaryDirectory()).path;
      Directory(appDir).delete(recursive: true);
    }
  }

  void addToQueue(QueueData q) {
    bool duplicate = false;
    while (!duplicate) {
      for (QueueData current in UploadQueue) {
        if (current.videoModel?.id == q.videoModel?.id)
          duplicate = true;
      }
      if(!duplicate) {
        UploadQueue.add(q);
        print("added to queue");
        print(UploadQueue.last);
      } break;
    }
    print("Adding done!");
    print("\n");

  }
  Future<void> fetchInitialData(String userId) async {
    bool isLoading = false;
    Wakelock.enabled.then((isEnable) {
      if (!isEnable) {
        Wakelock.enable();
      }
    });

    _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        isLoading = false;
        return;
      }
      try {
        Amplify.DataStore.observeQuery(TrojanTrackModel.classType,
            where: TrojanTrackModel.USERID.eq(userId),
            sortBy: [
              const QuerySortBy(order: QuerySortOrder.ascending, field: 'horseName')
            ]).listen((event) async {
          if (isLoading) {
            return;
          }
          for (var horse in event.items) {
            List<VideoModel> convertToVideo = horse.videosJson
                    ?.map((e) => VideoModel.fromJson(jsonDecode(e)))
                    .toList() ??
                [];
            try {
              if ((!(horse.preview?.isNetworkImage ?? true)) ||
                  convertToVideo.any((video) => !video.videoUrl.isNetworkImage)) {
                isLoading = true;
                List<VideoModel> videoList = [];
                String? imageUrl;
                if (!(horse.preview?.isNetworkImage ?? true)) {
                  imageUrl = await uploadImage(horse.preview,'${userId}/${horse.horseName}_${horse.id}/previews/pre_${horse.id}');
              } else {
                imageUrl = horse.preview;
              }

              for (var video in convertToVideo) {
                String? videoUrls = video.videoUrl;
                String? videoThumbnails = video.videoThumbnail;
                String? recordedStatus = video.recordedStatus;
                String? comment = video.comment;
                if (!(videoUrls?.isNetworkImage ?? false)) {
                  QueueData q = QueueData(
                      horse.horseName,
                      VideoModel(
                        createdDate: TemporalDateTime.now(),
                        videoUrl: null,
                        recordedStatus: recordedStatus,
                        comment: comment,
                        videoThumbnail: null,
                  ));
                  addToQueue(q);
                  String? videoUrl = await uploadVideo(
                      videoUrls,
                      '${userId}/${horse.horseName}_${horse.id}/videos/vid_${video.id}',
                      '${userId}/${horse.horseName}_${horse.id}/videos/');
                  String? tumUrl = await uploadImage(
                      videoThumbnails, '${userId}/${horse.horseName}_${horse.id}/images/img_${video.id}');
                  UploadQueue.last.videoModel = UploadQueue.last.videoModel?.copyWith(videoThumbnail: tumUrl);
                  
                videoList.add(
                    VideoModel(
                      createdDate: TemporalDateTime.now(),
                      videoUrl: videoUrl,
                      recordedStatus: recordedStatus,
                      comment: comment,
                      videoThumbnail: tumUrl,
                    ),
                  );
                } else {
                  videoList.add(video);
                }
              }
              TrojanTrackModel trojantrackModel = TrojanTrackModel(
                  sireName: horse.sireName,
                  id: horse.id,
                  yearofBirth: horse.yearofBirth,
                  damName: horse.damName,
                  preview: imageUrl,
                  horseName: horse.horseName,
                  userId: horse.userId,
                  userName: horse.userName,
                  videosJson:
                      videoList.map((e) => jsonEncode(e.toJson())).toList());
                await Amplify.DataStore.save(trojantrackModel).onError((e, stackTrace) {
                  print("Error while uploading $e");
                  isLoading = false;

                  Fluttertoast.showToast(msg: e.toString());
                });
                isLoading = false;
              }
            } on PathNotFoundException {
              isLoading = false;
            } catch (e) {
              print("Error while uploading $e");
              isLoading = false;
              fetchInitialData(userId);
            }
          }
        }).onError((e) {
          print("Error while uploading $e");
          isLoading = false;
          Fluttertoast.showToast(msg: e.toString());
          fetchInitialData(userId);
        });
      } catch (e) {
        fetchInitialData(userId);
        Fluttertoast.showToast(msg: e.toString());
        print("Error while uploading $e");
        isLoading = false;
      }
    }).onError(
      (e) {
        print(e);
      },
    );
  }

  Stream<QuerySnapshot<TrojanTrackModel>> fetchAllToDo(String horseName) async* {
    try {
      AuthUser authUser = await Amplify.Auth.getCurrentUser();

      yield* Amplify.DataStore.observeQuery(
        TrojanTrackModel.classType,
        where: TrojanTrackModel.USERID.eq(authUser.userId) &
        TrojanTrackModel.HORSENAME.contains(horseName),
        sortBy: [
          const QuerySortBy(order: QuerySortOrder.ascending, field: 'horseName')
        ],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TrojanTrackModel>> fetchAllToDoFuture(String horseName) async {
    try {
      AuthUser authUser = await Amplify.Auth.getCurrentUser();

      return Amplify.DataStore.query(
        TrojanTrackModel.classType,
        where: TrojanTrackModel.USERID.eq(authUser.userId) &
            TrojanTrackModel.HORSENAME.contains(horseName),
        sortBy: [
          const QuerySortBy(order: QuerySortOrder.ascending, field: 'horseName')
        ],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addHorse(
      String? previewPath,
      List<VideoModel> videos,
      String? horseName,
      String? horseId,
      String? sireName,
      String? yearofBirth,
      String? damName,
      String? widgetPreview,
      String userName) async {
    try {
      AuthUser authUser = await Amplify.Auth.getCurrentUser();
      if (authUser.userId == null) {
        throw 'please login first!';
      }

      TrojanTrackModel horse = TrojanTrackModel(
          id: horseId,
          userId: authUser.userId,
          userName: userName,
          horseName: horseName,
          sireName: sireName,
          yearofBirth: yearofBirth,
          damName: damName,
          preview: previewPath ??
              ((widgetPreview?.isNotEmpty ?? false)
                  ? widgetPreview
                  : previewPath),
          videosJson: videos.map((e) => jsonEncode(e.toJson())).toList());
      await Amplify.DataStore.save(horse);

      // fetchAllToDo();
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> uploadImage(String? path, String fileName) async {
    if (path == null) {
      return null;
    }
    try {
      File local = File(path);

      // final fileName = DateTime.now().toIso8601String();

      StorageUploadFileResult<StorageItem> result =
          await Amplify.Storage.uploadFile(
                  key: '$fileName.png',
                  localFile: AWSFile.fromPath(local.path),
                  options: const StorageUploadFileOptions(
                      accessLevel: StorageAccessLevel.guest))
              .result;

      // GetUrlResult url = await Amplify.Storage.getUrl(
      //     key: result.key,
      //     options: GetUrlOptions(accessLevel: StorageAccessLevel.guest));

      return getPrefixUrl + result.uploadedItem.key;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteHorse(TrojanTrackModel horse) async {
    try {
      await Amplify.DataStore.delete(horse);
      // fetchAllToDo();
    } catch (e) {
      rethrow;
    }
  }

  String get getPrefixUrl =>
      "https://trojantrackeaef8b18fdfa41feabdf09d6a174d4b595114-staging.s3-accelerate.amazonaws.com/public/";

  Future<String?> uploadVideo(
      String? path, String fileName, String speartePath) async {
    try {
      if (path == null) {
        return null;
      }
      File local = File(path);

      // final fileName = DateTime.now().toIso8601String();

      StorageUploadFileResult<StorageItem> result =
          await Amplify.Storage.uploadFile(
                  key: '$fileName.mp4',
                  localFile: AWSFile.fromPath(local.path),
                  onProgress: (p0) {
                    print("Uploading video $fileName ${p0.fractionCompleted}");
                  },
                  options: const StorageUploadFileOptions(
                      accessLevel: StorageAccessLevel.guest))
              .result;
      // GetUrlResult url = await Amplify.Storage.getUrl(
      //     key: result.key,
      //     options: GetUrlOptions(accessLevel: StorageAccessLevel.guest));
      // return url.url;
      // String url0 = url.url.split('.mp4').first;
      UploadQueue.last.videoModel = UploadQueue.last.videoModel?.copyWith(videoUrl: (getPrefixUrl + result.uploadedItem.key));
      return getPrefixUrl + result.uploadedItem.key;
    } catch (e) {
      rethrow;
    }
  }
}
