import 'package:flutter/material.dart';
import 'package:jwacademicsweb/core/app_colors.dart';
import 'package:jwacademicsweb/ui/widgets/responsive_layout.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingPageFooter extends StatelessWidget {
  const LandingPageFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(40),
      color: AppColors.primary,
      child: ResponsiveLayout.isLargeScreen(context) ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: _JWIntro()),
          Expanded(child: _FollowUs()),
          Expanded(child: _ContactUs()),
        ],
      ) : Column(
        children: [
          _JWIntro(),
          _FollowUs(),
          _ContactUs(),
        ],
      ),
    );
  }
}

class _JWIntro extends StatelessWidget {
  const _JWIntro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("JW Academics", style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        )),
        Text("We provide Academic Assignment Help to Diploma, Degree, Master and PHD full-time/part-time College/ University students.",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
        ),)
      ],
    );
  }
}

class _FollowUs extends StatelessWidget {
  const _FollowUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              if(await canLaunch("https://www.facebook.com/JWassignmentexpert/")){
                launch("https://www.facebook.com/JWassignmentexpert/");
              }
            },
            child: Text("FOLLOW US ON FACEBOOK",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),),
          ),
        ],
      ),
    );
  }
}

class _ContactUs extends StatelessWidget {
  const _ContactUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      child: Column(
        children: [
          Text("CONTACT US", style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),),
          SizedBox(height: 10,),
          Text("Call us: +00 00 000000000", style: TextStyle(
            color: Colors.white,
          ),),
          SizedBox(height: 10,),
          InkWell(
            onTap: (){
              launch("mailto:services.jwa@gmail.com");
            },
            child: Text("Email us: services.jwa@gmail.com", style: TextStyle(
              color: Colors.white,
            ),),
          ),
        ],
      )
    );
  }
}



