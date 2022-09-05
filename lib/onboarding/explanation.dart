import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ExplanationData {
  final String title;
  final String description;
  final String localImageSrc;
  final Color backgroundColor;

  ExplanationData(
      {required this.title,
      required this.description,
      required this.localImageSrc,
      required this.backgroundColor});
}

class ExplanationPage extends StatelessWidget {
  final ExplanationData data;

  ExplanationPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
                margin: const EdgeInsets.only(top: 24, bottom: 7),
                child: SvgPicture.asset(data.localImageSrc,
                    height: MediaQuery.of(context).size.height * 0.331,
                    alignment: Alignment.center)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultTextStyle(
                  child: Text(
                    data.title,
                    textAlign: TextAlign.center,
                  ),
                  style: const TextStyle(
                      color: Color.fromRGBO(13, 31, 60, 1),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Titillium_Web',
                      fontSize: 48.7),
                ),
              ],
            ),
            const SizedBox(
              height: 7,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: DefaultTextStyle(
                    child: Text(
                      data.description,
                      style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.center,
                      
                    ),
                    style: const TextStyle(color: Color(0xFF3D4C63)),
                  ),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}
