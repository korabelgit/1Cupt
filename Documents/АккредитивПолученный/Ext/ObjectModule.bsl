﻿Перем мУдалятьДвижения;

// Текущие курс и кратность валюты документа для расчетов
Перем КурсДокумента Экспорт;
Перем КратностьДокумента Экспорт;

Перем мВалютаРегламентированногоУчета Экспорт;

// Хранят группировочные признаки вида операции
Перем ЕстьРасчетыСКонтрагентами Экспорт;
Перем ЕстьРасчетыПоКредитам Экспорт;

// Хранит таблицу, использующуюся при проведении документа
Перем ТаблицаПлатежейУпр;

//Определение периода движений документа
Перем ДатаДвижений;

Перем мСтруктураПараметровДенежныхСредств;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда
	
// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходмое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт

	Если ЭтоНовый() Тогда
		Предупреждение("Документ можно распечатать только после его записи");
		Возврат;
	ИначеЕсли Не УправлениеДопПравамиПользователей.РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
		Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
		Возврат;
	КонецЕсли;

	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	Если ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда

		ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
		
		Если ТабДокумент = Неопределено Тогда
			Возврат
		КонецЕсли; 
		
	КонецЕсли;

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект), Ссылка);

КонецПроцедуры // Печать

// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

#КонецЕсли


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

// Формирует структуру полей, обязательных для заполнения при отражении фактического
// движения средств по банку.
//
// Возвращаемое значение:
//   СтруктураОбязательныхПолей   – структура для проверки
//
Функция СтруктураОбязательныхПолейОплатаУпр()

	СтруктураПолей=Новый Структура;
	СтруктураПолей.Вставить("СчетОрганизации");
	СтруктураПолей.Вставить("СуммаДокумента");
	СтруктураПолей.Вставить("ДатаОплаты","Не указана дата оплаты документа банком!");

	Возврат СтруктураПолей;

КонецФункции // СтруктураОбязательныхПолейОплатаУпр()

// Формирует структуру полей, обязательных для заполнения при отражении операции во 
// взаиморасчетах
// Возвращаемое значение:
//   СтруктурахПолей   – структура для проверки
//
Функция СтруктураОбязательныхПолейРасчетыУпр()

	Если ВидОперации = Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ПрочееПоступлениеБезналичныхДенежныхСредств Тогда
		СтруктураПолей = Новый Структура("Организация, СуммаДокумента, Ответственный");
	Иначе
		СтруктураПолей = Новый Структура("Организация, Контрагент, СуммаДокумента, Ответственный");
	КонецЕсли;
	СтруктураПолей.Вставить("СчетОрганизации","Не указан банковский счет организации!");

	Возврат СтруктураПолей;

КонецФункции // СтруктураОбязательныхПолейРасчетыУпр()

