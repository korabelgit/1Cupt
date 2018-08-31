﻿Перем мУдалятьДвижения;

// Строки, хранят реквизиты имеющие смысл только для бух. учета и упр. соответственно
// в случае если документ не отражается в каком-то виде учета, делаются невидимыми
Перем мСтрокаРеквизитыБухУчета Экспорт; // (Регл)
Перем мСтрокаРеквизитыУпрУчета Экспорт; // (Упр)

Перем мВалютаРегламентированногоУчета Экспорт; // (Регл)
Перем мВалютаУправленческогоУчета     Экспорт; // (Упр)

Перем мУчетнаяПолитика;                 // (Общ)
Перем УчетнаяПолитикаРегл;               // (Регл)

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда
	
// Функция формирование печатной формы документа "Списание НЗП"
//
Функция ПечатьСписаниеНЗП(ТипУчета)
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	СписаниеНЗП.Ссылка,
	|	СписаниеНЗП.Представление,
	|	СписаниеНЗП.Организация,
	|	ВЫБОР
	|		КОГДА &ТипУчета = ""Упр""
	|			ТОГДА СписаниеНЗП.Подразделение
	|		ИНАЧЕ СписаниеНЗП.ПодразделениеОрганизации
	|	КОНЕЦ КАК Подразделение,
	|	СписаниеНЗП.ДокИнвентаризация КАК Основание,
	|	СписаниеНЗП.Организация.Представление КАК ПечОрганизация,
	|	СписаниеНЗП.ДокИнвентаризация.Представление КАК ПечОснование,
	|	ВЫБОР
	|		КОГДА &ТипУчета = ""Упр""
	|			ТОГДА СписаниеНЗП.Подразделение.Представление
	|		ИНАЧЕ СписаниеНЗП.ПодразделениеОрганизации.Представление
	|	КОНЕЦ КАК ПечПодразделение,
	|	СписаниеНЗП.Материалы.(
	|		НомерСтроки                КАК НомерСтроки,
	|		Номенклатура               КАК Материал,
	|		ХарактеристикаНоменклатуры КАК Характеристика,
	|		СерияНоменклатуры          КАК Серия,
	|		КоличествоМест             КАК КолМест,
	|		ЕдиницаИзмеренияМест       КАК ЕдИзмМест,
	|		ЕдиницаИзмерения           КАК ЕдИзм,
	|		Количество,
	|		ВЫБОР КОГДА &ТипУчета = ""Упр"" ТОГДА
	|			СписаниеНЗП.Материалы.Цена
	|		ИНАЧЕ 
	|			СписаниеНЗП.Материалы.СуммаРегл / Количество
	|		КОНЕЦ КАК Цена,
	|		ВЫБОР КОГДА &ТипУчета = ""Упр"" ТОГДА
	|			СписаниеНЗП.Материалы.Сумма
	|		ИНАЧЕ
	|			СписаниеНЗП.Материалы.СуммаРегл
	|		КОНЕЦ КАК Сумма,
	|		СтатьяЗатрат,
	|		Заказ,
	|		НоменклатурнаяГруппа               КАК НомГруппа,
	|		СчетЗатрат                         КАК Счет,
	|		СтатьяЗатрат.Представление         КАК ПечСтатьяЗатрат,
	|		Заказ.Представление                КАК ПечЗаказ,
	|		НоменклатурнаяГруппа.Представление КАК ПечНомГруппа,
	|		СчетЗатрат.Представление           КАК ПечСчет,
	|		СтатьяЗатрат.ХарактерЗатрат        КАК ПечХарактЗатрат,
	|		ЕдиницаИзмерения.Представление     КАК ПечЕдИзм,
	|		ЕдиницаИзмеренияМест.Представление КАК ПечЕдИзмМест,
	|		Номенклатура.Код                   КАК Код,
	|		Номенклатура.Артикул               КАК Артикул
	|	)
	|ИЗ
	|	Документ.СписаниеНЗП КАК СписаниеНЗП
	|ГДЕ
	|	СписаниеНЗП.Ссылка = &ТекДок
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр( "ТекДок",   Ссылка);
	Запрос.УстановитьПараметр( "ТипУчета", ТипУчета);
	
	РезультатЗапроса = Запрос.Выполнить();
	Шапка = РезультатЗапроса.Выбрать();
	Шапка.Следующий();
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_СписаниеНЗП_СписаниеНЗП";
	
	Макет  = ПолучитьМакет("СписаниеНЗП");
	КодЯзыкаПечать = ЛокализацияПовтИсп.ПолучитьЯзыкФормированияПечатныхФормДокументов();
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;
	
	// Параметры вывода
	ДопКолонка = Константы.ДополнительнаяКолонкаПечатныхФормДокументов.Получить();
	КолАртикул = ?( ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул, "Артикул",
				 ?( ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Код,     "Код", ""));
	ФлагВыводКода = НЕ ПустаяСтрока(КолАртикул);
	ФлагВыводМест = Ложь;
	ТабЧасть = Шапка.Материалы.Выбрать();
	Пока ТабЧасть.Следующий() Цикл
		Если ТабЧасть.КолМест <> 0 ИЛИ ЗначениеЗаполнено(ТабЧасть.ЕдИзмМест) Тогда
			ФлагВыводМест = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	ФлагВыводСумм = ТипСтоимости = Перечисления.ВидыНормативнойСтоимостиПроизводства.Фиксированная;
	
	// Вывод заголовка
	Область = Макет.ПолучитьОбласть("Заголовок|Начало");
	Область.Параметры.Заголовок = ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект,,КодЯзыкаПечать);
	ТабДок.Вывести(Область);
	
	Если ФлагВыводКода Тогда
		Область = Макет.ПолучитьОбласть("Заголовок|Артикул");
		ТабДок.Присоединить(Область);
	КонецЕсли;
	
	Область = Макет.ПолучитьОбласть("Заголовок|Материал");
	ТабДок.Присоединить(Область);
	
	Если ФлагВыводМест Тогда
		Область = Макет.ПолучитьОбласть("Заголовок|КолМест");
		ТабДок.Присоединить(Область);
	КонецЕсли;
	
	Область = Макет.ПолучитьОбласть("Заголовок|Количество");
	ТабДок.Присоединить(Область);
	
	Если ФлагВыводСумм Тогда
		Область = Макет.ПолучитьОбласть("Заголовок|Суммы");
		ТабДок.Присоединить(Область);
	КонецЕсли;
	
	Если ФлагВыводКода Тогда
		
		Область = Макет.ПолучитьОбласть("ДокШапка|Начало");
		ТабДок.Вывести( Область);
		
		Область = Макет.ПолучитьОбласть("ДокШапка|Артикул");
		ТабДок.Присоединить( Область);
		
		Область = Макет.ПолучитьОбласть("ДокШапка|Материал");
		
	Иначе
		
		Область = Макет.ПолучитьОбласть("ДокШапкаБезАртикула|НачалоБезАртикула");
		ТабДок.Вывести( Область);
		
		Область = Макет.ПолучитьОбласть("ДокШапкаБезАртикула|МатериалБезАртикула");
		
	КонецЕсли;
	
	Область.Параметры.Подразделение    = Шапка.Подразделение;
	Область.Параметры.ПечПодразделение = Шапка.ПечПодразделение;
	Область.Параметры.Организация      = Шапка.Организация;
	Область.Параметры.ПечОрганизация   = Шапка.ПечОрганизация;
	Область.Параметры.Основание        = Шапка.Основание;
	Область.Параметры.ПечОснование     = Шапка.ПечОснование;
		
	ТабДок.Присоединить( Область);
	
	// Вывод шапки табличной части
	ОбластьНач  = Макет.ПолучитьОбласть("ТабШапка|Начало");
	ТабДок.Вывести( ОбластьНач);
	
	Если ФлагВыводКода Тогда
		ОбластьКод = Макет.ПолучитьОбласть("ТабШапка|Артикул");
		ОбластьКод.Параметры.ЗаголовокАртикул = КолАртикул;
		ТабДок.Присоединить( ОбластьКод);
	КонецЕсли;
	
	ОбластьМат = Макет.ПолучитьОбласть("ТабШапка|Материал");
	ОбластьМат.Параметры.ЗаголовокСчет = ?(ТипУчета = "Бух", 
											НСтр("ru='Счет';uk='Рахунок'", КодЯзыкаПечать), 
											НСтр("ru='Характер затрат';uk='Характер витрат'", КодЯзыкаПечать)
										  );
	ТабДок.Присоединить( ОбластьМат);
	
	Если ФлагВыводМест Тогда
		ОбластьМест = Макет.ПолучитьОбласть("ТабШапка|КолМест");
		ТабДок.Присоединить( ОбластьМест);
	КонецЕсли;
	
	ОбластьКол  = Макет.ПолучитьОбласть("ТабШапка|Количество");
	Если НЕ ФлагВыводСумм Тогда
		ОбластьКол.ТекущаяОбласть.ГраницаСправа = Новый Линия( ТипЛинииРисункаТабличногоДокумента.Сплошная, 2);
	КонецЕсли;
	ТабДок.Присоединить( ОбластьКол);
	
	Если ФлагВыводСумм Тогда
		ОбластьСумм = Макет.ПолучитьОбласть("ТабШапка|Суммы");
		ТабДок.Присоединить( ОбластьСумм);
	КонецЕсли;
	
	// Вывод табличной части
	ОбластьНач  = Макет.ПолучитьОбласть("ТабСтрока|Начало");
	ОбластьКод  = Макет.ПолучитьОбласть("ТабСтрока|Артикул");
	ОбластьМат  = Макет.ПолучитьОбласть("ТабСтрока|Материал");
	ОбластьМест = Макет.ПолучитьОбласть("ТабСтрока|КолМест");
	ОбластьКол  = Макет.ПолучитьОбласть("ТабСтрока|Количество");
	ОбластьСум  = Макет.ПолучитьОбласть("ТабСтрока|Суммы");
	
	ТабЧасть = Шапка.Материалы.Выбрать();
	СуммаИтого = 0;
	
	Пока ТабЧасть.Следующий() Цикл
		
		ОбластьНач.Параметры.ПечНомер = ТабЧасть.НомерСтроки;
		ТабДок.Вывести(ОбластьНач);
		Если ФлагВыводКода Тогда
			ОбластьКод.Параметры.ПечАртикул = ТабЧасть[КолАртикул];
			ТабДок.Присоединить(ОбластьКод);
		КонецЕсли;
		
		ОбластьМат.Параметры.ПечМатериал     = СокрЛП( ТабЧасть.Материал) + ФормированиеПечатныхФорм.ПредставлениеСерий( ТабЧасть);
		ОбластьМат.Параметры.Материал        = ТабЧасть.Материал;
		ОбластьМат.Параметры.ПечСтатьяЗатрат = ТабЧасть.ПечСтатьяЗатрат;
		ОбластьМат.Параметры.СтатьяЗатрат    = ТабЧасть.СтатьяЗатрат;
		ОбластьМат.Параметры.ПечЗаказ        = ТабЧасть.ПечЗаказ;
		ОбластьМат.Параметры.Заказ           = ТабЧасть.Заказ;
		ОбластьМат.Параметры.ПечНомГруппа    = ТабЧасть.ПечНомГруппа;
		ОбластьМат.Параметры.НомГруппа       = ТабЧасть.НомГруппа;
		Если ТипУчета = "Бух" Тогда
			ОбластьМат.Параметры.ПечСчет = ТабЧасть.ПечСчет;
			ОбластьМат.Параметры.Счет    = ТабЧасть.Счет;
		Иначе
			ОбластьМат.Параметры.ПечСчет = ТабЧасть.ПечХарактЗатрат;
			ОбластьМат.Параметры.Счет    = Неопределено;
		КонецЕсли;
		ТабДок.Присоединить(ОбластьМат);
		
		Если ФлагВыводМест Тогда
			ОбластьМест.Параметры.ПечЕдИзмМест = ТабЧасть.ПечЕдИзмМест;
			ОбластьМест.Параметры.КолМест      = ТабЧасть.КолМест;
			ТабДок.Присоединить(ОбластьМест);
		КонецЕсли;
		
		ОбластьКол.Параметры.ПечЕдИзм = ТабЧасть.ПечЕдИзм;
		ОбластьКол.Параметры.Колво    = ТабЧасть.Количество;
		Если НЕ ФлагВыводСумм Тогда
			ОбластьКол.Область( 1, 2, 1, 2).ГраницаСправа = Новый Линия( ТипЛинииРисункаТабличногоДокумента.Сплошная, 2);
		КонецЕсли;
		ТабДок.Присоединить(ОбластьКол);
		
		Если ФлагВыводСумм Тогда
			ОбластьСум.Параметры.Цена  = Окр(ТабЧасть.Цена, 2, 1);
			ОбластьСум.Параметры.Сумма = ТабЧасть.Сумма;
			ТабДок.Присоединить(ОбластьСум);
		КонецЕсли;
		
		СуммаИтого = СуммаИтого + ТабЧасть.Сумма;
		
	КонецЦикла;
	
	// Вывод итогов документа
	Если ФлагВыводСумм Тогда
		
		ОбластьИтог = Макет.ПолучитьОбласть( "ИтогСумма|Начало");
		ВалСумм = ?(ТипУчета = "Бух", мВалютаРегламентированногоУчета, мВалютаУправленческогоУчета);
		ОбластьИтог.Параметры.ИтоговаяСтрока = НСтр("ru='Всего наименований: ';uk='Всього найменувань: '", КодЯзыкаПечать) + ТабЧасть.Количество() 
											   + НСтр("ru=', на сумму ';uk=', на суму '", КодЯзыкаПечать) + ОбщегоНазначения.ФорматСумм(СуммаИтого, ВалСумм);
		ОбластьИтог.Параметры.СуммаПрописью  = ОбщегоНазначения.СформироватьСуммуПрописью(СуммаИтого, ВалСумм, КодЯзыкаПечать);
		ТабДок.Вывести( ОбластьИтог);
		
		Если ФлагВыводКода Тогда
			ОбластьИтог = Макет.ПолучитьОбласть( "ИтогСумма|Артикул");
			ТабДок.Присоединить( ОбластьИтог);
		КонецЕсли;
		
		ОбластьИтог = Макет.ПолучитьОбласть( "ИтогСумма|Материал");
		ТабДок.Присоединить( ОбластьИтог);
		
		Если ФлагВыводМест Тогда
			ОбластьИтог = Макет.ПолучитьОбласть( "ИтогСумма|КолМест");
			ТабДок.Присоединить( ОбластьИтог);
		КонецЕсли;
		
		ОбластьИтог = Макет.ПолучитьОбласть( "ИтогСумма|Количество");
		ТабДок.Присоединить( ОбластьИтог);
		
		ОбластьИтог = Макет.ПолучитьОбласть( "ИтогСумма|Суммы");
		ОбластьИтог.Параметры.ИтогоСумма = СуммаИтого;
		ТабДок.Присоединить( ОбластьИтог);
		
	Иначе
		
		ОбластьИтог = Макет.ПолучитьОбласть("ИтогКол|Начало");
		ОбластьИтог.Параметры.ИтоговаяСтрока = НСтр("ru='Всего наименований: ';uk='Всього найменувань: '", КодЯзыкаПечать) + ТабЧасть.Количество();
		ТабДок.Вывести( ОбластьИтог);
		
		Если ФлагВыводКода Тогда
			ОбластьИтог = Макет.ПолучитьОбласть( "ИтогКол|Артикул");
			ТабДок.Присоединить( ОбластьИтог);
		КонецЕсли;
		
		ОбластьИтог = Макет.ПолучитьОбласть( "ИтогКол|Материал");
		ТабДок.Присоединить( ОбластьИтог);
		
		Если ФлагВыводМест Тогда
			ОбластьИтог = Макет.ПолучитьОбласть( "ИтогКол|КолМест");
			ТабДок.Присоединить( ОбластьИтог);
		КонецЕсли;
		
		ОбластьИтог = Макет.ПолучитьОбласть( "ИтогКол|Количество");
		ТабДок.Присоединить( ОбластьИтог);
		
	КонецЕсли;
	
	
	Возврат ТабДок;
	
