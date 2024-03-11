import 'package:earthworms/HomeandData/BarGraph/individual_bar.dart';

class BarData {
  final double ratAmount;
  final double toadAmount;
  final double skinkAmount;

  BarData({
    required this.ratAmount,
    required this.toadAmount,
    required this.skinkAmount,
  });

  List<IndividualBar> barData = [];

  void initalizeBarData() {
    barData = [
      IndividualBar(x: 0, y: ratAmount),
      IndividualBar(x: 1, y: toadAmount),
      IndividualBar(x: 2, y: skinkAmount)
    ];
  }
}
