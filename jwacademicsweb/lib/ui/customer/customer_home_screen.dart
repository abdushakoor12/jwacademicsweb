import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jwacademicsweb/core/app_colors.dart';
import 'package:jwacademicsweb/ui/customer/customer_side_menu.dart';
import 'package:jwacademicsweb/ui/widgets/responsive_layout.dart';

final messagesListProvider = StreamProvider.autoDispose<List<ChatMessage>>((ref){
  final user = FirebaseAuth.instance.currentUser;
  if(user == null) return Stream.empty();
  return FirebaseDatabase.instance.ref("Messages").child(user.uid).onValue
      .map<List<ChatMessage>>((event) {
    List<ChatMessage> messages = [];
    if (event.snapshot.value != null) {
      final map = event.snapshot.value as LinkedHashMap;
      map.forEach((key, value) {
        messages.add(ChatMessage.fromJson(value));
      });
    }
    return messages;
  });
});

class ChatMessage{
  final String id;
  final String message;
  final String sender;
  final bool sent;
  final int time;
  final String type;

  ChatMessage({required this.id, required this.message, required this.sender, required this.sent, required this.time, required this.type});

  factory ChatMessage.fromJson(dynamic json){
    return ChatMessage(
        id: json['id'],
        message: json['message'],
        sender: json['sender'],
        sent: json['sent'],
        time: json['time'],
        type: json['type']
    );
  }
}

final customerHomeScaffoldKey = GlobalKey<ScaffoldState>();

class CustomerHomeScreen extends HookConsumerWidget {
  const CustomerHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(messagesListProvider).asData?.value ?? [];
    final textController = useTextEditingController();
    return Scaffold(
      key: customerHomeScaffoldKey,
      backgroundColor: AppColors.primary,
      drawer:
          ResponsiveLayout.isLargeScreen(context) ? null : CustomerSideMenu(),
      body: Row(
        children: [
          if (ResponsiveLayout.isLargeScreen(context))
            Expanded(child: CustomerSideMenu()),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      if(!ResponsiveLayout.isLargeScreen(context))
                        IconButton(onPressed: (){
                          if(customerHomeScaffoldKey.currentState!.isDrawerOpen == false){
                            customerHomeScaffoldKey.currentState!.openDrawer();
                          }
                        }, icon: Icon(Icons.menu, color: Colors.white,)),
                      Spacer(),
                    ],
                  ),
                  Expanded(child: ListView.builder(itemBuilder: (context, index){
                    final ChatMessage msg = messages[index];
                    return Row(
                      children: [
                        if(msg.sent)
                          Spacer(),
                        Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          decoration: BoxDecoration(
                            color: !msg.sent ? Colors.white.withOpacity(0.5) : AppColors.lightSalmonColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(msg.message, style: TextStyle(color: !msg.sent ? Colors.white : AppColors.primary),),
                        ),
                        if(!msg.sent)
                          Spacer()
                      ],
                    );
                  }, itemCount: messages.length,)),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              controller: textController,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Your Message",
                              )),
                        ),
                        IconButton(
                            onPressed: () async {
                              final text =
                                  textController.text.toString().trim();
                              if (text.isNotEmpty) {
                                final user = FirebaseAuth.instance.currentUser;
                                textController.clear();
                                await FirebaseDatabase.instance
                                    .ref("ChatList")
                                    .child(user!.uid)
                                    .update({
                                  "lastMessage": text,
                                  "lastMessageTime":
                                      DateTime.now().millisecondsSinceEpoch,
                                  "name": user.displayName ?? "Unnamed",
                                  "uid": user.uid,
                                });

                                final pushKey =
                                    FirebaseDatabase.instance.ref().push().key;

                                Map<String, dynamic> messageMap = {};
                                messageMap['message'] = text;
                                messageMap['sender'] = user.uid;
                                messageMap['time'] =
                                    DateTime.now().millisecondsSinceEpoch;
                                messageMap['type'] = 'text';
                                messageMap['id'] = pushKey;
                                messageMap["sent"] = false;

                                await FirebaseDatabase.instance
                                    .ref("AdminMessages")
                                    .child(user.uid)
                                    .child(pushKey!)
                                    .update(messageMap);

                                messageMap["sent"] = true;

                                await FirebaseDatabase.instance
                                    .ref("Messages")
                                    .child(user.uid)
                                    .child(pushKey)
                                    .update(messageMap);
                              }
                            },
                            icon: Icon(
                              Icons.send,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
