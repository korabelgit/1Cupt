﻿#Если Клиент Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ НАЧАЛЬНОЙ НАСТРОЙКИ ОТЧЕТА

// Процедура установки начальных настроек отчета с использованием текста запроса
//
Процедура УстановитьНачальныеНастройки(ДополнительныеПараметры = Неопределено) Экспорт
	
	// Настройка общих параметров универсального отчета
	
	// Содержит название отчета, которое будет выводиться в шапке.
	// Тип: Строка.
	// Пример:
	// УниверсальныйОтчет.мНазваниеОтчета = "Название отчета";
	УниверсальныйОтчет.мНазваниеОтчета = СокрЛП(ЭтотОбъект.Метаданные().Синоним);
	
	// Содержит признак необходимости отображения надписи и поля выбора раздела учета в форме настройки.
	// Тип: Булево.
	// Значение по умолчанию: Истина.
	// Пример:
	УниверсальныйОтчет.мВыбиратьИмяРегистра = Ложь;
	
	// Содержит имя регистра, по метаданным которого будет выполняться заполнение настроек отчета.
	// Тип: Строка.
	// Пример:
	// УниверсальныйОтчет.ИмяРегистра = "ТоварыНаСкладах";
	УниверсальныйОтчет.ИмяРегистра = "";
	
	// Содержит признак необходимости вывода отрицательных значений показателей красным цветом.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.ОтрицательноеКрасным = Истина;
	УниверсальныйОтчет.ОтрицательноеКрасным = Ложь;
	
	// Содержит признак необходимости вывода в отчет общих итогов.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.ВыводитьОбщиеИтоги = Ложь;
	УниверсальныйОтчет.ВыводитьОбщиеИтоги = Ложь;
	
	// Содержит признак необходимости вывода детальных записей в отчет.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	УниверсальныйОтчет.ВыводитьДетальныеЗаписи = Истина;
	
	// Содержит признак необходимости отображения флага использования свойств и категорий в форме настройки.
	// Тип: Булево.
	// Значение по умолчанию: Истина.
	// Пример:
	// УниверсальныйОтчет.мВыбиратьИспользованиеСвойств = Ложь;
	УниверсальныйОтчет.мВыбиратьИспользованиеСвойств = Истина;
	
	// Содержит признак использования свойств и категорий при заполнении настроек отчета.
	// Тип: Булево.
	// Значение по умолчанию: Истина.
	// Пример:
	// УниверсальныйОтчет.ИспользоватьСвойстваИКатегории = Истина;
	//УниверсальныйОтчет.ИспользоватьСвойстваИКатегории = Ложь;
	
	// Содержит признак использования простой формы настроек отчета без группировок колонок.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	УниверсальныйОтчет.мРежимФормыНастройкиБезГруппировокКолонок = Истина;
	
	// Дополнительные параметры, переданные из отчета, вызвавшего расшифровку.
	// Информация, передаваемая в переменной ДополнительныеПараметры, может быть использована
	// для реализации специфичных для данного отчета параметрических настроек.
	
	// Описание исходного текста запроса.
	// При написании текста запроса рекомендуется следовать правилам, описанным в следующем шаблоне текста запроса:
	//
	//ВЫБРАТЬ
	//	<ПсевдонимТаблицы.Поле> КАК <ПсевдонимПоля>,
	//	ПРЕДСТАВЛЕНИЕ(<ПсевдонимТаблицы>.<Поле>),
	//	<ПсевдонимТаблицы.Показатель> КАК <ПсевдонимПоказателя>
	//	//ПОЛЯ_СВОЙСТВА
	//	//ПОЛЯ_КАТЕГОРИИ
	//{ВЫБРАТЬ
	//	<ПсевдонимПоля>.*,
	//	<ПсевдонимПоказателя>,
	//	Регистратор,
	//	Период,
	//	ПериодДень,
	//	ПериодНеделя,
	//	ПериодДекада,
	//	ПериодМесяц,
	//	ПериодКвартал,
	//	ПериодПолугодие,
	//	ПериодГод
	//	//ПОЛЯ_СВОЙСТВА
	//	//ПОЛЯ_КАТЕГОРИИ
	//}
	//ИЗ
	//	<Таблица> КАК <ПсевдонимТаблицы>
	//	//СОЕДИНЕНИЯ
	//{ГДЕ
	//	<ПсевдонимТаблицы.Поле>.* КАК <ПсевдонимПоля>,
	//	<ПсевдонимТаблицы.Показатель> КАК <ПсевдонимПоказателя>,
	//	<ПсевдонимТаблицы>.Регистратор КАК Регистратор,
	//	<ПсевдонимТаблицы>.Период КАК Период,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, ДЕНЬ) КАК ПериодДень,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, НЕДЕЛЯ) КАК ПериодНеделя,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, ДЕКАДА) КАК ПериодДекада,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, МЕСЯЦ) КАК ПериодМесяц,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, КВАРТАЛ) КАК ПериодКвартал,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, ПОЛУГОДИЕ) КАК ПериодПолугодие,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, ГОД) КАК ПериодГод
	//	//ПОЛЯ_СВОЙСТВА
	//	//ПОЛЯ_КАТЕГОРИИ
	//}
	//{УПОРЯДОЧИТЬ ПО
	//	<ПсевдонимПоля>.*,
	//	<ПсевдонимПоказателя>,
	//	Регистратор,
	//	Период,
	//	ПериодДень,
	//	ПериодНеделя,
	//	ПериодДекада,
	//	ПериодМесяц,
	//	ПериодКвартал,
	//	ПериодПолугодие,
	//	ПериодГод
	//	//УПОРЯДОЧИТЬ_СВОЙСТВА
	//	//УПОРЯДОЧИТЬ_КАТЕГОРИИ
	//}
	//ИТОГИ
	//	АГРЕГАТНАЯ_ФУНКЦИЯ(<ПсевдонимПоказателя>)
	//	//ИТОГИ_СВОЙСТВА
	//	//ИТОГИ_КАТЕГОРИИ
	//ПО
	//	ОБЩИЕ
	//{ИТОГИ ПО
	//	<ПсевдонимПоля>.*,
	//	Регистратор,
	//	Период,
	//	ПериодДень,
	//	ПериодНеделя,
	//	ПериодДекада,
	//	ПериодМесяц,
	//	ПериодКвартал,
	//	ПериодПолугодие,
	//	ПериодГод
	//	//ПОЛЯ_СВОЙСТВА
	//	//ПОЛЯ_КАТЕГОРИИ
	//}
	//АВТОУПОРЯДОЧИВАНИЕ
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РезультатыСертификацииНоменклатуры.Регистратор КАК ДокСертификации,
	|	РезультатыСертификацииНоменклатуры.СерияНоменклатуры.Владелец КАК Номенклатура,
	|	РезультатыСертификацииНоменклатуры.СерияНоменклатуры КАК СерияНоменклатуры,
	|	РезультатыСертификацииНоменклатуры.ПоказательАнализа КАК ПоказательАнализа,
	|	РезультатыСертификацииНоменклатуры.НомерСтрокиДокумента КАК НомерСтрокиДокумента,
	|	РезультатыСертификацииНоменклатуры.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	РезультатыСертификацииНоменклатуры.ЗначениеПоказателя КАК ЗначениеПоказателя,
	|	РезультатыСертификацииНоменклатуры.МаксЗначений КАК МаксЗначений,
	|	РезультатыСертификацииНоменклатуры.СоответствуетНормативу КАК СоответствуетНормативу,
	|	РезультатыСертификацииНоменклатуры.ПоказательАнализа.МинЗначение КАК НормативЗначение,
	|	РезультатыСертификацииНоменклатуры.ПоказательАнализа.МаксЗначение КАК НормативМаксЗначение,
	|	РезультатыСертификацииНоменклатуры.ПоказательАнализа.ЕдиницаИзмерения КАК НормативЕдиницаИзмерения
	|	//ПОЛЯ_СВОЙСТВА
	|	//ПОЛЯ_КАТЕГОРИИ

	|{ВЫБРАТЬ
	|	ДокСертификации.*,
	|	Номенклатура.*,
	|	СерияНоменклатуры КАК СерияНоменклатуры,
	|	ПоказательАнализа КАК ПоказательАнализа,
	|	ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ЗначениеПоказателя КАК ЗначениеПоказателя,
	|	МаксЗначений КАК МаксЗначений,
	|	СоответствуетНормативу КАК СоответствуетНормативу,
	|	РезультатыСертификацииНоменклатуры.НомерСтрокиДокумента КАК НомерСтрокиДокумента,
	|	НормативЗначение КАК НормативЗначение,
	|	НормативМаксЗначение КАК НормативМаксЗначение,
	|	НормативЕдиницаИзмерения КАК НормативЕдиницаИзмерения
	|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ

	|}

	|ИЗ
	|	РегистрСведений.РезультатыСертификацииНоменклатуры КАК РезультатыСертификацииНоменклатуры
	|	//СОЕДИНЕНИЯ

	|ГДЕ
	|	РезультатыСертификацииНоменклатуры.Период МЕЖДУ &НачДата И &КонДата
	|{ГДЕ
	|	РезультатыСертификацииНоменклатуры.СерияНоменклатуры.*,
	|	РезультатыСертификацииНоменклатуры.НомерСтрокиДокумента,
	|	РезультатыСертификацииНоменклатуры.ПоказательАнализа,
	|	РезультатыСертификацииНоменклатуры.ЕдиницаИзмерения,
	|	РезультатыСертификацииНоменклатуры.ЗначениеПоказателя,
	|	РезультатыСертификацииНоменклатуры.МаксЗначений,
	|	РезультатыСертификацииНоменклатуры.СоответствуетНормативу,
	|	РезультатыСертификацииНоменклатуры.СерияНоменклатуры.Владелец.* КАК Номенклатура,
	|	РезультатыСертификацииНоменклатуры.Регистратор.* КАК ДокСертификации,
	|	РезультатыСертификацииНоменклатуры.ПоказательАнализа.МинЗначение КАК НормативЗначение,
	|	РезультатыСертификацииНоменклатуры.ПоказательАнализа.МаксЗначение КАК НормативМаксЗначение,
	|	РезультатыСертификацииНоменклатуры.ПоказательАнализа.ЕдиницаИзмерения КАК НормативЕдиницаИзмерения
	|	//УСЛОВИЯ_СВОЙСТВА
	|	//УСЛОВИЯ_КАТЕГОРИИ
	|}

	|{УПОРЯДОЧИТЬ ПО
	|	ДокСертификации.*,
	|	Номенклатура.*,
	|	СерияНоменклатуры КАК СерияНоменклатуры,
	|	ПоказательАнализа КАК ПоказательАнализа,
	|	ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ЗначениеПоказателя КАК ЗначениеПоказателя,
	|	МаксЗначений КАК МаксЗначений,
	|	СоответствуетНормативу КАК СоответствуетНормативу,
	|	РезультатыСертификацииНоменклатуры.НомерСтрокиДокумента КАК НомерСтрокиДокумента,
	|	НормативЗначение КАК НормативЗначение,
	|	НормативМаксЗначение КАК НормативМаксЗначение,
	|	НормативЕдиницаИзмерения КАК НормативЕдиницаИзмерения
	|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ

	|}

	|{ИТОГИ ПО
	|	СерияНоменклатуры.*,
	|	ПоказательАнализа.*,
	|	Номенклатура.*,
	|	ДокСертификации.*
	|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
	|}";

	
	// В универсальном отчете включен флаг использования свойств и категорий.
	Если УниверсальныйОтчет.ИспользоватьСвойстваИКатегории Тогда
		
		// Добавление свойств и категорий поля запроса в таблицу полей.
		// Необходимо вызывать для каждого поля запроса, предоставляющего возможность использования свойств и категорий.
		
		// УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля(<ПсевдонимТаблицы>.<Поле> , <ПсевдонимПоля>, <Представление>, <Назначение>);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("РезультатыСертификацииНоменклатуры.СерияНоменклатуры.Владелец" , "Номенклатура", "Номенклатура", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Номенклатура);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("РезультатыСертификацииНоменклатуры.Регистратор" , "ДокСертификации", "Документ сертификации", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Документы);

		// Добавление свойств и категорий в исходный текст запроса.
		УниверсальныйОтчет.ДобавитьВТекстЗапросаСвойстваИКатегории(ТекстЗапроса);
		
	КонецЕсли;
		
	// Инициализация текста запроса построителя отчета
	// УниверсальныйОтчет.ПостроительОтчета.Текст = ТекстЗапроса;
	УниверсальныйОтчет.ПостроительОтчета.Текст = ТекстЗапроса;
	
	// Представления полей отчета.
	// Необходимо вызывать для каждого поля запроса.
	// УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить(<ИмяПоля>, <ПредставлениеПоля>);
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ЗначениеПоказателя",        "Значение показателя");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("МаксЗначений",              "Макс. значений");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ЕдиницаИзмерения",          "Ед. изм.");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СоответствуетНормативу",    "Соответствует нормативу");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СерияНоменклатуры",         "Серия номенклатуры");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СерияНоменклатурыВладелец", "Номенклатура");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ПоказательАнализа",         "Показатель анализа");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДокСертификации",           "Документ сертификации");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("НомерСтрокиДокумента",      "Номер строки документа");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("НормативЗначение",          "Значение показателя (по нормативу)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("НормативМаксЗначение",      "Макс. значений (по нормативу)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("НормативЕдиницаИзмерения",  "Ед. изм. (по нормативу)");
	
	// Добавление показателей
	// Необходимо вызывать для каждого добавляемого показателя.
	// УниверсальныйОтчет.ДобавитьПоказатель(<ИмяПоказателя>, <ПредставлениеПоказателя>, <ВключенПоУмолчанию>, <Формат>, <ИмяГруппы>, <ПредставлениеГруппы>);
	УниверсальныйОтчет.ДобавитьПоказатель( "ЗначениеПоказателя",         "Значение" + Символы.ПС + "показателя",     Истина, , "Факт",     "Результат" + Символы.ПС + "измерений");
	УниверсальныйОтчет.ДобавитьПоказатель( "МаксЗначений",               "Макс."    + Символы.ПС + "значение",       Истина, , "Факт",     "Результат" + Символы.ПС + "измерений");
	УниверсальныйОтчет.ДобавитьПоказатель( "ЕдиницаИзмерения",           "Ед. изм.",                                 Истина, , "Факт",     "Результат" + Символы.ПС + "измерений");
	УниверсальныйОтчет.ДобавитьПоказатель( "НормативЗначение",           "Значение" + Символы.ПС + "показателя",     Истина, , "Норматив", "Нормативное" + Символы.ПС + "значение");
	УниверсальныйОтчет.ДобавитьПоказатель( "НормативМаксЗначение",       "Макс."    + Символы.ПС + "значение",       Истина, , "Норматив", "Нормативное" + Символы.ПС + "значение");
	УниверсальныйОтчет.ДобавитьПоказатель( "НормативЕдиницаИзмерения",   "Ед. изм.",                                 Истина, , "Норматив", "Нормативное" + Символы.ПС + "значение");
	УниверсальныйОтчет.ДобавитьПоказатель( "СоответствуетНормативу", "Соответствует" + Символы.ПС + "нормативу", Истина, "БЛ=Нет; БИ=Да", , );
	
	// Добавление предопредедленных группировок строк отчета.
	// Необходимо вызывать для каждой добавляемой группировки строки.
	// УниверсальныйОтчет.ДобавитьИзмерениеСтроки(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Номенклатура");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ДокСертификации");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("СерияНоменклатуры");
	
	// Добавление предопредедленных группировок колонок отчета.
	// Необходимо вызывать для каждой добавляемой группировки колонки.
	// УниверсальныйОтчет.ДобавитьИзмерениеКолонки(<ПутьКДанным>);
	
	// Добавление предопредедленных отборов отчета.
	// Необходимо вызывать для каждого добавляемого отбора.
	// УниверсальныйОтчет.ДобавитьОтбор(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьОтбор("Номенклатура");
	УниверсальныйОтчет.ДобавитьОтбор("СерияНоменклатуры");
	УниверсальныйОтчет.ДобавитьОтбор("ПоказательАнализа");
	
	// Установка представлений полей
	// УниверсальныйОтчет.УстановитьПредставленияПолей(УниверсальныйОтчет.мСтруктураПредставлениеПолей, УниверсальныйОтчет.ПостроительОтчета);
	УниверсальныйОтчет.УстановитьПредставленияПолей(УниверсальныйОтчет.мСтруктураПредставлениеПолей, УниверсальныйОтчет.ПостроительОтчета);
	
	// Установка типов значений свойств в отборах отчета
	УниверсальныйОтчет.УстановитьТипыЗначенийСвойствДляОтбора();
	
	// Заполнение начальных настроек универсального отчета
	УниверсальныйОтчет.УстановитьНачальныеНастройки(Ложь);
	
	// Добавление дополнительных полей
	// Необходимо вызывать для каждого добавляемого дополнительного поля.
	// УниверсальныйОтчет.ДобавитьДополнительноеПоле(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ПоказательАнализа", ТипРазмещенияРеквизитовИзмерений.ВместеСИзмерениями);
	//УниверсальныйОтчет.ДобавитьДополнительноеПоле("Регистратор");
	//УниверсальныйОтчет.ДобавитьДополнительноеПоле("Номенклатура");
	//УниверсальныйОтчет.ДобавитьДополнительноеПоле("СерияНоменклатуры");
	
КонецПроцедуры // УстановитьНачальныеНастройки()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ОТЧЕТА 
	
// Процедура формирования отчета
//
Процедура СформироватьОтчет(ТабличныйДокумент) Экспорт
	
	КонДата = Дата(УниверсальныйОтчет.ДатаКон);
	КонДата = КонецДня(?(КонДата = Дата('00010101000000'), Дата('39991231235959'), КонДата));
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить( "НачДата", Дата(УниверсальныйОтчет.ДатаНач));
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить( "КонДата", КонДата);
	
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
	
	ДополнительныеПараметры = Неопределено;
	УниверсальныйОтчет.ОбработкаРасшифровкиУниверсальногоОтчета(Расшифровка, Объект, ДополнительныеПараметры);
	
КонецПроцедуры // ОбработкаРасшифровки()

// Формирует структуру для сохранения настроек отчета
//
Процедура СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками) Экспорт
	
	УниверсальныйОтчет.СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками);
	
КонецПроцедуры // СформироватьСтруктуруДляСохраненияНастроек()

// Заполняет настройки отчета из структуры сохраненных настроек
//
Функция ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками) Экспорт
	
	Возврат УниверсальныйОтчет.ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками, ЭтотОбъект);
	
КонецФункции // ВосстановитьНастройкиИзСтруктуры()

// Содержит значение используемого режима ввода периода.
// Тип: Число.
// Возможные значения: 0 - произвольный период, 1 - на дату, 2 - неделя, 3 - декада, 4 - месяц, 5 - квартал, 6 - полугодие, 7 - год
// Значение по умолчанию: 0
// Пример:
// УниверсальныйОтчет.мРежимВводаПериода = 1;

#КонецЕсли
