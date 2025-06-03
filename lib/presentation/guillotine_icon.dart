import 'dart:ui' as ui;
import 'package:flutter/material.dart';

// This is from medium article
//https://medium.com/@kamranzafar128/flutter-performance-tip-how-to-use-svg-assets-as-a-pro-developer-d2ccb962d958

//Copy this CustomPainter code to the Bottom of the File
class GuillotineIcon extends CustomPainter {
  final Color? color;
  // update constructor name according to your class name
  const GuillotineIcon({this.color});

  static Size s(double w) => Size(w, w);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = color ?? Color(0xffFFA81E).withOpacity(1.0);
    canvas.drawRect(
        Rect.fromLTWH(
            size.width * 0.1394065, size.height * 0.1080861, size.width * 0.07328530, size.height * 0.8743728),
        paint_0_fill);

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = color ?? Color(0xffFFA81E).withOpacity(1.0);
    canvas.drawRect(
        Rect.fromLTWH(
            size.width * 0.7806578, size.height * 0.1080861, size.width * 0.07328530, size.height * 0.8743728),
        paint_1_fill);

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = color ?? Color(0xffFFA81E).withOpacity(1.0);
    canvas.drawRect(
        Rect.fromLTWH(
            size.width * 0.1077326, size.height * 0.01753128, size.width * 0.7914137, size.height * 0.09055877),
        paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(size.width * 0.6558040, size.height * 0.3583210);
    path_3.lineTo(size.width * 0.3162135, size.height * 0.4790654);
    path_3.lineTo(size.width * 0.3162135, size.height * 0.2556900);
    path_3.lineTo(size.width * 0.6558040, size.height * 0.2556900);
    path_3.close();

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = color ?? Color(0xffF8F8F8).withOpacity(1.0);
    canvas.drawPath(path_3, paint_3_fill);

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.color = color ?? Color(0xffE1E1E4).withOpacity(1.0);
    canvas.drawRect(
        Rect.fromLTWH(
            size.width * 0.3162155, size.height * 0.2557017, size.width * 0.3395944, size.height * 0.04504110),
        paint_4_fill);

    Path path_5 = Path();
    path_5.moveTo(size.width * 0.3162135, size.height * 0.4790654);
    path_5.lineTo(size.width * 0.6558060, size.height * 0.3583210);
    path_5.lineTo(size.width * 0.6558060, size.height * 0.2987760);
    path_5.lineTo(size.width * 0.3162135, size.height * 0.4195184);
    path_5.close();

    Paint paint_5_fill = Paint()..style = PaintingStyle.fill;
    paint_5_fill.color = color ?? Color(0xffFFFFFF).withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_fill);

    Path path_6 = Path();
    path_6.moveTo(size.width * 0.5906789, size.height * 0.7848785);
    path_6.cubicTo(size.width * 0.5906867, size.height * 0.7853511, size.width * 0.5908137, size.height * 0.7857886,
        size.width * 0.5908137, size.height * 0.7862633);
    path_6.cubicTo(size.width * 0.5908137, size.height * 0.8379430, size.width * 0.5486651, size.height * 0.8798396,
        size.width * 0.4966748, size.height * 0.8798396);
    path_6.cubicTo(size.width * 0.4446884, size.height * 0.8798396, size.width * 0.4025359, size.height * 0.8379450,
        size.width * 0.4025359, size.height * 0.7862633);
    path_6.cubicTo(size.width * 0.4025359, size.height * 0.7857886, size.width * 0.4026707, size.height * 0.7853511,
        size.width * 0.4026785, size.height * 0.7848785);
    path_6.lineTo(size.width * 0.2127387, size.height * 0.7848785);
    path_6.lineTo(size.width * 0.2127387, size.height * 0.9824687);
    path_6.lineTo(size.width * 0.7806109, size.height * 0.9824687);
    path_6.lineTo(size.width * 0.7806109, size.height * 0.7848785);
    path_6.lineTo(size.width * 0.5906789, size.height * 0.7848785);
    path_6.close();

