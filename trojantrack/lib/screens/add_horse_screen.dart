import 'dart:convert';
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/TrojanTrackModel.dart';
import '../models/VideoModel.dart';
import '../provider/horse_provider.dart';
import '../utils/custom_extension.dart';
import '../provider/auth_provider.dart';
import '../widgets/loading_indicator_overlay.dart';

class AddHorseScreen extends StatefulWidget {
  final TrojanTrackModel? trojantrackModel;
  const AddHorseScreen({Key? key, this.trojantrackModel}) : super(key: key);

  @override
  State<AddHorseScreen> createState() => _AddHorseScreenState();
}

class _AddHorseScreenState extends State<AddHorseScreen> {
  //Form Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //Auto validation mode
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  // Controller...
  final TextEditingController _horseNameController = TextEditingController();
  final TextEditingController _sireNameController = TextEditingController();
  final TextEditingController _yearofBirthController = TextEditingController();
  final TextEditingController _damNameController = TextEditingController();

  //Vars..
  PickedFile? preview;

  List<VideoModel> _videoList = [];
  String? time;
  PickedFile? video;

  // Loading Indicator
  final LoadingIndicatorNotifier _loadingIndicatorNotifier =
      LoadingIndicatorNotifier();

  TrojanTrackProvider get mutedProvider =>
      Provider.of<TrojanTrackProvider>(context, listen: false);

  @override
  void initState() {
    if (widget.trojantrackModel != null) {
      _horseNameController.text = widget.trojantrackModel?.horseName ?? "";
      _sireNameController.text = widget.trojantrackModel?.sireName ?? "";
      _yearofBirthController.text = widget.trojantrackModel?.yearofBirth ?? "";
      _damNameController.text = widget.trojantrackModel?.damName ?? "";
      _videoList = widget.trojantrackModel?.videosJson
              ?.map((e) => VideoModel.fromJson(jsonDecode(e)))
              .toList() ??
          [];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: LoadingIndicator(
        loadingStatusNotifier: _loadingIndicatorNotifier.statusNotifier,
        indicatorType: LoadingIndicatorType.Overlay,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(widget.trojantrackModel == null ? 'Add Horse' : 'Edit Horse'),
          ),
          body: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          autovalidateMode: _autovalidateMode,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: InkWell(
                  onTap: () async {
                    if ((widget.trojantrackModel?.preview ?? "").isNotEmpty) {
                      return;
                    }
                    preview = await ImagePicker.platform
                        .pickImage(source: ImageSource.camera);
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  child: CircleAvatar(
                    radius: 50,
                    child: (widget.trojantrackModel?.preview.isNetworkImage ?? false)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              imageUrl: widget.trojantrackModel?.preview ?? "",
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              placeholder: (context, imageProvider) =>
                                  const Center(
                                      child: CircularProgressIndicator()),
                              errorWidget: (context, error, stackTrace) =>
                                  Center(
                                    child: Image.asset(
                                    'assets/default_img.jpeg',
                                    height: 70,
                                    width: 70,
                                  )
                                  ),
                            ),
                          )
                        : preview == null
                            ? const Icon(Icons.file_upload_outlined)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(
                                  File(preview!.path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _horseNameController,
                enabled: (widget.trojantrackModel?.horseName ?? "").isEmpty,
                decoration: const InputDecoration(
                  hintText: 'Horse Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) => (value?.isEmpty ?? true)
                    ? 'Please enter name of horse'
                    : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                enabled: (widget.trojantrackModel?.sireName ?? "").isEmpty,
                controller: _sireNameController,
                decoration: const InputDecoration(
                  hintText: 'Sire Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
                textInputAction: TextInputAction.next,
                // validator: (value) => (value?.isEmpty ?? true)
                //     ? 'Please enter sire name'
                //     : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                enabled: (widget.trojantrackModel?.damName ?? "").isEmpty,
                controller: _damNameController,
                decoration: const InputDecoration(
                  hintText: 'Dam Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
                // validator: (value) => (value?.isEmpty ?? true)
                //     ? 'Please enter dam name'
                //     : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                enabled: (widget.trojantrackModel?.yearofBirth ?? "").isEmpty,
                controller: _yearofBirthController,
                decoration: const InputDecoration(
                  hintText: 'Year of Birth',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
                textInputAction: TextInputAction.next,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                // validator: (value) => (value?.isEmpty ?? true)
                //     ? 'Please enter year of birth'
                //     : null,
              ),


              const SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      if (!_formKey.currentState!.validate()) {
                        _autovalidateMode = AutovalidateMode.always;
                        final FocusScopeNode currentFocus =
                            FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        return;
                      }
                      _loadingIndicatorNotifier.show();
                      String? email;
                      String? fullName;
                      AuthUser? auth =
                          Provider.of<AuthsProvider>(context, listen: false)
                              .authUser;
                      List<AuthUserAttribute> userAttibutes =
                          Provider.of<AuthsProvider>(context, listen: false)
                              .userAttibutes;
                      List<AuthUserAttribute> nameAttibutes = userAttibutes
                          .where((element) =>
                              element.userAttributeKey ==
                              CognitoUserAttributeKey.name)
                          .toList();
                      if (nameAttibutes.isNotEmpty) {
                        fullName = nameAttibutes.first.value;
                      } else {
                        fullName = auth?.username;
                      }
                      List<AuthUserAttribute> emailAttibutes = userAttibutes
                          .where((element) =>
                              element.userAttributeKey ==
                              CognitoUserAttributeKey.email)
                          .toList();
                      if (emailAttibutes.isNotEmpty) {
                        email = emailAttibutes.first.value;
                      } else {
                        email = auth?.username;
                      }
                      mutedProvider.addHorse(
                          preview?.path,
                          _videoList,
                          _horseNameController.text,
                          widget.trojantrackModel?.id,
                          _sireNameController.text,
                          _yearofBirthController.text,
                          _damNameController.text,
                          widget.trojantrackModel?.preview,
                          fullName ?? "");

                      if (widget.trojantrackModel != null) {
                        Navigator.of(context).pop();
                      }
                      Navigator.of(context).pop();
                    } catch (e) {
                      context.showSnackBar(e);
                    } finally {
                      _loadingIndicatorNotifier.hide();
                    }
                  },
                  child: const Text('Submit'))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showConfrimDialog(void Function() onSubmit) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const SingleChildScrollView(
            child: Text('Would you like to delete this horse video?'),
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