КонецФункции // ПечатьСписаниеНЗП()
	
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

	Если ИмяМакета = "СписаниеНЗП" ИЛИ ИмяМакета = "СписаниеНЗП_Упр" ИЛИ ИмяМакета = "СписаниеНЗП_Бух" Тогда
		
		ТипУчета = ?( ИмяМакета = "СписаниеНЗП_Упр", "Упр",
				   ?( ИмяМакета = "СписаниеНЗП_Бух", "Бух",
				   ?( ОтражатьВУправленческомУчете, "Упр", "Бух")));
				   
		ТабДокумент = ПечатьСписаниеНЗП(ТипУчета);
		
	ИначеЕсли ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда

		ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
		
		Если ТабДокумент = Неопределено Тогда
			Возврат
		КонецЕсли; 
		
	КонецЕсли;

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект,,ЛокализацияПовтИсп.ПолучитьЯзыкФормированияПечатныхФормДокументов()), Ссылка);

КонецПроцедуры // Печать

// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	СтруктПечФорм = Новый Структура;
	Если ОтражатьВУправленческомУчете И ОтражатьВБухгалтерскомУчете Тогда
		СтруктПечФорм.Вставить( "СписаниеНЗП_Упр", "Списание НЗП (упр.)");
		СтруктПечФорм.Вставить( "СписаниеНЗП_Бух", "Списание НЗП (регл.)");
	Иначе
		СтруктПечФорм.Вставить( "СписаниеНЗП", "Списание НЗП");
	КонецЕсли;
	
	Возврат СтруктПечФорм;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

