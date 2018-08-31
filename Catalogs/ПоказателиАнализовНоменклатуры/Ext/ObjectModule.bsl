﻿Процедура ПередЗаписью(Отказ)
	
	Если НЕ ОбменДанными.Загрузка И НЕ ЭтоГруппа Тогда
		
		ПВХ = ПланыВидовХарактеристик.ВидыРезультатовАнализаНоменклатуры;
		Если НЕ ЗначениеЗаполнено(ВидРезультатаАнализа) Тогда
			ОбщегоНазначения.СообщитьОбОшибке( "Не указано значение вида результатов анализа.", Отказ);
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(ВидРезультатаАнализа) ИЛИ НЕ ВидРезультатаАнализа.Предопределенный Тогда
			
			ДопустимыеЗначенияПоказателей.Очистить();
			ЕдиницаИзмерения = 0;
			МинЗначение      = 0;
			МаксЗначение     = 0;
			
		ИначеЕсли ВидРезультатаАнализа = ПВХ.ЗначениеИзСписка Тогда
			
			ЕдиницаИзмерения = 0;
			МинЗначение      = 0;
			МаксЗначение     = 0;
			Для Каждого ТекЗначение Из ДопустимыеЗначенияПоказателей Цикл
				Если НЕ ЗначениеЗаполнено(ТекЗначение.ЗначениеПоказателя) Тогда
#ЕСЛИ КЛИЕНТ ТОГДА				
					ОбщегоНазначения.СообщитьОбОшибке("Не указано значение показателя в строке № " + ТекЗначение.НомерСтроки, Отказ);
#КОНЕЦЕСЛИ
				КонецЕсли;
			КонецЦикла;
			
		ИначеЕсли ВидРезультатаАнализа = ПВХ.ЧислоВИнтервале  Тогда
			
			ДопустимыеЗначенияПоказателей.Очистить();
			Если МинЗначение > МаксЗначение Тогда
#ЕСЛИ КЛИЕНТ ТОГДА				
				ОбщегоНазначения.СообщитьОбОшибке("Значение начала интервала должно быть меньше конца интервала.", Отказ);
#КОНЕЦЕСЛИ
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

