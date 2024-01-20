import 'dart:convert';

import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_farsi_socket/pages/chat/logic.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatLogic _logic = Get.put(ChatLogic());
  var box = GetStorage();
  late var userID;

  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userID = box.read("user_id");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (_logic.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: [
              Obx(() {
                return Expanded(
                  child: ListView.builder(
                    itemCount: _logic.chatList.value.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                          left: 4,
                          right: 4,
                        ),
                        child: Directionality(
                          textDirection:
                              userID == _logic.chatList[index].user.id
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                          child: Row(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        userID == _logic.chatList[index].user.id
                                            ? Colors.red
                                            : Colors.black),
                              ),
                              BubbleSpecialThree(
                                isSender:
                                    userID == _logic.chatList[index].user.id,
                                text: _logic.chatList[index].message,
                                color: userID == _logic.chatList[index].user.id
                                    ? const Color(0xFF1B97F3)
                                    : Colors.grey,
                                tail: true,
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: TextField(
                  controller: _messageController,
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () async {
                        var messageJson = jsonEncode({
                          "user_id": userID,
                          "message": _messageController.text.trim()
                        });
                        _logic.channel.sink.add(messageJson);
                        _messageController.clear();
                        await _logic.channel.sink.done;
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.blue,
                      ),
                    ),
                    hintText: "Message....",
                    hintStyle: const TextStyle(
                      fontSize: 18,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
