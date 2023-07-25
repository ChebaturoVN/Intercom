# Intercom
test_intercom

Макет: https://www.figma.com/file/Gmj3sHThcoQUlEZ5ck4zwM/%D0%A1%D1%82%D0%B0%D0%B6%D0%B8%D1%80%D0%BE%D0%B2%D0%BA%D0%B0-iOS?type=design&node-id=0%3A1&mode=design&t=WQrM7f5G5SWDqqhU-1

Api:
http://cars.cprogroup.ru/api/rubetek/cameras/ - метод получение камер
http://cars.cprogroup.ru/api/rubetek/doors/ - метод получение дверей

Условие:
Кэширование данных в Realm;
Изменение (имя) производим в realm;
При открытие раздела если в базе данных нет, то делаем запрос на сервер, если данные в базе есть то отображаем их + функция принудительного обновления через pullrefresh;
Без использования сторонних либ для ui;
Вся верстка через Interface Builder;
Архитектура MVC;
