﻿                                  
////////// ОБЩИЕ КОМАНДЫ ВСЕХ ОБРАБОТЧИКОВ //////////////

// Функция осуществляет подключение устройства.
//
// Параметры:
//  ОбъектДрайвера   - <*>
//           - ОбъектДрайвера драйвера торгового оборудования.
//
// Возвращаемое значение:
//  <Булево> - Результат работы функции.
//
Функция ПодключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт

	Результат = Истина;
	ВыходныеПараметры = Новый Массив();
	ПараметрыПодключения.Вставить("ИДУстройства", Неопределено);

	// Проверка настроенных параметров
	Порт              = Неопределено;
	Скорость          = Неопределено;
	Параметры.Свойство("Порт",              Порт);
	Параметры.Свойство("Скорость",          Скорость);
	
	Если Порт              = Неопределено
	 Или Скорость          = Неопределено Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Не настроены параметры устройства.
		|Для корректной работы устройства необходимо задать параметры его работы.
		|Сделать это можно при помощи формы ""Настройка параметров"" модели
		|подключаемого оборудования в форме ""Подключение и настройка оборудования"".'"));

		Результат = Ложь;
	КонецЕсли;

	МассивЗначений = Новый Массив;
	МассивЗначений.Добавить(Параметры.Порт);
	МассивЗначений.Добавить(Параметры.Скорость);
	МассивЗначений.Добавить(0);
	МассивЗначений.Добавить(8);
	МассивЗначений.Добавить(1);
	МассивЗначений.Добавить(Параметры.Модель);
	МассивЗначений.Добавить(Параметры.ИспользоватьБегущуюСтроку);
	МассивЗначений.Добавить(Параметры.БегущаяСтрока);
	
	Если Результат Тогда
		Ответ = ОбъектДрайвера.Подключить(МассивЗначений, ПараметрыПодключения.ИДУстройства);
		Если НЕ Ответ Тогда
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить(ОбъектДрайвера.ОписаниеРезультата);
			Результат = Ложь;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет отключение устройства.
//
// Параметры:
//  ОбъектДрайвера - <*>
//         - ОбъектДрайвера драйвера торгового оборудования.
//
// Возвращаемое значение:
//  <Булево> - Результат работы функции.
//
Функция ОтключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт

	Результат = Истина;

	ВыходныеПараметры = Новый Массив();

	ОбъектДрайвера.Отключить(ПараметрыПодключения.ИДУстройства);

	Возврат Результат;

КонецФункции

