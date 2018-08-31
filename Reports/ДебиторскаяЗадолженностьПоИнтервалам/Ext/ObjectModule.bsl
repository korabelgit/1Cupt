﻿#Если Клиент Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ НАЧАЛЬНОЙ НАСТРОЙКИ ОТЧЕТА

// Процедура установки начальных настроек отчета с использованием текста запроса
//
Процедура УстановитьНачальныеНастройки(ДополнительныеПараметры = Неопределено) Экспорт
	
	// Настройка общих параметров универсального отчета
	
	Если ДополнительныеПараметры <> Неопределено Тогда
		
		УправлениеОтчетами.ВосстановитьРеквизитыОтчета(ЭтотОбъект, ДополнительныеПараметры);
		
	КонецЕсли;
	
	// Содержит название отчета, которое будет выводиться в шапке.
	// Тип: Строка.
	// Пример:
	// УниверсальныйОтчет.мНазваниеОтчета = "Название отчета";
	УниверсальныйОтчет.мНазваниеОтчета = СокрЛП(ЭтотОбъект.Метаданные().Синоним);
	
	// Содержит признак необходимости отображения надписи и поля выбора раздела учета в форме настройки.
	// Тип: Булево.
	// Значение по умолчанию: Истина.
	// Пример:
	// УниверсальныйОтчет.мВыбиратьИмяРегистра = Ложь;
	УниверсальныйОтчет.мВыбиратьИмяРегистра = Ложь;
	
	// Содержит имя регистра, по метаданным которого будет выполняться заполнение настроек отчета.
	// Тип: Строка.
	// Пример:
	// УниверсальныйОтчет.ИмяРегистра = "ТоварыНаСкладах";
	
	// Содержит признак необходимости вывода отрицательных значений показателей красным цветом.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.ОтрицательноеКрасным = Истина;
	
	// Содержит признак необходимости вывода в отчет общих итогов.
	// Тип: Булево.
	// Значение по умолчанию: Истина.
	// Пример:
	// УниверсальныйОтчет.ВыводитьОбщиеИтоги = Ложь;
	
	// Содержит признак необходимости вывода детальных записей в отчет.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.ВыводитьДетальныеЗаписи = Истина;
	
	// Содержит признак необходимости отображения флага использования свойств и категорий в форме настройки.
	// Тип: Булево.
	// Значение по умолчанию: Истина.
	// Пример:
	// УниверсальныйОтчет.мВыбиратьИспользованиеСвойств = Ложь;
	УниверсальныйОтчет.мВыбиратьИспользованиеСвойств = истина;
	
	// Содержит признак использования свойств и категорий при заполнении настроек отчета.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.ИспользоватьСвойстваИКатегории = Истина;
	
	// Содержит признак использования простой формы настроек отчета без группировок колонок.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.мРежимФормыНастройкиБезГруппировокКолонок = Истина;
	
	// Дополнительные параметры, переданные из отчета, вызвавшего расшифровку.
	// Информация, передаваемая в переменной ДополнительныеПараметры, может быть использована
	// для реализации специфичных для данного отчета параметрических настроек.
	
	// Описание исходного текста запроса.
	
	ТабИнтервалы = новый ТаблицаЗначений;
	ТабИнтервалы.Колонки.Добавить("ИмяИнтервала");
	ТабИнтервалы.Колонки.Добавить("НомерИнтервала");
	ТабИнтервалы.Колонки.Добавить("НачалоИнтервала");
	ТабИнтервалы.Колонки.Добавить("КонецИнтервала");
	Если НЕ ЗначениеЗаполнено(Интервал) Тогда
		нстр = ТабИнтервалы.Добавить();
		нстр.ИмяИнтервала = "";
		нстр.НомерИнтервала = 0;
		нстр.НачалоИнтервала = УниверсальныйОтчет.ДатаНач;
		нстр.КонецИнтервала = УниверсальныйОтчет.ДатаКон;
	Иначе
		ДатаКон = ?(УниверсальныйОтчет.ДатаКон = Дата('00010101000000'),ТекущаяДата(),УниверсальныйОтчет.ДатаКон);
		Для каждого стр из Интервал.ТабличнаяЧасть цикл
			КонецИнтервала = КонецДня(ДатаКон-стр.КонецИнтервала*60*60*24);
			Если КонецИнтервала<УниверсальныйОтчет.ДатаНач Тогда
				Прервать;
			КонецЕсли;
			
			нстр = ТабИнтервалы.Добавить();
			нстр.ИмяИнтервала = Формат(стр.НомерСтроки, "ЧГ=0") + ". " + стр.Подпись;
			нстр.НомерИнтервала = стр.НомерСтроки;
			нстр.НачалоИнтервала = макс(НачалоДня(ДатаКон-стр.НачалоИнтервала*60*60*24),УниверсальныйОтчет.ДатаНач);
			нстр.КонецИнтервала = КонецДня(ДатаКон-стр.КонецИнтервала*60*60*24);
			
		КонецЦикла;
	КонецЕсли;
	
	ТекстУчастокЗапроса = "
	|	РегВзаиморасчеты.Организация КАК Организация,
	|	ПРЕДСТАВЛЕНИЕ(РегВзаиморасчеты.Организация),
	|	РегВзаиморасчеты.Контрагент КАК Контрагент,
	|	ПРЕДСТАВЛЕНИЕ(РегВзаиморасчеты.Контрагент),
	|	РегВзаиморасчеты.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	ПРЕДСТАВЛЕНИЕ(РегВзаиморасчеты.ДоговорКонтрагента),
	|	РегВзаиморасчеты.Сделка КАК Сделка,
	|	ПРЕДСТАВЛЕНИЕ(РегВзаиморасчеты.Сделка),
	//|	НЕОПРЕДЕЛЕНО КАК ДокументРасчетовСКонтрагентом,
	|	РегВзаиморасчеты.ДоговорКонтрагента.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	ПРЕДСТАВЛЕНИЕ(РегВзаиморасчеты.ДоговорКонтрагента.ВалютаВзаиморасчетов) КАК ВалютаВзаиморасчетовПредставление,
	|	&ИмяИнтервала КАК Интервал,
	|	&НомерИнтервала КАК НомерИнтервала,
	|	РегВзаиморасчеты.СуммаВзаиморасчетовНачальныйОстаток КАК СуммаВзаиморасчетовНачальныйОстаток,
	|	РегВзаиморасчеты.СуммаВзаиморасчетовКонечныйОстаток КАК СуммаВзаиморасчетовКонечныйОстаток,
	|	РегВзаиморасчеты.СуммаВзаиморасчетовПриход КАК СуммаВзаиморасчетовПриход,
	|	РегВзаиморасчеты.СуммаВзаиморасчетовРасход КАК СуммаВзаиморасчетовРасход,
	|	РегВзаиморасчеты.СуммаУпрНачальныйОстаток КАК СуммаУпрНачальныйОстаток,
	|	РегВзаиморасчеты.СуммаУпрКонечныйОстаток КАК СуммаУпрКонечныйОстаток,
	|	РегВзаиморасчеты.СуммаУпрПриход КАК СуммаУпрПриход,
	|	РегВзаиморасчеты.СуммаУпрРасход КАК СуммаУпрРасход
	|	//ПОЛЯ_СВОЙСТВА
	|	//ПОЛЯ_КАТЕГОРИИ
	|{ВЫБРАТЬ
	|	Организация.*,
	|	Контрагент.*,
	|	ДоговорКонтрагента.*,
	|	Контрагент.*,
	|	Сделка.*,
	|	Интервал,
	|	ВалютаВзаиморасчетов.*,
	|	СуммаВзаиморасчетовНачальныйОстаток,
	|	СуммаВзаиморасчетовКонечныйОстаток,
	|	СуммаВзаиморасчетовПриход,
	|	СуммаВзаиморасчетовРасход,
	|	СуммаУпрНачальныйОстаток,
	|	СуммаУпрКонечныйОстаток,
	|	СуммаУпрПриход,
	|	СуммаУпрРасход
	|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
	|}

	|ИЗ
	|	РегистрНакопления.ВзаиморасчетыСКонтрагентами.ОстаткиИОбороты(&ДатаНач, &ДатаКон, , , {ДоговорКонтрагента.*, Сделка.*, Контрагент.*, Организация.*}) КАК РегВзаиморасчеты
	|	//СОЕДИНЕНИЯ
	|{ГДЕ
	|	РегВзаиморасчеты.СуммаВзаиморасчетовНачальныйОстаток КАК СуммаВзаиморасчетовНачальныйОстаток,
	|	РегВзаиморасчеты.СуммаВзаиморасчетовКонечныйОстаток КАК СуммаВзаиморасчетовКонечныйОстаток,
	|	РегВзаиморасчеты.СуммаВзаиморасчетовПриход КАК СуммаВзаиморасчетовПриход,
	|	РегВзаиморасчеты.СуммаВзаиморасчетовРасход КАК СуммаВзаиморасчетовРасход,
	|	РегВзаиморасчеты.СуммаУпрНачальныйОстаток КАК СуммаУпрНачальныйОстаток,
	|	РегВзаиморасчеты.СуммаУпрКонечныйОстаток КАК СуммаУпрКонечныйОстаток,
	|	РегВзаиморасчеты.СуммаУпрПриход КАК СуммаУпрПриход,
	|	РегВзаиморасчеты.СуммаУпрРасход КАК СуммаУпрРасход
	|	//УСЛОВИЯ_СВОЙСТВА
	|	//УСЛОВИЯ_КАТЕГОРИИ
	|}";

	ТекстЗапроса = "";
	ПараметрыПостроителя = УниверсальныйОтчет.ПостроительОтчета.Параметры;
	Для каждого стр из ТабИнтервалы цикл
		текЗапрос = ТекстУчастокЗапроса;
		текЗапрос = стрЗаменить(текЗапрос,"&ДатаНач","&ДатаНач"+стр.НомерИнтервала);
		текЗапрос = стрЗаменить(текЗапрос,"&ДатаКон","&ДатаКон"+стр.НомерИнтервала);
        текЗапрос = стрЗаменить(текЗапрос,"&ИмяИнтервала","&ИмяИнтервала"+стр.НомерИнтервала);
        текЗапрос = стрЗаменить(текЗапрос,"&НомерИнтервала","&НомерИнтервала"+стр.НомерИнтервала);

		Если не ПустаяСтрока(ТекстЗапроса) Тогда
			ТекстЗапроса = ТекстЗапроса + "
			|Объединить все
			|";
		КонецЕсли;	
		ТекстЗапроса = ТекстЗапроса + 
		"ВЫБРАТЬ " + ?(ПустаяСтрока(ТекстЗапроса), "РАЗРЕШЕННЫЕ", "") + текЗапрос;
		
		ПараметрыПостроителя.Вставить("ДатаНач"+стр.НомерИнтервала, ?(стр.НачалоИнтервала = Дата('00010101000000'), стр.НачалоИнтервала, Новый Граница(НачалоДня(стр.НачалоИнтервала), ВидГраницы.Включая)));
		ПараметрыПостроителя.Вставить("ДатаКон"+стр.НомерИнтервала, ?(стр.КонецИнтервала = Дата('00010101000000'), стр.КонецИнтервала, Новый Граница(КонецДня(стр.КонецИнтервала), ВидГраницы.Включая)));
		ПараметрыПостроителя.Вставить("ИмяИнтервала"+стр.НомерИнтервала, стр.ИмяИнтервала);
		ПараметрыПостроителя.Вставить("НомерИнтервала"+стр.НомерИнтервала, стр.НомерИнтервала);

	КонецЦикла;
	ТекстЗапроса = ТекстЗапроса +"
	|Упорядочить по НомерИнтервала
	|{УПОРЯДОЧИТЬ ПО
	|	Организация.*,
	|	Контрагент.*,
	|	ДоговорКонтрагента.*,
	|	Сделка.*,
	|	ВалютаВзаиморасчетов.*,
	|	СуммаВзаиморасчетовНачальныйОстаток,
	|	СуммаВзаиморасчетовКонечныйОстаток,
	|	СуммаВзаиморасчетовПриход,
	|	СуммаВзаиморасчетовРасход,
	|	СуммаУпрНачальныйОстаток,
	|	СуммаУпрКонечныйОстаток,
	|	СуммаУпрПриход,
	|	СуммаУпрРасход
	|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
	|}

	|ИТОГИ
	|	СУММА(СуммаВзаиморасчетовНачальныйОстаток),
	|	СУММА(СуммаВзаиморасчетовКонечныйОстаток),
	|	СУММА(СуммаВзаиморасчетовПриход),
	|	СУММА(СуммаВзаиморасчетовРасход),
	|	СУММА(СуммаУпрНачальныйОстаток),
	|	СУММА(СуммаУпрКонечныйОстаток),
	|	СУММА(СуммаУпрПриход),
	|	СУММА(СуммаУпрРасход)
	|	//ИТОГИ_СВОЙСТВА
	|	//ИТОГИ_КАТЕГОРИИ
	|ПО
	|	ОБЩИЕ
	|{ИТОГИ ПО
	|	Организация.*,
	|	Контрагент.*,
	|	ДоговорКонтрагента.*,
	|	Контрагент.*,
	|	Сделка.*,
	|	Интервал,
	|	ВалютаВзаиморасчетов.*
	|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
	|}";

	
	
	// В универсальном отчете включен флаг использования свойств и категорий.
	Если УниверсальныйОтчет.ИспользоватьСвойстваИКатегории Тогда
		
		// Добавление свойств и категорий поля запроса в таблицу полей.
		// Необходимо вызывать для каждого поля запроса, предоставляющего возможность использования свойств и категорий.
		
		// УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля(<ПсевдонимТаблицы>.<Поле> , <ПсевдонимПоля>, <Представление>, <Назначение>);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("РегВзаиморасчеты.Контрагент", "Контрагент", "Контрагент", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Контрагенты);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("РегВзаиморасчеты.ДоговорКонтрагента", "ДоговорКонтрагента", "Договор контрагента", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_ДоговорыКонтрагентов);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("РегВзаиморасчеты.Организация", "Организация", "Организация", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Организации);

		УниверсальныйОтчет.ДобавитьВТекстЗапросаСвойстваИКатегории(ТекстЗапроса);
		
	КонецЕсли;
		
	// Инициализация текста запроса построителя отчета
	УниверсальныйОтчет.ПостроительОтчета.Текст = ТекстЗапроса;
	
	// Представления полей отчета.
	// Необходимо вызывать для каждого поля запроса.
	// УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить(<ИмяПоля>, <ПредставлениеПоля>);
	ВалютаУпр = "(" + СокрЛП(глЗначениеПеременной("ВалютаУправленческогоУчета").Наименование) + ")";

	// Представления полей отчета.
	// Необходимо вызывать для каждого поля запроса.
	// УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить(<ИмяПоля>, <ПредставлениеПоля>);
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДоговорКонтрагента", "Договор контрагента");
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДокументРасчетовСКонтрагентом", "Документ расчетов с контрагентом");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаВзаиморасчетовНачальныйОстаток", "Сумма взаиморасчетов начальный остаток");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаВзаиморасчетовКонечныйОстаток", "Сумма взаиморасчетов конечный остаток");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаВзаиморасчетовПриход", "Сумма взаиморасчетов приход");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаВзаиморасчетовРасход", "Сумма взаиморасчетов расход");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаУпрНачальныйОстаток", "Сумма " + ВалютаУпр + " (нач. ост.)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаУпрКонечныйОстаток", "Сумма " + ВалютаУпр + " (кон. ост.)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаУпрПриход", "Сумма " + ВалютаУпр + " (приход)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаУпрРасход", "Сумма " + ВалютаУпр + " (расход)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ВалютаВзаиморасчетов", "Валюта взаиморасчетов");

	
	// Добавление показателей
	// Необходимо вызывать для каждого добавляемого показателя.
	// УниверсальныйОтчет.ДобавитьПоказатель(<ИмяПоказателя>, <ПредставлениеПоказателя>, <ВключенПоУмолчанию>, <Формат>, <ИмяГруппы>, <ПредставлениеГруппы>);
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаВзаиморасчетовНачальныйОстаток", "нач. остаток", Ложь, "ЧЦ=15; ЧДЦ=2", "СуммаВзаиморасчетов", "Сумма взаиморасчетов");
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаВзаиморасчетовПриход", "приход", Ложь, "ЧЦ=15; ЧДЦ=2", "СуммаВзаиморасчетов", "Сумма взаиморасчетов");
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаВзаиморасчетовРасход", "расход", Ложь, "ЧЦ=15; ЧДЦ=2", "СуммаВзаиморасчетов", "Сумма взаиморасчетов");
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаВзаиморасчетовКонечныйОстаток",  "кон. остаток", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаВзаиморасчетов", "Сумма взаиморасчетов");
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаУпрНачальныйОстаток", "нач. остаток", Ложь, "ЧЦ=15; ЧДЦ=2", "СуммаУпр", "Сумма " + ВалютаУпр);
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаУпрПриход", "приход", Ложь, "ЧЦ=15; ЧДЦ=2", "СуммаУпр", "Сумма " + ВалютаУпр);
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаУпрРасход", "расход", Ложь, "ЧЦ=15; ЧДЦ=2", "СуммаУпр", "Сумма " + ВалютаУпр);
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаУпрКонечныйОстаток", "кон. остаток", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаУпр", "Сумма " + ВалютаУпр);

	
	// Добавление предопределенных группировок строк отчета.
	// Необходимо вызывать для каждой добавляемой группировки строки.
	// УниверсальныйОтчет.ДобавитьИзмерениеСтроки(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Организация");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Контрагент");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ДоговорКонтрагента");

	
	// Добавление предопределенных группировок колонок отчета.
	// Необходимо вызывать для каждой добавляемой группировки колонки.
	// УниверсальныйОтчет.ДобавитьИзмерениеКолонки(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьИзмерениеКолонки("Интервал");

	
	// Добавление предопределенных отборов отчета.
	// Необходимо вызывать для каждого добавляемого отбора.
	// УниверсальныйОтчет.ДобавитьОтбор(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьОтбор("Организация");
	УниверсальныйОтчет.ДобавитьОтбор("Контрагент");
	УниверсальныйОтчет.ДобавитьОтбор("ДоговорКонтрагента");
	УниверсальныйОтчет.ДобавитьОтбор("СуммаУпрКонечныйОстаток", Истина, ВидСравнения.Больше, 0,,, Ложь);
	УниверсальныйОтчет.ДобавитьОтбор("СуммаВзаиморасчетовКонечныйОстаток", Истина, ВидСравнения.Больше, 0,,, Ложь);

	
	// Добавление предопределенных полей порядка отчета.
	// Необходимо вызывать для каждого добавляемого поля порядка.
	// УниверсальныйОтчет.ДобавитьПорядок(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьПорядок("Организация");
	УниверсальныйОтчет.ДобавитьПорядок("Контрагент");
    УниверсальныйОтчет.ДобавитьПорядок("ДоговорКонтрагента");

	
	// Установка связи подчиненных и родительских полей
	// УниверсальныйОтчет.УстановитьСвязьПолей(<ПутьКДанным>, <ПутьКДаннымРодитель>);
	УниверсальныйОтчет.УстановитьСвязьПолей("ВалютаВзаиморасчетов", "ДоговорКонтрагента");

	
	// Установка связи полей и измерений
	// УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения(<ИмяПоля>, <ИмяИзмерения>);
	
	// Установка представлений полей
	УниверсальныйОтчет.УстановитьПредставленияПолей(УниверсальныйОтчет.мСтруктураПредставлениеПолей, УниверсальныйОтчет.ПостроительОтчета);
	
	// Установка типов значений свойств в отборах отчета
	УниверсальныйОтчет.УстановитьТипыЗначенийСвойствДляОтбора();
	
	// Заполнение начальных настроек универсального отчета
	УниверсальныйОтчет.УстановитьНачальныеНастройки(Ложь);
	
	УниверсальныйОтчет.ВыводитьОбщиеИтоги = ложь;

	
	// Добавление дополнительных полей
	// Необходимо вызывать для каждого добавляемого дополнительного поля.
	// УниверсальныйОтчет.ДобавитьДополнительноеПоле(<ПутьКДанным>, <Размещение>, <Положение>);
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ВалютаВзаиморасчетов");

	
КонецПроцедуры // УстановитьНачальныеНастройки()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ОТЧЕТА 
	
