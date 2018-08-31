﻿// В функции описано, какие данные следует сохранять в шаблоне
Функция СтруктураДополнительныхДанныхФормы() Экспорт
	
	Возврат ХранилищаНастроек.ДанныеФорм.СформироватьСтруктуруДополнительныхДанных("Товары,ВозвратнаяТара,Услуги");
	
КонецФункции

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ОшибкиПечати          - Список значений  - Ошибки печати  (значение - ссылка на объект, представление - текст ошибки)
//   ОбъектыПечати         - Список значений  - Объекты печати (значение - ссылка на объект, представление - имя области в которой был выведен объект)
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Заказ") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Заказ", "Счет на оплату поставщика", ПечатьСчетаЗаказа(МассивОбъектов, ОбъектыПечати, "Заказ"));
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЗаказПоДаннымПоставщика") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ЗаказПоДаннымПоставщика", "Счет на оплату поставщика (по данным поставщика)", ПечатьСчетаЗаказа(МассивОбъектов, ОбъектыПечати, "ЗаказПоДаннымПоставщика"));
	КонецЕсли;
КонецПроцедуры

// Функция формирует табличный документ с печатной формой заказа или счета,
// разработанного методистами
//
// Возвращаемое значение:
//  Табличный документ - сформированная печатная форма
//
Функция ПечатьСчетаЗаказа(МассивОбъектов, ОбъектыПечати, Тип)
	
	ТабДокумент = Новый ТабличныйДокумент;
	Если Тип = "ЗаказПоДаннымПоставщика" Тогда
		ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_СчетНаОплатуПоставщика_СчетЗаказПоДаннымПоставщика";
	Иначе
		ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_СчетНаОплатуПоставщика_СчетЗаказ";
	КонецЕсли;
	
	Макет = ПолучитьОбщийМакет("СчетЗаказ");
	
	// печать производится на языке, указанном в настройках пользователя
	КодЯзыкаПечать = Локализация.ПолучитьЯзыкФормированияПечатныхФорм(УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "РежимФормированияПечатныхФорм"));
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;
	
	ПервыйДокумент = Истина;
	
	Для каждого Ссылка Из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		ПараметрыПечати = ПолучитьПараметрыПечатиСчетаЗаказа(Тип, Ссылка);
	
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Номер,
		|	Дата,
		|	ДатаПоступления,
		|	ДоговорКонтрагента,
		|	ДоговорКонтрагента,
		|	ДоговорКонтрагента.ВидДоговора КАК ВидДоговораКонтрагента,
		|	ДоговорКонтрагента.ВедениеВзаиморасчетов КАК ДоговорВедениеВзаиморасчетов,
		|	ДоговорКонтрагента.НаименованиеДляПечати КАК ДоговорНаименованиеДляПечати,	
		|	ДоговорКонтрагента.ВыводитьИнформациюОСделкеПриПечатиДокументов КАК ПечататьСделку,		
		|	Контрагент КАК Поставщик,
		|	Организация,	
		|	Организация КАК Покупатель,
		|	СуммаДокумента,
		|	ВалютаДокумента,
		|	УчитыватьНДС,
		|	СуммаВключаетНДС
		|ИЗ
		|	Документ.СчетНаОплатуПоставщика КАК СчетНаОплатуПоставщика
		|
		|ГДЕ
		|	СчетНаОплатуПоставщика.Ссылка = &ТекущийДокумент";
		Шапка = Запрос.Выполнить().Выбрать();
		Шапка.Следующий();

		Запрос = Новый Запрос;


		// Определим параметры запроса и табличного документа  
		// в зависимости от необходимости отображения артикула поставщика  
		Если Тип = "ЗаказПоДаннымПоставщика" Тогда
			
			ТекстПоляТовараДляТоваров = "
			|	ВЫБОР КОГДА (НаименованиеКонтрагента ЕСТЬ NULL ИЛИ НаименованиеКонтрагента = """") ТОГДА ВЫРАЗИТЬ(ВложенныйЗапрос.Номенклатура.НаименованиеПолное КАК СТРОКА(1000)) ИНАЧЕ НаименованиеКонтрагента КОНЕЦ КАК Товар,";

			ТекстПоляТовараДляБСУ = "
			|	ВЫБОР КОГДА (ВЫРАЗИТЬ (НаименованиеНоменклатурыКонтрагента КАК Строка(1000)) ЕСТЬ NULL ИЛИ ВЫРАЗИТЬ (НаименованиеНоменклатурыКонтрагента КАК Строка(1000)) = """") ТОГДА ВЫРАЗИТЬ (СчетНаОплатуПоставщика.Номенклатура.НаименованиеПолное КАК СТРОКА(1000)) ИНАЧЕ ВЫРАЗИТЬ (НаименованиеНоменклатурыКонтрагента КАК Строка(1000)) КОНЕЦ КАК Товар,";
			
			ТекстПоляТовараДляОборудования = "
			|	ВЫБОР КОГДА (ВЫРАЗИТЬ (НаименованиеНоменклатурыКонтрагента КАК Строка(1000)) ЕСТЬ NULL ИЛИ ВЫРАЗИТЬ (НаименованиеНоменклатурыКонтрагента КАК Строка(1000)) = """") ТОГДА ВЫРАЗИТЬ (СчетНаОплатуПоставщика.Номенклатура.НаименованиеПолное КАК СТРОКА(1000)) ИНАЧЕ ВЫРАЗИТЬ (НаименованиеНоменклатурыКонтрагента КАК Строка(1000)) КОНЕЦ КАК Товар,";

			ТекстПоляТовараДляУслуг = "
			|	ВЫБОР КОГДА (ВЫРАЗИТЬ (НаименованиеНоменклатурыКонтрагента КАК Строка(1000)) ЕСТЬ NULL ИЛИ ВЫРАЗИТЬ (НаименованиеНоменклатурыКонтрагента КАК Строка(1000)) = """") ТОГДА ВЫРАЗИТЬ (СчетНаОплатуПоставщика.Содержание КАК СТРОКА(1000)) ИНАЧЕ ВЫРАЗИТЬ (НаименованиеНоменклатурыКонтрагента КАК Строка(1000)) КОНЕЦ КАК Товар,";

			ТекстПоляТовараДляТары = "
			|	ВЫБОР КОГДА (ВЫРАЗИТЬ (НаименованиеНоменклатурыКонтрагента КАК Строка(1000)) ЕСТЬ NULL ИЛИ ВЫРАЗИТЬ (НаименованиеНоменклатурыКонтрагента КАК Строка(1000)) = """") ТОГДА ВЫРАЗИТЬ (СчетНаОплатуПоставщика.Номенклатура.НаименованиеПолное КАК СТРОКА(1000)) ИНАЧЕ ВЫРАЗИТЬ (НаименованиеНоменклатурыКонтрагента КАК Строка(1000)) КОНЕЦ КАК Товар,";
		
			ТекстПоляТовараДляНМА = "
			|	ВЫРАЗИТЬ(СчетНаОплатуПоставщика.НематериальныйАктив.НаименованиеПолное КАК СТРОКА(1000))  КАК Товар,";
		
			ТекстПоляАртикула			= ",
				|	АртикулКонтрагента";

			ТекстВыборкиАртикула		= ", 
				|	АртикулНоменклатурыКонтрагента КАК АртикулКонтрагента";

			ТекстВыборкиНоменклатуры	= ", 
				|	ВЫРАЗИТЬ(НаименованиеНоменклатурыКонтрагента КАК Строка(1000)) КАК НаименованиеКонтрагента";

			ТекстИсточникАртикула		= "
				|	ЛЕВОЕ ВНЕШНЕЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураКонтрагентов КАК НоменклатураКонтрагентов
				|	ПО НоменклатураКонтрагентов.Номенклатура = СчетНаОплатуПоставщика.Номенклатура
				|	И  НоменклатураКонтрагентов.Контрагент = &Контрагент";

			ТекстГруппировкиАртикулаИНоменклатуры = ", 
				|	АртикулНоменклатурыКонтрагента,
				|	ВЫРАЗИТЬ(НаименованиеНоменклатурыКонтрагента КАК Строка(1000))";

		Иначе

			ТекстПоляТовараДляТоваров = "
			|	ВЫРАЗИТЬ (ВложенныйЗапрос.Номенклатура.НаименованиеПолное КАК СТРОКА(1000)) КАК Товар,";
			
			ТекстПоляТовараДляБСУ = "
			|	ВЫРАЗИТЬ (СчетНаОплатуПоставщика.Номенклатура.НаименованиеПолное КАК СТРОКА(1000))КАК Товар,";

			ТекстПоляТовараДляОборудования = "
			|	ВЫРАЗИТЬ (СчетНаОплатуПоставщика.Номенклатура.НаименованиеПолное КАК СТРОКА(1000))КАК Товар,";

			ТекстПоляТовараДляУслуг = "
			|	ВЫРАЗИТЬ (СчетНаОплатуПоставщика.Содержание КАК СТРОКА(1000)) КАК Товар,";

			ТекстПоляТовараДляТары = "
			|	ВЫРАЗИТЬ(СчетНаОплатуПоставщика.Номенклатура.НаименованиеПолное КАК СТРОКА(1000))  КАК Товар,";
			
			ТекстПоляТовараДляНМА = "
			|	ВЫРАЗИТЬ(СчетНаОплатуПоставщика.НематериальныйАктив.НаименованиеПолное КАК СТРОКА(1000))  КАК Товар,";
			
			ТекстПоляАртикула                     = "";
			ТекстВыборкиАртикула                  = ""; 
			ТекстИсточникАртикула                 = "";
			ТекстГруппировкиАртикулаИНоменклатуры = ""; 

		КонецЕсли;
		
		Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
		Запрос.УстановитьПараметр("Контрагент", Ссылка.Контрагент);
		Запрос.Текст ="
		
		|ВЫБРАТЬ
		|	ВложенныйЗапрос.НомерТЧ,
		|	ВложенныйЗапрос.НомерСтрокиТЧ,
		|	ВложенныйЗапрос.Номенклатура,"+ТекстПоляТовараДляТоваров+"
		|	ВложенныйЗапрос.Количество,
		|	ВложенныйЗапрос.ЕдиницаИзмерения,
		|	ВложенныйЗапрос.Цена,
		|	ВложенныйЗапрос.Сумма,
		|	ВложенныйЗапрос.СуммаНДС,
		|	ВложенныйЗапрос.Характеристика,
		|	NULL КАК Серия" + ТекстПоляАртикула + "
		|ИЗ
		|	(
		|	ВЫБРАТЬ
		|		1 КАК НомерТЧ,
		|		МИНИМУМ(СчетНаОплатуПоставщика.НомерСтроки) КАК НомерСтрокиТЧ,
		|		СчетНаОплатуПоставщика.Номенклатура,
		|		СчетНаОплатуПоставщика.ЕдиницаИзмерения,
		|		СчетНаОплатуПоставщика.Цена                        КАК Цена,
		|		СУММА(СчетНаОплатуПоставщика.Количество)           КАК Количество,
		|		СУММА(СчетНаОплатуПоставщика.Сумма     )           КАК Сумма,
		|		СУММА(СчетНаОплатуПоставщика.СуммаНДС  )           КАК СуммаНДС,
		|		СчетНаОплатуПоставщика.ХарактеристикаНоменклатуры  КАК Характеристика" + ТекстВыборкиАртикула + ТекстВыборкиНоменклатуры + "
		|	ИЗ
		|		Документ.СчетНаОплатуПоставщика.Товары КАК СчетНаОплатуПоставщика" + ТекстИсточникАртикула + "
		|
		|	ГДЕ
		|		СчетНаОплатуПоставщика.Ссылка = &ТекущийДокумент
		|
		|	СГРУППИРОВАТЬ ПО
		|		СчетНаОплатуПоставщика.Номенклатура,
		|		СчетНаОплатуПоставщика.ЕдиницаИзмерения,
		|		СчетНаОплатуПоставщика.Цена,
		|		СчетНаОплатуПоставщика.ХарактеристикаНоменклатуры" + ТекстГруппировкиАртикулаИНоменклатуры + "
		|	) КАК ВложенныйЗапрос
		|
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	2,
		|	СчетНаОплатуПоставщика.НомерСтроки КАК НомерСтрокиТЧ,
		|	СчетНаОплатуПоставщика.Номенклатура," + ТекстПоляТовараДляБСУ + "
		|	СчетНаОплатуПоставщика.Количество,
		|	СчетНаОплатуПоставщика.ЕдиницаИзмерения,
		|	СчетНаОплатуПоставщика.Цена,
		|	СчетНаОплатуПоставщика.Сумма,
		|	СчетНаОплатуПоставщика.СуммаНДС,
		|	NULL,
		|	NULL КАК Серия" + ТекстВыборкиАртикула + "
		|	
		|ИЗ
		|	Документ.СчетНаОплатуПоставщика.БланкиСтрогогоУчета КАК СчетНаОплатуПоставщика" + ТекстИсточникАртикула + "
		|
		|ГДЕ
		|	СчетНаОплатуПоставщика.Ссылка = &ТекущийДокумент
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	3,
		|	СчетНаОплатуПоставщика.НомерСтроки КАК НомерСтрокиТЧ,
		|	СчетНаОплатуПоставщика.Номенклатура," + ТекстПоляТовараДляОборудования + "
		|	СчетНаОплатуПоставщика.Количество,
		|	СчетНаОплатуПоставщика.ЕдиницаИзмерения.Представление,
		|	СчетНаОплатуПоставщика.Цена,
		|	СчетНаОплатуПоставщика.Сумма,
		|	СчетНаОплатуПоставщика.СуммаНДС,
		|	NULL,
		|	NULL КАК Серия" + ТекстВыборкиАртикула + "
		|	
		|ИЗ
		|	Документ.СчетНаОплатуПоставщика.Оборудование КАК СчетНаОплатуПоставщика" + ТекстИсточникАртикула + "
		|
		|ГДЕ
		|	СчетНаОплатуПоставщика.Ссылка = &ТекущийДокумент
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	4,
		|	СчетНаОплатуПоставщика.НомерСтроки КАК НомерСтрокиТЧ,
		|	СчетНаОплатуПоставщика.Номенклатура," + ТекстПоляТовараДляУслуг + "
		|	СчетНаОплатуПоставщика.Количество,
		|	СчетНаОплатуПоставщика.Номенклатура.ЕдиницаХраненияОстатков.Представление КАК ЕдиницаИзмерения,
		|	СчетНаОплатуПоставщика.Цена,
		|	СчетНаОплатуПоставщика.Сумма,
		|	СчетНаОплатуПоставщика.СуммаНДС,
		|	NULL,
		|	NULL КАК Серия" + ТекстВыборкиАртикула + "
		|	
		|ИЗ (ВЫБРАТЬ 
		|		Номенклатура 							КАК Номенклатура,
		|		ВЫРАЗИТЬ(Содержание КАК Строка(100)) 	КАК Содержание,
		|		Цена 									КАК Цена,
		|		СтавкаНДС 								КАК СтавкаНДС,
		|		Сумма(Количество) 						КАК Количество,
		|		Сумма(Сумма) 							КАК Сумма,
		|		Сумма(СуммаНДС) 						КАК СуммаНДС,
		|		Минимум(НомерСтроки) 					КАК НомерСтроки
		|	ИЗ  Документ.СчетНаОплатуПоставщика.Услуги 
		|	ГДЕ Ссылка = &ТекущийДокумент
		|	СГРУППИРОВАТЬ ПО Номенклатура, ВЫРАЗИТЬ(Содержание КАК Строка(100)), Цена, СтавкаНДС
		|	) КАК СчетНаОплатуПоставщика "+ ТекстИсточникАртикула + "
		//|	Документ.СчетНаОплатуПоставщика.Услуги КАК ЗаказПоставщику" + ТекстИсточникАртикула + "
		|
		//|ГДЕ
		//|	ЗаказПоставщику.Ссылка = &ТекущийДокумент
		|
		|	
		|УПОРЯДОЧИТЬ ПО
		|	НомерТЧ, НомерСтрокиТЧ
		|";
		
		ЗапросТовары = Запрос.Выполнить().Выгрузить();

		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
		Запрос.УстановитьПараметр("Контрагент", Ссылка.Контрагент);	
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	СчетНаОплатуПоставщика.НомерСтроки	КАК НомерСтрокиТЧ,
		|	СчетНаОплатуПоставщика.Номенклатура," + ТекстПоляТовараДляТары + "
		|	СчетНаОплатуПоставщика.Количество,
		|	СчетНаОплатуПоставщика.Номенклатура.ЕдиницаХраненияОстатков.Представление КАК ЕдиницаИзмерения,	
		|	СчетНаОплатуПоставщика.Цена,
		|	СчетНаОплатуПоставщика.Сумма" + ТекстВыборкиАртикула + "
		|ИЗ
		|	Документ.СчетНаОплатуПоставщика.ВозвратнаяТара КАК СчетНаОплатуПоставщика" + ТекстИсточникАртикула + "
		|
		|ГДЕ
		|	СчетНаОплатуПоставщика.Ссылка = &ТекущийДокумент
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтрокиТЧ
		|";
		ЗапросТара = Запрос.Выполнить().Выгрузить();
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
		Запрос.УстановитьПараметр("Контрагент", Ссылка.Контрагент);	
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	СчетНаОплатуПоставщика.НомерСтроки	КАК НомерСтрокиТЧ,
		|	СчетНаОплатуПоставщика.НематериальныйАктив," + ТекстПоляТовараДляНМА + "
		|	СчетНаОплатуПоставщика.Сумма,
		|	СчетНаОплатуПоставщика.СуммаНДС
		|ИЗ
		|	Документ.СчетНаОплатуПоставщика.НематериальныеАктивы КАК СчетНаОплатуПоставщика
		|
		|ГДЕ
		|	СчетНаОплатуПоставщика.Ссылка = &ТекущийДокумент
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтрокиТЧ
		|";
		ЗапросНМА = Запрос.Выполнить().Выгрузить();
		
		
		СведенияОПоставщике = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Поставщик, Шапка.Дата,,,КодЯзыкаПечать);
		СведенияОПокупателе = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Покупатель, Шапка.Дата,,,КодЯзыкаПечать);

		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		Если Шапка.ВидДоговораКонтрагента = Перечисления.ВидыДоговоровКонтрагентов.СКомитентом  Тогда	
			ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначения.СформироватьЗаголовокДокумента(Шапка, НСтр("ru='Список товаров от поставщика (на комиссию)';uk='Список товарів від постачальника (на комісію)'",КодЯзыкаПечать)+ Символы.ПС,КодЯзыкаПечать);
		Иначе	
			ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначения.СформироватьЗаголовокДокумента(Шапка, НСтр("ru='Счет на оплату поставщика';uk='Рахунок на оплату постачальника'",КодЯзыкаПечать),КодЯзыкаПечать);		
		КонецЕсли; 
		ТабДокумент.Вывести(ОбластьМакета);

		ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
		ОбластьМакета.Параметры.Заполнить(ПараметрыПечати);
		ОбластьМакета.Параметры.ПредставлениеПоставщика = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(СведенияОПоставщике, "ПолноеНаименование,",,КодЯзыкаПечать);
		ОбластьМакета.Параметры.РеквизитыПоставщика = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(СведенияОПоставщике, "Телефоны,ЮридическийАдрес,/,НомерСчета,Банк,МФО,/,КодПоЕДРПОУ,КодПоДРФО,ИНН,НомерСвидетельства,",,КодЯзыкаПечать);
		ТабДокумент.Вывести(ОбластьМакета);           

		ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
		ОбластьМакета.Параметры.Заполнить(ПараметрыПечати);
		ОбластьМакета.Параметры.ПредставлениеПокупателя = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(СведенияОПокупателе, "ПолноеНаименование,",,КодЯзыкаПечать);
		ТабДокумент.Вывести(ОбластьМакета);

		// Выводим дополнительно информацию о договоре и сделке
		СписокДополнительныхПараметров = "ДоговорНаименованиеДляПечати,";
		МассивСтруктурСтрок = ФормированиеПечатныхФормСервер.ДополнительнаяИнформация(Шапка,СписокДополнительныхПараметров,КодЯзыкаПечать);
		ОбластьМакета = Макет.ПолучитьОбласть("ДопИнформация");
	    Для каждого СтруктураСтроки Из МассивСтруктурСтрок Цикл
			ОбластьМакета.Параметры.Заполнить(СтруктураСтроки);
			ТабДокумент.Вывести(ОбластьМакета);
		КонецЦикла;		
		
		Если Тип = "ЗаказПоДаннымПоставщика" Тогда
			ВыводитьКоды = Истина;
			Колонка = "Артикул поставщика";
		Иначе
			ВыводитьКоды = Ложь;
		КонецЕсли;
		
		ОбластьНомера = Макет.ПолучитьОбласть("ШапкаТаблицы|НомерСтроки");
		ОбластьКодов  = Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаКодов");
		ОбластьДанных = Макет.ПолучитьОбласть("ШапкаТаблицы|Данные");
		ОбластьСуммы  = Макет.ПолучитьОбласть("ШапкаТаблицы|Сумма");

		ТабДокумент.Вывести(ОбластьНомера);
		Если ВыводитьКоды Тогда
			ОбластьКодов.Параметры.ИмяКолонкиКодов = Колонка;
			ТабДокумент.Присоединить(ОбластьКодов);
		КонецЕсли;
		
		Суффикс = "";
		Если Шапка.УчитыватьНДС Тогда
			Если Шапка.СуммаВключаетНДС Тогда
				Суффикс  = Суффикс  + НСтр("ru=' с ';uk=' з '",КодЯзыкаПечать);
			Иначе	
				Суффикс  = Суффикс  + НСтр("ru=' без ';uk=' без '",КодЯзыкаПечать);
			КонецЕсли;
			Суффикс = Суффикс  + НСтр("ru='НДС';uk='ПДВ'",КодЯзыкаПечать);
		КонецЕсли;
		ОбластьТовар = Макет.ПолучитьОбласть("ШапкаТаблицы|Товар");
		Если ВыводитьКоды Тогда
			ОбластьТовар = Макет.ПолучитьОбласть("ШапкаТаблицы|ТоварБезСкидок");
		Иначе
			ОбластьТовар = Макет.ПолучитьОбласть("ШапкаТаблицы|ТоварБезКодовИСкидок");
		КонецЕсли;
		ОбластьТовар.Параметры.Товар = НСтр("ru='Товары (работы, услуги)';uk=' Товари (роботи, послуги) '",КодЯзыкаПечать);
		ТабДокумент.Присоединить(ОбластьТовар);
		
		ОбластьДанных.Параметры.Цена  = НСтр("ru='Цена';uk='Ціна'",КодЯзыкаПечать) + Суффикс;
		//? ВидОперации???
		ТабДокумент.Присоединить(ОбластьДанных);
		
		ОбластьСуммы.Параметры.Сумма = НСтр("ru='Сумма';uk='Сума'",КодЯзыкаПечать)+ Суффикс;
		ТабДокумент.Присоединить(ОбластьСуммы);       	

		ОбластьКолонкаТовар = Макет.Область("Товар");
		Если Не ВыводитьКоды Тогда
			ОбластьКолонкаТовар.ШиринаКолонки = ОбластьКолонкаТовар.ШиринаКолонки + 
												Макет.Область("КолонкаКодов").ШиринаКолонки;
		КонецЕсли;
	    
		ОбластьКолонкаТовар = Макет.Область("Товар");
		Если Не ВыводитьКоды Тогда
			ОбластьКолонкаТовар.ШиринаКолонки = ОбластьКолонкаТовар.ШиринаКолонки + 
												Макет.Область("КолонкаКодов").ШиринаКолонки;
		КонецЕсли;
			ОбластьКолонкаТовар.ШиринаКолонки = ОбластьКолонкаТовар.ШиринаКолонки + 
												Макет.Область("СуммаБезСкидки").ШиринаКолонки +
												Макет.Область("СуммаСкидки").ШиринаКолонки;

		ОбластьНомера = Макет.ПолучитьОбласть("Строка|НомерСтроки");
		ОбластьКодов  = Макет.ПолучитьОбласть("Строка|КолонкаКодов");
		ОбластьДанных = Макет.ПолучитьОбласть("Строка|Данные");
		ОбластьСкидок = Макет.ПолучитьОбласть("Строка|Скидка");
		ОбластьСуммы  = Макет.ПолучитьОбласть("Строка|Сумма");
		
		ОбластьТовар = Макет.ПолучитьОбласть("Строка|Товар");
		Если ВыводитьКоды Тогда
			ОбластьТовар = Макет.ПолучитьОбласть("Строка|ТоварБезСкидок");
		Иначе
			ОбластьТовар = Макет.ПолучитьОбласть("Строка|ТоварБезКодовИСкидок");
		КонецЕсли;

		Сумма    = 0;
		СуммаНДС = 0;
		ВсегоСкидок    = 0;
		ВсегоБезСкидок = 0;

		Для каждого ВыборкаСтрокТовары из ЗапросТовары Цикл 

			Если НЕ ЗначениеЗаполнено(ВыборкаСтрокТовары.Номенклатура) Тогда
				Продолжить;
			КонецЕсли;

			ОбластьНомера.Параметры.НомерСтроки = ЗапросТовары.Индекс(ВыборкаСтрокТовары) + 1;
			ТабДокумент.Вывести(ОбластьНомера);
			
			Если ВыводитьКоды Тогда
				ОбластьКодов.Параметры.Артикул = ВыборкаСтрокТовары.АртикулКонтрагента;
				ТабДокумент.Присоединить(ОбластьКодов);
			КонецЕсли;

			ОбластьДанных.Параметры.Заполнить(ВыборкаСтрокТовары);
			ОбластьТовар.Параметры.Товар = СокрП(ВыборкаСтрокТовары.Товар) + ФормированиеПечатныхФормСервер.ПредставлениеСерий(ВыборкаСтрокТовары);
			ТабДокумент.Присоединить(ОбластьТовар);
			ТабДокумент.Присоединить(ОбластьДанных);
			
			Скидка = 0;
			
			ОбластьСуммы.Параметры.Заполнить(ВыборкаСтрокТовары);
			ТабДокумент.Присоединить(ОбластьСуммы);
			
			Сумма          = Сумма       + ВыборкаСтрокТовары.Сумма;
			СуммаНДС       = СуммаНДС    + ВыборкаСтрокТовары.СуммаНДС;
			ВсегоСкидок    = ВсегоСкидок + Скидка;
			ВсегоБезСкидок = Сумма       + ВсегоСкидок;

		КонецЦикла;

		// Вывести Итого
		ОбластьНомера = Макет.ПолучитьОбласть("Итого|НомерСтроки");
		ОбластьКодов  = Макет.ПолучитьОбласть("Итого|КолонкаКодов");
		ОбластьДанных = Макет.ПолучитьОбласть("Итого|Данные");
		ОбластьСуммы  = Макет.ПолучитьОбласть("Итого|Сумма");

		ТабДокумент.Вывести(ОбластьНомера);
		Если ВыводитьКоды Тогда
			ТабДокумент.Присоединить(ОбластьКодов);
		КонецЕсли;
		Если ВыводитьКоды Тогда
			ОбластьТовар = Макет.ПолучитьОбласть("Итого|ТоварБезСкидок");
		Иначе
			ОбластьТовар = Макет.ПолучитьОбласть("Итого|ТоварБезКодовИСкидок");
		КонецЕсли;
		ТабДокумент.Присоединить(ОбластьТовар);
		ТабДокумент.Присоединить(ОбластьДанных);
		ОбластьСуммы.Параметры.Всего = ОбщегоНазначения.ФорматСумм(Сумма);
		ТабДокумент.Присоединить(ОбластьСуммы);

		// Вывести ИтогоНДС
		Если Шапка.УчитыватьНДС Тогда
			ОбластьНомера = Макет.ПолучитьОбласть("ИтогоНДС|НомерСтроки");
			ОбластьКодов  = Макет.ПолучитьОбласть("ИтогоНДС|КолонкаКодов");
			ОбластьДанных = Макет.ПолучитьОбласть("ИтогоНДС|Данные");
			ОбластьСуммы  = Макет.ПолучитьОбласть("ИтогоНДС|Сумма");

			ТабДокумент.Вывести(ОбластьНомера);
			Если ВыводитьКоды Тогда
				ТабДокумент.Присоединить(ОбластьКодов);
			КонецЕсли;
			ОбластьТовар = Макет.ПолучитьОбласть("ИтогоНДС|Товар");
			Если ВыводитьКоды Тогда
				ОбластьТовар = Макет.ПолучитьОбласть("ИтогоНДС|ТоварБезСкидок");
			Иначе
				ОбластьТовар = Макет.ПолучитьОбласть("ИтогоНДС|ТоварБезКодовИСкидок");
			КонецЕсли;
			ТабДокумент.Присоединить(ОбластьТовар);
			ОбластьДанных.Параметры.НДС = ?(Шапка.СуммаВключаетНДС, НСтр("ru='В том числе НДС:';uk='У тому числі ПДВ:'",КодЯзыкаПечать), НСтр("ru='Сумма НДС:';uk='Сума ПДВ:'",КодЯзыкаПечать));
			ТабДокумент.Присоединить(ОбластьДанных);
			ОбластьСуммы.Параметры.ВсегоНДС = ОбщегоНазначения.ФорматСумм(СуммаНДС);
			ТабДокумент.Присоединить(ОбластьСуммы);
			
			// добавим строку с итоговой суммой, в случае когда НДС не входит в сумму
			Если НЕ Шапка.СуммаВключаетНДС Тогда
				ОбластьНомера = Макет.ПолучитьОбласть("ИтогоДополнительно|НомерСтроки");
				ОбластьКодов  = Макет.ПолучитьОбласть("ИтогоДополнительно|КолонкаКодов");
				ОбластьДанных = Макет.ПолучитьОбласть("ИтогоДополнительно|Данные");
				ОбластьСуммы  = Макет.ПолучитьОбласть("ИтогоДополнительно|Сумма");
				
				ТабДокумент.Вывести(ОбластьНомера);
				Если ВыводитьКоды Тогда
					ТабДокумент.Присоединить(ОбластьКодов);
				КонецЕсли;
				ТабДокумент.Присоединить(ОбластьТовар);
				ОбластьДанных.Параметры.Подпись = НСтр("ru='Всего с НДС:';uk='Усього з ПДВ:'",КодЯзыкаПечать);
				ТабДокумент.Присоединить(ОбластьДанных);
				ОбластьСуммы.Параметры.Сумма = ОбщегоНазначения.ФорматСумм(Сумма + СуммаНДС);
				ТабДокумент.Присоединить(ОбластьСуммы);
			КонецЕсли;
		КонецЕсли;

		
		СуммаНМА 	= 0;
		СуммаНДСНМА = 0;
		
		// выведем таблицу с НМА
		Если ЗапросНМА.Количество() > 0 Тогда
			// сделаем отступ от основной таблицы
			ОбластьПробел = Макет.ПолучитьОбласть("Пробел");
			ТабДокумент.Вывести(ОбластьПробел);
			
			ОбластьНомера = Макет.ПолучитьОбласть("ШапкаТаблицыНМА|НомерСтрокиНМА");
			ОбластьДанных = Макет.ПолучитьОбласть("ШапкаТаблицыНМА|ДанныеНМА");
			ОбластьСуммы  = Макет.ПолучитьОбласть("ШапкаТаблицыНМА|СуммаНМА");
			
			ТабДокумент.Вывести(ОбластьНомера);
			
			ТабДокумент.Присоединить(ОбластьДанных);
			
			ОбластьСуммы.Параметры.Сумма = НСтр("ru='Сумма';uk='Сума'",КодЯзыкаПечать)+ Суффикс;
			
			ТабДокумент.Присоединить(ОбластьСуммы);
			
			//ОбластьКолонкаТовар = Макет.Область("НМА");
			
			ОбластьНомера = Макет.ПолучитьОбласть("СтрокаНМА|НомерСтрокиНМА");
			ОбластьДанных = Макет.ПолучитьОбласть("СтрокаНМА|ДанныеНМА");
			ОбластьСуммы  = Макет.ПолучитьОбласть("СтрокаНМА|СуммаНМА");
			
			Для каждого ВыборкаСтрокНМА Из ЗапросНМА Цикл 
				
				Если НЕ ЗначениеЗаполнено(ВыборкаСтрокНМА.НематериальныйАктив) Тогда
					Продолжить;
				КонецЕсли;
				
				ОбластьНомера.Параметры.НомерСтроки = ЗапросНМА.Индекс(ВыборкаСтрокНМА) + 1;
				ТабДокумент.Вывести(ОбластьНомера);
				
				ОбластьДанных.Параметры.Заполнить(ВыборкаСтрокНМА);
				ОбластьДанных.Параметры.Товар = СокрП(ВыборкаСтрокНМА.Товар);			
				ТабДокумент.Присоединить(ОбластьДанных);
				
				ОбластьСуммы.Параметры.Заполнить(ВыборкаСтрокНМА);
				ТабДокумент.Присоединить(ОбластьСуммы);
				
				СуммаНМА 	= СуммаНМА 		+ ВыборкаСтрокНМА.Сумма;
				СуммаНДСНМА = СуммаНДСНМА 	+ ВыборкаСтрокНМА.СуммаНДС;
				
			КонецЦикла;
			
			// Вывести Итого
			ОбластьНомера = Макет.ПолучитьОбласть("ИтогоНМА|НомерСтрокиНМА");
			ОбластьДанных = Макет.ПолучитьОбласть("ИтогоНМА|ДанныеНМА");
			ОбластьСуммы  = Макет.ПолучитьОбласть("ИтогоНМА|СуммаНМА");
			
			ТабДокумент.Вывести(ОбластьНомера);
			ТабДокумент.Присоединить(ОбластьДанных);
			ОбластьСуммы.Параметры.Всего = ОбщегоНазначения.ФорматСумм(СуммаНМА);
			ТабДокумент.Присоединить(ОбластьСуммы);	
			
			// Вывести ИтогоНДС
			Если Шапка.УчитыватьНДС Тогда
				ОбластьНомера = Макет.ПолучитьОбласть("ИтогоНМАНДС|НомерСтрокиНМА");
				ОбластьДанных = Макет.ПолучитьОбласть("ИтогоНМАНДС|ДанныеНМА");
				ОбластьСуммы  = Макет.ПолучитьОбласть("ИтогоНМАНДС|СуммаНМА");

				ТабДокумент.Вывести(ОбластьНомера);
				ОбластьДанных.Параметры.НДС = ?(Шапка.СуммаВключаетНДС, НСтр("ru='В том числе НДС:';uk='У тому числі ПДВ:'",КодЯзыкаПечать), НСтр("ru='Сумма НДС:';uk='Сума ПДВ:'",КодЯзыкаПечать));
				ТабДокумент.Присоединить(ОбластьДанных);
				ОбластьСуммы.Параметры.ВсегоНДС = ОбщегоНазначения.ФорматСумм(СуммаНДСНМА);
				ТабДокумент.Присоединить(ОбластьСуммы);
				
				// добавим строку с итоговой суммой, в случае когда НДС не входит в сумму
				Если НЕ Шапка.СуммаВключаетНДС Тогда
					ОбластьНомера = Макет.ПолучитьОбласть("ИтогоНМАДополнительно|НомерСтрокиНМА");
					ОбластьДанных = Макет.ПолучитьОбласть("ИтогоНМАДополнительно|ДанныеНМА");
					ОбластьСуммы  = Макет.ПолучитьОбласть("ИтогоНМАДополнительно|СуммаНМА");
					
					ТабДокумент.Вывести(ОбластьНомера);
					ОбластьДанных.Параметры.Подпись = НСтр("ru='Всего с НДС:';uk='Усього з ПДВ:'",КодЯзыкаПечать);
					ТабДокумент.Присоединить(ОбластьДанных);
					ОбластьСуммы.Параметры.Сумма = ОбщегоНазначения.ФорматСумм(СуммаНМА + СуммаНДСНМА);
					ТабДокумент.Присоединить(ОбластьСуммы);
				КонецЕсли;
			КонецЕсли;
			
			// сделаем отступ 
			ТабДокумент.Вывести(ОбластьПробел);
		КонецЕсли;
		
		// выведем таблицу с возвратной тарой
		Если ЗапросТара.Количество() > 0 Тогда
			// сделаем отступ от основной таблицы
			ОбластьПробел = Макет.ПолучитьОбласть("Пробел");
			ТабДокумент.Вывести(ОбластьПробел);
			
			ОбластьНомера = Макет.ПолучитьОбласть("ШапкаТаблицыТара|НомерСтрокиТара");
			ОбластьКодов  = Макет.ПолучитьОбласть("ШапкаТаблицыТара|КолонкаКодовТара");
			ОбластьДанных = Макет.ПолучитьОбласть("ШапкаТаблицыТара|ДанныеТара");
			ОбластьСуммы  = Макет.ПолучитьОбласть("ШапкаТаблицыТара|СуммаТара");
			
			ТабДокумент.Вывести(ОбластьНомера);
			Если ВыводитьКоды Тогда
				ОбластьКодов.Параметры.ИмяКолонкиКодов = Колонка;
				ТабДокумент.Присоединить(ОбластьКодов);
			КонецЕсли;
			
			ТабДокумент.Присоединить(ОбластьДанных);
			ТабДокумент.Присоединить(ОбластьСуммы);
			
			ОбластьКолонкаТовар = Макет.Область("Тара");
			Если Не ВыводитьКоды Тогда
				ОбластьКолонкаТовар.ШиринаКолонки = ОбластьКолонкаТовар.ШиринаКолонки + 
													Макет.Область("КолонкаКодовТара").ШиринаКолонки;
			КонецЕсли;
			
			
			ОбластьНомера = Макет.ПолучитьОбласть("СтрокаТара|НомерСтрокиТара");
			ОбластьКодов  = Макет.ПолучитьОбласть("СтрокаТара|КолонкаКодовТара");
			ОбластьДанных = Макет.ПолучитьОбласть("СтрокаТара|ДанныеТара");
			ОбластьСуммы  = Макет.ПолучитьОбласть("СтрокаТара|СуммаТара");
			
			СуммаТара    = 0;
			
			Для каждого ВыборкаСтрокТара Из ЗапросТара Цикл 
				
				Если НЕ ЗначениеЗаполнено(ВыборкаСтрокТара.Номенклатура) Тогда
					Продолжить;
				КонецЕсли;
				
				ОбластьНомера.Параметры.НомерСтроки = ЗапросТара.Индекс(ВыборкаСтрокТара) + 1;
				ТабДокумент.Вывести(ОбластьНомера);
				
				Если ВыводитьКоды Тогда
					ОбластьКодов.Параметры.Артикул = ВыборкаСтрокТара.АртикулКонтрагента;
					ТабДокумент.Присоединить(ОбластьКодов);
				КонецЕсли;
				
				ОбластьДанных.Параметры.Заполнить(ВыборкаСтрокТара);
				ОбластьДанных.Параметры.Товар = СокрП(ВыборкаСтрокТара.Товар);			
				ТабДокумент.Присоединить(ОбластьДанных);
				
				ОбластьСуммы.Параметры.Заполнить(ВыборкаСтрокТара);
				ТабДокумент.Присоединить(ОбластьСуммы);
				
				СуммаТара = СуммаТара + ВыборкаСтрокТара.Сумма;
				
			КонецЦикла;
			
			// Вывести Итого
			ОбластьНомера = Макет.ПолучитьОбласть("ИтогоТара|НомерСтрокиТара");
			ОбластьКодов  = Макет.ПолучитьОбласть("ИтогоТара|КолонкаКодовТара");
			ОбластьДанных = Макет.ПолучитьОбласть("ИтогоТара|ДанныеТара");
			ОбластьСуммы  = Макет.ПолучитьОбласть("ИтогоТара|СуммаТара");
			
			ТабДокумент.Вывести(ОбластьНомера);
			Если ВыводитьКоды Тогда
				ТабДокумент.Присоединить(ОбластьКодов);
			КонецЕсли;
			ТабДокумент.Присоединить(ОбластьДанных);
			ОбластьСуммы.Параметры.Всего = ОбщегоНазначения.ФорматСумм(СуммаТара);
			ТабДокумент.Присоединить(ОбластьСуммы);	
			
			// сделаем отступ 
			ТабДокумент.Вывести(ОбластьПробел);
		КонецЕсли;

		
		// Вывести Сумму прописью
		ОбластьМакета = Макет.ПолучитьОбласть("СуммаПрописью");
		СуммаКПрописи = Сумма + ?(Шапка.СуммаВключаетНДС, 0, СуммаНДС);
		// НМА
		СуммаКПрописи = СуммаКПрописи + СуммаНМА + ?(Шапка.СуммаВключаетНДС, 0, СуммаНДСНМА);
		
		
		ОбластьМакета.Параметры.ИтоговаяСтрока = НСтр("ru='Всего наименований ';uk='Всього найменувань '",КодЯзыкаПечать) + (ЗапросТовары.Количество() + ЗапросНМА.Количество()) + "," +
												 НСтр("ru=' на сумму ';uk=' на суму '",КодЯзыкаПечать)  + ОбщегоНазначения.ФорматСумм(СуммаКПрописи, Шапка.ВалютаДокумента)
												 + ?(ЗапросТара.Количество() = 0, "",  НСтр("ru='; возвратная тара ';uk='; зворотна тара '",КодЯзыкаПечать) + ЗапросТара.Количество() + НСтр("ru=', на сумму ';uk=', на суму '",КодЯзыкаПечать) + ОбщегоНазначения.ФорматСумм(СуммаТара, Шапка.ВалютаДокумента)) + ".";									   
												 
		ОбластьМакета.Параметры.СуммаПрописью = ОбщегоНазначения.СформироватьСуммуПрописью(СуммаКПрописи, Шапка.ВалютаДокумента,КодЯзыкаПечать)
		 										 + ?(НЕ Шапка.УчитыватьНДС, "", Символы.ПС + НСтр("ru='В т.ч. НДС: ';uk='У т.ч. ПДВ: '",КодЯзыкаПечать) + ОбщегоНазначения.СформироватьСуммуПрописью(СуммаНДС + СуммаНДСНМА, Шапка.ВалютаДокумента, КодЯзыкаПечать));										 
												 
		ТабДокумент.Вывести(ОбластьМакета);

		// Вывести подписи
		ОбластьМакета = Макет.ПолучитьОбласть("ПодвалЗаказа");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ТабДокумент.Вывести(ОбластьМакета);
	
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, Ссылка);
	КонецЦикла;
	
	Возврат ТабДокумент;
КонецФункции // ПечатьСчетаЗаказа()

// Функция помещает в структуру все данные, отображаемые при печати документа.
// Вызывается из функции ПечатьСчетаЗаказа и из веб-приложения
//
// Параметры:
//  Тип - строка, содержит тип печатаемого документа (счет или заказ)
//
// Возвращаемое значение:
//  Структура
//
Функция ПолучитьПараметрыПечатиСчетаЗаказа(Тип, ДокументСсылка) Экспорт	
	
	ПараметрыПечати = Новый Структура;
	Позиции = Новый Массив;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", ДокументСсылка);
	Запрос.УстановитьПараметр("ПустойКонтрагент", Справочники.Контрагенты.ПустаяСсылка());
	Запрос.Текст ="
	|ВЫБРАТЬ
	|	Номер,
	|	Дата,
	|	ДоговорКонтрагента,
	|	Организация,
	|	Контрагент КАК Получатель,
	|	Организация КАК Руководители,
	|	Организация КАК Поставщик,
	|	СуммаДокумента,
	|	ВалютаДокумента,
	|	УчитыватьНДС,
	|	СуммаВключаетНДС
	|ИЗ
	|	Документ.СчетНаОплатуПоставщика КАК СчетНаОплатуПоставщика
	|
	|ГДЕ
	|	СчетНаОплатуПоставщика.Ссылка = &ТекущийДокумент";

	Шапка = Запрос.Выполнить().Выбрать();
	Шапка.Следующий();

	СтрокаВыборкиПоляСодержания = ОбработкаТабличныхЧастей.ПолучитьЧастьЗапросаДляВыбораСодержания("СчетНаОплату");
	
	// Выводим шапку накладной

	КодЯзыкаПечать = Локализация.ПолучитьЯзыкФормированияПечатныхФорм(УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "РежимФормированияПечатныхФорм"));
	ПараметрыПечати.Вставить("ТекстПоставщик", ?(Тип = "Счет", НСтр("ru='Поставщик:';uk='Постачальник:'",КодЯзыкаПечать), НСтр("ru='Исполнитель:';uk='Виконавець:'",КодЯзыкаПечать)));
	ПараметрыПечати.Вставить("ТекстПокупатель", ?(Тип = "Счет", НСтр("ru='Покупатель:';uk='Покупець:'",КодЯзыкаПечать), НСтр("ru='Заказчик:';uk='Замовник:'",КодЯзыкаПечать)));
	
	ПараметрыПечати.Вставить("УчитыватьНДС", Шапка.УчитыватьНДС);
	СведенияОПоставщике = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Поставщик, Шапка.Дата);
	Если Тип = "Счет" Тогда
		ПараметрыПечати.Вставить("ИНН", СведенияОПоставщике.ИНН);
		ПредставлениеПоставщикаДляПлатПоручения = "";
		Если ПустаяСтрока(ПредставлениеПоставщикаДляПлатПоручения) Тогда
			ПредставлениеПоставщикаДляПлатПоручения = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(СведенияОПоставщике, "ПолноеНаименование,");
		КонецЕсли;
		ПараметрыПечати.Вставить("ПредставлениеПоставщикаДляПлатПоручения", ПредставлениеПоставщикаДляПлатПоручения);
	КонецЕсли; 

	ПараметрыПечати.Вставить("ЕстьСкидки", Ложь);

	ДопКолонка = Константы.ДополнительнаяКолонкаПечатныхФормДокументов.Получить();
	Если ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул Тогда
		Колонка = "Артикул";
	ИначеЕсли ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Код Тогда
		Колонка = "Код";
	КонецЕсли;
	
	// Вывести ИтогоНДС
	Если ПараметрыПечати.УчитыватьНДС Тогда
		ПараметрыПечати.Вставить("НДС", ?(Шапка.СуммаВключаетНДС, "В том числе НДС:", "Сумма НДС:"));
	КонецЕсли;
	
	Возврат ПараметрыПечати;

КонецФункции //ПолучитьПараметрыПечатиСчетаЗаказа()

