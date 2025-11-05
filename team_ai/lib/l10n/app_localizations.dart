import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'ru': {
      // Common
      'app_name': 'TeamAI',
      'loading': 'Загрузка...',
      'error': 'Ошибка',
      'success': 'Успешно',
      'cancel': 'Отмена',
      'save': 'Сохранить',
      'delete': 'Удалить',
      'edit': 'Редактировать',
      'close': 'Закрыть',
      'done': 'Готово',
      'continue': 'Продолжить',
      'skip': 'Пропустить',
      'search': 'Поиск',
      'filter': 'Фильтр',
      'yes': 'Да',
      'no': 'Нет',

      // Auth
      'login': 'Войти',
      'register': 'Зарегистрироваться',
      'logout': 'Выйти',
      'email': 'Email',
      'password': 'Пароль',
      'confirm_password': 'Подтвердите пароль',
      'name': 'Имя',
      'forgot_password': 'Забыли пароль?',
      'login_title': 'Добро пожаловать!',
      'register_title': 'Создать аккаунт',
      'login_error': 'Ошибка входа',
      'register_error': 'Ошибка регистрации',

      // Navigation
      'home': 'Главная',
      'ai_agent': 'AI Агент',
      'calendar': 'Календарь',
      'profile': 'Профиль',

      // Home Dashboard
      'welcome': 'Привет',
      'today_tasks': 'Задачи на сегодня',
      'upcoming_deadlines': 'Ближайшие дедлайны',
      'active_projects': 'Активные проекты',
      'quick_actions': 'Быстрые действия',
      'activity_feed': 'Лента активности',
      'statistics': 'Статистика',
      'create_task': 'Создать задачу',
      'create_project': 'Создать проект',
      'view_all': 'Посмотреть все',
      'no_tasks': 'Нет задач на сегодня',
      'no_projects': 'Нет активных проектов',
      'efficiency': 'Эффективность',
      'tasks_completed': 'Выполнено задач',

      // AI Agent
      'projects': 'Проекты',
      'tasks': 'Задачи',
      'my_tasks': 'Мои задачи',
      'all_tasks': 'Все задачи',
      'project_details': 'Детали проекта',
      'ai_reasoning': 'AI Reasoning',
      'ai_chat': 'AI Чат',
      'no_projects_yet': 'Пока нет проектов',
      'create_first_project': 'Создайте первый проект',
      'team_members': 'Участники команды',
      'progress': 'Прогресс',

      // Calendar
      'add_event': 'Добавить событие',
      'add_task': 'Добавить задачу',
      'event_title': 'Название события',
      'event_description': 'Описание',
      'date': 'Дата',
      'start_time': 'Начало',
      'end_time': 'Конец',
      'reminder': 'Напоминание',
      'category': 'Категория',
      'no_events': 'Нет событий на эту дату',
      'create_with_ai': 'Создать задачу с помощью ИИ',

      // Profile
      'edit_profile': 'Редактировать профиль',
      'my_profile': 'Мой профиль',
      'settings': 'Настройки',
      'skills': 'Навыки',
      'experience': 'Опыт',
      'role': 'Роль',
      'my_teams': 'Мои команды',
      'add_skill': 'Добавить навык',
      'years': 'лет',

      // Settings
      'notifications': 'Уведомления',
      'privacy': 'Конфиденциальность',
      'language': 'Язык',
      'theme': 'Тема',
      'help': 'Помощь',
      'about': 'О приложении',
      'push_notifications': 'Push-уведомления',
      'email_notifications': 'Email уведомления',
      'task_reminders': 'Напоминания о задачах',
      'project_updates': 'Обновления проектов',
      'team_invites': 'Приглашения в команды',
      'show_email': 'Показывать email',
      'show_skills': 'Показывать навыки',
      'allow_search': 'Разрешить поиск',
      'light_theme': 'Светлая',
      'dark_theme': 'Темная',
      'system_theme': 'Системная',
      'faq': 'FAQ',
      'contact_support': 'Связаться с поддержкой',
      'change_password': 'Изменить пароль',
      'delete_account': 'Удалить аккаунт',

      // Chat
      'chat': 'Чат',
      'team_chat': 'Чат команды',
      'send_message': 'Отправить сообщение',
      'type_message': 'Введите сообщение...',
      'no_messages': 'Нет сообщений',

      // Status
      'todo': 'Нужно сделать',
      'in_progress': 'В процессе',
      'completed': 'Выполнено',

      // Priority
      'low': 'Низкий',
      'medium': 'Средний',
      'high': 'Высокий',
      'critical': 'Критичный',
      
      // Task Creation
      'task_title': 'Название задачи',
      'task_description': 'Описание задачи',
      'assign_to': 'Назначить на',
      'add_member': 'Добавить участника',
      'search_by_email': 'Поиск по email',
      'deadline': 'Срок выполнения',
      'priority': 'Приоритет',
      'required_skills': 'Требуемые навыки',
      'assign_member_hint': 'Введите email участника',
      'member_not_found': 'Участник не найден',
      'member_added': 'Участник добавлен',
      
      // Onboarding
      'onboarding_title_1': 'Управление проектами с AI',
      'onboarding_desc_1': 'Используйте искусственный интеллект для оптимального распределения задач',
      'onboarding_title_2': 'Командная работа',
      'onboarding_desc_2': 'Работайте вместе с командой в реальном времени',
      'onboarding_title_3': 'Аналитика и статистика',
      'onboarding_desc_3': 'Отслеживайте прогресс и эффективность команды',
      'get_started': 'Начать',
      
      // Appearance
      'appearance': 'Внешний вид',
      'language_region': 'Язык и регион',
      'russian': 'Русский',
      'kazakh': 'Қазақша',
      'logout_confirm': 'Вы уверены, что хотите выйти?',
      'logout_from_account': 'Выйти из аккаунта',
    },
    'kk': {
      // Common
      'app_name': 'TeamAI',
      'loading': 'Жүктелуде...',
      'error': 'Қате',
      'success': 'Сәтті',
      'cancel': 'Болдырмау',
      'save': 'Сақтау',
      'delete': 'Жою',
      'edit': 'Өңдеу',
      'close': 'Жабу',
      'done': 'Дайын',
      'continue': 'Жалғастыру',
      'skip': 'Өткізіп жіберу',
      'search': 'Іздеу',
      'filter': 'Сүзгі',
      'yes': 'Иә',
      'no': 'Жоқ',

      // Auth
      'login': 'Кіру',
      'register': 'Тіркелу',
      'logout': 'Шығу',
      'email': 'Email',
      'password': 'Құпия сөз',
      'confirm_password': 'Құпия сөзді растаңыз',
      'name': 'Аты',
      'forgot_password': 'Құпия сөзді ұмыттыңыз ба?',
      'login_title': 'Қош келдіңіз!',
      'register_title': 'Аккаунт жасау',
      'login_error': 'Кіру қатесі',
      'register_error': 'Тіркелу қатесі',

      // Navigation
      'home': 'Басты бет',
      'ai_agent': 'AI Агент',
      'calendar': 'Күнтізбе',
      'profile': 'Профиль',

      // Home Dashboard
      'welcome': 'Сәлем',
      'today_tasks': 'Бүгінгі тапсырмалар',
      'upcoming_deadlines': 'Жақын мерзімдер',
      'active_projects': 'Белсенді жобалар',
      'quick_actions': 'Жылдам әрекеттер',
      'activity_feed': 'Белсенділік желісі',
      'statistics': 'Статистика',
      'create_task': 'Тапсырма жасау',
      'create_project': 'Жоба жасау',
      'view_all': 'Барлығын көру',
      'no_tasks': 'Бүгін тапсырмалар жоқ',
      'no_projects': 'Белсенді жобалар жоқ',
      'efficiency': 'Тиімділік',
      'tasks_completed': 'Орындалған тапсырмалар',

      // AI Agent
      'projects': 'Жобалар',
      'tasks': 'Тапсырмалар',
      'my_tasks': 'Менің тапсырмаларым',
      'all_tasks': 'Барлық тапсырмалар',
      'project_details': 'Жоба мәліметтері',
      'ai_reasoning': 'AI Reasoning',
      'ai_chat': 'AI Чат',
      'no_projects_yet': 'Әзірге жобалар жоқ',
      'create_first_project': 'Бірінші жобаны жасаңыз',
      'team_members': 'Топ мүшелері',
      'progress': 'Прогресс',

      // Calendar
      'add_event': 'Оқиға қосу',
      'add_task': 'Тапсырма қосу',
      'event_title': 'Оқиға атауы',
      'event_description': 'Сипаттама',
      'date': 'Күн',
      'start_time': 'Бастау',
      'end_time': 'Аяқтау',
      'reminder': 'Еске салу',
      'category': 'Санат',
      'no_events': 'Бұл күнге оқиғалар жоқ',
      'create_with_ai': 'AI көмегімен тапсырма жасау',

      // Profile
      'edit_profile': 'Профильді өңдеу',
      'my_profile': 'Менің профилім',
      'settings': 'Баптаулар',
      'skills': 'Дағдылар',
      'experience': 'Тәжірибе',
      'role': 'Рөл',
      'my_teams': 'Менің топтарым',
      'add_skill': 'Дағды қосу',
      'years': 'жыл',

      // Settings
      'notifications': 'Хабарландырулар',
      'privacy': 'Құпиялылық',
      'language': 'Тіл',
      'theme': 'Тақырып',
      'help': 'Көмек',
      'about': 'Қолданба туралы',
      'push_notifications': 'Push-хабарландырулар',
      'email_notifications': 'Email хабарландырулар',
      'task_reminders': 'Тапсырмалар туралы еске салу',
      'project_updates': 'Жоба жаңартулары',
      'team_invites': 'Топқа шақырулар',
      'show_email': 'Email көрсету',
      'show_skills': 'Дағдыларды көрсету',
      'allow_search': 'Іздеуге рұқсат беру',
      'light_theme': 'Ашық',
      'dark_theme': 'Қараңғы',
      'system_theme': 'Жүйелік',
      'faq': 'FAQ',
      'contact_support': 'Қолдау қызметіне хабарласу',
      'change_password': 'Құпия сөзді өзгерту',
      'delete_account': 'Аккаунтты жою',

      // Chat
      'chat': 'Чат',
      'team_chat': 'Топ чаты',
      'send_message': 'Хабарлама жіберу',
      'type_message': 'Хабарламаны енгізіңіз...',
      'no_messages': 'Хабарламалар жоқ',

      // Status
      'todo': 'Орындау керек',
      'in_progress': 'Орындалуда',
      'completed': 'Орындалды',

      // Priority
      'low': 'Төмен',
      'medium': 'Орташа',
      'high': 'Жоғары',
      'critical': 'Сыни',
      
      // Task Creation
      'task_title': 'Тапсырма атауы',
      'task_description': 'Тапсырма сипаттамасы',
      'assign_to': 'Тағайындау',
      'add_member': 'Мүше қосу',
      'search_by_email': 'Email бойынша іздеу',
      'deadline': 'Орындау мерзімі',
      'priority': 'Басымдық',
      'required_skills': 'Қажетті дағдылар',
      'assign_member_hint': 'Мүшенің email-ін енгізіңіз',
      'member_not_found': 'Мүше табылмады',
      'member_added': 'Мүше қосылды',
      
      // Onboarding
      'onboarding_title_1': 'AI көмегімен жобаларды басқару',
      'onboarding_desc_1': 'Тапсырмаларды оңтайлы бөлу үшін жасанды интеллектті пайдаланыңыз',
      'onboarding_title_2': 'Топтық жұмыс',
      'onboarding_desc_2': 'Топпен нақты уақытта бірге жұмыс істеңіз',
      'onboarding_title_3': 'Аналитика және статистика',
      'onboarding_desc_3': 'Топтың прогресі мен тиімділігін қадағалаңыз',
      'get_started': 'Бастау',
      
      // Appearance
      'appearance': 'Сыртқы түрі',
      'language_region': 'Тіл және аймақ',
      'russian': 'Орысша',
      'kazakh': 'Қазақша',
      'logout_confirm': 'Шығуға сенімдісіз бе?',
      'logout_from_account': 'Аккаунттан шығу',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  // Helpers
  String get appName => translate('app_name');
  String get loading => translate('loading');
  String get error => translate('error');
  String get success => translate('success');
  String get cancel => translate('cancel');
  String get save => translate('save');
  String get delete => translate('delete');
  String get edit => translate('edit');
  String get close => translate('close');
  String get done => translate('done');
  
  // Auth
  String get login => translate('login');
  String get register => translate('register');
  String get logout => translate('logout');
  String get email => translate('email');
  String get password => translate('password');
  
  // Navigation
  String get home => translate('home');
  String get aiAgent => translate('ai_agent');
  String get calendar => translate('calendar');
  String get profile => translate('profile');
  
  // Home
  String get welcome => translate('welcome');
  String get todayTasks => translate('today_tasks');
  String get upcomingDeadlines => translate('upcoming_deadlines');
  String get activeProjects => translate('active_projects');
  String get createTask => translate('create_task');
  String get createProject => translate('create_project');
  String get aiChat => translate('ai_chat');
  
  // Settings
  String get settings => translate('settings');
  String get notifications => translate('notifications');
  String get privacy => translate('privacy');
  String get language => translate('language');
  String get theme => translate('theme');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ru', 'kk'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
