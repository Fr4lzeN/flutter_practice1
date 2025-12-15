import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice1/src/cubit/category_cubit.dart';
import 'package:practice1/src/cubit/task_list_cubit.dart';
import 'package:practice1/src/cubit/task_stats_cubit.dart';
import 'package:practice1/src/navigation/app_router.dart';
import 'package:practice1/src/settings/settings.dart';
import 'package:practice1/src/tags/tags.dart';
import 'package:practice1/src/subtasks/subtasks.dart';
import 'package:practice1/src/profile/profile.dart';
import 'package:practice1/src/reminders/reminders.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TaskListCubit()),
        BlocProvider(create: (_) => CategoryCubit()),
        BlocProvider(create: (_) => TaskStatsCubit()),
        BlocProvider(create: (_) => SettingsCubit()),
        BlocProvider(create: (_) => TagCubit()),
        BlocProvider(create: (_) => SubtaskCubit()),
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => ReminderCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, AppSettings>(
      builder: (context, settings) {
        return MaterialApp.router(
          title: 'Трекер задач',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          themeMode: settings.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
