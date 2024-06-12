import 'package:flutter/material.dart';
import 'package:myproject/Dashboared/Chat%20room/dashbored_chat.dart';
import 'package:myproject/Dashboared/Dashboared/Screens/Home_screen.dart';
import 'package:myproject/Pump/Employee%20screen/employee_screen.dart';
import 'package:myproject/Pump/Expense/Screens/daily_expense.dart';
import 'package:myproject/Pump/Customer/customer_screen.dart';
import 'package:myproject/Authentication/login_screen.dart';
import 'package:myproject/Pump/Daily_Overview/Screens/daily_overview.dart';
import 'package:myproject/Pump/chatroom/chatroom.dart';
import 'package:myproject/Pump/pump_dashboared_screen.dart';
import 'package:myproject/Pump/Stocks/Screens/stocks_screen.dart';
import 'package:myproject/Authentication/resgisteration_screen.dart';
import 'package:myproject/Pump/Credit_Debit/Screens/main_screen.dart';

class AppRoutes {
  static const String initialRoute = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboardOwnerScreen = '/dashboardOwnerScreen';
  static const String stock = '/stock';
  static const String dailyExpense = '/daily_expense';
  static const String creditDebit = '/credit_debit';
  static const String dailyOverview = '/daily_overview';
  static const String dashboardPumpScreen = '/dashboardPumpScreen';
  static const String customerScreen = '/customerScreen';
  static const String chatScreen = '/chatScreen';
  static const String pumpChatScreen = '/pumpchatScreen';
  static const String employeeDutyScreen = '/employeeDuty';

  static Map<String, WidgetBuilder> routes = {
    initialRoute: (context) =>
        //const RegistrationScreen(),
        //const EmployeeScreen(),
        // const ChatScreen(),
        //   DashboardOwnerScreen(),
        //  const SplashScreen(),
        PumpDashboardScreen(context: context),
    login: (context) => const LoginScreen(),
    register: (context) => const RegistrationScreen(),
    dashboardOwnerScreen: (context) => const DashboardOwnerScreen(),
    stock: (context) => const StocksScreen(),
    dailyExpense: (context) => DailyExpenseScreen(context: context),
    creditDebit: (context) => CreditDebit(context: context),
    dailyOverview: (context) => const DailyOverviewScreen(),
    dashboardPumpScreen: (context) => PumpDashboardScreen(context: context),
    customerScreen: (context) => CustomerScreen(context: context),
    chatScreen: (context) => const DashbordChat(),
    pumpChatScreen: (context) => const PumpChatScreen(),
    employeeDutyScreen: (context) => const EmployeeDutiesScreen()
  };
}
