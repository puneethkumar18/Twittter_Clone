import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/features/auth/controller/authapi_controller.dart';
import 'package:twitter_clone/features/notifications/controller/controller/notification_controller.dart';
import 'package:twitter_clone/features/notifications/widgets/notification_tile.dart';
import 'package:twitter_clone/models/notification_model.dart' as model;


class NotificationView extends ConsumerWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: currentUser == null ? 
      const Loader():
       ref.watch(getNotificationsProvider(currentUser.uid)).
    when(
      data: (notifications){
        return ref.watch(getLatestNOtificatiionProvider).
        when(
          data: (data){
              
              if(data.events.contains(
              'databases.*.${AppwriteConstants.databaseId}.collections.*.${AppwriteConstants.notificationsCollection}.documents.*.create'
            )){
              final latestNotification = model.Notification.fromMap(data.payload);
              if(latestNotification.uid == currentUser.uid){
                  notifications.insert(0, latestNotification);
              }
              
            }            
            
            return ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (BuildContext context ,int index){
            final notification = notifications[index];
            return NotificationTile(notification: notification);
                    });
          }, 
          error: (e,st){
            return ErorrText(erorrtext: e.toString());
            }, 
            loading: () {
              return ListView.builder(
                        itemCount: notifications.length,
                      itemBuilder: (BuildContext context ,int index){
                      final notification = notifications[index];
                      return NotificationTile(
                        notification: notification);
                        });
            },
            );
      },
      error: (e,st) => ErorrText(erorrtext: e.toString()), 
      loading: ()=> const Loader(),
   
  
      
      ),
    );
  }
}