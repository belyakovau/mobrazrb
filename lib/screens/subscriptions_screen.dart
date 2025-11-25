import 'package:flutter/material.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  final _subscriptionTypes = [
    {
      'id': 1,
      'name': 'Безлимит',
      'price': 3000,
      'duration_days': 30,
      'visits': -1, // -1 означает безлимит
    },
    {
      'id': 2,
      'name': '12 посещений',
      'price': 2500,
      'duration_days': 60,
      'visits': 12,
    },
    {
      'id': 3,
      'name': 'Разовое посещение',
      'price': 300,
      'duration_days': 1,
      'visits': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Абонементы'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Добавить тип абонемента',
            onPressed: () {
              // Диалог добавления типа абонемента
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Типы абонементов',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A1A1A), // Принцип 14
              height: 1.4, // Принцип 16
            ),
          ),
          const SizedBox(height: 20), // Принцип 1: пространство перед группой
          ..._subscriptionTypes.map(
            (type) => Container(
              margin: const EdgeInsets.only(
                bottom: 12,
              ), // Принцип 1: пространство между карточками (предотвращает наложение)
              decoration: BoxDecoration(
                color: Colors.lightGreen.shade200, // 0xFFC5E1A5
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(
                  16,
                ), // Принцип 1: внутренние отступы
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.card_membership,
                    color: Colors.green.shade700,
                    size: 24,
                  ),
                ),
                title: Text(
                  type['name'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1A1A1A), // Принцип 14
                    height: 1.4, // Принцип 16
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Принцип 15
                    children: [
                      Text(
                        'Цена: ${type['price']} ₽',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4A4A4A),
                          height: 1.5, // Принцип 16
                        ),
                      ),
                      const SizedBox(height: 4), // Принцип 1: пространство
                      Text(
                        type['visits'] == -1
                            ? 'Срок: ${type['duration_days']} дней'
                            : '${type['visits']} посещений, срок: ${type['duration_days']} дней',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4A4A4A),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  color: const Color(0xFF4A4A4A),
                  onPressed: () {
                    // Редактирование типа абонемента
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