#КонецЕсли

// Процедура заполняет структуры именами реквизитов, которые имеют смысл
// только для определенного вида учета
//
Процедура ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчета() Экспорт

	ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчетаУпр();
	ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчетаРегл();

КонецПроцедуры // ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчета()

// Процедура заполняет структуры именами реквизитов, которые имеют смысл
// только для упр. учета
//
Процедура ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчетаУпр()
   //мСтрокаРеквизитыУпрУчета = "Подразделение, НадписьПодразделение, Материалы.Сумма";
   мСтрокаРеквизитыУпрУчета = "Подразделение, НадписьПодразделение, Материалы.Сумма" + ?(ОтражатьПоЗатратам, ", ПодразделениеЗатраты", "");
   
КонецПроцедуры // ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчетаУпр()

// Процедура заполняет структуры именами реквизитов, которые имеют смысл
// только для регл. учета
//
Процедура ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчетаРегл()
	
	мСтрокаРеквизитыБухУчета = "ПодразделениеОрганизации, НадписьПодразделениеОрганизации,
		|СчетДт,      НадписьСчетДт,
		|СубконтоДт1, НадписьСубконтоДт1,
		|СубконтоДт2, НадписьСубконтоДт2,
		|СубконтоДт3, НадписьСубконтоДт3,
		|Материалы.СчетЗатрат, Материалы.СуммаРегл" + ?(ОтражатьПоЗатратам, ", ПодразделениеОрганизацииЗатраты", "");
		
	мСтрокаРеквизитыБухУчета = мСтрокаРеквизитыБухУчета + ",Материалы.НалоговоеНазначение, Материалы.СуммаНДС, Материалы.СуммаНДСКредит" 
		+ ?(ОтражатьПоЗатратам, ", НадписьНалоговоеНазначениеДоходовИЗатрат, НалоговоеНазначениеДоходовИЗатрат", "");

