﻿#Если Клиент Тогда

Перем ИмяРегистраБухгалтерии Экспорт;
Перем МетаданныеПланСчетов Экспорт;


//////////////////////////////////////////////////////////
// ФОРМИРОВАНИЕ ЗАГОЛОВКА ОТЧЕТА
//

// Выводит шапку отчета
//
// Параметры:
//	Нет.
//
Функция СформироватьЗаголовок() Экспорт

	ОписаниеПериода = БухгалтерскиеОтчеты.СформироватьСтрокуВыводаПараметровПоДатам(ДатаНач, ДатаКон);

	Макет = ПолучитьМакет("Макет");
	ЗаголовокОтчета = Макет.ПолучитьОбласть("Заголовок");

	НазваниеОрганизации = Организация.НаименованиеПолное;
	Если ПустаяСтрока(НазваниеОрганизации) Тогда
		НазваниеОрганизации = Организация;
	КонецЕсли;
	
	ЗаголовокОтчета.Параметры.НазваниеОрганизации = НазваниеОрганизации;

	ЗаголовокОтчета.Параметры.ОписаниеПериода = ОписаниеПериода;

	ЗаголовокОтчета.Параметры.Заголовок = ЗаголовокОтчета();

	// Вывод списка фильтров:
	СтрФильтры     = "";
	СтрДетализация = "";

	Для каждого стр Из Субконто Цикл
		СтрДетализация = СтрДетализация + "; " + Строка(стр.ВидСубконто);
	КонецЦикла;
	
	СтрФильтры = УправлениеОтчетами.СформироватьСтрокуОтборов(ПостроительОтчета.Отбор);
	
	СтрДетализация = Сред(СтрДетализация, 3);
	Если Не ПустаяСтрока(СтрДетализация) Тогда
		ЗаголовокОтчета.Параметры.Детализация = СтрДетализация;
	КонецЕсли;

	ОбластьОтбор = Макет.ПолучитьОбласть("СтрокаОтбор");

	Если Не ПустаяСтрока(СтрФильтры) Тогда
		ОбластьОтбор.Параметры.ТекстПроОтбор = "Отбор: " + СтрФильтры;
		ЗаголовокОтчета.Вывести(ОбластьОтбор);
	КонецЕсли;

	Возврат(ЗаголовокОтчета);

КонецФункции // СформироватьЗаголовок()

Функция ЗаголовокОтчета() Экспорт
	
	Возврат "Карточка субконто";
	
КонецФункции // ЗаголовокОтчета()


//////////////////////////////////////////////////////////
// СОХРАНЕНИЕ И ВОССТАНОВЛЕНИЕ ПАРАМЕТРОВ ОТЧЕТА
//

// Формирование структуры для сохранения настроек отчета.
// В структуру заносятся значимые реквизиты отчета
//
// Возвращаемое значение:
//    Структура
Функция СформироватьСтруктуруДляСохраненияНастроек() Экспорт

	СтруктураНастроек = Новый Структура;
	
	СтруктураНастроек.Вставить("Организация", Организация);
	СтруктураНастроек.Вставить("ДатаНач",    ДатаНач);
	СтруктураНастроек.Вставить("ДатаКон",    Макс(ДатаНач, ДатаКон));
	СтруктураНастроек.Вставить("Период",     Период);
	СтруктураНастроек.Вставить("ВсеПериоды", ВсеПериоды);
	СтруктураНастроек.Вставить("НастройкиПостроителя", ПостроительОтчета.ПолучитьНастройки());
	
	Для каждого стр Из Субконто Цикл
		СтруктураНастроек.Вставить("ВидСубконто"+стр.НомерСтроки, стр.ВидСубконто);
	КонецЦикла;
	
	Возврат СтруктураНастроек;

КонецФункции // СформироватьСтруктуруДляСохраненияНастроек(ПоказыватьЗаголовок)

// Восстановление значимых реквизитов отчета из структуры
//
// Параметры:
//    Структура   - структура, которая содержит значения реквизитов отчета
Процедура ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками) Экспорт

	Перем НастройкиПостроителя;
	
	Если ТипЗнч(СтруктураСНастройками) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураСНастройками.Свойство("Организация", Организация);
	СтруктураСНастройками.Свойство("Период",     Период);
	СтруктураСНастройками.Свойство("ВсеПериоды", ВсеПериоды);
	
	Для каждого Элемент Из СтруктураСНастройками Цикл
	
		Если Врег(Лев(Элемент.Ключ, 11)) = "ВИДСУБКОНТО" Тогда
		
			НомерСтроки = Число(Сред(Элемент.Ключ, 12));
			
			Пока Субконто.Количество()<НомерСтроки Цикл
				Субконто.Добавить();
			КонецЦикла;
			
			стр = Субконто.Получить(НомерСтроки-1);
			стр.ВидСубконто = Элемент.Значение;
		КонецЕсли;
	
	КонецЦикла;

	ЗаполнитьНачальныеНастройки();
	
	СтруктураСНастройками.Свойство("НастройкиПостроителя", НастройкиПостроителя);
	Если ТипЗнч(НастройкиПостроителя) = Тип("НастройкиПостроителяОтчета") Тогда
		ПостроительОтчета.УстановитьНастройки(НастройкиПостроителя, Истина, Истина, Истина, Истина);
	КонецЕсли;
	
