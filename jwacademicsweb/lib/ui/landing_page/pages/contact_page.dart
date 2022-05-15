import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jwacademicsweb/core/app_colors.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      width: double.infinity,
      padding: EdgeInsets.all(40),
      child: Column(
        children: [
          Text(
            'Contact Us',
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text("We're here to help you out with any queries you may have about JW Academics.", textAlign: TextAlign.center, style: TextStyle(
            color: Colors.white,
          ),),
          SizedBox(height: 20),
          Container(
            width: 400,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    hintText: "Full Name",
                    filled: true,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    hintText: "Email Address",
                    filled: true,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    hintText: "Type your message here",
                    filled: true,
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: (){},
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.lightSalmonColor,
                    ),
                    child: Text("Send", style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
