import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _isLogin = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  // Цвета из дизайнера - правильный формат с 0xFF
  static const Color _lightGreen = Color(
    0xFFBED882,
  ); // RGB(190, 216, 130) - фон полей
  static const Color _darkGreen = Color(
    0xFF688621,
  ); // RGB(104, 134, 33) - текст полей
  static const Color _buttonBg = Color(
    0xFF72922A,
  ); // RGB(114, 146, 42) - фон кнопки ВОЙТИ
  static const Color _buttonText = Color(
    0xFFD7FF7D,
  ); // RGB(215, 255, 125) - текст кнопки ВОЙТИ

  Future<void> _handleAuth() async {
    // Сначала очищаем предыдущие ошибки
    setState(() {
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    // Валидация полей
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      setState(() {
        _emailError = 'Введите email';
      });
      return;
    }

    // Более точная проверка email
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(email)) {
      setState(() {
        _emailError = 'Введите корректный email';
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        _passwordError = 'Введите пароль';
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        _passwordError = 'Пароль должен содержать минимум 6 символов';
      });
      return;
    }

    // Проверка совпадения паролей только при регистрации
    if (!_isLogin) {
      final confirmPassword = _confirmPasswordController.text;
      if (confirmPassword.isEmpty) {
        setState(() {
          _confirmPasswordError = 'Повторите пароль';
        });
        return;
      }
      if (password != confirmPassword) {
        setState(() {
          _confirmPasswordError = 'Пароли не совпадают';
        });
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    final supabase = Supabase.instance.client;

    try {
      if (_isLogin) {
        // Авторизация
        debugPrint('Попытка авторизации: $email');
        final response = await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
        debugPrint('Авторизация успешна: ${response.user?.email}');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Вход выполнен успешно!'),
              backgroundColor: Colors.green,
            ),
          );
          // Навигация на главную страницу произойдет автоматически через StreamBuilder в main.dart
        }
      } else {
        // Регистрация
        debugPrint('Попытка регистрации: $email');
        final signUpResponse = await supabase.auth.signUp(
          email: email,
          password: password,
        );
        debugPrint('Регистрация успешна: ${signUpResponse.user?.email}');

        // После регистрации всегда пытаемся автоматически войти
        if (signUpResponse.user != null) {
          debugPrint('Попытка автоматического входа после регистрации...');
          try {
            final signInResponse = await supabase.auth.signInWithPassword(
              email: email,
              password: password,
            );
            debugPrint(
              'Автоматический вход после регистрации успешен: ${signInResponse.user?.email}',
            );

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Регистрация успешна! Вы автоматически вошли в систему.',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              setState(() {
                _isLogin = true;
              });
              // Навигация на главную страницу произойдет автоматически через StreamBuilder в main.dart
            }
          } catch (signInError) {
            debugPrint(
              'Ошибка автоматического входа после регистрации: $signInError',
            );
            // Если автоматический вход не удался, переключаемся на режим входа
            // Пользователь может войти вручную
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Регистрация успешна! Теперь вы можете войти в систему.',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              setState(() {
                _isLogin = true;
              });
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Ошибка авторизации/регистрации: $e');

      String errorMessage = 'Произошла ошибка';

      // Обработка различных типов ошибок
      final errorString = e.toString().toLowerCase();

      if (errorString.contains('invalid login credentials') ||
          errorString.contains('invalid_credentials') ||
          errorString.contains('invalid credentials')) {
        errorMessage = 'Неверный email или пароль';
        setState(() {
          _emailError = 'Неверный email или пароль';
        });
      } else if (errorString.contains('email not confirmed') ||
          errorString.contains('email_not_confirmed')) {
        // Ошибка: email не подтвержден
        // Это означает, что в настройках Supabase включено требование подтверждения email
        // Попробуем войти еще раз через небольшую задержку
        errorMessage = 'Попытка входа...';
        debugPrint('Email не подтвержден, пытаемся войти повторно...');

        // Небольшая задержка и повторная попытка входа
        await Future.delayed(const Duration(milliseconds: 500));
        try {
          final retryResponse = await supabase.auth.signInWithPassword(
            email: email,
            password: password,
          );
          debugPrint('Повторный вход успешен: ${retryResponse.user?.email}');

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Вход выполнен успешно!'),
                backgroundColor: Colors.green,
              ),
            );
            return; // Успешный вход, выходим из функции
          }
        } catch (retryError) {
          debugPrint('Повторный вход не удался: $retryError');
          // Если повторный вход не удался, показываем сообщение о необходимости войти вручную
          errorMessage = 'Пожалуйста, войдите в систему вручную';
          setState(() {
            _isLogin = true;
          });
        }
      } else if (errorString.contains('user already registered') ||
          errorString.contains('already_registered') ||
          errorString.contains('email already registered')) {
        errorMessage = 'Пользователь с таким email уже зарегистрирован';
        setState(() {
          _emailError = 'Пользователь с таким email уже зарегистрирован';
        });
      } else if (errorString.contains('password') &&
          (errorString.contains('weak') ||
              errorString.contains('short') ||
              errorString.contains('minimum'))) {
        errorMessage = 'Пароль слишком слабый (минимум 6 символов)';
        setState(() {
          _passwordError = 'Пароль слишком слабый (минимум 6 символов)';
        });
      } else if (errorString.contains('email') &&
          (errorString.contains('invalid') ||
              errorString.contains('format') ||
              errorString.contains('malformed'))) {
        // Только если ошибка явно связана с форматом email
        errorMessage = 'Некорректный email адрес';
        setState(() {
          _emailError = 'Некорректный email адрес';
        });
      } else {
        // Для других ошибок показываем общее сообщение без установки ошибок в поля
        errorMessage = 'Произошла ошибка: ${e.toString()}';
        debugPrint('Необработанная ошибка: $e');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
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
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;
    final formWidth = isWeb ? 450.0 : screenWidth * 0.85;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('Frame.png'),
            fit: BoxFit
                .cover, // Покрывает весь экран, сохраняя пропорции без искажения
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                width: formWidth,
                constraints: const BoxConstraints(maxWidth: 450),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Отступ сверху, чтобы элементы были ниже надписи на фоне
                      const SizedBox(height: 200),
                      // Поле Логин (Email)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          constraints: const BoxConstraints(minHeight: 60),
                          decoration: BoxDecoration(
                            color: _lightGreen,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _darkGreen,
                              height: 1.5,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Логин',
                              hintStyle: const TextStyle(
                                color: _darkGreen,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              errorStyle: const TextStyle(
                                height: 0,
                                fontSize: 0,
                              ),
                            ),
                            onChanged: (value) {
                              if (_emailError != null) {
                                setState(() {
                                  _emailError = null;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      // Сообщение об ошибке для email - отдельно под полем
                      if (_emailError != null) ...[
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            _emailError!,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      // Поле Пароль
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          constraints: const BoxConstraints(minHeight: 60),
                          decoration: BoxDecoration(
                            color: _lightGreen,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _darkGreen,
                              height: 1.5,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Пароль',
                              hintStyle: const TextStyle(
                                color: _darkGreen,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: _darkGreen,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              errorStyle: const TextStyle(
                                height: 0,
                                fontSize: 0,
                              ),
                            ),
                            onChanged: (value) {
                              if (_passwordError != null) {
                                setState(() {
                                  _passwordError = null;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      // Сообщение об ошибке для пароля - отдельно под полем
                      if (_passwordError != null) ...[
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            _passwordError!,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                      // Поле "Повторите пароль" только для регистрации
                      if (!_isLogin) ...[
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 60),
                            decoration: BoxDecoration(
                              color: _lightGreen,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _darkGreen,
                                height: 1.5,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Повторите пароль',
                                hintStyle: const TextStyle(
                                  color: _darkGreen,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: _darkGreen,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                                errorStyle: const TextStyle(
                                  height: 0,
                                  fontSize: 0,
                                ),
                              ),
                              onChanged: (value) {
                                if (_confirmPasswordError != null) {
                                  setState(() {
                                    _confirmPasswordError = null;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        // Сообщение об ошибке для подтверждения пароля
                        if (_confirmPasswordError != null) ...[
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                              _confirmPasswordError!,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ],
                      const SizedBox(height: 24),
                      // Ссылка "Зарегистрироваться" или "Назад"
                      GestureDetector(
                        onTap: _isLoading
                            ? null
                            : () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                  // Очищаем поля при переключении режима
                                  if (_isLogin) {
                                    _emailController.clear();
                                    _passwordController.clear();
                                    _confirmPasswordController.clear();
                                    _emailError = null;
                                    _passwordError = null;
                                    _confirmPasswordError = null;
                                  }
                                });
                              },
                        child: Text(
                          _isLogin ? 'Зарегистрироваться' : 'Назад',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF424242),
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFF424242),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Кнопка "ВОЙТИ" или "ЗАРЕГИСТРИРОВАТЬСЯ"
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleAuth,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _buttonBg,
                            foregroundColor: _buttonText,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          _buttonText,
                                        ),
                                  ),
                                )
                              : Text(
                                  _isLogin ? 'ВОЙТИ' : 'ЗАРЕГИСТРИРОВАТЬСЯ',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
