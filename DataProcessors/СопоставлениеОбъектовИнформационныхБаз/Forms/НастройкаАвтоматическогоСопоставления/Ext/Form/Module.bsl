﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СписокПолейСопоставления = Параметры.СписокПолейСопоставления;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьТекстПоясняющейНадписи();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура СписокПолейСопоставленияПриИзменении(Элемент)
	
	ОбновитьТекстПоясняющейНадписи();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВыполнитьСопоставление(Команда)
	
	ОповеститьОВыборе(СписокПолейСопоставления.Скопировать());
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ОповеститьОВыборе(Неопределено);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОбновитьТекстПоясняющейНадписи()
	
	МассивОтмеченныхЭлементовСписка = ОбщегоНазначенияКлиентСервер.ПолучитьМассивОтмеченныхЭлементовСписка(СписокПолейСопоставления);
	
	Если МассивОтмеченныхЭлементовСписка.Количество() = 0 Тогда
		
		ПоясняющаяНадпись = НСтр("ru = 'Сопоставление будет выполнено только по внутренним идентификаторам объектов.'");
		
	Иначе
		
		ПоясняющаяНадпись = НСтр("ru = 'Сопоставление будет выполнено по внутренним идентификаторам объектов и по выбранным полям.'");
		
	КонецЕсли;
	
КонецПроцедуры
