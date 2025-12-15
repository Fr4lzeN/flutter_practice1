import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice1/src/navigation/app_router.dart';
import 'package:practice1/src/widgets/app_header.dart';
import '../cubit/settings_cubit.dart';
import '../models/app_settings_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  String _getPriorityName(int priority) {
    switch (priority) {
      case 1:
        return 'Высокий';
      case 2:
        return 'Средний';
      case 3:
        return 'Низкий';
      default:
        return 'Средний';
    }
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'ru':
        return 'Русский';
      case 'en':
        return 'English';
      default:
        return 'Русский';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, AppSettings>(
      builder: (context, settings) {
        return Scaffold(
          appBar: const AppHeader(currentRoute: AppRouter.settingsRoute),
          body: ListView(
            children: [
              const _SectionHeader(title: 'Внешний вид'),
              SwitchListTile(
                title: const Text('Темная тема'),
                subtitle: const Text('Переключить на темную тему'),
                value: settings.isDarkTheme,
                onChanged: (_) {
                  context.read<SettingsCubit>().toggleTheme();
                },
                secondary: const Icon(Icons.dark_mode),
              ),
              const Divider(),
              const _SectionHeader(title: 'Уведомления'),
              SwitchListTile(
                title: const Text('Уведомления'),
                subtitle: const Text('Включить/выключить уведомления'),
                value: settings.notificationsEnabled,
                onChanged: (_) {
                  context.read<SettingsCubit>().toggleNotifications();
                },
                secondary: const Icon(Icons.notifications),
              ),
              const Divider(),
              const _SectionHeader(title: 'Задачи'),
              SwitchListTile(
                title: const Text('Показывать выполненные'),
                subtitle: const Text('Отображать завершенные задачи в списке'),
                value: settings.showCompletedTasks,
                onChanged: (_) {
                  context.read<SettingsCubit>().toggleShowCompletedTasks();
                },
                secondary: const Icon(Icons.check_circle),
              ),
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text('Приоритет по умолчанию'),
                subtitle: Text(_getPriorityName(settings.defaultPriority)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showPriorityDialog(context, settings.defaultPriority),
              ),
              const Divider(),
              const _SectionHeader(title: 'Язык'),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Язык приложения'),
                subtitle: Text(_getLanguageName(settings.language)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showLanguageDialog(context, settings.language),
              ),
              const Divider(),
              const _SectionHeader(title: 'О приложении'),
              const ListTile(
                leading: Icon(Icons.info),
                title: Text('Версия'),
                subtitle: Text('1.0.0'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPriorityDialog(BuildContext context, int currentPriority) {
    showDialog(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Выберите приоритет'),
        children: [1, 2, 3].map((priority) {
          return SimpleDialogOption(
            onPressed: () {
              context.read<SettingsCubit>().setDefaultPriority(priority);
              Navigator.of(dialogContext).pop();
            },
            child: Row(
              children: [
                Icon(
                  priority == currentPriority
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 16),
                Text(_getPriorityName(priority)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, String currentLanguage) {
    showDialog(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Выберите язык'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              context.read<SettingsCubit>().setLanguage('ru');
              Navigator.of(dialogContext).pop();
            },
            child: Row(
              children: [
                Icon(
                  currentLanguage == 'ru'
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 16),
                const Text('Русский'),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              context.read<SettingsCubit>().setLanguage('en');
              Navigator.of(dialogContext).pop();
            },
            child: Row(
              children: [
                Icon(
                  currentLanguage == 'en'
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 16),
                const Text('English'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