КонецПроцедуры // ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчетаРегл()

// Процедура проверяет правильность заполнения реквизитов документа
//
Функция ПроверкаРеквизитов(Отказ, Заголовок) Экспорт

	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	СтруктураШапкиДокумента.Вставить("УчитыватьНДСПоЗатратнымРегистрам", Истина);	
	// Документ должен принадлежать хотя бы к одному виду учета (управленческий, бухгалтерский, налоговый)
	ОбщегоНазначения.ПроверитьПринадлежностьКВидамУчета(СтруктураШапкиДокумента, Отказ, Заголовок);

	ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчета();
	
	РеквизитыШапки = "Организация, ТипСтоимости" + ?(ОтражатьПоЗатратам, ", ПодразделениеЗатраты, ПодразделениеОрганизацииЗатраты, СтатьяЗатрат", ""); 

	ДополнитьРеквизитыШапкиУпр(РеквизитыШапки);
	ДополнитьРеквизитыШапкиРегл(РеквизитыШапки);

	РеквизитыТЧ = "Номенклатура, ЕдиницаИзмерения, СтатьяЗатрат, СчетЗатрат, НалоговоеНазначение";

	Если ТипСтоимости = Перечисления.ВидыНормативнойСтоимостиПроизводства.Фиксированная Тогда
		РеквизитыТЧ = РеквизитыТЧ + ", Сумма, СуммаРегл";
	Иначе
		РеквизитыТЧ = РеквизитыТЧ + ", Количество";
	КонецЕсли;
	
	УправлениеЗатратами.НепроверятьРеквизитыПоТипуУчета(ЭтотОбъект, РеквизитыШапки, СтруктураШапкиДокумента, мСтрокаРеквизитыУпрУчета, мСтрокаРеквизитыБухУчета);
	УправлениеЗатратами.НепроверятьРеквизитыПоТипуУчета(ЭтотОбъект, РеквизитыТЧ,    СтруктураШапкиДокумента, мСтрокаРеквизитыУпрУчета, мСтрокаРеквизитыБухУчета, "Материалы");

	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, Новый Структура(РеквизитыШапки), Отказ, Заголовок);
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Материалы", Новый Структура(РеквизитыТЧ), Отказ, Заголовок);
	
	// Проверим соответствие подразделения и организации.
	УправлениеЗатратами.ПроверитьПодразделениеОрганизации(ЭтотОбъект, Отказ, Заголовок);
	
	УправлениеЗапасами.ПроверитьЧтоНетНаборов(ЭтотОбъект, "Материалы", , Отказ, Заголовок);

	Если СтруктураШапкиДокумента.ОтражатьВБухгалтерскомУчете Тогда
		
        СписСчетовБух = УправлениеПроизводством.ПолучитьЗатратныеСчета("Бух", "15, 20, 23, 24, 25, 26, 28, 36, 37, 63, 65");

		Если Не СписСчетовБух.НайтиПоЗначению(СчетДт) = Неопределено Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Нельзя указывать счет " + СчетДт + " в качестве корреспонденции! (счет бух. учета)", Отказ, Заголовок);
		КонецЕсли;

	КонецЕсли;
	
	НалоговыйУчет.ПроверитьЗаполнениеНалоговыхНазначений(
		СтруктураШапкиДокумента, 
		Неопределено,      // Неопределено - в случае проверки шапки документа
		Неопределено,      // Неопределено - в случае проверки шапки документа
		Отказ, 
		Заголовок, 
		"Списание",        // ВидОперации
		Истина,            // ОтражатьПоЗатратам,
		"СчетДт",          // ИмяРеквизитаСчетЗатрат
		"СубконтоДт"       // ИмяРеквизитаСубконтоЗатрат
	);
	
	
	НалоговыйУчет.ПроверитьЗаполнениеНалоговыхНазначений(
		СтруктураШапкиДокумента, 
		Материалы.Выгрузить(, "НомерСтроки, НалоговоеНазначение"),
		"Материалы",
		Отказ, 
		Заголовок, 
		"Производство"
	);	
	
	
	Возврат СтруктураШапкиДокумента;

