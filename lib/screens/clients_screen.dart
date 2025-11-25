import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _clients = [];
  List<Map<String, dynamic>> _filteredClients = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClients();
    _searchController.addListener(_filterClients);
  }

  Future<void> _loadClients() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('clients')
          .select()
          .order('created_at', ascending: false);

      _clients = List<Map<String, dynamic>>.from(response);
      debugPrint('Загружено клиентов: ${_clients.length}');
      _filteredClients = _clients;
    } catch (e) {
      debugPrint('Ошибка загрузки клиентов: $e');
      // Если ошибка, показываем пустой список
      _clients = [];
      _filteredClients = [];
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterClients() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredClients = _clients;
      } else {
        _filteredClients = _clients.where((client) {
          final nameMatch =
              client['name']?.toString().toLowerCase().contains(query) ?? false;
          final phoneMatch =
              client['phone']?.toString().contains(query) ?? false;
          final emailMatch =
              client['email'] != null &&
              client['email'].toString().toLowerCase().contains(query);
          return nameMatch || phoneMatch || emailMatch;
        }).toList();
      }
    });
  }

  void _showAddClientDialog() {
    showDialog(
      context: context,
      builder: (context) => _AddClientDialog(
        onClientAdded: () {
          _loadClients();
        },
      ),
    );
  }

  void _showClientDetails(Map<String, dynamic> client) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ClientDetailsSheet(
        client: client,
        onClientUpdated: () {
          _loadClients();
        },
        onClientDeleted: () {
          _loadClients();
        },
        onEdit: () {
          Navigator.of(context).pop();
          _showEditClientDialog(client);
        },
      ),
    );
  }

  void _showEditClientDialog(Map<String, dynamic> client) {
    showDialog(
      context: context,
      builder: (context) => _EditClientDialog(
        client: client,
        onClientUpdated: () {
          _loadClients();
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Клиенты')),
      body: Column(
        children: [
          // Поиск - Принцип 1: Группировка с помощью пространства
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Color(0xFF1A1A1A), // Принцип 14
                ),
                decoration: InputDecoration(
                  hintText: 'Поиск по имени, телефону, email...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    height: 1.5,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey.shade600),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ),

          // Список клиентов
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredClients.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Клиенты не найдены',
                          style: TextStyle(
                            fontSize: 18,
                            color: const Color(0xFF4A4A4A), // Принцип 14, 8
                            height: 1.5, // Принцип 16
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadClients,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        0,
                        16,
                        16,
                      ), // Принцип 1: отступы
                      itemCount: _filteredClients.length,
                      itemBuilder: (context, index) {
                        final client = _filteredClients[index];
                        return Container(
                          margin: const EdgeInsets.only(
                            bottom: 12,
                          ), // Принцип 1: пространство между элементами
                          decoration: BoxDecoration(
                            color: Colors.lightGreen.shade200, // 0xFFC5E1A5
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              backgroundColor: Colors.green.shade700,
                              child: Text(
                                client['name']
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
                              client['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF1A1A1A), // Принцип 14
                                height: 1.4, // Принцип 16
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start, // Принцип 15
                                children: [
                                  const SizedBox(
                                    height: 6,
                                  ), // Принцип 1: пространство
                                  Text(
                                    client['phone'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF4A4A4A),
                                      height: 1.5, // Принцип 16
                                    ),
                                  ),
                                  if (client['email'] != null &&
                                      client['email']
                                          .toString()
                                          .isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      client['email'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF4A4A4A),
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                  const SizedBox(
                                    height: 10,
                                  ), // Принцип 1: пространство перед бейджем
                                  if (client['subscription_active'] == true)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: Colors.green.shade300,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            size: 14,
                                            color: Colors.green.shade800,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Активен до ${client['subscription_expires']}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.green.shade800,
                                              fontWeight: FontWeight.w500,
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  else
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: Colors.red.shade300,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.cancel,
                                            size: 14,
                                            color: Colors.red.shade800,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Абонемент не активен',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.red.shade800,
                                              fontWeight: FontWeight.w500,
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.arrow_forward_ios),
                              onPressed: () => _showClientDetails(client),
                            ),
                            onTap: () => _showClientDetails(client),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddClientDialog,
        backgroundColor: Colors.green.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _AddClientDialog extends StatefulWidget {
  final VoidCallback onClientAdded;

  const _AddClientDialog({required this.onClientAdded});

  @override
  State<_AddClientDialog> createState() => _AddClientDialogState();
}

class _AddClientDialogState extends State<_AddClientDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime? _dateOfBirth;
  final DateFormat _dateFormat = DateFormat('dd.MM.yyyy');
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _updateDateController();
  }

  void _updateDateController() {
    _dateController.text = _dateOfBirth != null
        ? _dateFormat.format(_dateOfBirth!)
        : '';
  }

  Future<void> _saveClient() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;
      final data = {
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        'date_of_birth': _dateOfBirth?.toIso8601String(),
      };

      debugPrint('Сохранение клиента: $data');

      await supabase.from('clients').insert(data);

      if (mounted) {
        Navigator.of(context).pop();
        widget.onClientAdded();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Клиент успешно добавлен'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint('Ошибка сохранения клиента: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Новый клиент'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'ФИО *',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите ФИО';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Телефон *',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите телефон';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate:
                        _dateOfBirth ??
                        DateTime.now().subtract(const Duration(days: 365 * 25)),
                    firstDate: DateTime(1920),
                    lastDate: DateTime.now(),
                  );
                  if (date != null && mounted) {
                    setState(() {
                      _dateOfBirth = date;
                      _updateDateController();
                    });
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Дата рождения',
                    hintText: 'Выберите дату',
                    prefixIcon: const Icon(Icons.calendar_today),
                    suffixIcon: _dateOfBirth != null
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _dateOfBirth = null;
                                _updateDateController();
                              });
                            },
                          )
                        : null,
                  ),
                  child: Text(
                    _dateOfBirth != null
                        ? _dateFormat.format(_dateOfBirth!)
                        : 'Выберите дату',
                    style: TextStyle(
                      color: _dateOfBirth != null
                          ? const Color(0xFF1A1A1A)
                          : Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email (необязательно)',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  // Email не обязателен, но если введен, должен быть корректным
                  if (value != null &&
                      value.isNotEmpty &&
                      !value.contains('@')) {
                    return 'Введите корректный email';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveClient,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Сохранить'),
        ),
      ],
    );
  }
}

class _EditClientDialog extends StatefulWidget {
  final Map<String, dynamic> client;
  final VoidCallback onClientUpdated;

  const _EditClientDialog({
    required this.client,
    required this.onClientUpdated,
  });

  @override
  State<_EditClientDialog> createState() => _EditClientDialogState();
}

class _EditClientDialogState extends State<_EditClientDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  final _dateController = TextEditingController();
  DateTime? _dateOfBirth;
  final DateFormat _dateFormat = DateFormat('dd.MM.yyyy');
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.client['name'] ?? '');
    _phoneController = TextEditingController(
      text: widget.client['phone'] ?? '',
    );
    _emailController = TextEditingController(
      text: widget.client['email'] ?? '',
    );
    if (widget.client['date_of_birth'] != null) {
      try {
        _dateOfBirth = DateTime.parse(widget.client['date_of_birth']);
      } catch (e) {
        debugPrint('Ошибка парсинга даты: $e');
      }
    }
    _updateDateController();
  }

  void _updateDateController() {
    _dateController.text = _dateOfBirth != null
        ? _dateFormat.format(_dateOfBirth!)
        : '';
  }

  Future<void> _updateClient() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;
      final data = {
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        'date_of_birth': _dateOfBirth?.toIso8601String(),
      };

      debugPrint('Обновление клиента ${widget.client['id']}: $data');

      await supabase.from('clients').update(data).eq('id', widget.client['id']);

      if (mounted) {
        Navigator.of(context).pop();
        widget.onClientUpdated();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Клиент успешно обновлен'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint('Ошибка обновления клиента: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Редактировать клиента'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'ФИО *',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите ФИО';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Телефон *',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите телефон';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate:
                        _dateOfBirth ??
                        DateTime.now().subtract(const Duration(days: 365 * 25)),
                    firstDate: DateTime(1920),
                    lastDate: DateTime.now(),
                  );
                  if (date != null && mounted) {
                    setState(() {
                      _dateOfBirth = date;
                      _updateDateController();
                    });
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Дата рождения',
                    hintText: 'Выберите дату',
                    prefixIcon: const Icon(Icons.calendar_today),
                    suffixIcon: _dateOfBirth != null
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _dateOfBirth = null;
                                _updateDateController();
                              });
                            },
                          )
                        : null,
                  ),
                  child: Text(
                    _dateOfBirth != null
                        ? _dateFormat.format(_dateOfBirth!)
                        : 'Выберите дату',
                    style: TextStyle(
                      color: _dateOfBirth != null
                          ? const Color(0xFF1A1A1A)
                          : Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email (необязательно)',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      !value.contains('@')) {
                    return 'Введите корректный email';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _updateClient,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Сохранить'),
        ),
      ],
    );
  }
}

