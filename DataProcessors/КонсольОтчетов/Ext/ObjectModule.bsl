﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ
//

Функция ПолучитьПутьСтроки(Строка) Экспорт

	ПутьСтроки = Неопределено;

	Если Строка <> Неопределено Тогда
		ТС = Строка;
		Пока ТС <> Неопределено Цикл
			Если ПутьСтроки = Неопределено Тогда
				ПутьСтроки = ТС.ИмяОтчета;
			Иначе
				ПутьСтроки = ТС.ИмяОтчета + Символы.ПС + ПутьСтроки;
			КонецЕсли;
			ТС = ТС.Родитель;
		КонецЦикла;
	КонецЕсли;

	Возврат ПутьСтроки;

КонецФункции

Функция НайтиСтрокуПоПути(Путь) Экспорт

	ТекущаяСтрокаДерева = Неопределено;

	Если Путь <> Неопределено Тогда

		Для тс = 1 По СтрЧислоСтрок(Путь) Цикл

			ТекущееИмяОтчета = СтрПолучитьСтроку(Путь, тс);

			Если ТекущаяСтрокаДерева = Неопределено Тогда 
				Строки = ДеревоОтчетов.Строки;
			Иначе
				Строки = ТекущаяСтрокаДерева.Строки;
			КонецЕсли;

			Найдено = Ложь;
			Для Каждого сд Из Строки Цикл
				Если сд.ИмяОтчета = ТекущееИмяОтчета Тогда
					// Нашли текущее имя
					Найдено = Истина;
					ТекущаяСтрокаДерева = сд;
					Прервать;
				КонецЕсли;
			КонецЦикла;

			Если Не Найдено Тогда
				Прервать;
			КонецЕсли;

		КонецЦикла;

	КонецЕсли;

	Возврат ТекущаяСтрокаДерева;

КонецФункции

// Создадим структуру дерева отчетов
ДеревоОтчетов.Колонки.Добавить("ИмяОтчета");
ДеревоОтчетов.Колонки.Добавить("СхемаКомпоновкиДанных");
ДеревоОтчетов.Колонки.Добавить("Настройки");
ДеревоОтчетов.Колонки.Добавить("НастройкаДляЗагрузки");
ДеревоОтчетов.Колонки.Добавить("СохранятьНастройкиАвтоматически");
