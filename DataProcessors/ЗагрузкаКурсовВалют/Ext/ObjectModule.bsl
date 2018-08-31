﻿Перем ИмяФайла;

Перем СерверИсточник;
Перем СтрокаПараметраПолучения;
Перем ИмяВходящегоФайла;

Перем ОшибкаКодаСервера;

#Если Клиент Тогда

// Выделяет из переданной строки первое значение
 //  до символа "TAB"
 //
 // Параметры: 
 //  ИсходнаяСтрока - Строка - строка для разбора
 //
 // Возвращаемое значение:
 //  подстроку до символа "TAB"
 //
Функция ВыделитьПодСтроку(ИсходнаяСтрока)

	Перем ПодСтрока;
	
    Поз = Найти(ИсходнаяСтрока,Символы.Таб);
	Если Поз > 0 Тогда
		ПодСтрока = Лев(ИсходнаяСтрока,Поз-1);
		ИсходнаяСтрока = Сред(ИсходнаяСтрока,Поз+1);
	Иначе
		ПодСтрока = ИсходнаяСтрока;
		ИсходнаяСтрока = "";
	КонецЕсли;
	
	Возврат ПодСтрока;
 
 КонецФункции // ВыделитьПодСтроку()

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТИРУЕМЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ


// Производит загрузку курсов и кратностей валют с сайта finance.ua по ежедневным настройкам
//
Функция КодДоступаАктуален() Экспорт
	
	Перем HTTP;
	
	ЗначениеКонстанты = Константы.НастройкиЗагрузкиКурсовВалют.Получить();
	Настройки 		  = ЗначениеКонстанты.Получить();
	
	Если ПустаяСтрока(Настройки.КодДоступа) Тогда
		Возврат Ложь;
	КонецЕсли;
	КодДоступа = Настройки.КодДоступа;
	
	//пытаемся прочитать вчерашний курс
 	КонДата = ТекущаяДата()-60*60*24;

	ЗапомнитьИмяИПароль = Настройки.ЗапомнитьИмяИПароль;

	Если ЗапомнитьИмяИПароль Тогда
		ИмяПользователя 	= Настройки.ИмяПользователя;
		ПарольПользователя 	= Настройки.ПарольПользователя;
	КонецЕсли;
	
	СерверИсточник = "fin.1c.ua";

	Код = "?"+КодДоступа;
	Адрес = "1c/";     // по 1 дате
	ТМП   = "/"+Формат(Год(КонДата),"ЧРГ=; ЧГ=0")+"/"+Формат(Месяц(КонДата),"ЧЦ=2;ЧДЦ=0;ЧВН=")+"/"+Формат(День(КонДата),"ЧЦ=2;ЧДЦ=0;ЧВН=");

	ВремКаталог = КаталогВременныхФайлов() + "tempKurs";
	СоздатьКаталог(ВремКаталог);
	УдалитьФайлы(ВремКаталог,"*.*");
	
	ИмяВходящегоФайла = "" + ВремКаталог + "\" + ИмяФайла;
	СтрокаПараметраПолучения = Адрес + "840" + ТМП + ".tsv" + СокрЛП(Код);
	Возврат ЗапроситьФайлыССервера(СерверИсточник, СтрокаПараметраПолучения, ИмяВходящегоФайла, HTTP);
	

КонецФункции // ПроверитьАктуальностьКодаДоступа()

// Производит загрузку курсов и кратностей валют с сайта finance.ua по ежедневным настройкам
//
Процедура ЗагрузитьКурсыПоНастройкам() Экспорт
	
	ЗначениеКонстанты = Константы.НастройкиЗагрузкиКурсовВалют.Получить();
	Настройки 		  = ЗначениеКонстанты.Получить();
	
	НачДата = ТекущаяДата();
	КонДата = ТекущаяДата();

	ЗапомнитьИмяИПароль = Настройки.ЗапомнитьИмяИПароль;

	Если ЗапомнитьИмяИПароль Тогда
		ИмяПользователя 	= Настройки.ИмяПользователя;
		ПарольПользователя 	= Настройки.ПарольПользователя;
	КонецЕсли;
	
	КодДоступа = Настройки.КодДоступа;
	
	Валюты = Настройки.СписокВалют;
	СписокВалют.Очистить();
	Для сч=0 По Валюты.Количество()-1 Цикл
		Вал = СписокВалют.Добавить();
		Вал.Валюта = Валюты[сч];
		Вал.Пометка = Истина;
	КонецЦикла;
	
	ЗагрузитьКурсы(,,Истина);

