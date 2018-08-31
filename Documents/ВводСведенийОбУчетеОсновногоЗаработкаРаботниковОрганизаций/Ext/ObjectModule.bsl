﻿Перем ПустойСпособОтраженияВБухучете; // для строк с незаполненый способом отражения

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
//

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ РАБОТЫ ФОРМ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Формирует запрос по шапке документа
//
// Параметры: 
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса
//
Функция СформироватьЗапросПоШапке(Режим)

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка" , Ссылка);
	Запрос.УстановитьПараметр("ПустаяОрганизация" , Справочники.Организации.ПустаяСсылка());

	Запрос.Текст = "
	|Выбрать 
	|	Дата, 
	|	Организация,
	|	ВЫБОР КОГДА Организация.ГоловнаяОрганизация = &ПустаяОрганизация ТОГДА Организация ИНАЧЕ Организация.ГоловнаяОрганизация КОНЕЦ КАК ГоловнаяОрганизация,
	| 	Ссылка 
	|Из 
	|	Документ." + Метаданные().Имя + "
	|Где 
	|	Ссылка = &ДокументСсылка
	|";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоШапке()

// Формирует запрос по таблице "РаботникиОрганизации" документа
//
// Параметры: 
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса.
//
Функция СформироватьЗапросПоРаботникиОрганизации(ВыборкаПоШапкеДокумента)

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
	Запрос.УстановитьПараметр("ГоловнаяОрганизация", ВыборкаПоШапкеДокумента.ГоловнаяОрганизация);

	// Описание текста запроса:
	// 1. Выборка "ТЧРаботникиОрганизации": 
	//		Выбираются строки документа.  
	// 2. Выборка "ПересекающиесяСтроки": 
	//		Среди остальных строк документа ищем строки с одинаковым значением реквизита "ФизЛицо"
	// 3. Выборка "ПоследующиеДвижение": 
	//		В регистре УчетОсновногоЗаработкаРаботниковОрганизаций 
	//      ищем движения, следующие за теми, которые мы собираемся записать в этот же регистр - 
	//      затем проверим, нет ли уже движения на ту дату, которая указана в документе
    //
	ТекстЗапроса = "ВЫБРАТЬ
	               |	ТЧРаботникиОрганизации.НомерСтроки КАК НомерСтроки,
	               |	ТЧРаботникиОрганизации.Сотрудник,
	               |	ТЧРаботникиОрганизации.Сотрудник.ФизЛицо,
	               |	ТЧРаботникиОрганизации.Сотрудник.ФизЛицо.Наименование КАК ФизЛицоНаименование,
	               |	ТЧРаботникиОрганизации.ДатаИзменения,
	               |	ТЧРаботникиОрганизации.СпособОтраженияВБухучете,
	               |	ПересекающиесяСтроки.КонфликтнаяСтрокаНомер,
	               |	ПоследующиеДвижение.РегистраторПредставление
	               |ИЗ
	               |	Документ.ВводСведенийОбУчетеОсновногоЗаработкаРаботниковОрганизаций.РаботникиОрганизации КАК ТЧРаботникиОрганизации
	               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			ТЧРаботникиОрганизации.НомерСтроки КАК НомерСтроки,
	               |			МИНИМУМ(ТЧРаботникиОрганизации2.НомерСтроки) КАК КонфликтнаяСтрокаНомер
	               |		ИЗ
	               |			Документ.ВводСведенийОбУчетеОсновногоЗаработкаРаботниковОрганизаций.РаботникиОрганизации КАК ТЧРаботникиОрганизации
	               |				ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВводСведенийОбУчетеОсновногоЗаработкаРаботниковОрганизаций.РаботникиОрганизации КАК ТЧРаботникиОрганизации2
	               |				ПО (ТЧРаботникиОрганизации2.Ссылка = &ДокументСсылка) И ТЧРаботникиОрганизации.Сотрудник = ТЧРаботникиОрганизации2.Сотрудник И ТЧРаботникиОрганизации.НомерСтроки > ТЧРаботникиОрганизации2.НомерСтроки И ТЧРаботникиОрганизации.ДатаИзменения = ТЧРаботникиОрганизации2.ДатаИзменения
	               |		
	               |		ГДЕ
	               |			ТЧРаботникиОрганизации.Ссылка = &ДокументСсылка
	               |		
	               |		СГРУППИРОВАТЬ ПО
	               |			ТЧРаботникиОрганизации.НомерСтроки) КАК ПересекающиесяСтроки
	               |		ПО ТЧРаботникиОрганизации.НомерСтроки = ПересекающиесяСтроки.НомерСтроки
	               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			МИНИМУМ(УчетОсновногоЗаработкаРаботниковОрганизаций.Период) КАК ДатаПоследующегоДвижения,
	               |			ТЧДокумента.Сотрудник КАК Сотрудник,
	               |			УчетОсновногоЗаработкаРаботниковОрганизаций.Регистратор.Представление КАК РегистраторПредставление
	               |		ИЗ
	               |			Документ.ВводСведенийОбУчетеОсновногоЗаработкаРаботниковОрганизаций.РаботникиОрганизации КАК ТЧДокумента
	               |				ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчетОсновногоЗаработкаРаботниковОрганизаций КАК УчетОсновногоЗаработкаРаботниковОрганизаций
	               |				ПО ТЧДокумента.Сотрудник = УчетОсновногоЗаработкаРаботниковОрганизаций.Сотрудник И (УчетОсновногоЗаработкаРаботниковОрганизаций.Организация = &ГоловнаяОрганизация) И ТЧДокумента.ДатаИзменения <= УчетОсновногоЗаработкаРаботниковОрганизаций.Период
	               |		
	               |		ГДЕ
	               |			ТЧДокумента.Ссылка = &ДокументСсылка
	               |		
	               |		СГРУППИРОВАТЬ ПО
	               |			ТЧДокумента.Сотрудник,
	               |			УчетОсновногоЗаработкаРаботниковОрганизаций.Регистратор.Представление) КАК ПоследующиеДвижение
	               |		ПО ТЧРаботникиОрганизации.Сотрудник = ПоследующиеДвижение.Сотрудник И ТЧРаботникиОрганизации.ДатаИзменения = ПоследующиеДвижение.ДатаПоследующегоДвижения
	               |
	               |ГДЕ
	               |	ТЧРаботникиОрганизации.Ссылка = &ДокументСсылка";
	
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоРаботникиОрганизации()

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизтов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа,
//  Отказ 					- флаг отказа в проведении,
//	Заголовок				- Заголовок для сообщений об ошибках проведения.
//
Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок)

	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Организация) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не указана организация, для которой ведется учет!", Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения реквизитов в строке ТЧ "РаботникиОрганизации" документа.
