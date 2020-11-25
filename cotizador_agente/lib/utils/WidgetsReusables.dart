import 'package:flutter/material.dart';

import 'AppColors.dart';

class ReusableWidgets {
  static getTextCenterTitle(String text) {
    return Container(
        height: 40,
        margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Roboto',
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.normal,
              fontSize: 24.0,
              color: AppColors.primary700),
        ));
  }

  static getTextCenterBienvenido(String text) {
    return Container(
        height: 64,
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Roboto',
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              fontSize: 24.0,
              color: AppColors.primary700),
        ));
  }

  static getTextUnderlineOrangeBody(String text) {
    return Text(text,
        style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16.0,
            decoration: TextDecoration.underline,
            letterSpacing: 0.5,
            fontWeight: FontWeight.normal,
            color: AppColors.secondary900));
  }

  static getTextCenterBody(String message) {
    return Container(
        margin: const EdgeInsets.all(5.0),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Roboto-Bold',
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
              color: AppColors.color_appBar),
        ));
  }
}
