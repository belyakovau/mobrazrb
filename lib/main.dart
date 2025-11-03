import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 1 - Basic UI with Navigation!!',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const MyHomePage(),
      // Регистрация именованных маршрутов
      routes: {
        '/second': (context) => const SecondScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // Навигация с помощью Navigator.push()
  void _navigateWithPush(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SecondScreen()),
    );
  }

  // Навигация с помощью Navigator.pushNamed()
  void _navigateWithPushNamed(BuildContext context) {
    Navigator.pushNamed(context, '/second');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 1: Basic UI - Главная'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            tooltip: 'Профиль',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Первый контейнер с кнопками навигации
            Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade300, width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Навигация',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _navigateWithPush(context),
                        child: const Text('Push()'),
                      ),
                      ElevatedButton(
                        onPressed: () => _navigateWithPushNamed(context),
                        child: const Text('PushNamed()'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Row с тремя текстовыми элементами
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Элемент 1',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  Text(
                    'Элемент 2',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Элемент 3',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),

            // Второй контейнер
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.green.shade100, Colors.lightGreen.shade200],
                ),
              ),
              child: const Center(
                child: Text(
                  'Нижний контейнер',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ),

            const Text(
              'CircleAvatar пример:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.purple.shade200,
                      child: const Text(
                        'A1',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        'https://picsum.photos/100/100?random=1',
                      ),
                    ),
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.orange.shade200,
                      child: const Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Счетчик
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Column(
                children: [
                  const Text(
                    'Счетчик нажатий:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '$_counter',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  Text(
                    _counter == 0
                        ? 'Нажмите FAB кнопку!'
                        : _counter < 5
                        ? 'Вы начинающий!'
                        : _counter < 10
                        ? 'Вы активны!'
                        : 'Вы эксперт!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Увеличить счетчик',
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      // BottomNavigationBar для дополнительной навигации
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Настройки',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/settings');
          }
        },
      ),
    );
  }
}

// Второй экран - демонстрация Navigator.pop()
class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Второй экран'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Назад',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Это второй экран!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green, width: 3),
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 80,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Использован Navigator.push() или Navigator.pushNamed()',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
              child: const Text('Вернуться назад (pop)'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Навигация на другой именованный маршрут
                Navigator.pushNamed(context, '/profile');
              },
              child: const Text('Перейти в профиль'),
            ),
          ],
        ),
      ),
    );
  }
}

// Экран профиля - демонстрация сложной навигации
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль пользователя'),
        backgroundColor: Colors.purple.shade800,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                'https://picsum.photos/200/200?random=2',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Пользователь',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'email@example.com',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Container(
              width: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.purple.shade200),
              ),
              child: const Column(
                children: [
                  Text(
                    'Это экран профиля',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Достигнут через именованный маршрут /profile',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Назад (pop)'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Возврат на главный экран с очисткой стека
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyHomePage(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text('На главную'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Экран настроек
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        backgroundColor: Colors.orange.shade800,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Уведомления'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          const ListTile(
            leading: Icon(Icons.security),
            title: Text('Конфиденциальность'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          const ListTile(
            leading: Icon(Icons.help),
            title: Text('Помощь'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          const SizedBox(height: 20),
          Card(
            color: Colors.orange.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Информация о навигации:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('• Этот экран открыт через BottomNavigationBar'),
                  Text('• Использован pushNamed с маршрутом /settings'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Закрыть настройки'),
            ),
          ),
        ],
      ),
    );
  }
}
