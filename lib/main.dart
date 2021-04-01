import 'package:demo_game/my_store.dart';
import 'package:demo_game/route/navigation_services.dart';
import 'package:demo_game/route/route_router.dart';
import 'package:demo_game/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:game/repository/sql_repository.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SqfliteRepository sqlRepo = new SqfliteRepository();
  await sqlRepo.initDb();
  await MyStore().init();
  await Future.delayed(Duration(milliseconds: 300));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final NavigationService navigationService = NavigationService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: MyStore().provides(),
      child: MaterialApp(
        navigatorKey: navigationService.navigationKey,
        initialRoute: ROUTE_HOME,
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
