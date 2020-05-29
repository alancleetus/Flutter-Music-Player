import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

var myColors = {
  "primary": Color(0xff263043),
  "primary_dark": Color(0xff212531),
  "primary_light": Color(0xff054d9f),
  "accent": Color(0xff1f93e1),
  "grey_dark": Color(0xff53535e),
  "grey_light": Color(0xffb3bfcc),
  "heading": Color(0xffffffff),
  "sub_heading": Color(0xffffffff),
  "text": Color(0xffffffff),
  "icon": Color(0xffe6a12f),
  "error": Color(0xffb9120d),
  "accent_red_light": Color(0xfff5aaaa),
  "accent_red": Color(0xffdc3030),
};

TextStyle headingTextStyle = TextStyle(
  fontSize: 36.0,
  fontFamily: "SFFlorencesans",
  color: myColors["heading"],
    letterSpacing: 2.0
);

TextStyle subHeadingTextStyle = TextStyle(
    fontSize: 24.0,
    fontFamily: "SFFlorencesans",
    color: myColors["sub_heading"],
    letterSpacing: 1.0);
