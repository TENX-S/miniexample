import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:window_manager/window_manager.dart';
import 'package:path_provider/path_provider.dart';

import 'settings/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WindowManager.instance.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationSupportDirectory());

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (_) => SettingsCubit(),
      child: BlocBuilder<SettingsCubit, Settings>(
        // buildWhen: (prev, curr) {
        //   print('prev: ${prev.alwaysOnTop}');
        //   print('curr: ${curr.alwaysOnTop}');
        //   return prev != curr;
        // },
        builder: (context, settings) {
          print('build ${settings.alwaysOnTop}');
          return MaterialApp(
            title: 'Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: HomePage(pinned: settings.alwaysOnTop),
          );
        }
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.pinned});

  final bool pinned;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WindowListener {
  @override
  void initState() {
    windowManager.addListener(this);
    windowManager.setAlwaysOnTop(widget.pinned);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          icon: widget.pinned? const Icon(FluentIcons.pin_24_filled): const Icon(FluentIcons.pin_24_regular),
          onPressed: () {
            context.read<SettingsCubit>().alwaysOnTop = !widget.pinned;
          },
        ),
      ),
    );
  }
}
