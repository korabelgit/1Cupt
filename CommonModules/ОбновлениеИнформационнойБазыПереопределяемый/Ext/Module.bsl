﻿// ИНТЕРФЕЙСНАЯ ЧАСТЬ ПЕРЕОПРЕДЕЛЯЕМОГО МОДУЛЯ

// Возвращает список процедур-обработчиков обновления ИБ для всех поддерживаемых версий ИБ.
//
// Пример добавления процедуры-обработчика в список:
//    Обработчик = Обработчики.Добавить();
//    Обработчик.Версия = "1.0.0.0";
//    Обработчик.Процедура = "ОбновлениеИБ.ПерейтиНаВерсию_1_0_0_0";
//
// Вызывается перед началом обновления данных ИБ.
//
Функция ОбработчикиОбновления() Экспорт
	
	Возврат БиблиотекаОбновленияИнформационнойБазыПереопределяемый.ОбработчикиОбновления();
	
КонецФункции

// Вызывается после завершении обновления данных ИБ.
// 
// Параметры:
//   ПредыдущаяВерсияИБ     - Строка - версия ИБ до обновления. "0.0.0.0" для "пустой" ИБ.
//   ТекущаяВерсияИБ        - Строка - версия ИБ после обновления.
//   ВыполненныеОбработчики - ДеревоЗначений - список выполненных процедур-обработчиков
//                                             обновления, сгруппированных по номеру версии.
//  Итерирование по выполненным обработчикам:
//		Для Каждого Версия Из ВыполненныеОбработчики.Строки Цикл
//	
//			Если Версия.Версия = "*" Тогда
//				группа обработчиков, которые выполняются всегда
//			Иначе
//				группа обработчиков, которые выполняются для определенной версии 
//			КонецЕсли;
//	
//			Для Каждого Обработчик Из Версия.Строки Цикл
//				...
//			КонецЦикла;
//	
//		КонецЦикла;
//
//   ВыводитьОписаниеОбновлений - Булево -	если Истина, то выводить форму с описанием 
//											обновлений.
// 
Процедура ПослеОбновления(Знач ПредыдущаяВерсияИБ, Знач ТекущаяВерсияИБ, Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений) Экспорт
	
КонецПроцедуры