КонецПроцедуры


//////////////////////////////////////////////////////////
// ПОСТРОЕНИЕ ОТЧЕТА
//

// Формирование текста запроса на основании настроек пользователя
//
// Параметры
//  Нет
//
// Возвращаемое значение:
//   Текст   – Текст запроса
//
Процедура ПолучитьТекстЗапроса(Запрос)

	СтрокаСубконтоДт = "";
	СтрокаСубконтоКт = "";
	
	Для н=1 По МетаданныеПланСчетов.МаксКоличествоСубконто Цикл
						
		СтрокаСубконтоДт = СтрокаСубконтоДт+СтрЗаменить("
		|	ПРЕДСТАВЛЕНИЕ(ДвиженияССубконто.СубконтоДт{к}) КАК СубконтоДт{к}Представление,",
		"{к}",Строка(н));
	
		СтрокаСубконтоКт = СтрокаСубконтоКт+СтрЗаменить("
		|	ПРЕДСТАВЛЕНИЕ(ДвиженияССубконто.СубконтоКт{к}) КАК СубконтоКт{к}Представление,",
		"{к}",Строка(н));
	
	КонецЦикла;
	
	Сч = 0;
	ТекстОтборСчетов = "";
	ТекстУсловиеОстатковИОборотов = "";
	БухгалтерскиеОтчеты.ДополнитьСтрокуОграниченийПоРеквизитам(ТекстУсловиеОстатковИОборотов, "Организация", Организация);
	Для каждого Элемент Из ПостроительОтчета.Отбор Цикл
		
		Если НЕ Элемент.Использование ИЛИ ПустаяСтрока(Элемент.ПутьКДанным) Тогда
			Продолжить;
		КонецЕсли;
		
		ОграничениеДляОтбора = УправлениеОтчетами.ПолучитьСтрокуОтбора(Элемент.ВидСравнения, "&ПараметрОтбора"+Сч, Элемент.ПутьКДанным, "&ПараметрОтбораС"+Сч, "&ПараметрОтбораПо"+Сч, Элемент.Значение, Элемент.ЗначениеС, Элемент.ЗначениеПо);
		
		Если Врег(Лев(Элемент.ПутьКДанным, 4)) = "СЧЕТ" Тогда
			ТекстОтборСчетов = ТекстОтборСчетов + " И " + ОграничениеДляОтбора;			
		Иначе
			Если Не ПустаяСтрока(ТекстУсловиеОстатковИОборотов) Тогда
				ТекстУсловиеОстатковИОборотов = ТекстУсловиеОстатковИОборотов + " И ";	
			КонецЕсли;
			
			ТекстУсловиеОстатковИОборотов = ТекстУсловиеОстатковИОборотов + ОграничениеДляОтбора;
		КонецЕсли;
		
		Сч = Сч + 1;
	
	КонецЦикла;
	
	ТекстОтборСчетов = Сред(ТекстОтборСчетов, 3);
		
	ОграничениеПоТипамСубконто = БухгалтерскиеОтчеты.СформироватьОграниченияПоТипуСубконто(Запрос, Субконто.ВыгрузитьКолонку("ВидСубконто"), 
		ИмяРегистраБухгалтерии, "ДвиженияССубконто");
	
	Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НАЧАЛОПЕРИОДА(ДвиженияССубконто.Период, " + ?(Период = "", "ДЕНЬ", Период)+") КАК НачПериода,
	|	ДвиженияССубконто.Период КАК Период,
	|	ДвиженияССубконто.Регистратор КАК Регистратор,
	|	ДвиженияССубконто.Содержание КАК Содержание,
	|	ПРЕДСТАВЛЕНИЕ(ДвиженияССубконто.Регистратор) КАК РегистраторПредставление,
	|	ДвиженияССубконто.НомерСтроки КАК НомерСтроки,
	|	ДвиженияССубконто.СчетДт.Вид ВидСчетаДт,
	|	ДвиженияССубконто.СчетКт.Вид ВидСчетаКт,
	|	ДвиженияССубконто.СчетДт.Валютный СчетВалютныйДт,
	|	ДвиженияССубконто.СчетКт.Валютный СчетВалютныйКт,
	|	ДвиженияССубконто.СчетДт.Количественный СчетКоличественныйДт,
	|	ДвиженияССубконто.СчетКт.Количественный СчетКоличественныйКт,
	|	ДвиженияССубконто.СчетДт.Представление КАК СчетДтПредставление,
	|	ДвиженияССубконто.СчетКт.Представление КАК СчетКтПредставление,
	|	ДвиженияССубконто.КоличествоДт,
	|	ДвиженияССубконто.КоличествоКт,"
	+СтрокаСубконтоДт
	+СтрокаСубконтоКт+"
	|	ДвиженияССубконто.ВалютаДт.Представление КАК ВалютаДт,
	|	ДвиженияССубконто.ВалютаКт.Представление КАК ВалютаКт,
	|	ДвиженияССубконто.ВалютнаяСуммаДт,
	|	ДвиженияССубконто.ВалютнаяСуммаКт,
	|	ДвиженияССубконто.Регистратор.Дата КАК РегистраторДата,
	|	ОстаткиИОбороты.СуммаНачальныйОстатокДт,
	|	ОстаткиИОбороты.СуммаНачальныйОстатокКт,
	|	ОстаткиИОбороты.СуммаКонечныйОстатокДт,
	|	ОстаткиИОбороты.СуммаКонечныйОстатокКт,
	|	ОстаткиИОбороты.СуммаОборотДт КАК СуммаОборотДт,
	|	ОстаткиИОбороты.СуммаОборотКт КАК СуммаОборотКт,
	|	ОстаткиИОбороты.КоличествоОборотДт,
	|	ОстаткиИОбороты.КоличествоОборотКт,
	|	ОстаткиИОбороты.ВалютнаяСуммаОборотДт,
	|	ОстаткиИОбороты.ВалютнаяСуммаОборотКт
	|ИЗ
	|		РегистрБухгалтерии."+ИмяРегистраБухгалтерии+".ДвиженияССубконто(&ДатаНач, &ДатаКон, " + ТекстУсловиеОстатковИОборотов + ") КАК ДвиженияССубконто
	|		
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрБухгалтерии."+ИмяРегистраБухгалтерии+".ОстаткиИОбороты(&ДатаНач, &ДатаКон, Запись, , "+ТекстОтборСчетов+", &МассивСубконто, " + ТекстУсловиеОстатковИОборотов + ") КАК ОстаткиИОбороты
	|		ПО ДвиженияССубконто.Регистратор = ОстаткиИОбороты.Регистратор
	|			И ДвиженияССубконто.НомерСтроки = ОстаткиИОбороты.НомерСтроки
	|ГДЕ
	|	" + ОграничениеПоТипамСубконто + "
	|
	|УПОРЯДОЧИТЬ ПО
	|	НачПериода,
	|	Период,
	|	РегистраторДата,
	|	Регистратор,
	|	НомерСтроки
	|ИТОГИ
	|	СУММА(СуммаОборотДт),
	|	СУММА(СуммаОборотКт),
	|	СУММА(СуммаНачальныйОстатокДт),
	|	СУММА(СуммаНачальныйОстатокКт),
	|	СУММА(СуммаКонечныйОстатокДт),
	|	СУММА(СуммаКонечныйОстатокКт)
	|ПО
	|	Общие,
	|	НачПериода "+?(ВсеПериоды И ЗначениеЗаполнено(Период), "ПЕРИОДАМИ("+Период+",,)", "");
	
	Запрос.Текст = Текст;	

