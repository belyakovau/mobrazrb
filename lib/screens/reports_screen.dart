import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final DateFormat _dateFormat = DateFormat('dd.MM.yyyy', 'ru_RU');
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Отчеты')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Выбор периода
          Container(
            decoration: BoxDecoration(
              color: Colors.lightGreen.shade200, // 0xFFC5E1A5
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Период отчета',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A1A), // Принцип 14
                    height: 1.4, // Принцип 16
                  ),
                ),
                const SizedBox(height: 20), // Принцип 1: пространство
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _startDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setState(() {
                              _startDate = date;
                            });
                          }
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(
                            14,
                          ), // Принцип 1: больше пространства
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 20,
                                color: const Color(0xFF4A4A4A),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _dateFormat.format(_startDate),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF1A1A1A),
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '—',
                        style: TextStyle(
                          fontSize: 18,
                          color: const Color(0xFF4A4A4A),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _endDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setState(() {
                              _endDate = date;
                            });
                          }
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 20,
                                color: const Color(0xFF4A4A4A),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _dateFormat.format(_endDate),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF1A1A1A),
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ), // Принцип 1: пространство перед кнопкой
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Генерация отчета
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Отчет будет сгенерирован'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Сформировать отчет',
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Типы отчетов
          Text(
            'Доступные отчеты',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A1A1A), // Принцип 14
              height: 1.4, // Принцип 16
            ),
          ),
          const SizedBox(height: 20), // Принцип 1: пространство перед группой

          _ReportCard(
            icon: Icons.attach_money,
            title: 'Отчет по выручке',
            description: 'Детальный отчет по продажам абонементов и услуг',
            onTap: () {
              _showRevenueReport();
            },
          ),

          _ReportCard(
            icon: Icons.people,
            title: 'Отчет по посещаемости',
            description:
                'Статистика посещений групповых и персональных занятий',
            onTap: () {
              _showAttendanceReport();
            },
          ),

          _ReportCard(
            icon: Icons.person,
            title: 'Отчет по тренерам',
            description: 'Отработанные часы и проведенные занятия тренеров',
            onTap: () {
              _showTrainersReport();
            },
          ),

          _ReportCard(
            icon: Icons.card_membership,
            title: 'Отчет по абонементам',
            description: 'Статистика продаж и активности абонементов',
            onTap: () {
              _showSubscriptionsReport();
            },
          ),
        ],
      ),
    );
  }

  void _showRevenueReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Отчет по выручке'),
        content: const Text('Детальный отчет будет отображаться здесь'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showAttendanceReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Отчет по посещаемости'),
        content: const Text('Отчет по посещаемости будет отображаться здесь'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showTrainersReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Отчет по тренерам'),
        content: const Text('Отчет по тренерам будет отображаться здесь'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showSubscriptionsReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Отчет по абонементам'),
        content: const Text('Отчет по абонементам будет отображаться здесь'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _ReportCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.lightGreen.shade200, // 0xFFC5E1A5
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.green.shade700, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Принцип 15
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A), // Принцип 14
                      height: 1.4, // Принцип 16
                    ),
                  ),
                  const SizedBox(height: 6), // Принцип 1: пространство
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4A4A4A),
                      height: 1.5, // Принцип 16
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