КонецПроцедуры // ЗагрузитьКурсыПоНастройкам()

// Производит загрузку курсов и кратностей валют с сайта finance.ua
//
// Параметры:
//  ИндикаторФормы     - ЭлементыФормы типа Индикатор - для отработки индикатора формы
//  НадписьВалютыФормы - ЭлементыФормы типа Надпись  - Для отработки надписи 
//													   загружаемой валюты
//
Процедура ЗагрузитьКурсы(ИндикаторФормы = Неопределено , НадписьВалютыФормы = Неопределено, ВыводитьСообщения = Ложь ) Экспорт
	
	Перем HTTP;
	
	РегистрКурсыВалют = РегистрыСведений.КурсыВалют;
	ЗаписьКурсовВалют = РегистрКурсыВалют.СоздатьМенеджерЗаписи();

	Текст = Новый ТекстовыйДокумент();

	СерверИсточник = "fin.1c.ua";

	Адрес1 = "1c/cb/";  // в интервале
	Адрес2 = "1c/";     // по 1 дате
	
	Код = ?(КодДоступа <> Неопределено, "?"+КодДоступа, "");
	
	Если НачДата = КонДата Тогда  // по 1 дате
		Адрес = Адрес2;
		ТМП   = "/"+Формат(Год(КонДата),"ЧРГ=; ЧГ=0")+"/"+Формат(Месяц(КонДата),"ЧЦ=2;ЧДЦ=0;ЧВН=")+"/"+Формат(День(КонДата),"ЧЦ=2;ЧДЦ=0;ЧВН=");
	Иначе    // в интервале
		Адрес = Адрес1;
		ТМП   = "";
	КонецЕсли;

	ВремКаталог = КаталогВременныхФайлов() + "tempKurs";
	СоздатьКаталог(ВремКаталог);
	УдалитьФайлы(ВремКаталог,"*.*");
	
	Для каждого СтрокаСпВалют из СписокВалют Цикл
		Если НЕ СтрокаСпВалют.Пометка Тогда
			Продолжить;	
		КонецЕсли;
		
		ТекВалюта = СтрокаСпВалют.Валюта;
		Стр = "";
		
		Если ВыводитьСообщения Тогда 
			Сообщить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Загружается курс для %1 (код %2).';uk='Завантажується курс для %1 (код %2).'"), СокрЛП(ТекВалюта.Наименование), ТекВалюта.Код)); 	
		КонецЕсли;
		
		ИмяВходящегоФайла = "" + ВремКаталог + "\" + ИмяФайла;
		СтрокаПараметраПолучения = Адрес + Прав(ТекВалюта.Код,3) + ТМП + ".tsv" + СокрЛП(Код);
		Если ЗапроситьФайлыССервера(СерверИсточник, СтрокаПараметраПолучения, ИмяВходящегоФайла, HTTP) <> Истина Тогда
			Сообщить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не удалось получить ресурс для валюты %1 (код %2). Курс для валюты не загружен.';uk='Не вдалося одержати ресурс для валюти %1 (код %2). Курс для валюти не завантажений.'"), СокрЛП(ТекВалюта.Наименование), ТекВалюта.Код)); 
			Если ОшибкаКодаСервера Тогда
				Прервать;
			КОнецЕсли;
			Продолжить;
		КонецЕсли; 

		ВходящийФайл = Новый Файл(ИмяВходящегоФайла);
		Если НЕ ВходящийФайл.Существует() Тогда
			Сообщить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не удалось получить ресурс для валюты %1 (код %2). Курс для валюты не загружен.';uk='Не вдалося одержати ресурс для валюти %1 (код %2). Курс для валюти не завантажений.'"), СокрЛП(ТекВалюта.Наименование), ТекВалюта.Код)); 
			Продолжить;
		КонецЕсли;	

		Текст.Прочитать(ИмяВходящегоФайла,КодировкаТекста.ANSI);
		
		КолСтрок = Текст.КоличествоСтрок();
		Для Инд = 1 По КолСтрок Цикл
			НадписьВалютыФормы = СокрЛП(ТекВалюта.Наименование);

			ИндикаторФормы = Инд/КолСтрок * 100;
				
			Стр = Текст.ПолучитьСтроку(Инд);
			Если (Стр = "") ИЛИ (Найти(Стр,Символы.Таб) = 0) Тогда
			   Продолжить;
			КонецЕсли;
			Если НачДата = КонДата Тогда  
			   ДатаКурса = КонДата;
			Иначе 
			   ДатаКурсаСтр = ВыделитьПодСтроку(Стр);
			   ДатаКурса    = Дата(Лев(ДатаКурсаСтр,4),Сред(ДатаКурсаСтр,5,2),Сред(ДатаКурсаСтр,7,2));
			КонецЕсли;
			Кратность = Число(ВыделитьПодСтроку(Стр));
			Курс      = Число(ВыделитьПодСтроку(Стр));

			Если ДатаКурса > КонДата Тогда
			   Прервать;
			КонецЕсли;

			Если ДатаКурса < НачДата Тогда 
			   Продолжить;
			КонецЕсли;

            ЗаписьКурсовВалют.Валюта = ТекВалюта;
			ЗаписьКурсовВалют.Период = ДатаКурса;
			ЗаписьКурсовВалют.Прочитать();
			ЗаписьКурсовВалют.Валюта    = ТекВалюта;
			ЗаписьКурсовВалют.Период    = ДатаКурса;
			ЗаписьКурсовВалют.Курс      = Курс;
			ЗаписьКурсовВалют.Кратность = Кратность;
			ЗаписьКурсовВалют.Записать();
		КонецЦикла;
		
		Если ВыводитьСообщения Тогда 
			Сообщить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Курс для %1 (код %2) загружен.';uk='Курс для %1 (код %2) завантажений.'"), СокрЛП(ТекВалюта.Наименование), ТекВалюта.Код)); 	
		КонецЕсли;
		
	КонецЦикла;	
	УдалитьФайлы(ВремКаталог,"*.*");