КонецПроцедуры // ПолучитьТекстЗапроса()

// Установка параметров запроса
Процедура УстановитьПараметрыЗапроса(Запрос)

	Запрос.УстановитьПараметр("ДатаНач", ДатаНач);
	Запрос.УстановитьПараметр("ДатаКон", ?(ДатаКон = '00010101', ДатаКон, Новый Граница(КонецДня(ДатаКон), ВидГраницы.Включая)));
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Запрос.УстановитьПараметр("Дебет", ВидДвиженияБухгалтерии.Дебет);

	Для каждого стрСубконто Из Субконто Цикл
		сн = Строка(стрСубконто.НомерСтроки);
		
		Запрос.УстановитьПараметр("Вид"+сн, стрСубконто.ВидСубконто);
		//Запрос.УстановитьПараметр("Значение"+сн, стрСубконто.Значение);
	КонецЦикла;
	
	Сч = 0;
	Для каждого Элемент Из ПостроительОтчета.Отбор Цикл
		
		Если НЕ Элемент.Использование ИЛИ ПустаяСтрока(Элемент.ПутьКДанным) Тогда
			Продолжить;
		КонецЕсли;
		
		Запрос.УстановитьПараметр("ПараметрОтбора"+Сч, Элемент.Значение);
		Запрос.УстановитьПараметр("ПараметрОтбораС"+Сч, Элемент.ЗначениеС);
		Запрос.УстановитьПараметр("ПараметрОтбораПо"+Сч, Элемент.ЗначениеПо);
		
		Сч=Сч+1;
	
	КонецЦикла;

	Запрос.УстановитьПараметр("МассивСубконто", Субконто.ВыгрузитьКолонку("ВидСубконто"));
	
