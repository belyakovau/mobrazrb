# Настройка системы учета фитнес-клуба "Олимп"

## Требования

- Flutter SDK (версия 3.9.2 или выше)
- Аккаунт на Supabase (https://supabase.com)

## Установка зависимостей

```bash
flutter pub get
```

## Настройка Supabase

1. Создайте проект на https://supabase.com
2. Перейдите в Settings -> API
3. Скопируйте:
   - Project URL
   - anon public key
4. Откройте файл `lib/config/supabase_config.dart`
5. Замените значения:
   ```dart
   static const String url = 'YOUR_SUPABASE_URL';
   static const String anonKey = 'YOUR_SUPABASE_ANON_KEY';
   ```

## Создание таблиц в Supabase

Выполните следующие SQL запросы в SQL Editor Supabase:

### Таблица клиентов (clients)
```sql
CREATE TABLE clients (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  phone TEXT NOT NULL,
  email TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### Таблица типов абонементов (subscription_types)
```sql
CREATE TABLE subscription_types (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  duration_days INTEGER NOT NULL,
  visits INTEGER, -- NULL или -1 означает безлимит
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### Таблица абонементов (subscriptions)
```sql
CREATE TABLE subscriptions (
  id BIGSERIAL PRIMARY KEY,
  client_id BIGINT REFERENCES clients(id) ON DELETE CASCADE,
  subscription_type_id BIGINT REFERENCES subscription_types(id),
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  visits_remaining INTEGER NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  price DECIMAL(10, 2) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### Таблица сотрудников (employees)
```sql
CREATE TABLE employees (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  phone TEXT NOT NULL,
  email TEXT NOT NULL,
  role TEXT NOT NULL, -- 'Тренер', 'Администратор', 'Бухгалтер', 'Владелец'
  specialization TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### Таблица занятий (classes)
```sql
CREATE TABLE classes (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT NOT NULL, -- 'group' или 'personal'
  trainer_id BIGINT REFERENCES employees(id),
  start_time TIMESTAMPTZ NOT NULL,
  duration_minutes INTEGER NOT NULL,
  max_participants INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### Таблица записей на занятия (class_bookings)
```sql
CREATE TABLE class_bookings (
  id BIGSERIAL PRIMARY KEY,
  class_id BIGINT REFERENCES classes(id) ON DELETE CASCADE,
  client_id BIGINT REFERENCES clients(id) ON DELETE CASCADE,
  booked_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(class_id, client_id)
);
```

### Таблица посещений (visits)
```sql
CREATE TABLE visits (
  id BIGSERIAL PRIMARY KEY,
  client_id BIGINT REFERENCES clients(id) ON DELETE CASCADE,
  subscription_id BIGINT REFERENCES subscriptions(id),
  visit_date TIMESTAMPTZ DEFAULT NOW(),
  class_id BIGINT REFERENCES classes(id)
);
```

## Настройка Row Level Security (RLS)

Для безопасности данных необходимо настроить RLS политики. Пример:

```sql
-- Включить RLS для всех таблиц
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscription_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE classes ENABLE ROW LEVEL SECURITY;
ALTER TABLE class_bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE visits ENABLE ROW LEVEL SECURITY;

-- Пример политики: все аутентифицированные пользователи могут читать клиентов
CREATE POLICY "Users can read clients"
  ON clients FOR SELECT
  TO authenticated
  USING (true);

-- Пример политики: только администраторы могут создавать клиентов
CREATE POLICY "Admins can insert clients"
  ON clients FOR INSERT
  TO authenticated
  WITH CHECK (true); -- Здесь можно добавить проверку роли
```

## Запуск приложения

```bash
flutter run
```

Для запуска в браузере:
```bash
flutter run -d chrome
# или
flutter run -d edge
```

## Цветовая схема

- Основной цвет: черный (#000000)
- Акцентный цвет: зеленый (#4CAF50, #66BB6A)
- Фон: светло-серый (#FAFAFA)

## Структура приложения

- `lib/main.dart` - Главный файл приложения
- `lib/screens/` - Экраны приложения
  - `auth_screen.dart` - Экран авторизации
  - `home_screen.dart` - Главный экран с статистикой
  - `clients_screen.dart` - Управление клиентами
  - `subscriptions_screen.dart` - Управление абонементами
  - `schedule_screen.dart` - Расписание занятий
  - `employees_screen.dart` - Управление сотрудниками
  - `reports_screen.dart` - Отчеты
- `lib/models/` - Модели данных
- `lib/config/` - Конфигурация

## Следующие шаги

1. Настроить Supabase и создать таблицы
2. Реализовать реальные запросы к базе данных вместо заглушек
3. Добавить обработку ошибок
4. Реализовать роли и права доступа
5. Добавить уведомления об истечении абонементов
6. Реализовать генерацию отчетов


