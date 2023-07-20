import 'package:chatbot/constants/pallete.dart';
import 'package:flutter/material.dart';

class FeatureBox extends StatelessWidget {
  final String titleText;
  final String descriptionText;
  const FeatureBox(
      {super.key, required this.titleText, required this.descriptionText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      decoration: const BoxDecoration(
          color: Pallete.firstSuggestionBoxColor,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 15, bottom: 20),
        child: Column(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              titleText,
              style: const TextStyle(
                  color: Pallete.blackColor,
                  fontFamily: "Cera Pro",
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            descriptionText,
            style: const TextStyle(
              color: Pallete.blackColor,
              fontFamily: "Cera Pro",
              fontSize: 14,
            ),
          ),
        ]),
      ),
    );
  }
}