    Paint paint_6_fill = Paint()..style = PaintingStyle.fill;
    paint_6_fill.color = color ?? Color(0xffFFD92D).withOpacity(1.0);
    canvas.drawPath(path_6, paint_6_fill);

    Path path_7 = Path();
    path_7.moveTo(size.width * 0.4026707, size.height * 0.7852574);
    path_7.cubicTo(size.width * 0.4026629, size.height * 0.7847847, size.width * 0.4025359, size.height * 0.7843472,
        size.width * 0.4025359, size.height * 0.7838726);
    path_7.cubicTo(size.width * 0.4025359, size.height * 0.7321928, size.width * 0.4446845, size.height * 0.6902963,
        size.width * 0.4966748, size.height * 0.6902963);
    path_7.cubicTo(size.width * 0.5486612, size.height * 0.6902963, size.width * 0.5908137, size.height * 0.7321909,
        size.width * 0.5908137, size.height * 0.7838726);
    path_7.cubicTo(size.width * 0.5908137, size.height * 0.7843472, size.width * 0.5906789, size.height * 0.7847847,
        size.width * 0.5906711, size.height * 0.7852574);
    path_7.lineTo(size.width * 0.7806109, size.height * 0.7852574);
    path_7.lineTo(size.width * 0.7806109, size.height * 0.5876652);
    path_7.lineTo(size.width * 0.2127387, size.height * 0.5876652);
    path_7.lineTo(size.width * 0.2127387, size.height * 0.7852554);
    path_7.lineTo(size.width * 0.4026707, size.height * 0.7852554);
    path_7.close();

    Paint paint_7_fill = Paint()..style = PaintingStyle.fill;
    paint_7_fill.color = color ?? Color(0xffFFA81E).withOpacity(1.0);
    canvas.drawPath(path_7, paint_7_fill);

