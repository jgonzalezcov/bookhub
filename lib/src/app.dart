import 'package:bookhub/src/providers/books_provider.dart';
import 'package:bookhub/src/providers/view_state_provider.dart';
import 'package:bookhub/src/routers/app.routes.dart';
import 'package:bookhub/src/screens/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ViewStateProvider()),
        ChangeNotifierProvider(create: (_) => BooksProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.initialRouter,
        routes: AppRoutes.routes,
        title: 'BookHub',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        home: const MainScreen(),
      ),
    );
  }
}
