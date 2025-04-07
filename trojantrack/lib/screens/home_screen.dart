import 'dart:async';
import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import '../screens/video_queue.dart';
import '../provider/horse_provider.dart';
import '../screens/about_us_screen.dart';
import '../screens/add_horse_screen.dart';
import '../screens/horse_detail_screen.dart';
import '../screens/record_video_screen.dart';
import '../utils/custom_extension.dart';
import 'package:provider/provider.dart';
import '../models/TrojanTrackModel.dart';
import '../provider/auth_provider.dart';
import '../widgets/loading_indicator_overlay.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
// Loading Status notifier...
  final LoadingIndicatorNotifier _loadingIndicator = LoadingIndicatorNotifier();

  final TextEditingController _searchController = TextEditingController();

  String? fullName;
  String? email;

  // We can change the min from here!
  final int _autoTimerMin = 150;

  Timer? _timer;
  @override
  void initState() {
    super.initState();
    fetchInfo();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: LoadingIndicator(
        loadingStatusNotifier: _loadingIndicator.statusNotifier,
        indicatorType: LoadingIndicatorType.Spinner,
        child: Consumer2<AuthsProvider, TrojanTrackProvider>(
          builder: (context, auth, horse, child) => Scaffold(
            drawer: _buildDrawer(context),
            appBar: AppBar(
              centerTitle: true,
              title: Text(fullName ?? ""),
              actions: [
              Padding(
              padding: EdgeInsets.only(right: 10),
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const AddHorseScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 40,
                    ))
              ),
              ],
            ),
            floatingActionButton: StreamBuilder<QuerySnapshot<TrojanTrackModel>>(
                stream: Provider.of<TrojanTrackProvider>(context, listen: false)
                    .fetchAllToDo(_searchController.text),
                builder: (context, snapshot) {
                  return FloatingActionButton.extended(
                      label: const Text("Record"),
                      onPressed: () async {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            context.showSnackBar("Loading...");
                            break;
                          case ConnectionState.active:
                          case ConnectionState.done:
                            if (snapshot.data?.items.isEmpty ?? true) {
                              context.showSnackBar("Please add Horse first! ");
                              return;
                            }
                            PickedFile? video =
                                await ImagePicker.platform.pickVideo(
                              source: ImageSource.camera,
                            );
                            if (video != null) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) =>
                                      RecordVideoScreen(video: video),
                                ),
                              );
                            }
                        }
                      },
                      icon: const Icon(Icons.camera));
                }),
            body: _buildBody(horse),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(TrojanTrackProvider horse) {
    return Column(
      children: [
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
                hintText: "Search horse by name...",
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
            onChanged: (value) {
              if (mounted) {
                setState(() {});
              }
            },
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<TrojanTrackModel>>(
              stream: Provider.of<TrojanTrackProvider>(context, listen: false)
                  .fetchAllToDo(_searchController.text),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );

                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.data?.items.isEmpty ?? true) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset('assets/horse.json',
                                height: 200),
                            const SizedBox(height: 10),
                            const Text('Start adding your horse'),
                            const SizedBox(height: 40),
                          ],
                        ),
                      );
                    }
                    return ListView.separated(
                      separatorBuilder: (context, index) => const Divider(),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 5),
                      itemCount: snapshot.data?.items.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                          direction: DismissDirection.endToStart,
                          resizeDuration: const Duration(milliseconds: 200),
                          key: ObjectKey(snapshot.data?.items.elementAt(index)),
                          confirmDismiss: (direction) async {
                            bool isConfrim = false;
                            await _showConfrimDialog(
                              () {
                                horse.deleteHorse(snapshot.data!.items[index]);
                                isConfrim = true;
                              },
                            );
                            return isConfrim;
                          },
                          background: Container(
                            padding: const EdgeInsets.only(left: 28.0),
                            alignment: AlignmentDirectional.centerStart,
                            color: Colors.red,
                            child: const Icon(
                              Icons.delete_forever,
                              color: Color(0xFFA4DAF3),
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => HorseDetailScreen(
                                      trojantrackModel: snapshot.data!.items[index]),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 5,
                              color: Color(0xFFA4DAF3),
                              shadowColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 10),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: (snapshot.data?.items[index]
                                                      .preview ??
                                                  "")
                                              .isNetworkImage
                                          ? CachedNetworkImage(
                                              imageUrl: snapshot.data
                                                      ?.items[index].preview ??
                                                  "",
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                              placeholder: (context,
                                                      imageProvider) =>
                                                  const Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                              errorWidget: (context, error,
                                                      stackTrace) =>
                                                  Center(
                                                child: Image.asset(
                                                  'assets/default_img.jpg',
                                                  height: 70,
                                                  width: 70,
                                                ),
                                              ),
                                            )
                                          : Image.file(
                                              File(snapshot.data?.items[index]
                                                      .preview ??
                                                  ""),
                                              width: 70,
                                              height: 70,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Center(
                                                      child: Image.asset(
                                                'assets/default_img.jpg',
                                                height: 70,
                                                width: 70,
                                              )),
                                            ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Card(
                                            elevation: 2,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              color: Color(0xFF1264AC),
                                              width: double.infinity,
                                              child: Text(
                                                snapshot.data?.items[index]
                                                        .horseName ??
                                                    "",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 1),
                                          Row(
                                            children: [
                                              // Expanded(
                                              //   child: Padding(
                                              //     padding:
                                              //         const EdgeInsets.only(
                                              //             left: 10),
                                              //     child: Text(
                                              //         "Type: ${snapshot.data?.items[index].damName ?? ""} / Age: ${snapshot.data?.items[index].sireName ?? ""}"),
                                              //   ),
                                              // ),
                                              // Padding(
                                              //   padding: const EdgeInsets.only(
                                              //       right: 10.0),
                                              //   child: Text(
                                              //     "${snapshot.data?.items[index].adminFiled ?? ""}",
                                              //     style: TextStyle(
                                              //       color: (snapshot.data?.items[index].adminFiled ?? "") == "Clear"
                                              //           ? Colors.green
                                              //           : (snapshot.data?.items[index].adminFiled ?? "") == "Doubtful"
                                              //           ? Colors.orange
                                              //           : (snapshot.data?.items[index].adminFiled ?? "") == "Injured"
                                              //           ? Colors.red
                                              //           : Colors.black,
                                              //       fontWeight: FontWeight.bold, // Make text bold
                                              //       fontSize: 14, // Set font size to 16
                                              //     ),
                                              //   ),
                                              // ),
                                              // Expanded(
                                              //   child: Padding(
                                              //     padding: const EdgeInsets.only(right: 10),
                                              //     child: Align(
                                              //       alignment: Alignment.centerRight,
                                              //       child: Text(
                                              //         "${snapshot.data?.items[index].adminFiled ?? ""}",
                                              //         style: TextStyle(
                                              //           color: snapshot.data?.items[index].adminFiled == "Clear"
                                              //               ? Colors.green
                                              //               : snapshot.data?.items[index].adminFiled == "Doubtful"
                                              //               ? Colors.orange
                                              //               : snapshot.data?.items[index].adminFiled == "Injured"
                                              //               ? Colors.red
                                              //               : Colors.black,
                                              //           fontWeight: FontWeight.bold,
                                              //           fontSize: 14,
                                              //         ),
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),

                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(right: 1),
                                                  child: Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Container(
                                                      padding: const EdgeInsets.all(1),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: snapshot.data?.items[index].adminFiled != null
                                                              ? (snapshot.data?.items[index].adminFiled == "All Clear"
                                                              ? Colors.green
                                                              : snapshot.data?.items[index].adminFiled == "Caution"
                                                              ? Colors.orange
                                                              : snapshot.data?.items[index].adminFiled == "Injured"
                                                              ? Colors.red
                                                              : Colors.black)
                                                              : Colors.transparent,
                                                          width: 2,
                                                        ),
                                                        borderRadius: BorderRadius.circular(1),
                                                      ),
                                                      child: Text(
                                                        "${snapshot.data?.items[index].adminFiled ?? ""}",
                                                        style: TextStyle(
                                                          color: snapshot.data?.items[index].adminFiled == "All Clear"
                                                              ? Colors.green
                                                              : snapshot.data?.items[index].adminFiled == "Caution"
                                                              ? Colors.orange
                                                              : snapshot.data?.items[index].adminFiled == "Injured"
                                                              ? Colors.red
                                                              : Colors.black,
                                                          fontWeight: FontWeight.normal,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Text(snapshot.data?.items[index].height ?? ""),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                }
              }),
        ),
      ],
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Center(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF2C2C2C)),
              currentAccountPicture: const CircleAvatar(
                child: Text('🏇', style: TextStyle(fontSize: 40)),
              ),
              accountEmail: Text(email ?? ""),
              accountName: Text(fullName ?? ""),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const AboutUsScreen(),
                  ),
                );
              },
              leading: const Icon(Icons.info_outline),
              title: const Text('About Us'),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => VideoQueueScreen(),
                  ),
                );
              },
              leading: const Icon(Icons.queue_outlined),
              title: const Text('Upload Queue'),
            ),
            ListTile(
              onTap: () {
                Provider.of<AuthsProvider>(context, listen: false).logOut();
              },
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
            ),
            // SizedBox(height: 420,),
            Expanded(
              child: Container(),
            ),
            ListTile(
              title: Center(child: Text('Made with ❤💪 in ☘ Ireland.\n©2023 Copyright TrojanTrack Limited.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Color(0xFF2C2C2C)),
                // other properties
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchInfo() async {
    try {
      _loadingIndicator.show();
      await Provider.of<AuthsProvider>(context, listen: false).fetchUser();
      await Provider.of<AuthsProvider>(context, listen: false).fetchUserData();
      AuthUser? auth =
          Provider.of<AuthsProvider>(context, listen: false).authUser;
      List<AuthUserAttribute> userAttibutes =
          Provider.of<AuthsProvider>(context, listen: false).userAttibutes;
      List<AuthUserAttribute> nameAttibutes = userAttibutes
          .where((element) =>
              element.userAttributeKey == CognitoUserAttributeKey.name)
          .toList();
      if (nameAttibutes.isNotEmpty) {
        fullName = nameAttibutes.first.value;
      } else {
        fullName = auth?.username;
      }
      List<AuthUserAttribute> emailAttibutes = userAttibutes
          .where((element) =>
              element.userAttributeKey == CognitoUserAttributeKey.email)
          .toList();
      if (emailAttibutes.isNotEmpty) {
        email = emailAttibutes.first.value;
      } else {
        email = auth?.username;
      }

      if (mounted) {
        setState(() {});
      }
      if (auth != null) {
        Provider.of<TrojanTrackProvider>(context, listen: false).clearData(auth.userId);
        Provider.of<TrojanTrackProvider>(context, listen: false)
            .fetchInitialData(auth.userId);
        
	  _timer = Timer.periodic(Duration(minutes: _autoTimerMin), (timer) {
          if (timer.tick > 0) {
            Provider.of<TrojanTrackProvider>(context, listen: false)
                .fetchInitialData(auth.userId);
          }
        });
      }
    } catch (e) {
      context.showSnackBar(e);
    } finally {
      _loadingIndicator.hide();
    }
  }

  Future<void> _showConfrimDialog(void Function() onSubmit) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const SingleChildScrollView(
            child: Text('Would you like to delete this horse?'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                onSubmit();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
