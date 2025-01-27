# Weather

### Тех. задание

Написать клиент для сайта https://openweathermap.org/api
Приложение должно состоять из 2 экранов, объединенных одним нижним меню

1-ый экран – поиск городов. Должен состоять из поля ввода имени города и кнопки выбрать. Пользователь должен найти и добавить город. Пользователь может добавить несколько городов
2-ой экран должен выводить список добавленных городов со следующими параметрами: название города, температура, скорость ветра, направление ветра(юг, запад, восток, северо-восток и тд). Удалять города, обновлять данные (потянув экран вниз - pull)

#### Требования к платформе:

- Swift
- Хранилище данных: любое
- Можно использовать GPS для нахождения местоположения
- Запросы должны быть асинхронные, должен показываться индикатор загрузки (любой)

### Ограничения бесплатного доступа к APi

- 60 запросов в минуту
- Прогноз с интервалом в 3 часа