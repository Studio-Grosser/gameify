import 'package:flutter/material.dart';

/// Returns a value thats relative to the devices width
/// It references the device-width of the design-device (iPhone 14 Pro Max)
/// with an width of 430.0.
/// Use this function to make the UI react to the devices width.
double responsiveWidth(double defaultSize, BuildContext context,
    {double referenceDeviceWidth = 430.0}) {
  double deviceWidth = MediaQuery.of(context).size.width;
  double multiplier = defaultSize / referenceDeviceWidth;
  return deviceWidth * multiplier;
}

/// Returns a value thats relative to the devices height
/// It references the device-height of the design-device (iPhone 14 Pro Max)
/// with an height of 932.0.
/// Use this function to make the UI react to the devices height.
double responsiveHeight(double defaultSize, BuildContext context,
    {double referenceDeviceHeight = 932.0}) {
  double deviceHeight = MediaQuery.of(context).size.height;
  double multiplier = defaultSize / referenceDeviceHeight;
  return deviceHeight * multiplier;
}
