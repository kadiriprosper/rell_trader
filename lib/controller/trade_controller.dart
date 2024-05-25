import 'package:get/get.dart';

class TradeController extends GetxController {
  Rx<double> _selectedMaximumRisk = 1.45.obs;

  double get selectedMaximumRisk => _selectedMaximumRisk.value;

  set selectedMaximumRisk(double maxRisk) {
    _selectedMaximumRisk.value = maxRisk;
  }
}