    Path path_8 = Path();
    path_8.moveTo(size.width * 0.8957029, 0);
    path_8.lineTo(size.width * 0.1042912, 0);
    path_8.cubicTo(size.width * 0.09460761, 0, size.width * 0.08675994, size.height * 0.007847672,
        size.width * 0.08675994, size.height * 0.01753128);
    path_8.lineTo(size.width * 0.08675994, size.height * 0.1080901);
    path_8.cubicTo(size.width * 0.08675994, size.height * 0.1177737, size.width * 0.09460761, size.height * 0.1256213,
        size.width * 0.1042912, size.height * 0.1256213);
    path_8.lineTo(size.width * 0.1218674, size.height * 0.1256213);
    path_8.lineTo(size.width * 0.1218674, size.height * 0.9824687);
    path_8.cubicTo(size.width * 0.1218674, size.height * 0.9921523, size.width * 0.1297151, size.height * 1.000000,
        size.width * 0.1393987, size.height * 1.000000);
    path_8.lineTo(size.width * 0.2126840, size.height * 1.000000);
    path_8.cubicTo(size.width * 0.2128598, size.height * 1.000000, size.width * 0.2130317, size.height * 0.9999785,
        size.width * 0.2132074, size.height * 0.9999746);
    path_8.cubicTo(size.width * 0.2133832, size.height * 0.9999785, size.width * 0.2135532, size.height * 1.000000,
        size.width * 0.2137309, size.height * 1.000000);
    path_8.lineTo(size.width * 0.7782027, size.height * 1.000000);
    path_8.cubicTo(size.width * 0.7786168, size.height * 1.000000, size.width * 0.7790230, size.height * 0.9999668,
        size.width * 0.7794293, size.height * 0.9999395);
    path_8.cubicTo(size.width * 0.7798355, size.height * 0.9999668, size.width * 0.7802418, size.height * 1.000000,
        size.width * 0.7806558, size.height * 1.000000);
    path_8.lineTo(size.width * 0.8539431, size.height * 1.000000);
    path_8.cubicTo(size.width * 0.8636267, size.height * 1.000000, size.width * 0.8714744, size.height * 0.9921523,
        size.width * 0.8714744, size.height * 0.9824687);
    path_8.lineTo(size.width * 0.8714744, size.height * 0.5412960);
    path_8.cubicTo(size.width * 0.8714744, size.height * 0.5316124, size.width * 0.8636267, size.height * 0.5237647,
        size.width * 0.8539431, size.height * 0.5237647);
    path_8.cubicTo(size.width * 0.8442595, size.height * 0.5237647, size.width * 0.8364118, size.height * 0.5316124,
        size.width * 0.8364118, size.height * 0.5412960);
    path_8.lineTo(size.width * 0.8364118, size.height * 0.9649355);
    path_8.lineTo(size.width * 0.7981871, size.height * 0.9649355);
    path_8.lineTo(size.width * 0.7981871, size.height * 0.1275178);
    path_8.lineTo(size.width * 0.8364118, size.height * 0.1275178);
    path_8.lineTo(size.width * 0.8364118, size.height * 0.2888463);
    path_8.cubicTo(size.width * 0.8364118, size.height * 0.2985299, size.width * 0.8442595, size.height * 0.3063776,
        size.width * 0.8539431, size.height * 0.3063776);
    path_8.cubicTo(size.width * 0.8636267, size.height * 0.3063776, size.width * 0.8714744, size.height * 0.2985299,
        size.width * 0.8714744, size.height * 0.2888463);
    path_8.lineTo(size.width * 0.8714744, size.height * 0.1256213);
    path_8.lineTo(size.width * 0.8957049, size.height * 0.1256213);
    path_8.cubicTo(size.width * 0.9053885, size.height * 0.1256213, size.width * 0.9132362, size.height * 0.1177737,
        size.width * 0.9132362, size.height * 0.1080901);
    path_8.lineTo(size.width * 0.9132362, size.height * 0.01753128);
    path_8.cubicTo(
        size.width * 0.9132342, size.height * 0.007847672, size.width * 0.9053865, 0, size.width * 0.8957029, 0);
    path_8.close();
    path_8.moveTo(size.width * 0.6394153, size.height * 0.2732212);
    path_8.lineTo(size.width * 0.6394153, size.height * 0.3459479);
    path_8.lineTo(size.width * 0.3348874, size.height * 0.4542216);
    path_8.lineTo(size.width * 0.3348874, size.height * 0.2732173);
    path_8.lineTo(size.width * 0.6394153, size.height * 0.2732173);
    path_8.lineTo(size.width * 0.6394153, size.height * 0.2732212);
    path_8.close();
    path_8.moveTo(size.width * 0.3173561, size.height * 0.2381587);
    path_8.cubicTo(size.width * 0.3076725, size.height * 0.2381587, size.width * 0.2998248, size.height * 0.2460063,
        size.width * 0.2998248, size.height * 0.2556900);
    path_8.lineTo(size.width * 0.2998248, size.height * 0.4790654);
    path_8.cubicTo(size.width * 0.2998248, size.height * 0.4847646, size.width * 0.3025943, size.height * 0.4901064,
        size.width * 0.3072486, size.height * 0.4933896);
    path_8.cubicTo(size.width * 0.3102447, size.height * 0.4955029, size.width * 0.3137838, size.height * 0.4965967,
        size.width * 0.3173580, size.height * 0.4965967);
    path_8.cubicTo(size.width * 0.3193327, size.height * 0.4965967, size.width * 0.3213170, size.height * 0.4962627,
        size.width * 0.3232291, size.height * 0.4955830);
    path_8.lineTo(size.width * 0.6628197, size.height * 0.3748406);
    path_8.cubicTo(size.width * 0.6698079, size.height * 0.3723562, size.width * 0.6744759, size.height * 0.3657409,
        size.width * 0.6744759, size.height * 0.3583230);
    path_8.lineTo(size.width * 0.6744759, size.height * 0.2556919);
    path_8.cubicTo(size.width * 0.6744759, size.height * 0.2460083, size.width * 0.6666283, size.height * 0.2381606,
        size.width * 0.6569446, size.height * 0.2381606);
    path_8.lineTo(size.width * 0.5014111, size.height * 0.2381606);
    path_8.lineTo(size.width * 0.5014111, size.height * 0.1957035);
    path_8.lineTo(size.width * 0.7631206, size.height * 0.1955863);
    path_8.lineTo(size.width * 0.7631206, size.height * 0.5701320);
    path_8.lineTo(size.width * 0.2302133, size.height * 0.5701320);
    path_8.lineTo(size.width * 0.2302133, size.height * 0.1958285);
    path_8.lineTo(size.width * 0.4663525, size.height * 0.1957230);
    path_8.lineTo(size.width * 0.4663525, size.height * 0.2381606);
    path_8.lineTo(size.width * 0.3173561, size.height * 0.2381606);
    path_8.lineTo(size.width * 0.3173561, size.height * 0.2381587);
    path_8.close();
    path_8.moveTo(size.width * 0.4200067, size.height * 0.7863179);
    path_8.cubicTo(size.width * 0.4200340, size.height * 0.7859527, size.width * 0.4200536, size.height * 0.7855582,
        size.width * 0.4200614, size.height * 0.7851324);
    path_8.cubicTo(size.width * 0.4200731, size.height * 0.7843726, size.width * 0.4200164, size.height * 0.7836226,
        size.width * 0.4199305, size.height * 0.7828765);
    path_8.cubicTo(size.width * 0.4204657, size.height * 0.7414018, size.width * 0.4543661, size.height * 0.7078276,
        size.width * 0.4959678, size.height * 0.7078276);
    path_8.cubicTo(size.width * 0.5375753, size.height * 0.7078276, size.width * 0.5714816, size.height * 0.7414175,
        size.width * 0.5720050, size.height * 0.7829058);
    path_8.cubicTo(size.width * 0.5719699, size.height * 0.7832066, size.width * 0.5719445, size.height * 0.7835113,
        size.width * 0.5719249, size.height * 0.7838160);
    path_8.cubicTo(size.width * 0.5718996, size.height * 0.7841812, size.width * 0.5718781, size.height * 0.7845758,
        size.width * 0.5718703, size.height * 0.7850035);
    path_8.cubicTo(size.width * 0.5718585, size.height * 0.7857633, size.width * 0.5719152, size.height * 0.7865133,
        size.width * 0.5720011, size.height * 0.7872594);
    path_8.cubicTo(size.width * 0.5714660, size.height * 0.8287340, size.width * 0.5375655, size.height * 0.8623083,
        size.width * 0.4959658, size.height * 0.8623083);
    path_8.cubicTo(size.width * 0.4543583, size.height * 0.8623083, size.width * 0.4204500, size.height * 0.8287184,
        size.width * 0.4199266, size.height * 0.7872301);
    path_8.cubicTo(size.width * 0.4199598, size.height * 0.7869254, size.width * 0.4199871, size.height * 0.7866246,
        size.width * 0.4200067, size.height * 0.7863179);
    path_8.close();
    path_8.moveTo(size.width * 0.4959639, size.height * 0.6727650);
    path_8.cubicTo(size.width * 0.4403114, size.height * 0.6727650, size.width * 0.3940945, size.height * 0.7138920,
        size.width * 0.3860906, size.height * 0.7673472);
    path_8.lineTo(size.width * 0.2312583, size.height * 0.7673472);
    path_8.lineTo(size.width * 0.2312583, size.height * 0.6051965);
    path_8.lineTo(size.width * 0.7606655, size.height * 0.6051965);
    path_8.lineTo(size.width * 0.7606655, size.height * 0.7673472);
    path_8.lineTo(size.width * 0.6058332, size.height * 0.7673472);
    path_8.cubicTo(size.width * 0.5978312, size.height * 0.7138901, size.width * 0.5516144, size.height * 0.6727650,
        size.width * 0.4959639, size.height * 0.6727650);
    path_8.close();
    path_8.moveTo(size.width * 0.1951508, size.height * 0.9649394);
    path_8.lineTo(size.width * 0.1569280, size.height * 0.9649394);
    path_8.lineTo(size.width * 0.1569280, size.height * 0.1275178);
    path_8.lineTo(size.width * 0.1951508, size.height * 0.1275178);
    path_8.lineTo(size.width * 0.1951508, size.height * 0.9649394);
    path_8.close();
    path_8.moveTo(size.width * 0.2312583, size.height * 0.9649394);
    path_8.lineTo(size.width * 0.2312583, size.height * 0.8027887);
    path_8.lineTo(size.width * 0.3860906, size.height * 0.8027887);
    path_8.cubicTo(size.width * 0.3940945, size.height * 0.8562458, size.width * 0.4403114, size.height * 0.8973709,
        size.width * 0.4959639, size.height * 0.8973709);
    path_8.cubicTo(size.width * 0.5516124, size.height * 0.8973709, size.width * 0.5978312, size.height * 0.8562439,
        size.width * 0.6058332, size.height * 0.8027887);
    path_8.lineTo(size.width * 0.7606655, size.height * 0.8027887);
    path_8.lineTo(size.width * 0.7606655, size.height * 0.9649394);
    path_8.lineTo(size.width * 0.2312583, size.height * 0.9649394);
    path_8.close();
    path_8.moveTo(size.width * 0.7631206, size.height * 0.1605238);
    path_8.lineTo(size.width * 0.2302133, size.height * 0.1607640);
    path_8.lineTo(size.width * 0.2302133, size.height * 0.1256213);
    path_8.lineTo(size.width * 0.7631206, size.height * 0.1256213);
    path_8.lineTo(size.width * 0.7631206, size.height * 0.1605238);
    path_8.close();
    path_8.moveTo(size.width * 0.8781716, size.height * 0.09055877);
    path_8.lineTo(size.width * 0.1218225, size.height * 0.09055877);
    path_8.lineTo(size.width * 0.1218225, size.height * 0.03506257);
    path_8.lineTo(size.width * 0.8781716, size.height * 0.03506257);
    path_8.lineTo(size.width * 0.8781716, size.height * 0.09055877);
    path_8.close();