КонецПроцедуры

// Проверка корректности настроек отчета
//
// Параметры
//  Нет
//
// Возвращаемое значение:
//   Булево
//
Функция ПараметрыОтчетаКорректны()

	ОграничениеПоДатамКорректно = БухгалтерскиеОтчеты.ПроверитьКорректностьОграниченийПоДатам(ДатаНач, ДатаКон);
	Если НЕ ОграничениеПоДатамКорректно Тогда
        Возврат Ложь;
	КонецЕсли;

	Если Субконто.Количество()=0 Тогда
		Предупреждение("Отчет не может быть построен. Не задан ни один вид субконто.", 60);
		Возврат Ложь;
	КонецЕсли;
	
	Для каждого стр Из Субконто Цикл
		Если Не ЗначениеЗаполнено(стр.ВидСубконто) Тогда
			Предупреждение("Отчет не может быть построен. Не задан вид субконто в строке настройки "+стр.НомерСтроки+".", 60);
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции // ПараметрыОтчетаКорректны()

// Вывод секции субконто в отчет
Процедура ВывестиСубконто(ДокументРезультат, ВыборкаПроводок, СтруктураПараметров, Расшифровка)

	ОблСубконто = СтруктураПараметров.ОбластьСтрокаСубконто;
	
	Для н=1 По МетаданныеПланСчетов.МаксКоличествоСубконто Цикл
		Содержание = ВыборкаПроводок[СтрЗаменить("СубконтоДт{н}Представление", "{н}", Строка(н))];
		Если ЗначениеЗаполнено(Содержание) Тогда
			ОблСубконто.Параметры.Содержание = Содержание;
			ОблСубконто.Параметры.Расшифровка = Расшифровка;
			ДокументРезультат.Вывести(ОблСубконто, ВыборкаПроводок.Уровень());
		КонецЕсли;
	КонецЦикла;
	
	Для н=1 По МетаданныеПланСчетов.МаксКоличествоСубконто Цикл
		Содержание = ВыборкаПроводок[СтрЗаменить("СубконтоКт{н}Представление", "{н}", Строка(н))];
		Если ЗначениеЗаполнено(Содержание) Тогда
			ОблСубконто.Параметры.Содержание = Содержание;
			ОблСубконто.Параметры.Расшифровка = Расшифровка;
			ДокументРезультат.Вывести(ОблСубконто, ВыборкаПроводок.Уровень());
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Вывод секции количества в отчет
Процедура ВывестиКоличество(ДокументРезультат, ВыборкаПроводок, СтруктураПараметров, Расшифровка)

	ОблКоличество = СтруктураПараметров.ОбластьКоличествоПроводки;
	
	ОблКоличество.Параметры.Заполнить(ВыборкаПроводок);
	ОблКоличество.Параметры.Расшифровка = Расшифровка;
	
	ДокументРезультат.Вывести(ОблКоличество, ВыборкаПроводок.Уровень());
	
КонецПроцедуры

// Вывод секции валют в отчет
Процедура ВывестиВалюты(ДокументРезультат, ВыборкаПроводок, СтруктураПараметров, Расшифровка)

	ОблВалюты = СтруктураПараметров.ОбластьВалютнаяСуммаПроводки;
	
	ОблВалюты.Параметры.Заполнить(ВыборкаПроводок);
	ОблВалюты.Параметры.Расшифровка = Расшифровка;
	
	ДокументРезультат.Вывести(ОблВалюты, ВыборкаПроводок.Уровень());
	
КонецПроцедуры

