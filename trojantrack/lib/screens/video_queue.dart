import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../provider/horse_provider.dart';
import '../utils/custom_extension.dart';

class VideoQueueScreen extends StatefulWidget {
  VideoQueueScreen({super.key});

  @override
  State<VideoQueueScreen> createState() => _VideoQueueScreenState();
}

class _VideoQueueScreenState extends State<VideoQueueScreen> {
  @override
  Widget build(BuildContext context) {
    List<QueueData> pending = [];
    List<QueueData> completed = [];
    getUploadedVideos(UploadQueue, pending, completed);

    return Scaffold(
      appBar: AppBar(title: Text("Upload Queue", style: const TextStyle(
          color: Colors.white,
          fontSize: 30),),),

      body: Center(
        child: Column(
          children: [

            // title In Queue
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color:  Color(0xFF1264AC),
                ),
                padding: const EdgeInsets.all(8.0),
                width: double.infinity,
                child: Text("In Queue",
                textAlign: TextAlign.left,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w500),),
              ),
            ),

            // videos in queue
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Column(
                children: returnVideoList(pending)
              ),
            ),

          // title Uploaded
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color:  Color(0xFF1264AC),
                ),
                padding: const EdgeInsets.all(8.0),
                width: double.infinity,
                child: Text("Uploaded",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight:
                      FontWeight.w500),),
              ),
            ),

            // for videos uploaded
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Column(
                children: returnVideoList(completed)

              ),
            ),
          ],
        ),
      )
    );
  }
}


// separates the queue of uploaded videos into pending and uploaded
void getUploadedVideos(final List<QueueData> queue, final List<QueueData> pending, final List<QueueData> completed) {
  for(QueueData q in queue) {
    print(q);
    // checks for uploaded thumbnail to see if upload worked
    if(q.videoModel?.videoUrl != null) {
      completed.add(q);
    }
    else {
      pending.add(q);
    }
  }
}

// helper to set up display for list of videos
List<Widget> returnVideoList(List<QueueData> vidList) {
  return vidList.map<Widget>((queue) => Padding(
    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
    child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color:  Color(0xFFA4DAF3),
          boxShadow: [
            BoxShadow(
                color:  Color(0xFF1264AC),
                blurRadius: 2,
                offset: Offset(2, 4),
                spreadRadius: 2// Shadow position
            ),
          ],
        ),
        padding: const EdgeInsets.all(6.0),
        width: double.infinity,
        child: Row(
          children: [
            Text(queue.getHorseName().toString(),
              textAlign: TextAlign.left,
              style: const TextStyle(
                  color: Color(0xFF1264AC),
                  fontSize: 24,
                  fontWeight: FontWeight.w500),),
            Spacer(),

            Container(
              child: Column(
                children: [
                  Text(queue.videoModel?.createdDate.toString().substring(0,10) ?? "date unknown",
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                        color: Color(0xFF1264AC),
                        fontSize: 16,
                        fontWeight: FontWeight.w500),),

                  Text(queue.videoModel?.createdDate.toString().substring(11,16) ?? "time unknown",
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                        color: Color(0xFF1264AC),
                        fontSize: 16,
                        fontWeight: FontWeight.w500),),
                ],
              ),
            ),
          ],
        )),

  )).toList();
}