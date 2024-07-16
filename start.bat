::::::::::::::::::::::::::::::::::::::::::::
:: Количество FPS на сервере
SET tickrate=32
:: Порт, на котором будет запущен сервер
SET port=27015
:: ID Workshop-коллекции, которая будет скачана на сервер (но не на клиенты)
SET workshop=3044598688
:: Максимальное количество игроков
SET players=32
:: Гейммод, указать название папки в gamemodes
SET gamemode=breach
:: Карта, без добавления .bsp
SET map=ares_site19_alpha
::::::::::::::::::::::::::::::::::::::::::::

:: Запуск сервера, тут ничего не трогаем
srcds.exe -tickrate "%tickrate%" -port "%port%" -console -game "garrysmod" +host_workshop_collection "%workshop%" +gamemode "%gamemode%" +map "%map%" +maxplayers "%players%"
