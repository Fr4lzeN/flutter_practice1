import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice1/src/navigation/app_router.dart';
import 'package:practice1/src/widgets/app_header.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoginMode = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    if (_isLoginMode) {
      authCubit.login(_emailController.text, _passwordController.text);
    } else {
      authCubit.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: const AppHeader(currentRoute: AppRouter.profileRoute),
          body: state.isLoggedIn ? _buildProfile(context, state) : _buildAuthForm(context, state),
        );
      },
    );
  }

  Widget _buildAuthForm(BuildContext context, AuthState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.account_circle, size: 100, color: Colors.grey),
          const SizedBox(height: 24),
          Text(
            _isLoginMode ? 'Вход в аккаунт' : 'Регистрация',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          if (!_isLoginMode) ...[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Имя',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
          ],
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Пароль',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _submit(context),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: state.isLoading ? null : () => _submit(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: state.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(_isLoginMode ? 'Войти' : 'Зарегистрироваться'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              setState(() {
                _isLoginMode = !_isLoginMode;
              });
            },
            child: Text(
              _isLoginMode
                  ? 'Нет аккаунта? Зарегистрироваться'
                  : 'Уже есть аккаунт? Войти',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfile(BuildContext context, AuthState state) {
    final user = state.user!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              user.name[0].toUpperCase(),
              style: const TextStyle(fontSize: 48, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.name,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            user.email,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 32),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Статистика',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Divider(),
                  _buildStatRow(
                    'Создано задач',
                    user.totalTasksCreated.toString(),
                    Icons.add_task,
                  ),
                  _buildStatRow(
                    'Выполнено задач',
                    user.totalTasksCompleted.toString(),
                    Icons.check_circle,
                  ),
                  _buildStatRow(
                    'Дата регистрации',
                    '${user.createdAt.day}.${user.createdAt.month}.${user.createdAt.year}',
                    Icons.calendar_today,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Редактировать профиль'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showEditProfileDialog(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Выйти из аккаунта',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Выйти из аккаунта?'),
                  content: const Text('Вы уверены, что хотите выйти?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text('Отмена'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthCubit>().logout();
                        Navigator.of(dialogContext).pop();
                      },
                      child: const Text('Выйти'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 16),
          Expanded(child: Text(label)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final state = context.read<AuthCubit>().state;
    final nameController = TextEditingController(text: state.user?.name);
    final emailController = TextEditingController(text: state.user?.email);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Редактировать профиль'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Имя',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthCubit>().updateProfile(
                    name: nameController.text,
                    email: emailController.text,
                  );
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}
