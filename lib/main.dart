import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice1/src/cubit/category_cubit.dart';
import 'package:practice1/src/cubit/task_list_cubit.dart';
import 'package:practice1/src/cubit/task_stats_cubit.dart';
import 'package:practice1/src/navigation/app_router.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TaskListCubit()),
        BlocProvider(create: (_) => CategoryCubit()),
        BlocProvider(create: (_) => TaskStatsCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Трекер задач',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router,
    );
  }
}
