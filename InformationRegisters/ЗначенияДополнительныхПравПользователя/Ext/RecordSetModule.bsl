﻿
Процедура ПередЗаписью(Отказ, Замещение)

	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;

	Для каждого Запись Из ЭтотОбъект Цикл
		
		Если Запись.Значение <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		// приводим запись к нужному типу
		Запись.Значение = Запись.Право.ТипЗначения.ПривестиЗначение(Запись.Значение);

	КонецЦикла;

КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	УправлениеПользователями.ИнформироватьОбИзмененииНастроекДопПрав(ЭтотОбъект);
																					  
КонецПроцедуры