// Вывести данные по проводке
Процедура ВывестиПроводки(ДокументРезультат, ВыборкаВерхнегоУровня, СтруктураПараметров)
	
	ОблЗаголовокПроводки = СтруктураПараметров.ОбластьЗаголовокПроводки;
	
	ВыборкаПроводок = ВыборкаВерхнегоУровня.Выбрать(ОбходРезультатаЗапроса.Прямой);
	Пока ВыборкаПроводок.Следующий() Цикл
		
		Если ВыборкаПроводок.ТипЗаписи() <> ТипЗаписиЗапроса.ДетальнаяЗапись Тогда
			Продолжить;
		КонецЕсли;
		
		Расшифровка = Новый Структура;
		Расшифровка.Вставить("ДокументОперации", ВыборкаПроводок.Регистратор);
		Расшифровка.Вставить("ПараметрТекущаяСтрока", ВыборкаПроводок.НомерСтроки);
	
		ОблЗаголовокПроводки.Параметры.Заполнить(ВыборкаПроводок);
		ОблЗаголовокПроводки.Параметры.Расшифровка = Расшифровка;
		
		Если ВыборкаПроводок.СуммаКонечныйОстатокДт > ВыборкаПроводок.СуммаКонечныйОстатокКт Тогда
			ОблЗаголовокПроводки.Параметры.Флаг = "Д";
			ОблЗаголовокПроводки.Параметры.Остаток = ВыборкаПроводок.СуммаКонечныйОстатокДт - ВыборкаПроводок.СуммаКонечныйОстатокКт;
		Иначе
			ОблЗаголовокПроводки.Параметры.Флаг = "К";
			ОблЗаголовокПроводки.Параметры.Остаток = ВыборкаПроводок.СуммаКонечныйОстатокКт - ВыборкаПроводок.СуммаКонечныйОстатокДт;
		КонецЕсли;
		
		ДокументРезультат.Вывести(ОблЗаголовокПроводки, ВыборкаПроводок.Уровень());
		
		ВерхСекции = ДокументРезультат.ВысотаТаблицы;
		
		ВывестиСубконто(ДокументРезультат, ВыборкаПроводок, СтруктураПараметров, Расшифровка);
		Если ВыборкаПроводок.СчетКоличественныйДт = Истина 
			ИЛИ ВыборкаПроводок.СчетКоличественныйКт = Истина Тогда
			
			ВывестиКоличество(ДокументРезультат, ВыборкаПроводок, СтруктураПараметров, Расшифровка);
			
		КонецЕсли;
		
		Если ВыборкаПроводок.СчетВалютныйДт = Истина 
			ИЛИ ВыборкаПроводок.СчетВалютныйКт = Истина Тогда
			
			ВывестиВалюты(ДокументРезультат, ВыборкаПроводок, СтруктураПараметров, Расшифровка);
			
		КонецЕсли;
		
		НизСекции = ДокументРезультат.ВысотаТаблицы;
		
		ДокументРезультат.Область(ВерхСекции,2,НизСекции,2).Объединить();
		ДокументРезультат.Область(ВерхСекции,3,НизСекции,3).Объединить();
	КонецЦикла;
	
КонецПроцедуры

// Вывести общий итог или итог по периоду
Процедура ВывестиПодИтог(ДокументРезультат, Выборка, СтруктураПараметров, ОписательПериода)

	ОблИтог = СтруктураПараметров.ОбластьОбороты;
	
	ОблИтог.Параметры.ОписательПериода = ОписательПериода;
	ОблИтог.Параметры.СуммаОборотДт = Выборка.СуммаОборотДт;
	ОблИтог.Параметры.СуммаОборотКт = Выборка.СуммаОборотКт;
	
	ДокументРезультат.Вывести(ОблИтог, Выборка.Уровень());

КонецПроцедуры

