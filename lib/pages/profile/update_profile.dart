part of 'profile.dart';

class UpdateProfile extends StatefulWidget {
  UserModel userData;
  UpdateProfile({super.key, required this.userData});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _storage = FlutterSecureStorage();
  late UserModel _user; //pake late biar dinamis
  bool isEditingName = false;
  bool isEditingBio = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _bioFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _user = widget.userData;

    _nameFocus.addListener(() {
      if (!_nameFocus.hasFocus) {
        setState(() {
          isEditingName = false;
        });
      }
    });

    _bioFocus.addListener(() {
      if (!_bioFocus.hasFocus) {
        setState(() {
          isEditingBio = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _nameFocus.dispose();
    _bioFocus.dispose();
    super.dispose();
  }

  void _changeProfile() async {
    try {
      File? imageFile = await ImageService().pickImage();
      if (imageFile == null) return;

      Map<String, dynamic> userDataPayload = {
        "data": {
          "email": _user.email,
          "username": _user.username,
          "profilePic": _user.profilePic,
          "bannerPic": _user.bannerPic,
          "role": _user.role,
        }
      };

      await UserService().updateUser(userDataPayload, _user.userId, profileImage: imageFile);

      final dir = await getTemporaryDirectory();
      final newProfilePath = '${dir.path}/Profile/${_user.userId}.png';

      UserModel newData = UserModel(
        userId: _user.userId,
        email: _user.email,
        profilePic: newProfilePath,
        bannerPic: _user.bannerPic,
        username: _user.username,
        name: _user.name,
        bio: _user.bio,
        role: _user.role,
        createdAt: _user.createdAt,
      );

      await _storage.write(key: 'userData', value: jsonEncode(newData.toMap()));

      setState(() {
        _user = newData;
      });
    } catch (e) {
      print("Error uploading profile image: $e");
    }
  }

  void _changeBanner() async {
    try {
      File? imageFile = await ImageService().pickImage();
      if (imageFile == null) return;

      Map<String, dynamic> userDataPayload = {
        "data": {
          "email": _user.email,
          "username": _user.username,
          "profilePic": _user.profilePic,
          "bannerPic": _user.bannerPic,
          "role": _user.role,
        }
      };

      await UserService().updateUser(userDataPayload, _user.userId, bannerImage: imageFile);

      final dir = await getTemporaryDirectory();
      final newBannerPath = '${dir.path}/Banner/${_user.userId}.png';

      UserModel newData = UserModel(
        userId: _user.userId,
        email: _user.email,
        profilePic: _user.profilePic,
        bannerPic: newBannerPath,
        username: _user.username,
        name: _user.name,
        bio: _user.bio,
        role: _user.role,
        createdAt: _user.createdAt,
      );

      await _storage.write(key: 'userData', value: jsonEncode(newData.toMap()));

      setState(() {
        _user = newData;
      });
    } catch (e) {
      print("Error uploading banner image: $e");
    }
  }

  void _changeName() async {
    try {
      Map<String, dynamic> userDataPayload = {
        "data": {
          "email": _user.email,
          "username": _nameController.text,
          "profilePic": _user.profilePic,
          "bannerPic": _user.bannerPic,
          "role": _user.role,
        }
      };

      await UserService().updateUser(userDataPayload, _user.userId);

      UserModel newData = UserModel(
        userId: _user.userId,
        email: _user.email,
        profilePic: _user.profilePic,
        bannerPic: _user.bannerPic,
        username: _nameController.text,
        name: _user.name,
        bio: _user.bio,
        role: _user.role,
        createdAt: _user.createdAt,
      );

      await _storage.write(key: 'userData', value: jsonEncode(newData.toMap()));

      setState(() {
        _user = newData;
      });
    } catch (e) {
      print("Error updating name: $e");
    }
  }

  void _changeBio() async {
      try {
        Map<String, dynamic> userDataPayload = {
          "data": {
            "email": _user.email,
            "username": _user.username,
            "profilePic": _user.profilePic,
            "bannerPic": _user.bannerPic,
            "role": _user.role,
          }
        };

        await UserService().updateUser(userDataPayload, _user.userId);

        UserModel newData = UserModel(
          userId: _user.userId,
          email: _user.email,
          profilePic: _user.profilePic,
          bannerPic: _user.bannerPic,
          username: _user.username,
          name: _user.name,
          bio: _bioController.text,
          role: _user.role,
          createdAt: _user.createdAt,
        );

        await _storage.write(key: 'userData', value: jsonEncode(newData.toMap()));

        setState(() {
          _user = newData;
        });
      } catch (e) {
        print("Error updating name: $e");
      }
    }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          isEditingName = false;
          isEditingBio = false;
        });
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        body: _build(context),
      ),
    );
  }

  Widget _build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Stack(
                children: [
                  Positioned(
                    child: _user.bannerPic.isEmpty
                        ? Image.asset(
                      "assets/images/bg_profile.png",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    )
                        : Image(
                      image: FileImage(File(_user.bannerPic)),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: (MediaQuery.of(context).size.width - 140) / 2,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: _user.profilePic.isEmpty
                              ? AssetImage("assets/images/profile.png")
                              : FileImage(File(_user.profilePic)) as ImageProvider,
                          onBackgroundImageError: (exception, stackTrace) {},
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 120,
                    right: (MediaQuery.of(context).size.width - 280) / 2 + 40,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: IconButton(
                        onPressed: _changeProfile,
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          color: whiteColor,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: IconButton(
                        onPressed: _changeBanner,
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          color: whiteColor,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              isEditingName
                ? MyTextField2(
                controller: _nameController,
                name: "Masukkan nama",
                inputType: TextInputType.text,
                onSubmitted: (_) => _changeName(),
              )
                  : ListTile(
                title: MyText(
                  "Username",
                  fontSize: 15,
                  color: Colors.grey[400],
                ),
                subtitle: MyText(
                  _user.username,
                  fontSize: 20,
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  setState(() {
                    isEditingName = true;
                    isEditingBio = false;
                  });
                  Future.delayed(const Duration(milliseconds: 100), () {
                    _nameFocus.requestFocus();
                  });
                },
              ),
              const Divider(),
              isEditingBio
                  ? MyTextField2(
                controller: _bioController,
                name: 'Masukkan Bio',
                inputType: TextInputType.text,
                onSubmitted: (_) => _changeBio()
              )
                  : ListTile(
                title: MyText(
                  "Bio",
                  fontSize: 15,
                  color: Colors.grey[400],
                ),
                subtitle: MyText(
                  _user.bio.isEmpty ? "Tidak ada bio" : _user.bio,
                  fontSize: 18,
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  setState(() {
                    isEditingBio = true;
                    isEditingName = false;
                  });
                  Future.delayed(const Duration(milliseconds: 100), () {
                    _bioFocus.requestFocus();
                  });
                },
              ),
              const Divider(),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildHeader(BuildContext context) {
    return Container(
      color: primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              "assets/images/back-button.png",
              width: 40,
              height: 40,
            ),
          ),

          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Update Profile",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 32),
        ],
      ),
    );
  }
}
