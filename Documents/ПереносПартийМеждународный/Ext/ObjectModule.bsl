﻿Перем мУдалятьДвижения;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда
// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходимое количество копий.
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

	Если ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда

		ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
		
		Если ТабДокумент = Неопределено Тогда
			Возврат
		КонецЕсли; 
		
	КонецЕсли;

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект), Ссылка);

КонецПроцедуры // Печать

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

#КонецЕсли

Процедура ОбработкаПроведения(Отказ, Режим)

	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);

	Для Каждого ТекСтрокаПартииТоваровНаСкладах Из ПартииТоваровНаСкладах Цикл
		
		Если НЕ ЗначениеЗаполнено(ТекСтрокаПартииТоваровНаСкладах.СчетУчета) Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Строка "+ТекСтрокаПартииТоваровНаСкладах.НомерСтроки+" : Не указан счет учета!", Отказ, Заголовок);
			Продолжить;
		КонецЕсли;
		// регистр ПартииТоваровНаСкладахМеждународныйУчет
		Движение = Движения.ПартииТоваровНаСкладахМеждународныйУчет.Добавить();
		Если ТекСтрокаПартииТоваровНаСкладах.ВидДвижения = Перечисления.ВидыДвиженийПартий.Поступление Тогда
			Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		ИначеЕсли ТекСтрокаПартииТоваровНаСкладах.ВидДвижения = Перечисления.ВидыДвиженийПартий.Реализация Тогда
			Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		КонецЕсли;
		Движение.Период = ТекСтрокаПартииТоваровНаСкладах.Период;
		Движение.Организация = Организация;
		Движение.Номенклатура = ТекСтрокаПартииТоваровНаСкладах.Номенклатура;
		Движение.Склад = ТекСтрокаПартииТоваровНаСкладах.Склад;
		Движение.ДокументОприходования = ТекСтрокаПартииТоваровНаСкладах.ДокументОприходования;
		Движение.ХарактеристикаНоменклатуры = ТекСтрокаПартииТоваровНаСкладах.ХарактеристикаНоменклатуры;
		Движение.СерияНоменклатуры = ТекСтрокаПартииТоваровНаСкладах.СерияНоменклатуры;
		Движение.Заказ = ТекСтрокаПартииТоваровНаСкладах.Заказ;
		Движение.Качество = ТекСтрокаПартииТоваровНаСкладах.Качество;
		Движение.СчетУчета = ТекСтрокаПартииТоваровНаСкладах.СчетУчета;
		Движение.Количество = ТекСтрокаПартииТоваровНаСкладах.Количество;
		Движение.Стоимость = ТекСтрокаПартииТоваровНаСкладах.Стоимость;
		Движение.КодОперации = Перечисления.КодыОперацийПартииТоваров.Поступление;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;


	 
	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью


