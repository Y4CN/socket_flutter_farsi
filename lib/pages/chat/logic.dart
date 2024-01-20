import 'dart:convert';

import 'package:flutter_farsi_socket/model/model.dart';
import 'package:flutter_farsi_socket/pages/util.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatLogic extends GetxController {
  RxBool isLoading = false.obs;
  late final WebSocketChannel channel;
  RxList<ChatModel> chatList = <ChatModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    connectTosocket();
  }

  connectTosocket() async {
    isLoading(true);

    channel = WebSocketChannel.connect(Uri.parse(Links.socketUrl));
    await channel.ready;
    listenToSocket();
    isLoading.value = false;
  }

  listenToSocket() {
    channel.stream.listen((event) {
      Map<String, dynamic> myJson = jsonDecode(event);
      if (myJson["status"] == true) {
        chatList.add(ChatModel.fromJson(myJson["item"]));
      }
    });
  }
}
