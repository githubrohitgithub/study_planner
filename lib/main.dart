import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'presentation/bloc/subject/subject_bloc.dart';
import 'presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection
  final injectionContainer = InjectionContainer();
  await injectionContainer.init();
  
  runApp(StudyPlannerApp(injectionContainer: injectionContainer));
}

class StudyPlannerApp extends StatelessWidget {
  final InjectionContainer injectionContainer;
  
  const StudyPlannerApp({
    super.key,
    required this.injectionContainer,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SubjectBloc>(
          create: (context) => injectionContainer.subjectBloc,
        ),
      ],
      child: MaterialApp(
        title: 'Study Planner',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: MediaQuery.of(context).textScaler.clamp(
                minScaleFactor: 0.8,
                maxScaleFactor: 1.2,
              ),
            ),
            child: child!,
          );
        },
      ),
    );
  }
}
