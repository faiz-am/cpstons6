import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/tip_model.dart';

class InsightController extends GetxController {

  var isLoading = false.obs;

  var tips = <TipModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTips();
  }

  Future<void> fetchTips() async {

  try {

    isLoading.value = true;

    final url =
        'http://127.0.0.1:5000/api/tips';

    print(url);

    final response =
        await http.get(Uri.parse(url));

    print(response.statusCode);

    print(response.body);

    if (response.statusCode == 200) {

      final List<dynamic> jsonData =
          jsonDecode(response.body);

      tips.value = jsonData
          .map(
            (e) => TipModel.fromJson(e),
          )
          .toList();

      print(tips.length);
    }

  } catch (e) {

    print("ERROR:");
    print(e);

  } finally {

    isLoading.value = false;
  }
}
}