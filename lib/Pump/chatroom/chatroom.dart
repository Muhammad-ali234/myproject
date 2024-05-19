import 'package:flutter/material.dart';
import 'package:myproject/Common/chat_roam.dart';
import 'package:myproject/Common/constant.dart';
import 'package:myproject/Pump/common/screens/app_drawer.dart';
import 'package:myproject/Pump/common/screens/drawer_meue_item.dart';
import 'package:myproject/Pump/common/screens/sidebar.dart';
import 'package:myproject/Pump/common/widgets/sidebar_menue_item.dart';

class PumpChatScreen extends StatelessWidget {
  const PumpChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColor
              .dashbordWhiteColor, // Change the color of the back icon here
        ),
        title: Text(
          'Pump Chat Room',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColor.dashbordWhiteColor),
        ),
        centerTitle: true,
        backgroundColor: AppColor.dashbordBlueColor,
      ),
      drawer: MediaQuery.of(context).size.width < 600
          ? AppDrawer(
              username: 'Petrol Pump Station 1',
              drawerItems: getDrawerMenuItems(context),
            )
          : null,
      body: Row(
        children: [
          if (width >= 700)
            SideBar(
              menuItems: getMenuItems(context),
            ),
          ChatScreen(
            name: 'Pump',
          ),
        ],
      ),
    );
  }
}
