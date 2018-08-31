﻿///////////////////////////////////////////////////////////////////////////////
//// БЛОК НАСТРОЙКИ ПАРАМЕТРОВ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Параметры.Свойство("Идентификатор", Идентификатор);
	Заголовок = НСтр("ru='ДП'") + " """ + Строка(Идентификатор) + """";

	ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
	ЦветОшибки = ЦветаСтиля.ЦветОтрицательногоЧисла;

	СпМодель = Элементы.Модель.СписокВыбора;
	СпМодель.Добавить("Datecs DPD-201");
	СпМодель.Добавить("EPSON-совместимый");
	СпМодель.Добавить("EPSON-совместимый (USA)");
	СпМодель.Добавить("Меркурий ДП-01");
	СпМодель.Добавить("Меркурий ДП-02");
	СпМодель.Добавить("Меркурий ДП-03");
	СпМодель.Добавить("Flytech");
	СпМодель.Добавить("GIGATEK DSP800");
	СпМодель.Добавить("GIGATEK DSP850A");
	СпМодель.Добавить("Штрих-FrontMaster");
	СпМодель.Добавить("Posiflex PD2300 USB");
	СпМодель.Добавить("IPC");
	СпМодель.Добавить("GIGATEK DSP820");
	СпМодель.Добавить("TEC LIUST-51");
	СпМодель.Добавить("Демо-дисплей");

	СпПорт = Элементы.Порт.СписокВыбора;
	Для Номер = 1 По 32 Цикл
		СпПорт.Добавить(Номер, "COM" + Формат(Номер, "ЧЦ=2; ЧДЦ=0; ЧН=0; ЧГ=0"));
	КонецЦикла;
	СпПорт.Добавить(101, "ComProxy 1");
	СпПорт.Добавить(102, "ComProxy 2");

	СпСкорость = Элементы.Скорость.СписокВыбора;
	СпСкорость.Добавить(4,  "2400");
	СпСкорость.Добавить(5,  "4800");
	СпСкорость.Добавить(7,  "9600");
	СпСкорость.Добавить(9,  "14400");
	СпСкорость.Добавить(10, "19200");

	СпЧетность = Элементы.Четность.СписокВыбора;
	СпЧетность.Добавить(0, НСтр("ru='Нет'"));
	СпЧетность.Добавить(1, НСтр("ru='Нечетность'"));
	СпЧетность.Добавить(2, НСтр("ru='Четность'"));
	СпЧетность.Добавить(3, НСтр("ru='Установлен'"));
	СпЧетность.Добавить(4, НСтр("ru='Сброшен'"));

	СпБитыДанных = Элементы.БитыДанных.СписокВыбора;
	СпБитыДанных.Добавить(3, "7 бит");
	СпБитыДанных.Добавить(4, "8 бит");

	СпСтопБиты = Элементы.СтопБиты.СписокВыбора;
	СпСтопБиты.Добавить(0, "1 бит");
	СпСтопБиты.Добавить(2, "2 бита");

	СпКодировка = Элементы.Кодировка.СписокВыбора;
	СпКодировка.Добавить(437, НСтр("ru='437 (OEM - США)'"));
	СпКодировка.Добавить(850, НСтр("ru='850 (OEM - многоязычная латиница 1)'"));
	СпКодировка.Добавить(852, НСтр("ru='852 (OEM - кириллица традиционная)'"));
	СпКодировка.Добавить(860, НСтр("ru='860 (OEM - португальский)'"));
	СпКодировка.Добавить(863, НСтр("ru='863 (OEM - франко-канадский)'"));
	СпКодировка.Добавить(865, НСтр("ru='865 (OEM - скандинавский)'"));
	СпКодировка.Добавить(866, НСтр("ru='866 (OEM - русский)'"));
	СпКодировка.Добавить(932, НСтр("ru='932 (ANSI/OEM - японский Shift-JIS)'"));
	СпКодировка.Добавить(988, "988 (ASCII)");


	времПорт            = Неопределено;
	времСкорость        = Неопределено;
	времЧетность        = Неопределено;
	времБитыДанных      = Неопределено;
	времСтопБиты        = Неопределено;
	времКодировка       = Неопределено;
	времЗагружатьШрифты = Неопределено;
	времМодель          = Неопределено;

	Параметры.Свойство("Порт",            времПорт);
	Параметры.Свойство("Скорость",        времСкорость);
	Параметры.Свойство("Четность",        времЧетность);
	Параметры.Свойство("БитыДанных",      времБитыДанных);
	Параметры.Свойство("СтопБиты",        времСтопБиты);
	Параметры.Свойство("Кодировка",       времКодировка);
	Параметры.Свойство("ЗагружатьШрифты", времЗагружатьШрифты);
	Параметры.Свойство("Модель",          времМодель);

	Порт            = ?(времПорт            = Неопределено,    1, времПорт);
	Скорость        = ?(времСкорость        = Неопределено,    7, времСкорость);
	Четность        = ?(времЧетность        = Неопределено,    0, времЧетность);
	БитыДанных      = ?(времБитыДанных      = Неопределено,    4, времБитыДанных);
	СтопБиты        = ?(времСтопБиты        = Неопределено,    0, времСтопБиты);
	Кодировка       = ?(времКодировка       = Неопределено,  866, времКодировка);
	ЗагружатьШрифты = ?(времЗагружатьШрифты = Неопределено, Ложь, времЗагружатьШрифты);

	Модель          = ?(времМодель          = Неопределено, Элементы.Модель.СписокВыбора[0], времМодель);

	Элементы.ТестУстройства.Видимость    = (ПараметрыСеанса.РабочееМестоКлиента
	                                        = Строка(Идентификатор.РабочееМесто));
	Элементы.УстановитьДрайвер.Видимость = (ПараметрыСеанса.РабочееМестоКлиента
	                                        = Идентификатор.РабочееМесто);

КонецПроцедуры

// Процедура - обработчик события "Перед открытием" формы.
//
// Параметры:
//  Отказ                - <Булево>
//                       - Признак отказа от открытия формы. Если в теле
//                         процедуры-обработчика установить данному параметру
//                         значение Истина, открытие формы выполнено не будет.
//                         Значение по умолчанию: Ложь 
//
//  СтандартнаяОбработка - <Булево>
//                       - В данный параметр передается признак выполнения
//                         стандартной (системной) обработки события. Если в
//                         теле процедуры-обработчика установить данному
//                         параметру значение Ложь, стандартная обработка
//                         события производиться не будет. Отказ от стандартной
//                         обработки не отменяет открытие формы.
//                         Значение по умолчанию: Истина 
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ОбновитьИнформациюОДрайвере();

	УстановитьДоступностьЭлементов();

КонецПроцедуры // ПередОткрытием()

// Процедура представляет обработчик события "Нажатие" кнопки
// "ОК" командной панели "ОсновныеДействияФормы".
//
// Параметры:
//  Кнопка - <КнопкаКоманднойПанели>
//         - Кнопка, с которой связано данное событие (кнопка "ОК").
//
&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()

	Параметры.ПараметрыНастройки.Добавить(Порт            , "Порт");
	Параметры.ПараметрыНастройки.Добавить(Скорость        , "Скорость");
	Параметры.ПараметрыНастройки.Добавить(Четность        , "Четность");
	Параметры.ПараметрыНастройки.Добавить(БитыДанных      , "БитыДанных");
	Параметры.ПараметрыНастройки.Добавить(СтопБиты        , "СтопБиты");
	Параметры.ПараметрыНастройки.Добавить(Кодировка       , "Кодировка");
	Параметры.ПараметрыНастройки.Добавить(ЗагружатьШрифты , "ЗагружатьШрифты");
	Параметры.ПараметрыНастройки.Добавить(Модель          , "Модель");

	ОчиститьСообщения();
	Закрыть(КодВозвратаДиалога.ОК);

КонецПроцедуры // ОсновныеДействияФормыОК()

&НаКлиенте
Процедура УстановитьДрайвер(Команда)

	МенеджерОборудованияКлиент.УстановитьДрайвер(Идентификатор);

	ОбновитьИнформациюОДрайвере();

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
//// ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура УстановитьДоступностьЭлементов()

	ДоступностьЗагружатьШрифты = (Модель = "EPSON-совместимый")
							 Или (Модель = "Posiflex PD2300 USB")
							 Или (Модель = "Штрих-FrontMaster");

	ДоступностьПараметрыПорта  = (Модель <> "Posiflex PD2300 USB")
							   И (Модель <> "Демо-дисплей");

	Элементы.ЗагружатьШрифты.Доступность   = ДоступностьЗагружатьШрифты;
	Элементы.Порт.Доступность              = ДоступностьПараметрыПорта;
	Элементы.Скорость.Доступность          = ДоступностьПараметрыПорта;
	Элементы.Четность.Доступность          = ДоступностьПараметрыПорта;
	Элементы.БитыДанных.Доступность        = ДоступностьПараметрыПорта;
	Элементы.СтопБиты.Доступность          = ДоступностьПараметрыПорта;

КонецПроцедуры

&НаКлиенте
Процедура МодельПриИзменении(Элемент)

	УстановитьДоступностьЭлементов();

КонецПроцедуры

&НаКлиенте
Процедура ТестУстройства(Команда)

	РезультатТеста = Неопределено;

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"           , Порт);
	времПараметрыУстройства.Вставить("Скорость"       , Скорость);
	времПараметрыУстройства.Вставить("Четность"       , Четность);
	времПараметрыУстройства.Вставить("БитыДанных"     , БитыДанных);
	времПараметрыУстройства.Вставить("СтопБиты"       , СтопБиты);
	времПараметрыУстройства.Вставить("Кодировка"      , Кодировка);
	времПараметрыУстройства.Вставить("ЗагружатьШрифты", ЗагружатьШрифты);
	времПараметрыУстройства.Вставить("Модель"         , Модель);

	Результат = МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("CheckHealth",
	                                                                      ВходныеПараметры,
	                                                                      ВыходныеПараметры,
	                                                                      Идентификатор,
	                                                                      времПараметрыУстройства);

	Если Результат Тогда
		ТекстСообщения = НСтр("ru = 'Тест успешно выполнен.'");
		ПоказатьОповещениеПользователя(ТекстСообщения);
	Иначе
		ДополнительноеОписание = ?(ТипЗнч(ВыходныеПараметры) = Тип("Массив")
		                           И ВыходныеПараметры.Количество() >= 2,
		                           НСтр("ru = 'Дополнительное описание:'") + " " + ВыходныеПараметры[1],
		                           "");


		ТекстСообщения = НСтр("ru = 'Тест не пройден.%ПереводСтроки%%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПереводСтроки%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                  "",
		                                                                  Символы.ПС));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                           "",
		                                                                           ДополнительноеОписание));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформациюОДрайвере()

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"           , Порт);
	времПараметрыУстройства.Вставить("Скорость"       , Скорость);
	времПараметрыУстройства.Вставить("Четность"       , Четность);
	времПараметрыУстройства.Вставить("БитыДанных"     , БитыДанных);
	времПараметрыУстройства.Вставить("СтопБиты"       , СтопБиты);
	времПараметрыУстройства.Вставить("Кодировка"      , Кодировка);
	времПараметрыУстройства.Вставить("ЗагружатьШрифты", ЗагружатьШрифты);
	времПараметрыУстройства.Вставить("Модель"         , Модель);

	Если МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("ПолучитьВерсиюДрайвера",
	                                                               ВходныеПараметры,
	                                                               ВыходныеПараметры,
	                                                               Идентификатор,
	                                                               времПараметрыУстройства) Тогда
		Драйвер = ВыходныеПараметры[0];
		Версия  = ВыходныеПараметры[1];
	Иначе
		Драйвер = ВыходныеПараметры[2];
		Версия  = НСтр("ru='Не определена'");
	КонецЕсли;

	Элементы.Драйвер.ЦветТекста = ?(Драйвер = НСтр("ru='Не установлен'"), ЦветОшибки, ЦветТекста);
	Элементы.Версия.ЦветТекста  = ?(Версия  = НСтр("ru='Не определена'"), ЦветОшибки, ЦветТекста);

	Элементы.УстановитьДрайвер.Доступность = Не (Драйвер = НСтр("ru='Установлен'"));

КонецПроцедуры