КонецФункции // ПроверкаРеквизитов()

// Процедура дополняет список реквизитов шапки упр. реквизитами
//
Процедура ДополнитьРеквизитыШапкиУпр(Реквизиты)

	Реквизиты = Реквизиты + ?(ПустаяСтрока(Реквизиты),"",", ")  + "Подразделение";

КонецПроцедуры // ДополнитьРеквизитыШапкиУпр()

// Процедура дополняет список реквизитов шапки регл. реквизитами
//
Процедура ДополнитьРеквизитыШапкиРегл(Реквизиты)

	Реквизиты = Реквизиты + ?(ПустаяСтрока(Реквизиты),"",", ") + "ПодразделениеОрганизации, СчетДт";

КонецПроцедуры // ДополнитьРеквизитыШапкиРегл()

// Производит заполнение и установку необходимых полей при изменении номенклатуры в табличной части.
//
Процедура ПриИзмененииНоменклатурыМатериалов(СтрокаТабличнойЧасти) Экспорт

	СтрокаТабличнойЧасти.ЕдиницаИзмерения 		= СтрокаТабличнойЧасти.Номенклатура.ЕдиницаХраненияОстатков;
	СтрокаТабличнойЧасти.Коэффициент      		= СтрокаТабличнойЧасти.ЕдиницаИзмерения.Коэффициент;
	ОбработкаТабличныхЧастей.ЗаполнитьЕдиницуМестТабЧасти(СтрокаТабличнойЧасти, ЭтотОбъект, Ложь);
	
