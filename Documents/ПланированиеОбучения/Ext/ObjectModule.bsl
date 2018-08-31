﻿////////////////////////////////////////////////////////////////////////////////
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

	Запрос.Текст = "
	|Выбрать 
	|	Дата, 
	| 	Ссылка 
	|Из 
	|	Документ." + Метаданные().Имя + "
	|Где 
	|	Ссылка = &ДокументСсылка
	|";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоШапке()

// Формирует запрос по всем местам работы физлица во всех организациях
//
// Параметры: 
//  ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа,
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса
//
Функция СформироватьЗапросПоСпискуКурсов(ВыборкаПоШапкеДокумента,Режим)

	Запрос = Новый Запрос;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);

	Запрос.Текст = "ВЫБРАТЬ
	               |	Док.КурсОбучения,
	               |	Док.НомерСтроки КАК НомерСтроки,
	               |	Док.ДатаОкончанияОбучения,
	               |	Док.КоличествоРаботников
	               |ИЗ
	               |	Документ.ПланированиеОбучения.УчебныйПлан КАК Док
	               |ГДЕ
	               |	Док.Ссылка = &ДокументСсылка";
				   	   			   
	Возврат Запрос.Выполнить();

	
КонецФункции // СформироватьЗапросПоСпискуКурсов()

// Проверяет правильность заполнения реквизитов в строке ТЧ "" документа.
// Если какой-то из реквизтов, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по строке ТЧ документа,
// все проверяемые реквизиты должны быть включены в выборку.
//
// Параметры: 
//  ВыборкаПоСтрокамДокумента	- спозиционированная на определеной строке выборка 
//  							  из результата запроса по строкам. 
//  Отказ        - флаг отказа в проведении,
//	Заголовок				- Заголовок для сообщений об ошибках проведения.
//
Процедура ПроверитьЗаполнениеСтрокиТабличнойЧасти(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, Отказ, Заголовок)
	
	СтрокаНачалаСообщенияОбОшибке = "В строке номер """+ СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) +
									""" табл. части ""Учебный план"": ";
	
	// КурсОбучения
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.КурсОбучения) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не указан курс обучения!", Отказ, Заголовок);
	КонецЕсли;
	
	// ДатаОкончанияОбучения
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ДатаОкончанияОбучения) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не указана дата окончания обучения!", Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры // ПроверитьЗаполнениеСтрокиТабличнойЧасти()

// Создает и заполняет структуру, содержащую имена регистров накопления
// документа. В дальнейшем движения заносятся только по тем регистрам накопления, для которых в 
// данной процедуре заданы ключи
//
// Параметры: 
//  СтруктураПроведенияПоРегистрамНакопления - структура, содержащая имена регистров 
//                                             накопления по которым надо проводить документ
//
// Возвращаемое значение:
//  Нет.
//
Процедура ЗаполнитьСтруктуруПроведенияПоРегистрамНакопления(ВыборкаПоШапкеДокумента, СтруктураПроведенияПоРегистрамНакопления)

	СтруктураПроведенияПоРегистрамНакопления = Новый Структура();
	СтруктураПроведенияПоРегистрамНакопления.Вставить("ПотребностиВОбучении");

КонецПроцедуры // ЗаполнитьСтруктуруПроведенияПоРегистрамНакопления

// По строке выборки результата запроса по документу формируем движения по регистрам
//
// Параметры: 
//  ВыборкаПоШапкеДокумента                  - выборка из результата запроса по шапке документа
//  СтруктураПроведенияПоРегистрамНакопления - структура, содержащая имена регистров 
//                                             накопления по которым надо проводить документ
//  СтруктураПараметров                      - структура параметров проведения.
//
// Возвращаемое значение:
//  Нет.
//
Процедура ДобавитьСтрокуВДвиженияПоРегистрамНакопления(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокам, 
	СтруктураПроведенияПоРегистрамНакопления, СтруктураПараметров = "")
	
	// Если документ нужно проводить по регистру, то для него есть ключ в структуре
	ИмяРегистра = "ПотребностиВОбучении";
	Если СтруктураПроведенияПоРегистрамНакопления.Свойство(ИмяРегистра) Тогда
		
		Движение = Движения[ИмяРегистра].Добавить();
		
		Движение.Период = ВыборкаПоСтрокам.ДатаОкончанияОбучения;
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		
		// Измерения
		Движение.КурсОбучения = ВыборкаПоСтрокам.КурсОбучения;
		Движение.ДокументПланирования = ВыборкаПоШапкеДокумента.Ссылка;
		
		// Ресурсы
		Движение.КоличествоРаботников = ВыборкаПоСтрокам.КоличествоРаботников;
		
		// Ревизиты
	КонецЕсли; 
	
КонецПроцедуры // ДобавитьСтрокуВДвиженияПоРегистрамНакопления

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	
	//структура, содержащая имена регистров накопления по которым надо проводить документ
	Перем СтруктураПроведенияПоРегистрамНакопления;

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);	

	РезультатЗапросаПоШапке = СформироватьЗапросПоШапке(Режим);

	// Получим реквизиты шапки из запроса
	ВыборкаПоШапкеДокумента = РезультатЗапросаПоШапке.Выбрать();
	
	Если ВыборкаПоШапкеДокумента.Следующий() Тогда

		// Создадим и заполним структуры, содержащие имена регистров, по которым в зависимости от типа учета
		// проводится документ. В дальнейшем будем считать, что если для регистра не создан ключ в структуре,
		// то проводить по нему не надо.
		ЗаполнитьСтруктуруПроведенияПоРегистрамНакопления(ВыборкаПоШапкеДокумента, СтруктураПроведенияПоРегистрамНакопления);
		
		// Проверка строк.
		РезультатЗапросаПоСтрокамТЧ = СформироватьЗапросПоСпискуКурсов(ВыборкаПоШапкеДокумента, Режим);
		
		ВыборкаПоСтрокамТЧ = РезультатЗапросаПоСтрокамТЧ.Выбрать();
		
		Пока ВыборкаПоСтрокамТЧ.Следующий() Цикл 
			
			ПроверитьЗаполнениеСтрокиТабличнойЧасти(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамТЧ, Отказ, Заголовок);
			
			Если НЕ Отказ Тогда
				ДобавитьСтрокуВДвиженияПоРегистрамНакопления(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамТЧ,СтруктураПроведенияПоРегистрамНакопления,);
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры
