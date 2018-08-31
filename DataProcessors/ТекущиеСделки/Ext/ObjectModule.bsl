﻿
Перем мСписокОтборов Экспорт;

Перем мСтруктураПредставленийОтборов Экспорт;

// Функция возвращает Строку Вида отбора для запроса
// 
// Параметры
// ВидОтбора - ВидОтбора
// ЗначениеОтбора - Значение отбора запроса
// 
// Возвращаемое значение 
//  Строка для запроса
Функция ВозвратитьСтрокуВидаОтбора(ВидОтбора, ЗначениеОтбора)

	СтрокаВозврата = "";
	Если ВидОтбора = ВидСравнения.Равно Тогда
		СтрокаВозврата = Строка("= "+ЗначениеОтбора);
	ИначеЕсли ВидОтбора = ВидСравнения.НеРавно Тогда
		СтрокаВозврата = Строка("<> "+ЗначениеОтбора);
	ИначеЕсли ВидОтбора = ВидСравнения.ВСписке Тогда
		СтрокаВозврата = Строка("В ("+ЗначениеОтбора+")");
	ИначеЕсли ВидОтбора = ВидСравнения.НеВСписке Тогда
		СтрокаВозврата = Строка("НЕ В ("+ЗначениеОтбора+")");
	КонецЕсли;

	Возврат СтрокаВозврата;
	
КонецФункции // ВозвратитьСтрокуВидаОтбора()

// Процедура заполняет табличную часть обработки Сделки
// 
// Параметры
//  НЕТ
// 
// Возвращаемое значение 
//  НЕТ
Процедура ЗаполнитьСделки() Экспорт
	
	Перем Отбор;

	Запрос = Новый Запрос;

	Запрос.УстановитьПараметр("ВыбПоДоговору", Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоДоговоруВЦелом);
	Запрос.УстановитьПараметр("ДатаНач"      , ДатаНач);
	Запрос.УстановитьПараметр("ДатаКон"      , ДатаКон);
	Запрос.УстановитьПараметр("ТекущаяДата"  , ТекущаяДата());
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	КонтрагентыВзаиморасчетыКомпании.Сделка.Дата КАК Дата,
	               |	КонтрагентыВзаиморасчетыКомпании.Сделка.Номер КАК Номер,
	               |	ВЫБОР
	               |		КОГДА КонтрагентыВзаиморасчетыКомпании.Сделка.Проведен
	               |			ТОГДА 0
	               |		КОГДА КонтрагентыВзаиморасчетыКомпании.Сделка.ПометкаУдаления
	               |			ТОГДА 1
	               |		ИНАЧЕ 2
	               |	КОНЕЦ КАК Проведен,
	               |	КонтрагентыВзаиморасчетыКомпании.Сделка.ВидОперации КАК ВидОперации,
	               |	КонтрагентыВзаиморасчетыКомпании.Сделка КАК Документ,
	               |	КонтрагентыВзаиморасчетыКомпании.Контрагент КАК Контрагент,
	               |	КонтрагентыВзаиморасчетыКомпании.СуммаВзаиморасчетовОстаток КАК ЗависшаяСуммаСделки,
	               |	КонтрагентыВзаиморасчетыКомпании.ДоговорКонтрагента КАК ДоговорКонтрагента,
	               |	КонтрагентыВзаиморасчетыКомпании.ДоговорКонтрагента.ВалютаВзаиморасчетов КАК Валюта,
	               |	ВЫБОР
	               |		КОГДА КонтрагентыВзаиморасчетыКомпании.Сделка ССЫЛКА Документ.ЗаказПокупателя
	               |			ТОГДА ВЫБОР
	               |					КОГДА СуммыЗаказовПокупателей.СуммаСделки ЕСТЬ NULL 
	               |						ТОГДА 0
	               |					ИНАЧЕ ВЫБОР
	               |							КОГДА СуммыЗаказовПокупателей.СуммаСделки < 0
	               |								ТОГДА -1 * СуммыЗаказовПокупателей.СуммаСделки
	               |							ИНАЧЕ СуммыЗаказовПокупателей.СуммаСделки
	               |						КОНЕЦ
	               |				КОНЕЦ
	               |		КОГДА КонтрагентыВзаиморасчетыКомпании.Сделка ССЫЛКА Документ.ЗаказПоставщику
	               |			ТОГДА ВЫБОР
	               |					КОГДА СуммыЗаказовПоставщикам.СуммаСделки ЕСТЬ NULL 
	               |						ТОГДА 0
	               |					ИНАЧЕ ВЫБОР
	               |							КОГДА СуммыЗаказовПоставщикам.СуммаСделки < 0
	               |								ТОГДА -1 * СуммыЗаказовПоставщикам.СуммаСделки
	               |							ИНАЧЕ СуммыЗаказовПоставщикам.СуммаСделки
	               |						КОНЕЦ
	               |				КОНЕЦ
	               |		ИНАЧЕ ВЫБОР
	               |				КОГДА СуммыСделок.СуммаСделки ЕСТЬ NULL 
	               |					ТОГДА 0
	               |				ИНАЧЕ ВЫБОР
	               |						КОГДА СуммыСделок.СуммаСделки < 0
	               |							ТОГДА -1 * СуммыСделок.СуммаСделки
	               |						ИНАЧЕ СуммыСделок.СуммаСделки
	               |					КОНЕЦ
	               |			КОНЕЦ
	               |	КОНЕЦ КАК ОбщаяСуммаСделки
	               |ИЗ
	               |	РегистрНакопления.РасчетыСКонтрагентами.Остатки(&ТекущаяДата, ) КАК КонтрагентыВзаиморасчетыКомпании
	               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			РасчетыСКонтрагентамиВсяТаблица.Регистратор КАК Сделка,
	               |			СУММА(РасчетыСКонтрагентамиВсяТаблица.СуммаВзаиморасчетов) КАК СуммаСделки
	               |		ИЗ
	               |			РегистрНакопления.РасчетыСКонтрагентами КАК РасчетыСКонтрагентамиВсяТаблица
	               |		
	               |		СГРУППИРОВАТЬ ПО
	               |			РасчетыСКонтрагентамиВсяТаблица.Регистратор) КАК СуммыСделок
	               |		ПО (СуммыСделок.Сделка = КонтрагентыВзаиморасчетыКомпании.Сделка)
	               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			ЗаказыПокупателейВсяТаблица.ЗаказПокупателя КАК Сделка,
	               |			СУММА(ЗаказыПокупателейВсяТаблица.СуммаВзаиморасчетов) КАК СуммаСделки
	               |		ИЗ
	               |			РегистрНакопления.ЗаказыПокупателей КАК ЗаказыПокупателейВсяТаблица
	               |		ГДЕ
	               |			(ЗаказыПокупателейВсяТаблица.Регистратор ССЫЛКА Документ.ЗаказПокупателя
	               |					ИЛИ ЗаказыПокупателейВсяТаблица.Регистратор ССЫЛКА Документ.КорректировкаЗаказаПокупателя
	               |					ИЛИ ЗаказыПокупателейВсяТаблица.Регистратор ССЫЛКА Документ.ИзменениеЗаказаПокупателя
	               |					ИЛИ ЗаказыПокупателейВсяТаблица.Регистратор ССЫЛКА Документ.ЗаказПоставщику
	               |					ИЛИ ЗаказыПокупателейВсяТаблица.Регистратор ССЫЛКА Документ.КорректировкаЗаказаПоставщику)
	               |		
	               |		СГРУППИРОВАТЬ ПО
	               |			ЗаказыПокупателейВсяТаблица.ЗаказПокупателя) КАК СуммыЗаказовПокупателей
	               |		ПО (СуммыЗаказовПокупателей.Сделка = КонтрагентыВзаиморасчетыКомпании.Сделка)
	               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			ЗаказыПоставщикамВсяТаблица.ЗаказПоставщику КАК Сделка,
	               |			СУММА(ЗаказыПоставщикамВсяТаблица.СуммаВзаиморасчетов) КАК СуммаСделки
	               |		ИЗ
	               |			РегистрНакопления.ЗаказыПоставщикам КАК ЗаказыПоставщикамВсяТаблица
	               |		ГДЕ
	               |			(ЗаказыПоставщикамВсяТаблица.Регистратор ССЫЛКА Документ.ЗаказПокупателя
	               |					ИЛИ ЗаказыПоставщикамВсяТаблица.Регистратор ССЫЛКА Документ.КорректировкаЗаказаПокупателя
	               |					ИЛИ ЗаказыПоставщикамВсяТаблица.Регистратор ССЫЛКА Документ.ИзменениеЗаказаПокупателя
	               |					ИЛИ ЗаказыПоставщикамВсяТаблица.Регистратор ССЫЛКА Документ.ЗаказПоставщику
	               |					ИЛИ ЗаказыПоставщикамВсяТаблица.Регистратор ССЫЛКА Документ.КорректировкаЗаказаПоставщику)
	               |		
	               |		СГРУППИРОВАТЬ ПО
	               |			ЗаказыПоставщикамВсяТаблица.ЗаказПоставщику) КАК СуммыЗаказовПоставщикам
	               |		ПО (СуммыЗаказовПоставщикам.Сделка = КонтрагентыВзаиморасчетыКомпании.Сделка)
	               |ГДЕ
	               |	КонтрагентыВзаиморасчетыКомпании.Сделка.Дата >= &ДатаНач" + ?(ДатаКон <> Дата("000101010000")," И КонтрагентыВзаиморасчетыКомпании.Сделка.Дата <= &ДатаКон","") + "
                   |
	               |";

	Отбор = СтруктураОтборов.Получить("Пользователь");
	Если Отбор <> Неопределено Тогда

		Запрос.Текст = Запрос.Текст + "
		|	И
		|	КонтрагентыВзаиморасчетыКомпании.Сделка.Ответственный " + ВозвратитьСтрокуВидаОтбора(Отбор[0],"&ВыбОтветственный") + "
		|";
		Запрос.УстановитьПараметр("ВыбОтветственный",Отбор[1]);
		
	КонецЕсли;

	Отбор = СтруктураОтборов.Получить("Контрагент");
	Если Отбор <> Неопределено Тогда

		Запрос.Текст = Запрос.Текст + "
		|	И
		|	КонтрагентыВзаиморасчетыКомпании.Контрагент " + ВозвратитьСтрокуВидаОтбора(Отбор[0],"&ВыбКонтрагент") + "
		|";
		Запрос.УстановитьПараметр("ВыбКонтрагент",Отбор[1]);
		
	КонецЕсли;
	
	Сделки.Очистить();
	Сделки.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