// Проверяет значение, необходимое при проведении
Процедура ПроверитьЗначение(Значение, Отказ, Заголовок, ИмяРеквизита)
	
	Если НЕ ЗначениеЗаполнено(Значение) Тогда 
		
		ОбщегоНазначения.СообщитьОбОшибке("Не заполнено значение реквизита """+ИмяРеквизита+"""",Отказ, Заголовок);
		
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗначение()

// Проверяет заполнение табличной части документа
//
Процедура ПроверитьЗаполнениеТЧ(Отказ, Заголовок)

	Для Каждого Платеж Из РасшифровкаПлатежа Цикл

		ПроверитьЗначение(Платеж.ДоговорКонтрагента,Отказ, Заголовок,"Договор");
		ПроверитьЗначение(Платеж.СуммаВзаиморасчетов,Отказ, Заголовок,"Сумма взаиморасчетов");
		
		Если Не Отказ Тогда
			
			// Сделка должна быть заполнена, если учет взаиморасчетов ведется по заказам.
			Если Платеж.ДоговорКонтрагента.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказам Тогда
				
				ТекстСделка=?(УправлениеДенежнымиСредствами.ОпределитьПараметрыВыбораСделки(ВидОперации).ТипЗаказа="ЗаказПокупателя","Заказ покупателя","Заказ поставщику");
				ПроверитьЗначение(Платеж.Сделка,Отказ, Заголовок,ТекстСделка);
				
				Если Отказ Тогда
				
					Сообщить("По договору "+Строка(Платеж.ДоговорКонтрагента)+" установлен способ ведения взаиморасчетов ""по заказам""! 
					|Заполните поле """+ТекстСделка+"""!");
					
				КонецЕсли;
				
			ИначеЕсли Платеж.ДоговорКонтрагента.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоСчетам Тогда
				
				ТекстСделка=?(УправлениеДенежнымиСредствами.ОпределитьПараметрыВыбораСделки(ВидОперации).ТипЗаказа="ЗаказПокупателя","Счет покупателя","Счет поставщику");
				ПроверитьЗначение(Платеж.Сделка,Отказ, Заголовок,ТекстСделка);

				Если Отказ Тогда
					Сообщить("По договору "+Строка(Платеж.ДоговорКонтрагента)+" установлен способ ведения взаиморасчетов ""по счетам""! 
					|Заполните поле """+ТекстСделка+"""!");
				КонецЕсли;
						
			КонецЕсли;

			Если ЗначениеЗаполнено(Организация) 
				И Организация <> Платеж.ДоговорКонтрагента.Организация Тогда
				ОбщегоНазначения.СообщитьОбОшибке("Выбран договор контрагента, не соответствующий организации, указанной в документе!", Отказ, Заголовок);
			КонецЕсли;

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры // ПроверитьЗаполнениеТЧ

// Формирует движения по регистрам
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//  Режим 					  - режим проведения документа
//
Процедура ДвиженияПоРегистрам(РежимПроведения, Отказ, Заголовок, СтруктураШапкиДокумента)

	ДвиженияПоРегистрамУпр(РежимПроведения, Отказ, Заголовок, СтруктураШапкиДокумента);
	ДвиженияПоРегистрамРегл(РежимПроведения, Отказ, Заголовок,СтруктураШапкиДокумента);
	
	Если ЕстьРасчетыСКонтрагентами или ЕстьРасчетыПоКредитам Тогда
		ДвиженияПоРегистрамОперативныхВзаиморасчетов(РежимПроведения, Отказ, Заголовок,СтруктураШапкиДокумента);
	КонецЕсли; 

КонецПроцедуры // ДвиженияПоРегистрам()

Процедура ДвиженияПоРегистрамУпр(РежимПроведения, Отказ, Заголовок, СтруктураШапкиДокумента)

	мСтруктураПараметровДенежныхСредств.Вставить("ЕстьРасчетыСКонтрагентами", ЕстьРасчетыСКонтрагентами);
	мСтруктураПараметровДенежныхСредств.Вставить("ЕстьРасчетыПоКредитам",     ЕстьРасчетыПоКредитам);
	мСтруктураПараметровДенежныхСредств.Вставить("БанковскийСчетКасса",       СчетОрганизации);
	мСтруктураПараметровДенежныхСредств.Вставить("ДатаДвижений",              ДатаДвижений);
	
	УправлениеДенежнымиСредствами.ПровестиПоступлениеДенежныхСредствУпр(
		СтруктураШапкиДокумента, мСтруктураПараметровДенежныхСредств, ТаблицаПлатежейУпр, Движения, Отказ, Заголовок);

КонецПроцедуры

Процедура ДвиженияПоРегистрамОперативныхВзаиморасчетов(РежимПроведения, Отказ, Заголовок, СтруктураШапкиДокумента)
	
	Если НЕ (Оплачено И ОтраженоВОперУчете) Тогда
		Возврат;
	КонецЕсли;
	
	ВидДвижения = ВидДвиженияНакопления.Расход;
	Если СтруктураШапкиДокумента.ВидОперации = Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ВозвратДенежныхСредствПоставщиком Тогда
		ВидРасчетовПоОперации = перечисления.ВидыРасчетовСКонтрагентами.ПоПриобретению;
	ИначеЕсли СтруктураШапкиДокумента.ВидОперации = Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ОплатаПокупателя Тогда
		ВидРасчетовПоОперации = перечисления.ВидыРасчетовСКонтрагентами.ПоРеализации;
	Иначе
		ВидРасчетовПоОперации = перечисления.ВидыРасчетовСКонтрагентами.Прочее;
	КонецЕсли;
	СтруктураШапкиДокумента.Вставить("РежимПроведения", РежимПроведения);
	
	УправлениеВзаиморасчетами.ОтражениеОплатыВРегистреОперативныхРасчетовПоДокументам(СтруктураШапкиДокумента, ДатаДвижений, "РасшифровкаПлатежа", ВидРасчетовПоОперации, ВидДвижения, Движения, Отказ, Заголовок);

КонецПроцедуры

Процедура ДвиженияПоРегистрамРегл(РежимПроведения, Отказ, Заголовок,СтруктураШапкиДокумента)

	мСтруктураПараметровДенежныхСредствРегл = Новый Структура;
	мСтруктураПараметровДенежныхСредствРегл.Вставить("ЕстьРасчетыСКонтрагентами",	ЕстьРасчетыСКонтрагентами);
	мСтруктураПараметровДенежныхСредствРегл.Вставить("ЕстьРасчетыПоКредитам",		ЕстьРасчетыПоКредитам);
	мСтруктураПараметровДенежныхСредствРегл.Вставить("РежимПроведения",				РежимПроведения);
	мСтруктураПараметровДенежныхСредствРегл.Вставить("ДатаДвижений",				ДатаДвижений);
	мСтруктураПараметровДенежныхСредствРегл.Вставить("СчетОрганизации",				СчетОрганизации);
	мСтруктураПараметровДенежныхСредствРегл.Вставить("Оплачено",					Оплачено);
	мСтруктураПараметровДенежныхСредствРегл.Вставить("ВидДенежныхСредств", 			Перечисления.ВидыДенежныхСредств.Безналичные);
	
	УправлениеДенежнымиСредствами.ПровестиПоступлениеДенежныхСредствРегл(
		СтруктураШапкиДокумента, мСтруктураПараметровДенежныхСредствРегл, ТаблицаПлатежейУпр, Движения, Отказ, Заголовок);
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеДокументаУпр(Отказ, Заголовок)

	Если НЕ РасшифровкаПлатежа.Итог("СуммаПлатежа")= СуммаДокумента Тогда
		Сообщить(Заголовок+" 
		|не совпадают сумма документа и ее расшифровка.");

		Отказ = Истина;
	КонецЕсли;

	Если Оплачено Тогда
		ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолейОплатаУпр(), Отказ, Заголовок);
	КонецЕсли;
	
	Если ОтраженоВОперУчете Тогда
		
		ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолейРасчетыУпр(), Отказ, Заголовок);
		Если НЕ ВидОперации=Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ПрочееПоступлениеБезналичныхДенежныхСредств Тогда
			ПроверитьЗаполнениеТЧ(Отказ, Заголовок);
		
			Если Не Отказ Тогда
				ТаблицаПлатежейУпр.ЗаполнитьЗначения(Ложь, "КонтролироватьСуммуЗадолженности");
				УправлениеДенежнымиСредствами.КонтрольОстатковПоТЧ(Дата, ТаблицаПлатежейУпр, Отказ, Заголовок,,Истина);
			КонецЕсли;
		
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

Процедура ПроверитьЗаполнениеДокументаРегл(Отказ, Заголовок, СтруктураШапкиДокумента)

	Если ОтражатьВБухгалтерскомУчете Тогда
		
		СтруктураПолей = Новый Структура("СчетУчетаРасчетовСКонтрагентом");
		
		Если ВидОперации=Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ПрочееПоступлениеБезналичныхДенежныхСредств Тогда
			
			ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект,СтруктураПолей, Отказ, Заголовок);
			
			НалоговыйУчет.ПроверитьЗаполнениеНалоговыхНазначений(
				СтруктураШапкиДокумента, 
				Неопределено,      // Неопределено - в случае проверки шапки документа
				Неопределено,      // Неопределено - в случае проверки шапки документа
				Отказ, 
				Заголовок, 
				"ОтражениеЗатрат", // ВидОперации
				Истина,            // ОтражатьПоЗатратам,
				"СчетУчетаРасчетовСКонтрагентом", // ИмяРеквизитаСчетЗатрат
				"СубконтоКт"       // ИмяРеквизитаСубконтоЗатрат
			);
			
		Иначе
                
			ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "РасшифровкаПлатежа", СтруктураПолей, Отказ, Заголовок);
			Если ВидОперации=Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ОплатаПокупателя
			ИЛИ ВидОперации=Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ВозвратДенежныхСредствПоставщиком Тогда
				СтруктураПолей.Вставить("СчетУчетаРасчетовПоАвансам");			
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента, Отказ=Ложь)
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке      = УправлениеЗапасами.СформироватьДеревоПолейЗапросаПоШапке();
	УправлениеЗапасами.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорКонтрагента"  , "ВедениеВзаиморасчетов"                         , "ВедениеВзаиморасчетов");
	УправлениеЗапасами.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорКонтрагента"  , "ВалютаВзаиморасчетов"                          , "ВалютаВзаиморасчетов");
	УправлениеЗапасами.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорКонтрагента"  , "Организация"                       			, "ДоговорОрганизация");
	УправлениеЗапасами.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорКонтрагента"  , "ВидДоговора"                       			, "ВидДоговора");
	УправлениеЗапасами.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "УчетнаяПолитика"     , "ВедениеУчетаПоПроектам"                     , "ВедениеУчетаПоПроектам");
	УправлениеЗапасами.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "Организация"         , "ОтражатьВРегламентированномУчете"              , "ОтражатьВРегламентированномУчете");

	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, мВалютаРегламентированногоУчета);
	СтруктураШапкиДокумента.Вставить("ОтражатьВУправленческомУчете",Истина); // Банковские документы всегда отражаются в упр. учете
	// Получим данные учетной политики
	ПодготовитьПараметрыУчетнойПолитикиРегл(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	Если ВидОперации = Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ПрочиеРасчетыСКонтрагентами ИЛИ
		ВидОперации = Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.РасчетыПоКредитамИЗаймам Тогда
		
		КурсДокумента      = РасшифровкаПлатежа[0].КурсВзаиморасчетов;
		КратностьДокумента = РасшифровкаПлатежа[0].КратностьВзаиморасчетов;

	Иначе	
		СтруктураКурсаДокумента = МодульВалютногоУчета.ПолучитьКурсВалюты(ВалютаДокумента,Дата);
		
		КурсДокумента      = СтруктураКурсаДокумента.Курс;
		КратностьДокумента = СтруктураКурсаДокумента.Кратность;
	КонецЕсли;
	СтруктураШапкиДокумента.Вставить("КурсДокумента"		, КурсДокумента);
	СтруктураШапкиДокумента.Вставить("КратностьДокумента"	, КратностьДокумента);
	
	ДатаДвижений=?(Оплачено,УправлениеДенежнымиСредствами.ПолучитьДатуДвижений(Дата,ДатаОплаты),Дата);
	СтруктураШапкиДокумента.Вставить("ДатаОплаты",ДатаДвижений);


КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(Основание)

	Если Документы.ТипВсеСсылки().СодержитТип(ТипЗнч(Основание)) И НЕ (Основание = Неопределено) Тогда
		// Заполним реквизиты из стандартного набора по документу основанию.
		ЗаполнениеДокументов.ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, Основание);
		УправлениеДенежнымиСредствами.ЗаполнитьПриходПоОснованию(ЭтотОбъект, Основание, УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнойОтветственный"));
	КонецЕсли;	
КонецПроцедуры // ОбработкаЗаполнения()

Процедура ОбработкаПроведения(Отказ, Режим)

	Перем Заголовок, СтруктураШапкиДокумента;
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;
	ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента, Отказ);

	ЕстьРасчетыСКонтрагентами=УправлениеДенежнымиСредствами.ЕстьРасчетыСКонтрагентами(ВидОперации);
	ЕстьРасчетыПоКредитам=УправлениеДенежнымиСредствами.ЕстьРасчетыПоКредитам(ВидОперации);

	// Документ должен принадлежать хотя бы к одному виду учета (управленческий, бухгалтерский)
	ОбщегоНазначения.ПроверитьПринадлежностьКВидамУчета(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	Если НЕ ОтраженоВОперУчете И НЕ Оплачено Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не выбрано правило проведения (""Отразить в опер. учете"",""Оплачено"")",Отказ, Заголовок);
	КонецЕсли;

	ТаблицаПлатежейУпр=УправлениеДенежнымиСредствами.ПолучитьТаблицуПлатежейУпр(ДатаДвижений,ВалютаДокумента,Ссылка, "АккредитивПолученный");
	
	ПроверитьЗаполнениеДокументаУпр(Отказ, Заголовок);
	ПроверитьЗаполнениеДокументаРегл(Отказ, Заголовок, СтруктураШапкиДокумента);

	//Проверим на возможность проведения в БУ и НУ
	Если СтруктураШапкиДокумента.ОтражатьВБухгалтерскомУчете тогда
		Для каждого СтрокаОплаты из РасшифровкаПлатежа Цикл
			УправлениеВзаиморасчетами.ПроверкаВозможностиПроведенияВ_БУ_НУ(СтрокаОплаты.ДоговорКонтрагента, СтруктураШапкиДокумента.ВалютаДокумента,
						СтруктураШапкиДокумента.ОтражатьВБухгалтерскомУчете,
						мВалютаРегламентированногоУчета, Истина,Отказ, Заголовок,"Строка "+СтрокаОплаты.НомерСтроки+" - ");
		КонецЦикла;
	КонецЕсли;

	// Движения по документу
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(Режим, Отказ, Заголовок, СтруктураШапкиДокумента);
	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события "ПриЗаписи"
//
Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Если ЧастичнаяОплата Тогда
		Сообщить("По документу "+ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка)+" уже прошла частичная оплата.
		|Перед отменой проведения документа необходимо отменить проведение платежных ордеров.");
		Отказ=Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ОтражатьВБухгалтерскомУчете И ВидОперации = Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ПрочееПоступлениеБезналичныхДенежныхСредств Тогда
		
		НалоговыйУчет.ЗаполнитьНалоговыеНазначенияВШапкеПередЗаписьюДокумента(
			ЭтотОбъект,
			"СчетУчетаРасчетовСКонтрагентом",    // ИмяРеквизитаСчетЗатрат
			"СубконтоКт" // ИмяРеквизитаСубконто
		);
		
	КонецЕсли;
	 
	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументОснование = Неопределено;
	ЧастичнаяОплата   = Ложь;
	Оплачено		  = Ложь;
	ДатаОплаты		  = Дата('00010101000000');
	
КонецПроцедуры

// Процедура определяет параметры регл. учетной политики
//
Процедура ПодготовитьПараметрыУчетнойПолитикиРегл(СтруктураШапкиДокумента, Отказ, Заголовок)

	Если ОтражатьВБухгалтерскомУчете Тогда
		
		// Прежде всего, проверим заполнение реквизита Организация в шапке документа
		СтруктураОбязательныхПолей = Новый Структура("Организация");
		// Теперь позовем общую процедуру проверки
		ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);
        // Организация не заполнена, получать учетную политику нет смысла
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;

	Если ОтражатьВБухгалтерскомУчете Тогда
		
		мУчетнаяПолитикаРегл = ОбщегоНазначения.ПолучитьПараметрыУчетнойПолитикиРегл(КонецМесяца(Дата), Организация);
		
		Если НЕ ЗначениеЗаполнено(мУчетнаяПолитикаРегл) Тогда
			Отказ = Истина;
		КонецЕсли;
		
		Если НЕ Отказ Тогда
			СтруктураШапкиДокумента.Вставить("ЕстьНалогНаПрибыль"	, мУчетнаяПолитикаРегл.ЕстьНалогНаПрибыль);
			СтруктураШапкиДокумента.Вставить("ЕстьНалогНаПрибыльДо2015"	, мУчетнаяПолитикаРегл.ЕстьНалогНаПрибыльДо2015);
			СтруктураШапкиДокумента.Вставить("ЕстьНДС"           	, мУчетнаяПолитикаРегл.ЕстьНДС);
		    СтруктураШапкиДокумента.Вставить("ЕстьЕдиныйНалог"   	, мУчетнаяПолитикаРегл.ЕстьЕдиныйНалог);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры // ПодготовитьПараметрыУчетнойПолитикиРегл()

мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");

мСтруктураПараметровДенежныхСредств = Новый Структура;
мСтруктураПараметровДенежныхСредств.Вставить("ВидДенежныхСредств", Перечисления.ВидыДенежныхСредств.Безналичные);