КонецПроцедуры // ПриИзмененииНоменклатурыМатериалов()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Процедура определяет параметры учетной политики
//
Процедура ПодготовитьПараметрыУчетнойПолитики(СтруктураШапкиДокумента, Отказ, Заголовок)

	мУчетнаяПолитика = ОбщегоНазначения.ПолучитьПараметрыУчетнойПолитикиУпр(Дата);
	Если НЕ ЗначениеЗаполнено(мУчетнаяПолитика) Тогда
		Отказ = Истина;
	КонецЕсли; 
	Если СтруктураШапкиДокумента.ОтражатьВБухгалтерскомУчете Тогда
		ПодготовитьПараметрыУчетнойПолитикиРегл(Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры // ПодготовитьПараметрыУчетнойПолитики()

// Процедура определяет параметры регл. учетной политики
//
Процедура ПодготовитьПараметрыУчетнойПолитикиРегл(Отказ, Заголовок)

	УчетнаяПолитикаРегл = ОбщегоНазначения.ПолучитьПараметрыУчетнойПолитикиРегл(Дата, Организация);
    Если НЕ ЗначениеЗаполнено(УчетнаяПолитикаРегл) Тогда
		Отказ = Истина;
	КонецЕсли; 

КонецПроцедуры // ПодготовитьПараметрыУчетнойПолитикиРегл()

// По результату запроса по шапке документа формируем движения по регистрам.
//
// Параметры: 
//  РежимПроведения           - режим проведения документа (оперативный или неоперативный),
//  СтруктураШапкиДокумента   - выборка из результата запроса по шапке документа,
//  ТаблицаПоТоварам          - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  ТаблицаПоТаре             - таблица значений, содержащая данные для проведения и проверки ТЧ "Возвратная тара",
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//
Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, Отказ, Заголовок)
	
	ДвиженияПоРегистрамУпр(РежимПроведения, СтруктураШапкиДокумента, Отказ, Заголовок);
	
	// Формирование движений по регистрам "Затраты на выпуск продукции".				
	УправлениеПроизводствомДвиженияПоРегистрам.СформироватьДвиженияПоРегиструЗатратыНаВыпускПродукции(
		СтруктураШапкиДокумента, 
		,
		мУчетнаяПолитика,
		УчетнаяПолитикаРегл
		);
	
	// Формирование движений по регистрам "Выпуск продукции" и направлениям выпуска.
	УправлениеПроизводствомДвиженияПоРегистрам.СформироватьДвиженияПоВыпускуПродукцииИНаправлениямВыпуска(
		СтруктураШапкиДокумента, 
		,
		мУчетнаяПолитика, 
		УчетнаяПолитикаРегл
		);	