// Заполним реквизиты обработки по умолчанию
ДатаНач = НачалоДня(Дата("000101010000"));
ДатаКон = КонецДня(ТекущаяДата());

Отборы = Новый Соответствие;
МассивЗначенийОтбора = Новый Массив;
МассивЗначенийОтбора.Добавить(ВидСравнения.Равно);
МассивЗначенийОтбора.Добавить(ПараметрыСеанса.ТекущийПользователь);
Отборы.Вставить("Пользователь", МассивЗначенийОтбора);
СтруктураОтборов = Отборы;

мСписокОтборов = Новый СписокЗначений;
мСтруктураПредставленийОтборов = Новый Структура;
мСтруктураПредставленийОтборов.Вставить("Дата", "Дата");
мСписокОтборов.Добавить("Контрагент","СправочникСсылка.Контрагенты");
мСтруктураПредставленийОтборов.Вставить("Контрагент", "Контрагент");
мСписокОтборов.Добавить("Пользователь","СправочникСсылка.Пользователи");
мСтруктураПредставленийОтборов.Вставить("Пользователь", "Ответственный");
мСписокОтборов.Добавить("Сумма","Сумма");
мСтруктураПредставленийОтборов.Вставить("Сумма", "Сумма");
мСписокОтборов.Добавить("ОбщаяСуммаСделки", "Сумма");
мСтруктураПредставленийОтборов.Вставить("ОбщаяСуммаСделки", "Общая сумма сделки");
мСписокОтборов.Добавить("Валюта", "СправочникСсылка.Валюты");
мСтруктураПредставленийОтборов.Вставить("Валюта", "Валюта");
мСписокОтборов.Добавить("ТипДокумента","ОписаниеТипов");
мСтруктураПредставленийОтборов.Вставить("ТипДокумента", "Вид документа");
мСписокОтборов.Добавить("Договор","СправочникСсылка.ДоговорыКонтрагентов");
мСтруктураПредставленийОтборов.Вставить("Договор", "Договор контрагента");
мСписокОтборов.Добавить("Номер","Строка");
мСтруктураПредставленийОтборов.Вставить("Номер", "Номер документа");
мСписокОтборов.Добавить("ВидОперации","");
мСтруктураПредставленийОтборов.Вставить("ВидОперации", "Вид операции");
