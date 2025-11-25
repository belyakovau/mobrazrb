import 'package:flutter/material.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  final _employees = [
    {
      'id': 1,
      'name': 'Иванов Иван Иванович',
      'role': 'Тренер',
      'specialization': 'Кроссфит, Персональные тренировки',
      'phone': '+7 (999) 111-22-33',
      'email': 'ivanov@olymp.ru',
      'status': 'active',
    },
    {
      'id': 2,
      'name': 'Сидорова Мария Сергеевна',
      'role': 'Тренер',
      'specialization': 'Йога, Пилатес',
      'phone': '+7 (999) 222-33-44',
      'email': 'sidorova@olymp.ru',
      'status': 'active',
    },
    {
      'id': 3,
      'name': 'Петрова Анна Владимировна',
      'role': 'Администратор',
      'specialization': null,
      'phone': '+7 (999) 333-44-55',
      'email': 'petrova@olymp.ru',
      'status': 'active',
    },
    {
      'id': 4,
      'name': 'Кузнецов Алексей Викторович',
      'role': 'Тренер',
      'specialization': 'Кроссфит, Функциональный тренинг',
      'phone': '+7 (999) 444-55-66',
      'email': 'kuznetsov@olymp.ru',
      'status': 'active',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сотрудники'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Добавить сотрудника',
            onPressed: () {
              _showAddEmployeeDialog();
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _employees.length,
        itemBuilder: (context, index) {
          final employee = _employees[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.lightGreen.shade200, // 0xFFC5E1A5
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Colors.green.shade700,
                radius: 28,
                child: Text(
                  employee['name']
                      .toString()
                      .split(' ')
                      .map((n) => n[0])
                      .take(2)
                      .join(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                employee['name'] as String,
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getRoleColor(
                          employee['role'] as String,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _getRoleColor(
                            employee['role'] as String,
                          ).withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        employee['role'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: _getRoleColor(employee['role'] as String),
                          fontWeight: FontWeight.bold,
                          height: 1.4,
                        ),
                      ),
                    ),
                    if (employee['specialization'] != null) ...[
                      const SizedBox(height: 10), // Принцип 1: пространство
                      Text(
                        employee['specialization'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4A4A4A),
                          height: 1.5, // Принцип 16
                        ),
                      ),
                    ],
                    const SizedBox(height: 6), // Принцип 1: пространство
                    Text(
                      employee['phone'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4A4A4A),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              trailing: PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 8),
                        Text('Редактировать'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Удалить', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    // Редактирование сотрудника
                  } else if (value == 'delete') {
                    // Удаление сотрудника
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Тренер':
        return Colors.green;
      case 'Администратор':
        return Colors.blue;
      case 'Бухгалтер':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showAddEmployeeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавить сотрудника'),
        content: const Text('Функция добавления сотрудника будет реализована'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
