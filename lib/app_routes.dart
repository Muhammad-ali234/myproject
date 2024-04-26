import 'package:flutter/material.dart';
import 'package:myproject/Dashboared/Home_screen.dart';
import 'package:myproject/Pump/Expense/Screens/daily_expense.dart';
import 'package:myproject/Pump/Customer/customer_screen.dart';
import 'package:myproject/Authentication/login_screen.dart';
import 'package:myproject/Pump/Daily_Overview/Screens/daily_overview.dart';
import 'package:myproject/Pump/pump_dashboared_screen.dart';
import 'package:myproject/Pump/Stocks/Screens/stocks_screen.dart';
import 'package:myproject/Authentication/resgisteration_screen.dart';
import 'package:myproject/Authentication/splash_screen.dart';
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

  static Map<String, WidgetBuilder> routes = {
    initialRoute: (context) => DashboardOwnerScreen(),
    //    const SplashScreen(),
    // PumpDashboardScreen(context: context),
    login: (context) => const LoginScreen(),
    register: (context) => const RegistrationScreen(),
    dashboardOwnerScreen: (context) => DashboardOwnerScreen(),
    stock: (context) => const StocksScreen(),
    dailyExpense: (context) => DailyExpenseScreen(context: context),
    creditDebit: (context) => CreditDebit(context: context),
    dailyOverview: (context) =>
        DailyOverviewScreen(users: const [], context: context),
    dashboardPumpScreen: (context) => PumpDashboardScreen(context: context),
    customerScreen: (context) => CustomerScreen(context: context),
  };
}