class _ClientDetailsSheet extends StatelessWidget {
  final Map<String, dynamic> client;
  final VoidCallback onClientUpdated;
  final VoidCallback onClientDeleted;
  final VoidCallback onEdit;

  const _ClientDetailsSheet({
    required this.client,
    required this.onClientUpdated,
    required this.onClientDeleted,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.green.shade700,
                        child: Text(
                          client['name']
                              .toString()
                              .split(' ')
                              .map((n) => n[0])
                              .take(2)
                              .join(),
                          style: const TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        client['name'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _DetailRow(
                      icon: Icons.phone,
                      label: 'Телефон',
                      value: client['phone']?.toString() ?? '',
                    ),
                    if (client['email'] != null &&
                        client['email'].toString().isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _DetailRow(
                        icon: Icons.email,
                        label: 'Email',
                        value: client['email']?.toString() ?? '',
                      ),
                    ],
                    if (client['date_of_birth'] != null) ...[
                      const SizedBox(height: 20),
                      _DetailRow(
                        icon: Icons.calendar_today,
                        label: 'Дата рождения',
                        value: DateFormat(
                          'dd.MM.yyyy',
                        ).format(DateTime.parse(client['date_of_birth'])),
                      ),
                    ],
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // TODO: Отметить посещение
                        },
                        icon: const Icon(Icons.check, size: 20),
                        label: const Text(
                          'Отметить посещение',
                          style: TextStyle(fontSize: 16, height: 1.5),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // TODO: Продать абонемент
                        },
                        icon: const Icon(Icons.card_membership, size: 20),
                        label: const Text(
                          'Продать абонемент',
                          style: TextStyle(fontSize: 16, height: 1.5),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(
                            color: Colors.green.shade700,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onEdit();
                        },
                        icon: const Icon(Icons.edit, size: 20),
                        label: const Text(
                          'Редактировать',
                          style: TextStyle(fontSize: 16, height: 1.5),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(
                            color: Colors.blue.shade700,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Удаление клиента'),
                              content: Text(
                                'Вы уверены, что хотите удалить клиента "${client['name']}"?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Отмена'),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text('Удалить'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            try {
                              final supabase = Supabase.instance.client;
                              await supabase
                                  .from('clients')
                                  .delete()
                                  .eq('id', client['id']);

                              if (context.mounted) {
                                Navigator.of(context).pop();
                                onClientDeleted();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Клиент успешно удален'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            } catch (e) {
                              debugPrint('Ошибка удаления клиента: $e');
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Ошибка удаления: ${e.toString()}',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        },
                        icon: const Icon(Icons.delete, size: 20),
                        label: const Text(
                          'Удалить',
                          style: TextStyle(fontSize: 16, height: 1.5),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(
                            color: Colors.red.shade700,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade600),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF4A4A4A), // Принцип 8, 14
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6), // Принцип 1: пространство
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A1A), // Принцип 14
                  height: 1.5, // Принцип 16
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