// Формирование отчета
Процедура СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок, ВысотаЗаголовка) Экспорт
	
	Если Не ПараметрыОтчетаКорректны() Тогда
		Возврат;
	КонецЕсли;

	Запрос = Новый Запрос;
	ПолучитьТекстЗапроса(Запрос);
	
	УстановитьПараметрыЗапроса(Запрос);
	
	Результат = Запрос.Выполнить();

	ВыборкаОбщие = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Общие");
	ВыборкаОбщие.Следующий();
	
	ВыборкаПоПериодам = ВыборкаОбщие.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "НачПериода");
	ВыборкаПоПериодам.Следующий();
	
	ВыборкаДетальная = ВыборкаПоПериодам.Выбрать(ОбходРезультатаЗапроса.Прямой);
	ВыборкаДетальная.Следующий();
	
	Макет = ПолучитьМакет("Макет");
	ОблШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОблСальдо       = Макет.ПолучитьОбласть("Сальдо");
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("ОбластьШапкаТаблицы",          ОблШапкаТаблицы);
	СтруктураПараметров.Вставить("ОбластьЗаголовокПроводки",     Макет.ПолучитьОбласть("ЗаголовокПроводки"));
	СтруктураПараметров.Вставить("ОбластьОбороты",               Макет.ПолучитьОбласть("Обороты"));
	СтруктураПараметров.Вставить("ОбластьСтрокаСубконто",        Макет.ПолучитьОбласть("СтрокаСубконто"));
	СтруктураПараметров.Вставить("ОбластьКоличествоПроводки",    Макет.ПолучитьОбласть("КоличествоПроводки"));
	СтруктураПараметров.Вставить("ОбластьВалютнаяСуммаПроводки", Макет.ПолучитьОбласть("ВалютнаяСуммаПроводки"));
	
	ДокументРезультат.Очистить();
	
	// Вывод заголовка отчета
	БухгалтерскиеОтчеты.СформироватьИВывестиЗаголовокОтчета(ЭтотОбъект, ДокументРезультат, ВысотаЗаголовка, ПоказыватьЗаголовок);

	ДокументРезультат.Вывести(ОблШапкаТаблицы, 1);
	
	ОблСальдо.Параметры.ОписательСальдо = "Сальдо на " + формат(ДатаНач, "ДФ=dd.MM.yyyy");
	ОблСальдо.Параметры.СуммаСальдоДт = ВыборкаДетальная.СуммаНачальныйОстатокДт;
	ОблСальдо.Параметры.СуммаСальдоКт = ВыборкаДетальная.СуммаНачальныйОстатокКт;
	ДокументРезультат.Вывести(ОблСальдо, 1);
	
	// вывод основной части отчета
	ДокументРезультат.НачатьАвтогруппировкуСтрок();
	
	Если Не ЗначениеЗаполнено(Период) Тогда
		// без разбивки по периодам
		ВывестиПроводки(ДокументРезультат, ВыборкаОбщие, СтруктураПараметров);
	Иначе
		// с разбивкой по периодам
		ФорматПериода = БухгалтерскиеОтчеты.ПолучитьСтрокуФорматаПериода(Период);
		
		ВыборкаПоПериодам = ВыборкаОбщие.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "НачПериода");
		
		Пока ВыборкаПоПериодам.Следующий() Цикл
			
			ВывестиПодИтог(ДокументРезультат, ВыборкаПоПериодам, СтруктураПараметров, Формат(ВыборкаПоПериодам.НачПериода, ФорматПериода));
			
			ВывестиПроводки(ДокументРезультат, ВыборкаПоПериодам, СтруктураПараметров);
			
		КонецЦикла;
	КонецЕсли;
	
	ВывестиПодИтог(ДокументРезультат, ВыборкаОбщие, СтруктураПараметров, "Итого за период");
	
	ДокументРезультат.ЗакончитьАвтогруппировкуСтрок();
	
	// Вывод конечного сальдо
	ОблСальдоПараметры = ОблСальдо.Параметры;
	ОблСальдоПараметры.ОписательСальдо = "Сальдо на " + формат(ДатаКон, "ДФ=dd.MM.yyyy");
	
	ВыборкаПоПериодам.Сбросить();
	
	Пока ВыборкаПоПериодам.Следующий() Цикл
		
		ВыборкаДетальная = ВыборкаПоПериодам.Выбрать(ОбходРезультатаЗапроса.Прямой);
		
		Пока ВыборкаДетальная.Следующий() Цикл
			ОблСальдоПараметры.СуммаСальдоДт = ВыборкаДетальная.СуммаКонечныйОстатокДт;
			ОблСальдоПараметры.СуммаСальдоКт = ВыборкаДетальная.СуммаКонечныйОстатокКт;
		КонецЦикла;
	КонецЦикла;
	
	ДокументРезультат.Вывести(ОблСальдо, 1);
	
	// Зафиксируем заголовок отчета
	ДокументРезультат.ФиксацияСверху = ВысотаЗаголовка + 3;
	
	// Шапку отчета печатаем на каждой странице
	ДокументРезультат.ПовторятьПриПечатиСтроки = ДокументРезультат.Область(ВысотаЗаголовка+1,,ВысотаЗаголовка+3);

	// Первую колонку не печатаем
	ДокументРезультат.ОбластьПечати = ДокументРезультат.Область(1,2,ДокументРезультат.ВысотаТаблицы,ДокументРезультат.ШиринаТаблицы);
	
	// Присвоим имя для сохранения параметров печати табличного документа
	ДокументРезультат.ИмяПараметровПечати = "КарточкаСубконто"+ИмяРегистраБухгалтерии;

	УправлениеОтчетами.УстановитьКолонтитулыПоУмолчанию(ДокументРезультат, ЗаголовокОтчета(), Строка(глЗначениеПеременной("глТекущийПользователь")));
	
КонецПроцедуры


//////////////////////////////////////////////////////////
// ПРОЧИЕ ПРОЦЕДУРЫ И ФУНКЦИИ
//

