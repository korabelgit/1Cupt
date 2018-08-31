﻿///////////////////////////////////////////////////////////////////////////////
//// БЛОК НАСТРОЙКИ ПАРАМЕТРОВ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Параметры.Свойство("Идентификатор", Идентификатор);
	Заголовок = НСтр("ru='ДП'") + " """ + Строка(Идентификатор) + """";

	ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
	ЦветОшибки = ЦветаСтиля.ЦветОтрицательногоЧисла;

	СпМодель = Элементы.Модель.СписокВыбора;
	СпМодель.Добавить("0",  "ВР 4149");
	СпМодель.Добавить("1",  "ВР 4900");
	СпМодель.Добавить("2",  "Штрих ВТ");
	СпМодель.Добавить("3",  "Штрих АС");
	СпМодель.Добавить("4",  "ШТРИХ-ПРИНТ протокол CAS LP v.1.5");
	СпМодель.Добавить("04",  "CAS LP v.1.5");
	СпМодель.Добавить("5",  "Штрих АС POS");
	СпМодель.Добавить("6",  "Штрих АС мини POS");
	СпМодель.Добавить("7",  "CAS AP");
	СпМодель.Добавить("8",  "CAS AD");
	СпМодель.Добавить("9",  "CAS SC");
	СпМодель.Добавить("10", "CAS S-2000");
	СпМодель.Добавить("11", "ПетВес серия Е");
	СпМодель.Добавить("12", "Тензо ТВ-003/05Д");
	СпМодель.Добавить("13", "Bolet MD-991");
	СпМодель.Добавить("14", "Масса-К серии ПВ");
	СпМодель.Добавить("15", "Масса-К серий ВТ, ВТМ");
	СпМодель.Добавить("16", "Масса-К серий MK-A, MK-T");
	СпМодель.Добавить("17", "Мера (Ока) до 30 кг");
	СпМодель.Добавить("18", "Мера (Ока) до 150 кг");
	СпМодель.Добавить("19", "ACOM PC100W");
	СпМодель.Добавить("20", "ACOM PC100");
	СпМодель.Добавить("21", "ACOM SI-1");
	СпМодель.Добавить("22", "CAS ER");
	СпМодель.Добавить("23", "CAS LP v.1.6");
	СпМодель.Добавить("023", "CAS LP v.2.0");
	СпМодель.Добавить("24", "Mettler Toledo 8217");
	СпМодель.Добавить("25", "Штрих ВМ100");
	СпМодель.Добавить("26", "Мера (9 байт) до 30 кг");
	СпМодель.Добавить("27", "Мера (9 байт) до 150 кг");

	СпПорт = Элементы.Порт.СписокВыбора;
	Для Номер = 1 По 32 Цикл
		СпПорт.Добавить(Номер, "COM" + Формат(Номер, "ЧЦ=2; ЧДЦ=0; ЧН=0; ЧГ=0"));
	КонецЦикла;

	СпСкорость = Элементы.Скорость.СписокВыбора;
	СпСкорость.Добавить(3,  "1200");
	СпСкорость.Добавить(4,  "2400");
	СпСкорость.Добавить(5,  "4800");
	СпСкорость.Добавить(7,  "9600");
	СпСкорость.Добавить(9,  "14400");
	СпСкорость.Добавить(10, "19200");

	СпЧетность = Элементы.Четность.СписокВыбора;
	СпЧетность.Добавить(0, НСтр("ru='Нет'"));
	СпЧетность.Добавить(1, НСтр("ru='Нечетность'"));
	СпЧетность.Добавить(2, НСтр("ru='Четность'"));

	времПорт         = Неопределено;
	времСкорость     = Неопределено;
	времЧетность     = Неопределено;
	времМодель       = Неопределено;
	времНаименование = Неопределено;

	Параметры.Свойство("Порт"        , времПорт);
	Параметры.Свойство("Скорость"    , времСкорость);
	Параметры.Свойство("Четность"    , времЧетность);
	Параметры.Свойство("Модель"      , времМодель);
	Параметры.Свойство("Наименование", времНаименование);

	Порт         = ?(времПорт         = Неопределено, 1, времПорт);
	Скорость     = ?(времСкорость     = Неопределено, 7, времСкорость);
	Четность     = ?(времЧетность     = Неопределено, 0, времЧетность);
	Модель       = ?(времМодель       = Неопределено, Элементы.Модель.СписокВыбора[0].Значение, времМодель);
	Наименование = ?(времНаименование = Неопределено, Элементы.Модель.СписокВыбора[0].Представление, времНаименование);

	Элементы.ТестУстройства.Видимость    = (ПараметрыСеанса.РабочееМестоКлиента
	                                        = Идентификатор.РабочееМесто);
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

	Параметры.ПараметрыНастройки.Добавить(Порт        , "Порт");
	Параметры.ПараметрыНастройки.Добавить(Скорость    , "Скорость");
	Параметры.ПараметрыНастройки.Добавить(Четность    , "Четность");
	Параметры.ПараметрыНастройки.Добавить(Модель      , "Модель");
	Параметры.ПараметрыНастройки.Добавить(Наименование, "Наименование");

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
Процедура ТестУстройства(Команда)

	РезультатТеста = Неопределено;

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"        , Порт);
	времПараметрыУстройства.Вставить("Скорость"    , Скорость);
	времПараметрыУстройства.Вставить("Четность"    , Четность);
	времПараметрыУстройства.Вставить("Модель"      , Модель);
	времПараметрыУстройства.Вставить("Наименование", Наименование);

	Результат = МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("CheckHealth",
	                                                                      ВходныеПараметры,
	                                                                      ВыходныеПараметры,
	                                                                      Идентификатор,
	                                                                      времПараметрыУстройства);

	Если Результат Тогда
		ТекстСообщения = НСтр("ru = 'Тест успешно выполнен.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
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
	времПараметрыУстройства.Вставить("Порт"        , Порт);
	времПараметрыУстройства.Вставить("Скорость"    , Скорость);
	времПараметрыУстройства.Вставить("Четность"    , Четность);
	времПараметрыУстройства.Вставить("Модель"      , Модель);
	времПараметрыУстройства.Вставить("Наименование", Наименование);

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

&НаКлиенте
Процедура МодельОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Наименование = Элементы.Модель.СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение).Представление;

КонецПроцедуры
