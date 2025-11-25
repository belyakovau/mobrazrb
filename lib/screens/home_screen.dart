import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Map<String, dynamic>> _loadStatistics() async {
    // Заглушка для статистики (в дальнейшем заменить на реальные запросы к Supabase)
    // Здесь будут запросы к базе данных для получения статистики за сегодня
    await Future.delayed(const Duration(milliseconds: 500));

    return {
      'revenue': 12500.0,
      'newClients': 5,
      'visits': 42,
      'activeSubscriptions': 128,
    };
  }

  Future<void> _handleLogout() async {
    try {
      await Supabase.instance.client.auth.signOut();
      debugPrint('Выход выполнен успешно');
    } catch (e) {
      debugPrint('Ошибка выхода: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка выхода: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    // Защита от случая, когда пользователь не авторизован
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Главная')),
        body: const Center(child: Text('Пользователь не авторизован')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Motion'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Выйти',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadStatistics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = snapshot.data ?? {};
          final formatter = NumberFormat.currency(locale: 'ru_RU', symbol: '₽');

          return RefreshIndicator(
            onRefresh: () async {
              // Обновление статистики
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Приветствие - Принцип 1: Группировка связанных элементов
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.lightGreen.shade200, // 0xFFC5E1A5
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.only(
                      bottom: 0,
                    ), // Принцип 1: без внешних отступов
                    padding: const EdgeInsets.all(
                      20,
                    ), // Принцип 1: больше пространства
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.green.shade700,
                          radius: 32,
                          child: Text(
                            user.email?.substring(0, 1).toUpperCase() ?? 'U',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ), // Принцип 1: пространство между элементами
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Принцип 15: выравнивание по левому краю
                            children: [
                              Text(
                                'Добро пожаловать!',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(
                                    0xFF1A1A1A,
                                  ), // Принцип 14: не чисто чёрный
                                  height: 1.4, // Принцип 16: высота строки
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ), // Принцип 1: пространство между строками
                              Text(
                                user.email ?? 'Пользователь',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: const Color(
                                    0xFF4A4A4A,
                                  ), // Второстепенный текст
                                  height: 1.5, // Принцип 16
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ), // Принцип 1: пространство между секциями
                  // Статистика за сегодня - Принцип 4: Визуальная иерархия
                  Text(
                    'Статистика за сегодня',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(
                        0xFF1A1A1A,
                      ), // Принцип 14: не чисто чёрный
                      height: 1.4, // Принцип 16
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ), // Принцип 1: пространство перед группой
                  // Принцип 1: Группировка связанных карточек статистики
                  // Выручка
                  _StatCard(
                    icon: Icons.attach_money,
                    title: 'Выручка',
                    value: formatter.format(stats['revenue'] ?? 0),
                    color: Colors.green,
                  ),
                  const SizedBox(
                    height: 12,
                  ), // Принцип 1: единообразное пространство
                  // Новые клиенты
                  _StatCard(
                    icon: Icons.person_add,
                    title: 'Новые клиенты',
                    value: '${stats['newClients'] ?? 0}',
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 12),

                  // Посещения
                  _StatCard(
                    icon: Icons.directions_walk,
                    title: 'Посещения',
                    value: '${stats['visits'] ?? 0}',
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 12),

                  // Активные абонементы
                  _StatCard(
                    icon: Icons.card_membership,
                    title: 'Активные абонементы',
                    value: '${stats['activeSubscriptions'] ?? 0}',
                    color: Colors.purple,
                  ),
                  const SizedBox(
                    height: 32,
                  ), // Принцип 1: больше пространства между секциями
                  // Быстрые действия - Принцип 4: Визуальная иерархия
                  Text(
                    'Быстрые действия',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A1A), // Принцип 14
                      height: 1.4, // Принцип 16
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ), // Принцип 1: пространство перед группой

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      _QuickActionCard(
                        icon: Icons.person_add,
                        title: 'Новый клиент',
                        onTap: () {
                          // Навигация к добавлению клиента
                        },
                      ),
                      _QuickActionCard(
                        icon: Icons.card_membership,
                        title: 'Продать абонемент',
                        onTap: () {
                          // Навигация к продаже абонемента
                        },
                      ),
                      _QuickActionCard(
                        icon: Icons.calendar_today,
                        title: 'Расписание',
                        onTap: () {
                          // Навигация к расписанию
                        },
                      ),
                      _QuickActionCard(
                        icon: Icons.bar_chart,
                        title: 'Отчеты',
                        onTap: () {
                          // Навигация к отчетам
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ), // Принцип 1: пространство между карточками
      decoration: BoxDecoration(
        color: Colors.lightGreen.shade200, // 0xFFC5E1A5
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(
        18,
      ), // Принцип 1: достаточные внутренние отступы
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(
            width: 18,
          ), // Принцип 1: больше пространства между элементами
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Принцип 15: выравнивание по левому краю
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(
                      0xFF4A4A4A,
                    ), // Принцип 8: достаточная контрастность (4.5:1)
                    height: 1.5, // Принцип 16
                  ),
                ),
                const SizedBox(
                  height: 8,
                ), // Принцип 1: пространство между элементами
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(
                      0xFF1A1A1A,
                    ), // Принцип 14: не чисто чёрный
                    height: 1.4, // Принцип 16
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.lightGreen.shade200, // 0xFFC5E1A5
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.green.shade700),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign
                  .center, // Для коротких заголовков центрирование допустимо
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1A1A1A), // Принцип 14
                height: 1.5, // Принцип 16
              ),
            ),
          ],
        ),
      ),
    );
  }
}
