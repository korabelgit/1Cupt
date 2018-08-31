﻿// Процедура подключает обработчик ожидания КонтрольРежимаЗавершенияРаботыПользователей
//
Процедура УстановитьКонтрольРежимаЗавершенияРаботыПользователей()  Экспорт
	
	Если ПолучитьСкоростьКлиентскогоСоединения() <> СкоростьКлиентскогоСоединения.Обычная Тогда
		Возврат;	
	КонецЕсли;
	
	РежимБлокировки = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ПараметрыБлокировкиСеансов;
	ТекущееВремя = РежимБлокировки.ТекущаяДатаСеанса;
	Если РежимБлокировки.Установлена 
		 И (НЕ ЗначениеЗаполнено(РежимБлокировки.Начало) ИЛИ ТекущееВремя >= РежимБлокировки.Начало) 
		 И (НЕ ЗначениеЗаполнено(РежимБлокировки.Конец) ИЛИ ТекущееВремя <= РежимБлокировки.Конец) Тогда
		// Если пользователь зашел в базу, в которой установлена режим блокировки, значит использовался ключ /UC.
		// Завершать работу такого пользователя не следует
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("КонтрольРежимаЗавершенияРаботыПользователей", 60);	
	
КонецПроцедуры

// Обработать параметры запуска, связанные с завершение и разрешение соединений ИБ.
//
// Параметры
//  ЗначениеПараметраЗапуска  – Строка – главный параметр запуска
//  ПараметрыЗапуска          – Массив – дополнительные параметры запуска, разделенные
//                                       символом ";".
//
// Возвращаемое значение:
//   Булево   – Истина, если требуется прекратить выполнение запуска системы.
//
Функция ОбработатьПараметрыЗапуска(Знач ЗначениеПараметраЗапуска, Знач ПараметрыЗапуска) Экспорт

	// Обработка параметров запуска программы - 
	// ЗапретитьРаботуПользователей и РазрешитьРаботуПользователей
	Если ЗначениеПараметраЗапуска = Врег("РазрешитьРаботуПользователей") Тогда
		
		Если НЕ СоединенияИБ.РазрешитьРаботуПользователей() Тогда
			ТекстСообщения = НСтр("ru = 'Параметр запуска РазрешитьРаботуПользователей не отработан. Нет прав на администрирование информационной базы.'");
			Предупреждение(ТекстСообщения);
			Возврат Ложь;
		КонецЕсли;
		
		ЗавершитьРаботуСистемы(Ложь);
		Возврат Истина;
		
	// Параметр может содержать две дополнительные части, разделенные символом ";" - 
	// имя и пароль администратора ИБ, от имени которого происходит подключение к кластеру серверов
	// в клиент-серверном варианте развертывания системы. Их необходимо передавать в случае, 
	// если текущий пользователь не является администратором ИБ.
	// См. использование в процедуре ЗавершитьРаботуПользователей().
	ИначеЕсли ЗначениеПараметраЗапуска = Врег("ЗавершитьРаботуПользователей") Тогда
		
		// поскольку блокировка еще не установлена, то при входе в систему
		// для данного пользователя был подключен обработчик ожидания завершения работы.
		// Отключаем его. Так как для этого пользователя подключается специализированный обработчики ожидания
		// "ЗавершитьРаботуПользователей", который ориентирован на то, что данный пользователь
		// должен быть отключен последним.
		ОтключитьОбработчикОжидания("КонтрольРежимаЗавершенияРаботыПользователей");
		
		Если НЕ СоединенияИБ.УстановитьБлокировкуСоединений() Тогда
			ТекстСообщения = НСтр("ru = 'Параметр запуска ЗавершитьРаботуПользователей не отработан. Нет прав на администрирование информационной базы.'");
			Предупреждение(ТекстСообщения);
			Возврат Ложь;
		КонецЕсли;
		
		ПодключитьОбработчикОжидания("ЗавершитьРаботуПользователей", 60);
		ЗавершитьРаботуПользователей();
		Возврат Истина;
		
	ИначеЕсли ЗначениеПараметраЗапуска = Врег("ВыводитьСлужебнуюИнформацию") 
		ИЛИ ЗначениеПараметраЗапуска = Врег("test") Тогда
		
		РаботаСОбщимиПеременными.УстановитьЗначениеПеременной("ВыводитьСлужебнуюИнформацию", Истина, Истина);
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Подключить обработчик ожидания КонтрольРежимаЗавершенияРаботыПользователей или
// ЗавершитьРаботуПользователей в зависимости от параметра УстановитьБлокировкуСоединений.
//
Процедура УстановитьОбработчикиОжиданияЗавершенияРаботыПользователей(Знач УстановитьБлокировкуСоединений) Экспорт
	
	Если УстановитьБлокировкуСоединений Тогда
		// поскольку блокировка еще не установлена, то при входе в систему
		// для данного пользователя был подключен обработчик ожидания завершения работы.
		// Отключаем его. Так как для этого пользователя подключается специализированный обработчик ожидания
		// "ЗавершитьРаботуПользователей", который ориентирован на то, что данный пользователь
		// должен быть отключен последним.
		
		ОтключитьОбработчикОжидания("КонтрольРежимаЗавершенияРаботыПользователей");
		ПодключитьОбработчикОжидания("ЗавершитьРаботуПользователей", 60);
		ЗавершитьРаботуПользователей();
		ПоказатьОповещениеПользователя(НСтр("ru = 'Режим блокировки'"),
			"e1cib/app/Обработка.БлокировкаСоединенийСИнформационнойБазой",
			НСтр("ru = 'Установлена блокировка соединений с информационной базой.'"), 
			БиблиотекаКартинок.Информация32);
	Иначе
		ОтключитьОбработчикОжидания("ЗавершитьРаботуПользователей");
		ПодключитьОбработчикОжидания("КонтрольРежимаЗавершенияРаботыПользователей", 60);
		ПоказатьОповещениеПользователя(НСтр("ru = 'Режим блокировки'"),
			"e1cib/app/Обработка.БлокировкаСоединенийСИнформационнойБазой",
			НСтр("ru = 'Снята блокировка соединений с информационной базой.'"), 
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при неудачной попытке установить монопольный режим в файловой базе.
// 
// Параметры:
//  Отказ - булево - если Истина - завершает работу программы
//
Процедура ПриОткрытииФормыОшибкиУстановкиМонопольногоРежима(Отказ) Экспорт
	
	Результат = Вопрос("Невозможно выполнить обновление версии программы, т.к. с ней работают другие пользователи."+
		Символы.ПС+"Для продолжения необходимо завершить их работу.", РежимДиалогаВопрос.ПовторитьОтмена, , 
		КодВозвратаДиалога.Отмена, "Не удалось выполнить обновление");
	
	Если Результат = КодВозвратаДиалога.Отмена 
		ИЛИ Результат = Неопределено Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

