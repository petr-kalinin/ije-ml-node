React = require('react')

export default LANG = 
    name: "RUS"

    NoContestsRunning: "Контестов нет"
    StatusUnknown: "Состояние неизвестно"
    TimeOfTime: (a, b) -> "#{a} из #{b}"
    NotLoggedIn: "Вы не вошли"
    LogIn: "Войти"
    ChangeContest: "Сменить контест"
    ChangeContestSuccessfull: "Смена контеста удачна"
    LoggedAsSbToSth: (a, b) -> <span>Вы вошли как {a} в {b}</span>
    LogOut: "Log out"
    ThisIsIJE: 'This is IJEml:http version %s (IJE %s) running on %s<br/>'
    PageGeneratedAtTime: "Page generated at %s"
    LoginError: "Ошибка входа в систему"
    Error: "Ошибка"
    UnknownTeamName: "Неизвестное название команды"
    UnknownContest: "Неизвестный контест"
    TryToDo: "Попробуйте %s"
    relogin: 'заново войти в систему'
    WrongLoginPassword: 'Неверный пароль для входа в систему'
    SthRequiredToAccess: "Чтобы просмотреть эту страницу, необходимо %s"
    LoginForReq: "войти в систему"
    Login: "Имя"
    Home: "Инфо"
    ContestName: "Название контеста"
    ContestFormat: "Формат контеста"
    MonitorMessagesTime: "Время монитора и сообщений"
    ContestLength: "Длительность контеста"
    ContestStatus: "Состояние контеста"
    NumberOfProblems: "Количество задач"
    NumberOfTeams: "Количество команд"
    NumberOfAllowedLanguages: "Количество разрешенных языков программирования"
    StrangeMonitorTime: "Странное время монитора; возможно, IJE не запущена"
    monitorStatus: "состояние контеста из монитора"
    Contest: "Контест"
    LoginSuccessfull: "Вход в систему успешно выполнен"
    LoginRejected: "Вход в систему отклонен"
    Password: "Пароль"
    LogOut: "Выйти"
    LogoutSuccessfull: "Выход из системы успешно завершен"

    MessageDetails: 'Подробности сообщения'
    Messages: 'Сообщения'
    ClickOnMessageTime: "Щелкните на времени сообщения, чтобы просмотреть его подробности"
    SortBy: "Сортировать по:"
    time: "времени"
    problem: "задаче"
    Time: "Время"
    Problem: "Задача"
    NoSubmissions: "Нет попыток"
    Test: "Тест"

    Standings: "Результаты"
    CurrentStandings: 'Текущие результаты'
    HideSuccessTimes: "Спрятать время успешных сдач"
    ShowSuccessTimes: "Показать время успешных сдач"
    Id: "Id"
    Party: "Команда/участник"

    SelectTheProblemFirst: "Выберите задачу"
    SelectTheLanguageFirst: "Выберите язык"
    Submit: "Сдать решение"
    ErrorUploadedFile: "An error occured while moving uploaded file"
    SubmitFailed: "Не удалось послать решение на проверку"
    NoResponseFromIJE: 'IJE не отвечает'
    SubmitSuccessfull: "Решение успешно сдано"
    YourSolutionHasBeen: "Ваше решение было успешно послано на проверку. Удачи!"
    YouCanSee: "Вы сможете просмотреть результаты тестирования на странице \"%s\""

    AnErrorOccured: 'Ошибка'
    SelectTheProblem: "Выберите задачу"
    Language: "Язык программирования"
    SelectTheLanguage: "Выберите язык"
    ProgramText: "Текст программы"
    OR: "ИЛИ"
    FileWithSolution: 'Файл с решением'

    Statements: "Условия"

export LTEXT = 
    'OK': 'Зачтено',
    'WA': 'Неверный ответ',
    'PE': 'Нарушен формат выходных данных',
    'TL': 'Превышен предел времени исполнения',
    'ML': 'Превышен предел памяти',
    'OL': 'Превышен предел размера выходного файла',
    'IL': 'Превышен предел времени простоя',
    'RE': 'Ненулевой код возврата',
    'CR': 'Недопустимая операция', 
    'SV': 'Нарушение правил',
    'NC': 'Не зачтено',
    'CE': 'Ошибка компиляции',
    'NS': "Задача не сдавалась",
    'CP': "Скомпилировано",
    'FL': 'Ошибка тестирующей системы',
    'NT': 'Не протестировано'
