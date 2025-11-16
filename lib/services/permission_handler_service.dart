import 'package:permission_handler/permission_handler.dart';

Future<void> requestNotiPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}