// Если какой-то из реквизтов, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по строке ТЧ документа,
// все проверяемые реквизиты должны быть включены в выборку.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента		- выборка из результата запроса по шапке документа,
//  ВыборкаПоСтрокамДокумента	- спозиционированная на определеной строке выборка 
//  							  из результата запроса по товарам документа, 
//  Отказ 						- флаг отказа в проведении.
//
Процедура ПроверитьЗаполнениеСтрокиРаботникаОрганизации(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, Отказ, Заголовок)

	СтрокаНачалаСообщенияОбОшибке = "В строке номер """+ СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) +
									""" табл. части ""Работники организации"": ";

	// ФизЛицо
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Сотрудник) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не выбран работник!", Отказ, Заголовок);
	КонецЕсли;
	
	// Дата
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ДатаИзменения) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не указана дата изменения учета работника!", Отказ, Заголовок);
	КонецЕсли;
	
	// СпособОтраженияВБухучете
	ПустойСпособОтраженияВБухучете = НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.СпособОтраженияВБухучете);
	Если ПустойСпособОтраженияВБухучете  Тогда
		//СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не указан способ отражения заработка работника в бухгалтерском учете!", Отказ);
		Сообщить(СтрокаНачалаСообщенияОбОшибке + "не указан способ отражения заработка работника в бухгалтерском учете!
		|Движение по этой строке производиться не будет.")
	КонецЕсли;
	
	// повторяющиеся строки		
	Если ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.КонфликтнаяСтрокаНомер)  Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "по работнику " + ВыборкаПоСтрокамДокумента.ФизЛицоНаименование + " найдена повторяющаяся строка № " + ВыборкаПоСтрокамДокумента.КонфликтнаяСтрокаНомер + "!", Отказ, Заголовок);
	КонецЕсли;
	
	// повторяющиеся строки		
	Если ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.РегистраторПредставление)  Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "способ учета основного заработка работника " + ВыборкаПоСтрокамДокумента.ФизЛицоНаименование + " уже зарегистрирован ранее документом " + ВыборкаПоСтрокамДокумента.РегистраторПредставление + "!", Отказ, Заголовок);
	КонецЕсли;
	

КонецПроцедуры // ПроверитьЗаполнениеСтрокиРаботникаОрганизации()

// По строке выборки результата запроса по документу формируем движения по регистрам
//
// Параметры: 
//  ВыборкаПоШапкеДокумента                - выборка из результата запроса по шапке документа,
//  СтруктураПроведенияПоРегистрамСведений - структура, содержащая имена регистров 
//                                           сведений по которым надо проводить документ,
//  СтруктураПараметров                    - структура параметров проведения,
//
// Возвращаемое значение:
//  Нет.
//
Процедура ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаПоРаботникиОрганизации)

	//Движения по регистру "УчетОсновногоЗаработкаРаботниковОрганизаций"
	Движение = Движения.УчетОсновногоЗаработкаРаботниковОрганизаций.Добавить();
	// Свойства
	Движение.Период                     = ВыборкаПоРаботникиОрганизации.ДатаИзменения;
	
	// Измерения
	Движение.Сотрудник                    = ВыборкаПоРаботникиОрганизации.Сотрудник;
	Движение.Организация				= ВыборкаПоШапкеДокумента.ГоловнаяОрганизация;
	// Ресурсы
	Движение.СпособОтраженияВБухучете   = ВыборкаПоРаботникиОрганизации.СпособОтраженияВБухучете;

КонецПроцедуры // ДобавитьСтрокуВДвиженияПоРегистрамСведений

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);

	РезультатЗапросаПоШапке = СформироватьЗапросПоШапке(Режим);

	// Получим реквизиты шапки из запроса
	ВыборкаПоШапкеДокумента = РезультатЗапросаПоШапке.Выбрать();

	Если ВыборкаПоШапкеДокумента.Следующий() Тогда

		//Надо позвать проверку заполнения реквизитов шапки
		ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок);

		// Движения стоит добавлять, если в проведении еще не отказано (отказ =ложь)
		Если НЕ Отказ Тогда

			// выполним выборку по табличной части документа
			РезультатЗапросаПоРаботники = СформироватьЗапросПоРаботникиОрганизации(ВыборкаПоШапкеДокумента);
			ВыборкаСтрокЗапроса = РезультатЗапросаПоРаботники.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			// обходим строки запроса, проверяем данные и формируем движения
			Пока ВыборкаСтрокЗапроса.Следующий() Цикл
				
				ПроверитьЗаполнениеСтрокиРаботникаОрганизации(ВыборкаПоШапкеДокумента, ВыборкаСтрокЗапроса , Отказ, Заголовок);
				Если НЕ Отказ Тогда
					
					Если НЕ ПустойСпособОтраженияВБухучете Тогда // Движения с пустым способом отражения не формировать
						ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаСтрокЗапроса);
					КонецЕсли;
					
				КонецЕсли; 
				
			КонецЦикла;					
			
		КонецЕсли;	

	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаЗаполнения(Основание)
	
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ПриемНаРаботуВОрганизацию")
		или ТипЗнч(Основание) = Тип("ДокументСсылка.КадровоеПеремещениеОрганизаций") Тогда

		// Заполним реквизиты из стандартного набора по документу основанию.
		ЗаполнениеДокументов.ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, Основание);
		
		Если Основание.Проведен Тогда
			
			ОтражаемыйДокумент = Основание;
			
			ОснованиеЕстьПриказОПриеме = ТипЗнч(Основание) = Тип("ДокументСсылка.ПриемНаРаботуВОрганизацию");
			Если ОснованиеЕстьПриказОПриеме Тогда
				РеквизитДатаС = "ДатаПриема";	
				РеквизитДатаПо = "ДатаУвольнения";
			ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.КадровоеПеремещениеОрганизаций") Тогда
				РеквизитДатаС = "ДатаНачала";	
				РеквизитДатаПо = "ДатаОкончания";
			Иначе
				Возврат
			КонецЕсли; 
			
			Для каждого  СтрокаОснования Из Основание.РаботникиОрганизации Цикл
				
				// Для даты начала
				НоваяСтрока	= РаботникиОрганизации.Добавить();
				НоваяСтрока.Сотрудник = СтрокаОснования.Сотрудник;
				НоваяСтрока.ДатаИзменения = СтрокаОснования[РеквизитДатаС];
				
				// Для даты окончания
				Если ЗначениеЗаполнено(СтрокаОснования[РеквизитДатаПо]) Тогда    
					НоваяСтрока	= РаботникиОрганизации.Добавить();
					НоваяСтрока.Сотрудник = СтрокаОснования.Сотрудник;
					НоваяСтрока.ДатаИзменения = СтрокаОснования[РеквизитДатаПо];
				КонецЕсли; 
				
			КонецЦикла; 
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаЗаполнения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	КраткийСоставДокумента = ПроцедурыУправленияПерсоналом.ЗаполнитьКраткийСоставДокумента(РаботникиОрганизации);
	ПроцедурыУправленияПерсоналом.ЗаполнитьФизЛицоПоТЧ(РаботникиОрганизации);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументОснование = Неопределено;
	
КонецПроцедуры