КонецПроцедуры // ЗагрузитьКурсы()

// Производит загрузку курсов и кратностей валют с диска ИТС
//
// Параметры:
//  ИндикаторФормы     - ЭлементыФормы типа Индикатор - для отработки индикатора формы
//  НадписьВалютыФормы - ЭлементыФормы типа Надпись  - Для отработки надписи 
//													   загружаемой валюты
//
Процедура ЗагрузитьКурсыСИТС(ИндикаторФормы = Неопределено ,НадписьВалютыФормы = Неопределено, ВыводитьСообщения = Ложь ) Экспорт
	Если БукваДиска = "" Тогда 
		Сообщить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не указана буква привода дисков CD-ROM.';uk='Не зазначена буква приводу дисків CD-ROM.'"))); 
	Иначе
	
		Если (ИндикаторФормы = Неопределено) И (НадписьВалютыФормы = Неопределено) Тогда
			ЗначениеКонстанты = Константы.НастройкиЗагрузкиКурсовВалют.Получить();
			Если ЗначениеКонстанты <> Неопределено Тогда
				Настройки = ЗначениеКонстанты.Получить();
			КонецЕсли;
			Валюты = Настройки.СписокВалют;
			СписокВалют.Очистить();
			Для сч=0 По Валюты.Количество()-1 Цикл
				Вал = СписокВалют.Добавить();
				Вал.Валюта = Валюты[сч];
				Вал.Пометка = Истина;
			КонецЦикла;
		КонецЕсли;
		
		РегистрКурсыВалют = РегистрыСведений.КурсыВалют;
		ЗаписьКурсовВалют = РегистрКурсыВалют.СоздатьМенеджерЗаписи();

		Текст = Новый ТекстовыйДокумент();
			
		Адрес = БукваДиска + ":\1CIts\EXE\Finance\";

		ВремКаталог = КаталогВременныхФайлов() + "tempKurs";
		СоздатьКаталог(ВремКаталог);
		УдалитьФайлы(ВремКаталог,"*.*");
		
		Для каждого СтрокаСпВалют из СписокВалют Цикл
            Если НЕ СтрокаСпВалют.Пометка Тогда
				Продолжить;	
			КонецЕсли;
			
			ТекВалюта = СтрокаСпВалют.Валюта;
			Стр = "";
			
			Если ВыводитьСообщения Тогда 
				Сообщить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Загружается курс для %1 (код %2).';uk='Завантажується курс для %1 (код %2).'"), СокрЛП(ТекВалюта.Наименование), ТекВалюта.Код)); 	
			КонецЕсли;
			
			СтрокаПараметраПолучения = Адрес + Прав(ТекВалюта.Код,3) + ".tsv";

			ВходящийФайл = Новый Файл(СтрокаПараметраПолучения);
			Если НЕ ВходящийФайл.Существует() Тогда
				Сообщить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не удалось получить ресурс для валюты %1 (код %2). Курс для валюты не загружен.';uk='Не вдалося одержати ресурс для валюти %1 (код %2). Курс для валюти не завантажений.'"), СокрЛП(ТекВалюта.Наименование), ТекВалюта.Код)); 
				Продолжить;
			КонецЕсли;	

			Текст.Прочитать(СтрокаПараметраПолучения,КодировкаТекста.ANSI);
			
			КолСтрок = Текст.КоличествоСтрок();
			Для Инд = 1 По КолСтрок Цикл
				НадписьВалютыФормы = СокрЛП(ТекВалюта.Наименование);

				ИндикаторФормы = Инд/КолСтрок * 100;
					
				Стр = Текст.ПолучитьСтроку(Инд);
				Если (Стр = "") ИЛИ (Найти(Стр,Символы.Таб) = 0) Тогда
				   Продолжить;
				КонецЕсли;
				Если НачДата = КонДата Тогда  
				   ДатаКурса = КонДата;
				   // В случае ИТСа формат строки такой же как и за период (3 значения) - 20120428	100	798.9900
				   Если СтрЧислоВхождений(СокрЛП(Стр), Символы.Таб) = 2 Тогда
					   // ДатаКурсаСтр
					   ВыделитьПодСтроку(Стр);
				   КонецЕсли;	
				Иначе 
				   ДатаКурсаСтр = ВыделитьПодСтроку(Стр);
				   ДатаКурса    = Дата(Лев(ДатаКурсаСтр,4),Сред(ДатаКурсаСтр,5,2),Сред(ДатаКурсаСтр,7,2));
				КонецЕсли;
				Кратность = Число(ВыделитьПодСтроку(Стр));
				Курс      = Число(ВыделитьПодСтроку(Стр));

				Если ДатаКурса > КонДата Тогда
				   Прервать;
				КонецЕсли;

				Если ДатаКурса < НачДата Тогда 
				   Продолжить;
				КонецЕсли;

	            ЗаписьКурсовВалют.Валюта = ТекВалюта;
				ЗаписьКурсовВалют.Период = ДатаКурса;
				ЗаписьКурсовВалют.Прочитать();
				ЗаписьКурсовВалют.Валюта    = ТекВалюта;
				ЗаписьКурсовВалют.Период    = ДатаКурса;
				ЗаписьКурсовВалют.Курс      = Курс;
				ЗаписьКурсовВалют.Кратность = Кратность;
				ЗаписьКурсовВалют.Записать();
			КонецЦикла;
			
			Если ВыводитьСообщения Тогда 
				Сообщить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Курс для %1 (код %2) загружен.';uk='Курс для %1 (код %2) завантажений.'"), СокрЛП(ТекВалюта.Наименование), ТекВалюта.Код)); 	
			КонецЕсли;
			
		КонецЦикла;	
		УдалитьФайлы(ВремКаталог,"*.*");
	КонецЕсли;

