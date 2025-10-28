import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/program_provider.dart';
import 'providers/user_provider.dart';
import 'services/data_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize data service
  final dataService = DataService();
  await dataService.loadData();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(dataService),
        ),
        ChangeNotifierProvider(
          create: (_) => ProgramProvider(dataService),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(dataService),
        ),
      ],
      child: const ExcelerateApp(),
    ),
  );
}