КонецПроцедуры // ДвиженияПоРегистрам()   

// Формирование движений по регистрам по управленческому учету.
//
Процедура ДвиженияПоРегистрамУпр(РежимПроведения, СтруктураШапкиДокумента, Отказ, Заголовок)
	Если Не СтруктураШапкиДокумента.ОтражатьВУправленческомУчете Тогда
		Возврат;
	КонецЕсли;
	
	// Проверка остатков при оперативном проведении.
	Движения.МатериалыВПроизводстве.КонтрольОстатков(
		СтруктураШапкиДокумента, 
		Отказ, 
		Заголовок, 
		РежимПроведения);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Формирование движений расход по регистру "Материалы в производстве".
	УправлениеПроизводствомДвиженияПоРегистрам.СформироватьДвиженияПоМатериаламВПроизводстве(
		СтруктураШапкиДокумента, 
		мУчетнаяПолитика
	); 

КонецПроцедуры // ДвиженияПоРегистрамУпр()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	СтруктураШапкиДокумента = ПроверкаРеквизитов(Отказ, Заголовок);
	ПодготовитьПараметрыУчетнойПолитики(СтруктураШапкиДокумента, Отказ, Заголовок);
		
	// Движения по документу.
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры	// ОбработкаПроведения()

Процедура ОбработкаЗаполнения(Основание)
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ТребованиеНакладная") Тогда
		
		// Заполнение шапки
		Организация                  = Основание.Организация;
		Подразделение                = Основание.Подразделение;
		ПодразделениеОрганизации     = Основание.ПодразделениеОрганизации;
		ОтражатьВБухгалтерскомУчете  = Основание.ОтражатьВБухгалтерскомУчете;
		ОтражатьВУправленческомУчете = Основание.ОтражатьВУправленческомУчете;
		
		Для Каждого ТекСтрокаМатериалы Из Основание.Материалы Цикл
			
			НоваяСтрока = Материалы.Добавить();
			НоваяСтрока.Номенклатура               = ТекСтрокаМатериалы.Номенклатура;
			НоваяСтрока.ХарактеристикаНоменклатуры = ТекСтрокаМатериалы.ХарактеристикаНоменклатуры;
			НоваяСтрока.СерияНоменклатуры          = ТекСтрокаМатериалы.СерияНоменклатуры;
			НоваяСтрока.ЕдиницаИзмерения           = ТекСтрокаМатериалы.ЕдиницаИзмерения;
			НоваяСтрока.ЕдиницаИзмеренияМест       = ТекСтрокаМатериалы.ЕдиницаИзмеренияМест;
			НоваяСтрока.Количество                 = ТекСтрокаМатериалы.Количество;
			НоваяСтрока.КоличествоМест             = ТекСтрокаМатериалы.КоличествоМест;
			НоваяСтрока.Коэффициент                = ТекСтрокаМатериалы.Коэффициент;
			
			НоваяСтрока.НоменклатурнаяГруппа       = ТекСтрокаМатериалы.НоменклатурнаяГруппа;
			НоваяСтрока.СтатьяЗатрат               = ТекСтрокаМатериалы.СтатьяЗатрат;
			НоваяСтрока.СчетЗатрат                 = ТекСтрокаМатериалы.СчетЗатрат;
			НоваяСтрока.НалоговоеНазначение   = ТекСтрокаМатериалы.НалоговоеНазначение;
			
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ИнвентаризацияНЗП") Тогда
		
		// Заполнение шапки
		Организация                  = Основание.Организация;
		ОтражатьВБухгалтерскомУчете  = Основание.ОтражатьВБухгалтерскомУчете;
		ОтражатьВУправленческомУчете = Основание.ОтражатьВУправленческомУчете;
		Подразделение                = Основание.Подразделение;
		ПодразделениеОрганизации     = Основание.ПодразделениеОрганизации;
		ДокИнвентаризация            = Основание.Ссылка;
		#Если Клиент Тогда		
		Дата						 = РабочаяДата;
		#КонецЕсли
		
		УправлениеПроизводством.ЗаполнитьМатериалыПоИнвентаризацииНЗП(ЭтотОбъект, Материалы, ДокИнвентаризация);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ОтражатьВБухгалтерскомУчете Тогда
		
		НалоговыйУчет.ЗаполнитьНалоговыеНазначенияВШапкеПередЗаписьюДокумента(
			ЭтотОбъект,
			"СчетДт",     // ИмяРеквизитаСчетЗатрат
			"СубконтоДт", // ИмяРеквизитаСубконто
			,             // ЕстьРеквизитНалоговоеНазначение
			Истина        // УчитыватьДатуДокументаПриОпределенииГруппыНалоговогоНазначенияЗатрат
		);
		
		НалоговыйУчет.ЗаполнитьНалоговыеНазначенияВТабличныхЧастяхПередЗаписьюДокумента(
			"Списание",
			Дата,
			Организация,
			Материалы,              // ТабличнаяЧастьТовары
			Неопределено,       	// ТабличнаяЧастьВозвратнаяТара
			Неопределено,           // ТабличнаяЧастьУслуги
			Неопределено,         	// ТабличнаяЧастьОборудование
			Неопределено, 			// ТабличнаяЧастьОбъектыСтроительства
			Неопределено            // ТабличнаяЧастьБланкиСтрогогоУчета
		);
		
	КонецЕсли;
	 
	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;  
	
КонецПроцедуры

// Процедура заполняет счета учета по бухгалтерскому и налоговому учету.
//
Процедура ЗаполнитьСчетаУчетаВСтрокеТабЧастиРегл(СтрокаТЧ, ИмяТабЧасти, ЗаполнятьБУ) Экспорт

	СчетаУчета = СчетаУчетаВДокументах.ПолучитьСчетаУчетаНоменклатурыИзНастроек(Организация, СтрокаТЧ.Номенклатура, , Дата);
	СтрокаТЧ.НалоговоеНазначение =  СчетаУчета.НалоговоеНазначение;
		
КонецПроцедуры // ЗаполнитьСчетаУчетаВСтрокеТабЧасти()


мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");
мВалютаУправленческогоУчета     = глЗначениеПеременной("ВалютаУправленческогоУчета");