КонецПроцедуры // ЗагрузитьКурсы()

////////////////////////////////////////////////////////////////////////////////

// Функция создает HTTP соединение используя параметры
// Прокси-сервера, вводимые пользователем
//
// Возвращаемое значение:
//   HTTPСоединение
//
Функция СоздатьСоединение()

	Перем HTTP;
	Перем ПроксиСервер;
	
	Если ЗначениеЗаполнено(ИмяПользователя) Тогда
		ПроксиСервер = Новый ИнтернетПрокси();
		ПроксиСервер.Пользователь = ИмяПользователя;
		ПроксиСервер.Пароль       = ПарольПользователя;
		HTTP = Новый HTTPСоединение(СерверИсточник,,,, ПроксиСервер);
	Иначе
		HTTP = Новый HTTPСоединение(СерверИсточник);
	КонецЕсли;
	
	Возврат HTTP;
	
КонецФункции

// Функция получает файлы с сервера с указанными параметрами и сохраняет на диск
//
// Параметры:
// СерверИсточникПараметр - Строка, сервер, с которого необходимо получить файлы
// СтрокаПараметраПолученияПараметр - Строка, адрес ресурса на сервере.
// ИмяВходящегоФайлаПараметр - Имя файла, в который помещаются данные полученного ресурса.
// HTTP - HTTPСоединение, если приходится использовать данную функцию в цикле, то тут передается
//         переменная с созданным в предыдущей итерации цикла HTTPСоединением
//
// Возвращаемое значение:
//  Булево - Успешно получены файлы или нет.
//
Функция ЗапроситьФайлыССервера(СерверИсточникПараметр, СтрокаПараметраПолученияПараметр, ИмяВходящегоФайлаПараметр, HTTP = Неопределено)
	
	СерверИсточник           = СерверИсточникПараметр;
	СтрокаПараметраПолучения = СтрокаПараметраПолученияПараметр;
	ИмяВходящегоФайла        = ИмяВходящегоФайлаПараметр;
	Заголовки = "";
	ФормаОшибки = ЭтотОбъект.ПолучитьФорму("ФормаОшибки"); 
	
	Если ТипЗнч(HTTP) <> Тип("HTTPСоединение") Тогда
		HTTP = СоздатьСоединение();
	КонецЕсли; 
	
	Попытка
		HTTP.Получить(СтрокаПараметраПолучения, ИмяВходящегоФайла);
		Возврат Истина;
	Исключение
		СтрОписаниеОшибки = ОписаниеОшибки(); 
		Если ПустаяСтрока(СтрОписаниеОшибки) <> 0 Тогда
			ФормаОшибки.Панель.ТекущаяСтраница = ФормаОшибки.Панель.Страницы.Страница0;
			ОшибкаКодаСервера = Истина;
			ФормаОшибки.ОткрытьМодально();
		ИначеЕсли Найти(СтрОписаниеОшибки, "407") <> 0 И Найти(НРег(СтрОписаниеОшибки), "unauthorized") <> 0 Тогда
			ФормаОшибки.Панель.ТекущаяСтраница = ФормаОшибки.Панель.Страницы.Страница407;
			ОшибкаКодаСервера = Истина;
			ФормаОшибки.ОткрытьМодально();
		ИначеЕсли Найти(СтрОписаниеОшибки, "402") <> 0 Тогда
			ФормаОшибки.Панель.ТекущаяСтраница = ФормаОшибки.Панель.Страницы.Страница402;
			ОшибкаКодаСервера = Истина;
			ФормаОшибки.ОткрытьМодально();
		ИначеЕсли Найти(СтрОписаниеОшибки, "403") <> 0 Тогда
			ФормаОшибки.Панель.ТекущаяСтраница = ФормаОшибки.Панель.Страницы.Страница403;
			ОшибкаКодаСервера = Истина;
			ФормаОшибки.ОткрытьМодально();
		ИначеЕсли Найти(СтрОписаниеОшибки, "500") <> 0 Тогда
			ФормаОшибки.Панель.ТекущаяСтраница = ФормаОшибки.Панель.Страницы.Страница500;
			ОшибкаКодаСервера = Истина;
			ФормаОшибки.ОткрытьМодально();
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецПопытки;

КонецФункции

Процедура ОткрытьСайтФинансУа() Экспорт
	ЗапуститьПриложение("http://1c.finance.ua");
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

ИмяФайла = "Curses.html"; 
ОшибкаКодаСервера = Ложь;

#КонецЕсли
