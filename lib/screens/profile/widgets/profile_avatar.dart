import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mining_solutions/hubkens/colors.dart';
import 'package:mining_solutions/providers/user_info_provider.dart';
import 'package:mining_solutions/screens/profile/edit_profile_page.dart';
import 'package:provider/provider.dart';

class ProfileAvatar extends StatefulWidget {
  const ProfileAvatar({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  loadState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context, listen: false);

    final avatarUrl =
        userInfo.profilePhotoPath == "" || userInfo.profilePhotoPath == null
            ? "https://hubmine.s3.amazonaws.com/default-profile.png"
            : 'http://23.100.25.47:8010/media/' + userInfo.profilePhotoPath;
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        SizedBox(
            width: MediaQuery.of(context).size.width / 4,
            height: MediaQuery.of(context).size.width / 4,
            child: CachedNetworkImage(
              errorWidget: (context, url, error) => Icon(Icons.error),
              placeholder: (context, url) => CircularProgressIndicator(),
              imageUrl: avatarUrl,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              fit: BoxFit.cover,
            )),
        GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => EditProfilePage(
                      name: userInfo.firstName,
                      lastName: userInfo.lastName,
                      phone: userInfo.phone,
                      email: userInfo.email,
                      company: userInfo.businessName,
                      rfc: userInfo.rfc,
                    ),
                  ),
                )
                .then((value) => loadState());
          },
          child: CircleAvatar(
            child: SvgPicture.asset("assets/edit.svg", color: Colors.white),
            foregroundColor: Colors.white,
            backgroundColor: primaryClr,
          ),
        )
      ],
    );
  }
}