// Заполнение настроек построителя отчетов
Процедура ЗаполнитьНачальныеНастройки() Экспорт
	
	МассивСубконто = Новый Массив;
	
	Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ОстаткиИОбороты.СуммаОборотКт КАК СуммаОборотКт";
	
	ТекстПоля = "";
	ТекстОтбор = "Валюта";
	ТекстИтоги = "";
	ТекстПорядок = "";
	
	БухгалтерскиеОтчеты.УдалитьПустыеСубконтоИзТабличнойЧасти(Субконто);
	
	МассивВидыСубконто = Новый Массив;

	Для каждого стр Из Субконто Цикл
		
		Если Не ЗначениеЗаполнено(стр.ВидСубконто) Тогда
			Продолжить;
		КонецЕсли;
		
		МассивСубконто.Добавить(стр.ВидСубконто);
		МассивВидыСубконто.Добавить(стр.ВидСубконто);
		
		ТекстПоля = ТекстПоля + ", ОстаткиИОбороты.Субконто" +стр.НомерСтроки+" КАК Субконто"+стр.НомерСтроки;
		ТекстОтбор = ТекстОтбор + ", Субконто"+стр.НомерСтроки+".*";
		ТекстИтоги = ТекстИтоги + ", Субконто"+стр.НомерСтроки;
		ТекстПорядок = ТекстПорядок + ", ОстаткиИОбороты.Субконто" +стр.НомерСтроки+".*";
	
	КонецЦикла;
	
	Если Не ПустаяСтрока(ТекстПоля) Тогда
		Текст = Текст +	"
		|{ВЫБРАТЬ
		|" + Сред(ТекстПоля
		//+ ТекстПоляПериоды
		, 2) 
		+ "}";
	КонецЕсли;
	
	ТекстОтбор = "{"+ТекстОтбор+"}";
	
	Текст = Текст + "
	|ИЗ
	|	РегистрБухгалтерии."+ИмяРегистраБухгалтерии+".ОстаткиИОбороты(, , МЕСЯЦ, , {Счет} , &МассивСубконто, "+ТекстОтбор+") КАК ОстаткиИОбороты
	|";
	
	Если Не ПустаяСтрока(ТекстПорядок) Тогда
		Текст = Текст + "
		|{УПОРЯДОЧИТЬ ПО 
		|" + Сред(ТекстПорядок 
		//+ ТекстПоляПериоды
		, 2) + "}";
	КонецЕсли;
	
	Текст = Текст + "
	|ИТОГИ СУММА(СуммаОборотКт) ПО ОБЩИЕ";
	
	Если Не ПустаяСтрока(ТекстПоля) Тогда
		Текст = Текст + "
		|{ИТОГИ ПО
		|" + Сред(ТекстПоля 
		//+ ТекстПоляПериоды
		, 2) + "}";
	КонецЕсли;
	
	ПостроительОтчета.Параметры.Вставить("ПустаяОрганизация", Справочники.Организации.ПустаяСсылка());
	
	ПостроительОтчета.Параметры.Вставить("МассивСубконто", МассивСубконто);
	
	ПостроительОтчета.Текст = Текст;
	
	БухгалтерскиеОтчеты.УстановитьТипыОтборовПостроителяПоСубконто(ПостроительОтчета, МассивСубконто);
	
	// Определим признаки учета субконто, которые могут быть использованы
	ИмяПланаСчетов = Метаданные.РегистрыБухгалтерии[ИмяРегистраБухгалтерии].ПланСчетов.Имя;
	ЗапросСчета = Новый Запрос(
	"ВЫБРАТЬ
	|	МАКСИМУМ(Подзапрос.Валютный) КАК Валютный,
	|	МАКСИМУМ(Подзапрос.Количественный) КАК Количественный
	|ИЗ (ВЫБРАТЬ
	|	(ВС.Валютный И ВС.Ссылка.Валютный) Валютный,
	|	(ВС.Количественный И ВС.Ссылка.Количественный) Количественный
	|ИЗ
	|	ПланСчетов."+ИмяПланаСчетов+".ВидыСубконто КАК ВС	
	|ГДЕ
	|	ВС.ВидСубконто В(&ВидСубконто)) КАК Подзапрос
	|");
	
	ЗапросСчета.УстановитьПараметр("ВидСубконто", МассивВидыСубконто);
	
	ВыборкаСчета = ЗапросСчета.Выполнить().Выбрать();
	
	ЕстьВалюта = Ложь;
	ЕстьКоличество = Ложь;
	Пока ВыборкаСчета.Следующий() Цикл
		ЕстьВалюта = ?(ВыборкаСчета.Валютный=Ложь, Ложь, Истина);
		ЕстьКоличество = ?(ВыборкаСчета.Количественный=Ложь, Ложь, Истина);
	КонецЦикла;
	
	ПоКоличеству =  ЕстьКоличество;
	
	Если ЕстьВалюта = Ложь Тогда
		ПоВалютам = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Перезаполнение настроек построителя отчетов с сохранением пользовательских настроек
Процедура ПерезаполнитьНачальныеНастройки() Экспорт
	
	Настройки = ПостроительОтчета.ПолучитьНастройки();
	
	ЗаполнитьНачальныеНастройки();
	
	ПостроительОтчета.УстановитьНастройки(Настройки);
	
	ДобавитьОтборПоВалюте();
	
КонецПроцедуры

// Если в настройке отбора нет поля валюты, его надо добавить
//
// Параметры
//    Нет
//
Процедура ДобавитьОтборПоВалюте()

	Поле = Неопределено;
	
	Для каждого ПолеОтбора Из ПостроительОтчета.Отбор Цикл
	
		Если Врег(ПолеОтбора.ПутьКДанным) = Врег("Валюта") Тогда
			Поле = ПолеОтбора;
			Прервать;
		КонецЕсли;
	
	КонецЦикла;
	
	Если Поле = Неопределено Тогда
	
		Поле = ПостроительОтчета.Отбор.Добавить("Валюта");
		Поле.Использование = Ложь;
	
	КонецЕсли;

КонецПроцедуры // ДобавитьОтборПоВалюте()


// Обработчик события начала выбора значения субконто
//
// Параметры:
//	Элемент управления.
//	Стандартная обработка.
//
Процедура НачалоВыбораЗначенияСубконто(Элемент, СтандартнаяОбработка, ТипЗначенияПоля=Неопределено) Экспорт
	
	СписокПараметров = Новый Структура;
	СписокПараметров.Вставить("Дата",         ДатаКон);
	СписокПараметров.Вставить("СчетУчета",    Неопределено);
	СписокПараметров.Вставить("Номенклатура", Неопределено);
	СписокПараметров.Вставить("Склад", Неопределено);
	СписокПараметров.Вставить("Организация",  Организация);
	СписокПараметров.Вставить("Контрагент",  Неопределено);
	СписокПараметров.Вставить("ДоговорКонтрагента", Неопределено);
	СписокПараметров.Вставить("ЭтоНовыйДокумент", Ложь);
	
	// Поищем значения в отборе и в полях выбора субконто
	Для каждого стр из ПостроительОтчета.Отбор Цикл
		ЗначениеОтбора = стр.Значение;
		Если ЗначениеЗаполнено(ЗначениеОтбора) Тогда
			Если стр.ТипЗначения = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура.ТипЗначения Тогда
				СписокПараметров.Вставить("Номенклатура", ЗначениеОтбора);
			ИначеЕсли стр.ТипЗначения = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады.ТипЗначения Тогда
				СписокПараметров.Вставить("Склад", ЗначениеОтбора);
			ИначеЕсли стр.ТипЗначения = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты.ТипЗначения Тогда
				СписокПараметров.Вставить("Контрагент", ЗначениеОтбора);
			ИначеЕсли стр.ТипЗначения = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры.ТипЗначения Тогда
				СписокПараметров.Вставить("ДоговорКонтрагента", ЗначениеОтбора);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	БухгалтерскийУчет.ОбработатьВыборСубконто(Элемент, СтандартнаяОбработка, Организация, СписокПараметров, ТипЗначенияПоля);
	
КонецПроцедуры // ОбработкаВыбораСубконто()

// Настраивает отчет по заданным параметрам (например, для расшифровки)
Процедура Настроить(СтруктураПараметров) Экспорт
	
	Параметры = БухгалтерскиеОтчеты.СоздатьПоСтруктуреСоответствие(СтруктураПараметров); 

	Организация = Параметры["Организация"];
	ДатаНач = Параметры["ДатаНач"];
	ДатаКон = Параметры["ДатаКон"];
	
	МассивВидовСубконто = Параметры["ВидыСубконто"];
	Если ТипЗнч(МассивВидовСубконто) = Тип("Массив") Тогда
		Для н=0 По МассивВидовСубконто.Количество()-1 Цикл
			Строка = Субконто.Добавить();
			Строка.ВидСубконто = МассивВидовСубконто[н];
		КонецЦикла;
	КонецЕсли;
	
	ЗаполнитьНачальныеНастройки();
	ДобавитьОтборПоВалюте();
	
	СтрокиОтбора = Параметры["Отбор"];
	БухгалтерскиеОтчеты.ВосстановитьОтборПостроителяОтчетовПоПараметрам(ПостроительОтчета, СтрокиОтбора);

КонецПроцедуры

//////////////////////////////////////////////////////////
// МОДУЛЬ ОБЪЕКТА
//

ИмяРегистраБухгалтерии = "Хозрасчетный";

МетаданныеПланСчетов = Метаданные.РегистрыБухгалтерии[ИмяРегистраБухгалтерии].ПланСчетов;

#КонецЕсли