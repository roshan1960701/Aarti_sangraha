import 'package:flutter/material.dart';

class SliderModel {
  String imageAssetPath;
  String title;
  String desc;

  SliderModel({this.imageAssetPath, this.title, this.desc});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String getImageAssetPath() {
    return imageAssetPath;
  }

  String getTitle() {
    return title;
  }

  String getDesc() {
    return desc;
  }
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = new List<SliderModel>();
  SliderModel sliderModel = new SliderModel();

  //1
  sliderModel.setDesc("");
  sliderModel.setTitle(
      "|| वक्रतुंड महाकाय सूर्य कोटी समप्रभ, निर्विग्नहं कुरु मे दैव सर्व कार्येषु सर्वदा ||");
  sliderModel.setImageAssetPath("asset/images/ganesha.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //2
  sliderModel.setDesc("");
  sliderModel.setTitle(
      "|| जय श्री कृष्ण जो आहे माखन चोर, जो आहे मुरलीधर, तो च आहे आपल्या सर्वांचा तारणहार ||");
  sliderModel.setImageAssetPath("asset/images/krishna.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //3
  sliderModel.setDesc("");
  sliderModel.setTitle("|| ॐ नमः शिवाय ||");
  sliderModel.setImageAssetPath("asset/images/shiva.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  return slides;
}
