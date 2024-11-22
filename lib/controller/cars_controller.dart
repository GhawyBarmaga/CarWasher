import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CarsController extends GetxController {

  @override
  void onInit() {
    getCars();
    super.onInit();
  }
  final cars = Hive.box('cars');
  List<Map<String, dynamic>> carsList = [];
  void getCars() {
    carsList.clear();
    final data = cars.keys.map((key) {
      final value = cars.get(key);
      return {
        'id': key,
        'name': value['name'],
        'licence': value['licence'],
        'service': value['service'],
        'notes': value['notes'],
        'entryDate': value['entryDate'],
        'exitDate': value['exitDate'],
      };
    }).toList();
   
      carsList = data;
      update();
  }

  void updateExitdatewithId(int id)async {
    final car =await cars.get(id);
    car['exitDate'] = DateTime.now();
    cars.put(id, car);
    getCars();
    update();
  }

}