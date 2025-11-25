import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase_config.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/clients_screen.dart';
import 'screens/subscriptions_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/employees_screen.dart';
import 'screens/reports_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Supabase
  try {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
    debugPrint('Supabase инициализирован успешно');
  } catch (e) {
    debugPrint('Ошибка инициализации Supabase: $e');
    // Приложение все равно запустится, но авторизация не будет работать
  }

  runApp(const FitnessClubApp());
}

class FitnessClubApp extends StatelessWidget {
  const FitnessClubApp({super.key});

  Widget _checkAuthState() {
    try {
      // Проверяем состояние авторизации через Supabase
      final client = Supabase.instance.client;
      return StreamBuilder<AuthState>(
        stream: client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          final session = snapshot.hasData
              ? snapshot.data!.session
              : client.auth.currentSession;

          debugPrint(
            'Текущая сессия: ${session != null ? "авторизован" : "не авторизован"}',
          );

          // Если пользователь не авторизован, показываем экран входа
          if (session == null) {
            return const AuthScreen();
          }

          // Если авторизован, показываем главный экран
          return const MainNavigationWrapper();
        },
      );
    } catch (e) {
      // Если произошла ошибка при проверке авторизации
      debugPrint('Ошибка проверки авторизации: $e');
      // Показываем экран входа по умолчанию
      return const AuthScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Motion - Фитнес Студия',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
          primary: Colors.green.shade700,
          secondary: Colors.green.shade400,
          surface: Colors.grey.shade50,
        ),
        // Светло-зеленый фон страниц
        scaffoldBackgroundColor: Colors.lightGreen.shade100, // 0xFFDCEDC8
        // Принцип 14: Избегать чисто чёрного текста - используем тёмно-серый
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Color(0xFF1A1A1A), // Тёмно-серый вместо чёрного
            height: 1.6, // Принцип 16: минимум 1.5 высоты строки
          ),
          bodyMedium: TextStyle(color: Color(0xFF1A1A1A), height: 1.6),
          bodySmall: TextStyle(
            color: Color(
              0xFF4A4A4A,
            ), // Более светлый для второстепенного текста
            height: 1.6,
          ),
          titleLarge: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
            height: 1.5,
          ),
          titleMedium: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
            height: 1.5,
          ),
          labelLarge: TextStyle(color: Color(0xFF1A1A1A), height: 1.5),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.lightGreen.shade700,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          margin: EdgeInsets
              .zero, // Убираем внешние отступы, управляем через padding родителя
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.green.shade700, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          labelStyle: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 14,
            height: 1.5,
          ),
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ),
      home: _checkAuthState(),
      routes: {
        '/home': (context) => const MainNavigationWrapper(),
        '/clients': (context) => const ClientsScreen(),
        '/subscriptions': (context) => const SubscriptionsScreen(),
        '/schedule': (context) => const ScheduleScreen(),
        '/employees': (context) => const EmployeesScreen(),
        '/reports': (context) => const ReportsScreen(),
      },
    );
  }
}

// Главный виджет-обертка для управления навигацией
class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ClientsScreen(),
    const SubscriptionsScreen(),
    const ScheduleScreen(),
    const EmployeesScreen(),
    const ReportsScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.lightGreen.shade700,
        selectedItemColor: Colors.green.shade400,
        unselectedItemColor: Colors.grey.shade400,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Главная',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Клиенты'),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_membership),
            label: 'Абонементы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Расписание',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Сотрудники',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Отчеты'),
        ],
      ),
    );
  }
}
