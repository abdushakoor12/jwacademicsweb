import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/app_colors.dart';
import '../customer/customer_home_screen.dart';
import '../widgets/responsive_layout.dart';
import 'admin_side_menu.dart';

final chatListProvider = StreamProvider.autoDispose<List<Chat>>((ref){
  final user = FirebaseAuth.instance.currentUser;
  if(user == null) return Stream.empty();
  return FirebaseDatabase.instance.ref("ChatList").onValue
      .map<List<Chat>>((event) {
    List<Chat> messages = [];
    if (event.snapshot.value != null) {
      final map = event.snapshot.value as LinkedHashMap;
      map.forEach((key, value) {
        messages.add(Chat.fromJson(value));
      });
    }
    return messages;
  });
});

class Chat{
  final String lastMessage;
  final int lastMessageTime;
  final String name;
  final String uid;

  const Chat({required this.lastMessage,
    required this.lastMessageTime,
    required this.name,
    required this.uid,
  });

  factory Chat.fromJson(Map<String, dynamic> json){
    return Chat(
      lastMessage: json['lastMessage'],
      lastMessageTime: json['lastMessageTime'],
      name: json['name'],
      uid: json['uid'],
    );
  }
}

final customerMessagesListProvider = StreamProvider.autoDispose.family<List<ChatMessage>, String>((ref, customerId){
  if(customerId.isEmpty) return Stream.empty();
  return FirebaseDatabase.instance.ref("AdminMessages").child(customerId).onValue
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

final adminHomeScaffoldKey = GlobalKey<ScaffoldState>();

class AdminHomeScreen extends HookConsumerWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final messages = ref.watch(messagesListProvider).asData?.value ?? [];
    final selectedCustomer = useState<String?>(null);
    final chatsValue = ref.watch(chatListProvider);
    print(chatsValue);
    final chats = chatsValue.asData?.value ?? [];

    return Scaffold(
      key: adminHomeScaffoldKey,
      backgroundColor: AppColors.primary,
      drawer:
      ResponsiveLayout.isLargeScreen(context) ? null : AdminSideMenu(),
      body: Row(
        children: [
          if (ResponsiveLayout.isLargeScreen(context))
            Expanded(child: AdminSideMenu()),
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
                          if(adminHomeScaffoldKey.currentState!.isDrawerOpen == false){
                            adminHomeScaffoldKey.currentState!.openDrawer();
                          }
                        }, icon: Icon(Icons.menu, color: Colors.white,)),
                      Spacer(),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: ListView.builder(itemBuilder: (context, index){
                          final chat = chats[index];
                          return ListTile(
                            onTap: (){
                              selectedCustomer.value = chat.uid;
                            },
                            title: Text(chat.name, style: TextStyle(color: Colors.white, fontSize: 20),),
                            subtitle: Text(chat.lastMessage, style: TextStyle(color: Colors.white, fontSize: 15),),
                            trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.white,),
                          );
                        }, itemCount: chats.length,)),
                        if(selectedCustomer.value == null)
                          Spacer(flex: 2,),
                        if(selectedCustomer.value != null)
                          Expanded(
                              flex: 2,
                              child: SingleChatView(selectedCustomer.value!))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SingleChatView extends HookConsumerWidget {
  final String customerId;
  const SingleChatView(this.customerId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(customerMessagesListProvider(customerId)).asData?.value ?? [];
    final textController = useTextEditingController();
    return Column(
      children: [
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
                          .child(customerId)
                          .update({
                        "lastMessage": text,
                        "lastMessageTime":
                        DateTime.now().millisecondsSinceEpoch,
                        // "name": "Admin",
                        // "uid": user?.uid,
                      });

                      final pushKey =
                          FirebaseDatabase.instance.ref().push().key;

                      Map<String, dynamic> messageMap = {};
                      messageMap['message'] = text;
                      messageMap['sender'] = user!.uid;
                      messageMap['time'] =
                          DateTime.now().millisecondsSinceEpoch;
                      messageMap['type'] = 'text';
                      messageMap['id'] = pushKey;
                      messageMap["sent"] = true;

                      await FirebaseDatabase.instance
                          .ref("AdminMessages")
                          .child(customerId)
                          .child(pushKey!)
                          .update(messageMap);

                      messageMap["sent"] = false;

                      await FirebaseDatabase.instance
                          .ref("Messages")
                          .child(customerId)
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
    );
  }
}

