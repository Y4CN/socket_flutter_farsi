import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_farsi_socket/model/model.dart';
import 'package:flutter_farsi_socket/pages/util.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';

import '../chat/view.dart';

class LoginLogic extends GetxController {
  final box = GetStorage();
  RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final userId = box.read("user_id");
    if (userId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAll(() => const ChatPage());
      });
    }
  }

  login(String name) async {
    loading.value = true;

    FormData _formData = FormData.fromMap({
      "name": name,
    });
    var response =
        await Dio().post("${Links.host}user/newuser", data: _formData);

    if (response.data["status"] == true) {
      box.write("user_id", response.data["item"]["ID"]);
      UserModel userModel = UserModel.fromJson(response.data["item"]);
      Get.offAll(() => const ChatPage());
    }

    loading(false);
  }
}
