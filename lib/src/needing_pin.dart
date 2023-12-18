part of flutter_newpos_sdk;

abstract class NeedingPin {
  static const needingPinList = [
    PinInfo(tagRes: '00', needPin: false),
    PinInfo(tagRes: '40', needPin: false),
    PinInfo(tagRes: '01', needPin: true),
    PinInfo(tagRes: '41', needPin: true),
    PinInfo(tagRes: '02', needPin: true),
    PinInfo(tagRes: '42', needPin: true),
    PinInfo(tagRes: '03', needPin: true),
    PinInfo(tagRes: '43', needPin: true),
    PinInfo(tagRes: '04', needPin: true),
    PinInfo(tagRes: '44', needPin: true),
    PinInfo(tagRes: '05', needPin: true),
    PinInfo(tagRes: '45', needPin: true),
    PinInfo(tagRes: '1E', needPin: false),
    PinInfo(tagRes: '5E', needPin: false),
    PinInfo(tagRes: '1F', needPin: false),
    PinInfo(tagRes: '3F', needPin: false),
  ];
}