    Paint paint_8_fill = Paint()..style = PaintingStyle.fill;
    paint_8_fill.color = color ?? Color(0xff1C2042).withOpacity(1.0);
    canvas.drawPath(path_8, paint_8_fill);

    Path path_9 = Path();
    path_9.moveTo(size.width * 0.8539411, size.height * 0.3585808);
    path_9.cubicTo(size.width * 0.8442575, size.height * 0.3585808, size.width * 0.8364098, size.height * 0.3664285,
        size.width * 0.8364098, size.height * 0.3761121);
    path_9.lineTo(size.width * 0.8364098, size.height * 0.3994871);
    path_9.cubicTo(size.width * 0.8364098, size.height * 0.4091707, size.width * 0.8442575, size.height * 0.4170184,
        size.width * 0.8539411, size.height * 0.4170184);
    path_9.cubicTo(size.width * 0.8636247, size.height * 0.4170184, size.width * 0.8714724, size.height * 0.4091707,
        size.width * 0.8714724, size.height * 0.3994871);
    path_9.lineTo(size.width * 0.8714724, size.height * 0.3761121);
    path_9.cubicTo(size.width * 0.8714724, size.height * 0.3664285, size.width * 0.8636228, size.height * 0.3585808,
        size.width * 0.8539411, size.height * 0.3585808);
    path_9.close();

    Paint paint_9_fill = Paint()..style = PaintingStyle.fill;
    paint_9_fill.color = color ?? Color(0xff1C2042).withOpacity(1.0);
    canvas.drawPath(path_9, paint_9_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
