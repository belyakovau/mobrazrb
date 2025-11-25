import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _selectedDate = DateTime.now();
  final DateFormat _dateFormat = DateFormat('dd MMMM yyyy', 'ru_RU');
  final DateFormat _dayFormat = DateFormat('EEEE', 'ru_RU');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Расписание'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Добавить занятие',
            onPressed: () {
              // Диалог добавления занятия
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Выбор даты - Принцип 1: Группировка элементов навигации
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 12,
            ), // Принцип 1: вертикальные отступы
            decoration: BoxDecoration(
              color: Colors.lightGreen.shade200, // 0xFFC5E1A5
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  color: const Color(
                    0xFF1A1A1A,
                  ), // Принцип 7: контрастность элементов
                  onPressed: () {
                    setState(() {
                      _selectedDate = _selectedDate.subtract(
                        const Duration(days: 1),
                      );
                    });
                  },
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _dateFormat.format(_selectedDate),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A), // Принцип 14
                          height: 1.4, // Принцип 16
                        ),
                      ),
                      const SizedBox(height: 4), // Принцип 1: пространство
                      Text(
                        _dayFormat.format(_selectedDate),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4A4A4A),
                          height: 1.5, // Принцип 16
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  color: const Color(0xFF1A1A1A),
                  onPressed: () {
                    setState(() {
                      _selectedDate = _selectedDate.add(
                        const Duration(days: 1),
                      );
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  color: const Color(0xFF1A1A1A),
                  tooltip: 'Выбрать дату',
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 365),
                      ),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        _selectedDate = date;
                      });
                    }
                  },
                ),
              ],
            ),
          ),

          // Список занятий - Принцип 1: Группировка с помощью пространства
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _ScheduleItem(
                  time: '09:00',
                  title: 'Персональная тренировка',
                  trainer: 'Иванов И.И.',
                  client: 'Петров П.П.',
                  type: 'personal',
                ),
                _ScheduleItem(
                  time: '10:00',
                  title: 'Йога',
                  trainer: 'Сидорова М.С.',
                  type: 'group',
                  participants: 8,
                  maxParticipants: 15,
                ),
                _ScheduleItem(
                  time: '11:00',
                  title: 'Кроссфит',
                  trainer: 'Кузнецов А.В.',
                  type: 'group',
                  participants: 12,
                  maxParticipants: 20,
                ),
                _ScheduleItem(
                  time: '14:00',
                  title: 'Персональная тренировка',
                  trainer: 'Иванов И.И.',
                  client: 'Смирнова А.А.',
                  type: 'personal',
                ),
                _ScheduleItem(
                  time: '18:00',
                  title: 'Пилатес',
                  trainer: 'Сидорова М.С.',
                  type: 'group',
                  participants: 10,
                  maxParticipants: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  final String time;
  final String title;
  final String trainer;
  final String? client;
  final String type; // 'personal' or 'group'
  final int? participants;
  final int? maxParticipants;

  const _ScheduleItem({
    required this.time,
    required this.title,
    required this.trainer,
    this.client,
    required this.type,
    this.participants,
    this.maxParticipants,
  });

  @override
  Widget build(BuildContext context) {
    final isPersonal = type == 'personal';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.lightGreen.shade200, // 0xFFC5E1A5
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Время
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              time,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Информация о занятии
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 16,
                      color: const Color(0xFF4A4A4A),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        trainer,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4A4A4A),
                          height: 1.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (isPersonal && client != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 16,
                        color: const Color(0xFF4A4A4A),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          client!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF4A4A4A),
                            height: 1.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                if (!isPersonal &&
                    participants != null &&
                    maxParticipants != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        size: 16,
                        color: const Color(0xFF4A4A4A),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$participants/$maxParticipants',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4A4A4A),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Бейдж типа занятия - Принцип 9: не только цвет, но и текст и иконка
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isPersonal ? Colors.blue.shade50 : Colors.orange.shade50,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isPersonal
                    ? Colors.blue.shade300
                    : Colors.orange.shade300,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPersonal ? Icons.person : Icons.people,
                  size: 14,
                  color: isPersonal
                      ? Colors.blue.shade800
                      : Colors.orange.shade800,
                ),
                const SizedBox(width: 6),
                Text(
                  isPersonal ? 'Персональное' : 'Групповое',
                  style: TextStyle(
                    fontSize: 12,
                    color: isPersonal
                        ? Colors.blue.shade800
                        : Colors.orange.shade800,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
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