// Функция получает, обрабатывает и перенаправляет на исполнение команду к драйверу
//
Функция ВыполнитьКоманду(Команда, ВходныеПараметры = Неопределено, ВыходныеПараметры = Неопределено,
                         ОбъектДрайвера, Параметры, ПараметрыПодключения) Экспорт

	Результат = Истина;

	ВыходныеПараметры = Новый Массив();

	// Вывод строк на дисплей
	Если Команда = "ВывестиСтрокуНаДисплейПокупателя" ИЛИ Команда = "DisplayText" Тогда
		СтрокаТекста = ВходныеПараметры[0];
		Результат = ВывестиСтрокуНаДисплейПокупателя(ОбъектДрайвера, Параметры, ПараметрыПодключения, СтрокаТекста, ВыходныеПараметры);

	// Очистка дисплея
	ИначеЕсли Команда = "ОчиститьДисплейПокупателя" ИЛИ Команда = "ClearText" Тогда
		Результат = ОчиститьДисплейПокупателя(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Тестирование устройства
	ИначеЕсли Команда = "ТестУстройства" ИЛИ Команда = "CheckHealth" Тогда
		Результат = ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Получение версии драйвера
	ИначеЕсли Команда = "ПолучитьВерсиюДрайвера" Тогда
		Результат = ПолучитьВерсиюДрайвера(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Указанная команда не поддерживается данным драйвером
	Иначе
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Команда ""%Команда%"" не поддерживается данным драйвером.'"));
		ВыходныеПараметры[1] = СтрЗаменить(ВыходныеПараметры[1], "%Команда%", Команда);
		Результат = Ложь;

	КонецЕсли;

	Возврат Результат;

КонецФункции


/////////////////////////////////////
// Функции-исполнители команд

///////// СПЕЦИФИЧНЫЕ ПО ТИПУ ОБОРУДОВАНИЯ КОМАНДЫ ////////////////

// Функция осуществляет вывод списка строк на дисплей покупателя.
//
Функция ВывестиСтрокуНаДисплейПокупателя(ОбъектДрайвера, Параметры, ПараметрыПодключения, СтрокаТекста, ВыходныеПараметры)

	Результат = Истина;

	МассивСтрок = Новый Массив();
	МассивСтрок.Добавить(СтрПолучитьСтроку(СтрокаТекста, 1));
	МассивСтрок.Добавить(СтрПолучитьСтроку(СтрокаТекста, 2));

	Ответ = ОбъектДрайвера.ВывестиСтрокуНаДисплейПокупателя(ПараметрыПодключения.ИДУстройства, МассивСтрок);
	
	//ОбъектДрайвера.ЗаписатьСлой(1);
	//ОбъектДрайвера.Демо(1, 7);

	Если Не Ответ Тогда
		Результат = Ложь;
		ОбъектДрайвера.ПолучитьОшибку(ОбъектДрайвера.ОписаниеОшибки);
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(ОбъектДрайвера.ОписаниеОшибки);
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет очистку дисплея покупателя.
//
Функция ОчиститьДисплейПокупателя(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	Ответ = ОбъектДрайвера.ОчиститьДисплейПокупателя(ПараметрыПодключения.ИДУстройства);
	Если Не Ответ Тогда
		Результат = Ложь;
		ОбъектДрайвера.ПолучитьОшибку(ОбъектДрайвера.ОписаниеОшибки);
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(ОбъектДрайвера.ОписаниеОшибки);
	КонецЕсли;

	Возврат Результат;

КонецФункции

//////////// ДОПОЛНИТЕЛЬНЫЕ КОМАНДЫ ////////////////////

// Функция осуществляет тестирование устройства.
//
Функция ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	Результат = ПодключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
	Если НЕ Результат Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Ошибка при подключении устройства'"));
	Иначе
		СтрокаТекста = НСтр("ru='Тестовая строка 1'")+Символы.ПС+НСтр("ru='Тестовая строка 2'");
		Результат = ВывестиСтрокуНаДисплейПокупателя(ОбъектДрайвера, Параметры, ПараметрыПодключения, СтрокаТекста, ВыходныеПараметры);
		Пауза(5);
		Если Результат Тогда
			ВыходныеПараметры.Добавить(0);
			ВыходныеПараметры.Добавить(НСтр("ru='Тест успешно выполнен'"));
		КонецЕсли;
	КонецЕсли;

	ОтключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	Возврат Результат;

КонецФункции

// Функция возвращает версию установленного драйвера
//
Функция ПолучитьВерсиюДрайвера(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	ВыходныеПараметры.Добавить(НСтр("ru='Установлен'"));
	ВыходныеПараметры.Добавить(НСтр("ru='Не определена'"));

	Попытка
		ВыходныеПараметры[1] = ОбъектДрайвера.ПолучитьНомерВерсии();
	Исключение
	КонецПопытки;

	Возврат Результат;

КонецФункции

///////// ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ ОБРАБОТЧИКА ///////////

// Процедура формирует задержку указанной длительности
//
// Параметры:
//  Время - <Число>
//        - Длительность задержки в секундах.
//
Процедура Пауза(Время)

	ВремяЗавершения = ТекущаяДата() + Время;
	Пока ТекущаяДата() < ВремяЗавершения Цикл
	КонецЦикла;

КонецПроцедуры // Пауза()