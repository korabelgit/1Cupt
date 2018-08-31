﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем ЭлементыНастройки    Экспорт; // Массив элементов структуры СКД         
Перем СохраненнаяНастройка Экспорт;   
Перем Расшифровки          Экспорт;

#Если Клиент Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ОТЧЕТА 

// Формирование отчета в табличный документ
// 
Функция СформироватьОтчет(Результат = Неопределено, ДанныеРасшифровки = Неопределено, ВыводВФормуОтчета = истина) Экспорт
	
	Если ДанныеРасшифровки = Неопределено тогда
		ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	КонецЕсли;
	
	Возврат ТиповыеОтчеты.СформироватьТиповойОтчет(ЭтотОбъект, Результат, ДанныеРасшифровки, ВыводВФормуОтчета);
	
КонецФункции //СформироватьОтчет()

// Запоминание элементов структуры отчета
//
Процедура ЗапомнитьНастройку() Экспорт 
	
	ЭлементыНастройки[0] = КомпоновщикНастроек.Настройки.Структура[0].Колонки[0];
	ЭлементыНастройки[1] = КомпоновщикНастроек.Настройки.Структура[0].Колонки[1];
	ЭлементыНастройки[2] = КомпоновщикНастроек.Настройки.Структура[0].Колонки[2];
	ЭлементыНастройки[3] = КомпоновщикНастроек.Настройки.Структура[0].Колонки[1].Структура[0];
	
	КомпоновщикНастроек.Настройки.Структура[0].Колонки.Удалить(ЭлементыНастройки[0]);
	КомпоновщикНастроек.Настройки.Структура[0].Колонки.Удалить(ЭлементыНастройки[1]);
	КомпоновщикНастроек.Настройки.Структура[0].Колонки.Удалить(ЭлементыНастройки[2]);
	
КонецПроцедуры //ЗапомнитьНастройку()

// Инициализация отчета
//
// Параметры:
//  Нет.
//
Процедура ИнициализацияОтчета() Экспорт
	
	ТиповыеОтчеты.ИнициализацияТиповогоОтчета(ЭтотОбъект);
	
КонецПроцедуры //ИнициализацияОтчета()


// Добавление настройки структуры в колонки таблицы
//
Процедура ВосстановитьНастройку() Экспорт  
	
	ЭлементГруппировки = КомпоновщикНастроек.Настройки.Структура[0].Колонки.Добавить();
	ТиповыеОтчеты.СкопироватьНастройкиКомпоновкиДанных(ЭлементГруппировки, ЭлементыНастройки[0]);
	
	ЭлементГруппировки = КомпоновщикНастроек.Настройки.Структура[0].Колонки.Добавить();
	ТиповыеОтчеты.СкопироватьНастройкиКомпоновкиДанных(ЭлементГруппировки, ЭлементыНастройки[1]);
	
	//ЭлементГруппировки = ЭлементГруппировки.Структура.Добавить();
	//ТиповыеОтчеты.СкопироватьНастройкиКомпоновкиДанных(ЭлементГруппировки, ЭлементыНастройки[3]);
	
	ЭлементГруппировки = КомпоновщикНастроек.Настройки.Структура[0].Колонки.Добавить();
	ТиповыеОтчеты.СкопироватьНастройкиКомпоновкиДанных(ЭлементГруппировки, ЭлементыНастройки[2]);
	
КонецПроцедуры //ВосстановитьНастройку()

// Возвращает значение истина, если в элементах структуры отчета присутствует поле Период регистрации
//
Функция ПрисутствуетПолеПериодРегистрацииВГруппировке()
	
	Если КомпоновщикНастроек.Настройки.Структура.Количество() <> 0 тогда
		
		Если Тип(КомпоновщикНастроек.Настройки.Структура[0]) = Тип("ТаблицаКомпоновкиДанных") тогда
			
			Возврат НайтиПериодРегистрации(КомпоновщикНастроек.Настройки.Структура[0].Строки[0]);
			
		ИначеЕсли Тип(КомпоновщикНастроек.Настройки.Структура[0]) = Тип("ГруппировкаКомпоновкиДанных") тогда
			
			Возврат НайтиПериодРегистрации(КомпоновщикНастроек.Настройки.Структура[0]);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ложь;
	
КонецФункции //ПрисутствуетПолеПериодРегистрацииВГруппировке()

// Функция возвращает значение истина, если в группировках элементов структуры присутствует поле "Период регистрации"
//
Функция НайтиПериодРегистрации(Структура)
	
	ЕстьПоле = ложь;
	
	ПолеПериодРегистрации = Новый ПолеКомпоновкиДанных("ПериодРегистрации");
	
	Для каждого ПолеГруппировки из Структура.ПоляГруппировки.Элементы Цикл
		
		Если ПолеГруппировки.Использование И ПолеГруппировки.Поле = ПолеПериодРегистрации тогда
			
			ЕстьПоле = истина;
			
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не ЕстьПоле И Структура.Структура.Количество() <> 0 тогда
		
		ЕстьПоле = НайтиПериодРегистрации(Структура.Структура[0]);
		
	КонецЕсли;
	
	Возврат ЕстьПоле;
	
КонецФункции //НайтиПериодРегистрации()

// Доработка компоновщика отчета перед выводом
//
Процедура ДоработатьКомпоновщикПередВыводом() Экспорт
	
	ЗначениеПараметра          = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ЕстьГруппировкаПоПериодуРегисрации"));
	ЗначениеПараметра.Значение = ПрисутствуетПолеПериодРегистрацииВГруппировке();
	
КонецПроцедуры //ДоработатьКомпоновщикПередВыводом()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Сохранение настроек схемы компоновки
//
Процедура СохранитьНастройку() Экспорт
	
	СтруктураНастроек = ТиповыеОтчеты.ПолучитьСтруктуруПараметровТиповогоОтчета(ЭтотОбъект);
	СохранениеНастроек.СохранитьНастройкуОбъекта(СохраненнаяНастройка, СтруктураНастроек);
	
КонецПроцедуры //СохранитьНастройку()


// Заполнение параметров отчета по элементу справочника из переменной СохраненнаяНастройка.
//
Процедура ПрименитьНастройку() Экспорт
	
	Если СохраненнаяНастройка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	 
	СтруктураПараметров = СохраненнаяНастройка.ХранилищеНастроек.Получить();
	ТиповыеОтчеты.ПрименитьСтруктуруПараметровОтчета(ЭтотОбъект, СтруктураПараметров);
	
КонецПроцедуры //ПрименитьНастройку()


ЭлементыНастройки = Новый Массив(4);

Расшифровки = Новый СписокЗначений;


#КонецЕсли