// Процедура формирования отчета
//
Процедура СформироватьОтчет(ТабличныйДокумент) Экспорт
	
	// Перед формирование отчета можно установить необходимые параметры универсального отчета.
	
	УниверсальныйОтчет.СформироватьОтчет(ТабличныйДокумент,,, ЭтотОбъект);

КонецПроцедуры // СформироватьОтчет()

Функция ПолучитьТекстСправкиФормы() Экспорт
	
	Возврат "";
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура обработки расшифровки
//
Процедура ОбработкаРасшифровки(Расшифровка, Объект) Экспорт
	
	// Дополнительные параметры в расшифровывающий отчет можно передать
	// посредством инициализации переменной "ДополнительныеПараметры".
	
	ДополнительныеПараметры = УправлениеОтчетами.СохранитьРеквизитыОтчета(ЭтотОбъект);
	УниверсальныйОтчет.ОбработкаРасшифровкиУниверсальногоОтчета(Расшифровка, Объект, ДополнительныеПараметры);
	
КонецПроцедуры // ОбработкаРасшифровки()

// Формирует структуру для сохранения настроек отчета
//
Процедура СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками) Экспорт
	
	УниверсальныйОтчет.СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками);
	УправлениеОтчетами.СохранитьРеквизитыОтчета(ЭтотОбъект, СтруктураСНастройками);
	
КонецПроцедуры // СформироватьСтруктуруДляСохраненияНастроек()

// Заполняет настройки отчета из структуры сохраненных настроек
//
Функция ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками) Экспорт
	
	УправлениеОтчетами.ВосстановитьРеквизитыОтчета(ЭтотОбъект, СтруктураСНастройками);
	Возврат УниверсальныйОтчет.ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками, ЭтотОбъект);
	
КонецФункции // ВосстановитьНастройкиИзСтруктуры()

// Содержит значение используемого режима ввода периода.
// Тип: Число.
// Возможные значения: // (-1) - не выбирать период, 0 - произвольный период, 1 - на дату, 2 - неделя, 3 - декада, 4 - месяц, 5 - квартал, 6 - полугодие, 7 - год
// Значение по умолчанию: 0
// Пример:
// УниверсальныйОтчет.мРежимВводаПериода = 1;

#КонецЕсли
