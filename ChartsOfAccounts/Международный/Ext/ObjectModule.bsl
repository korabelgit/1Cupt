﻿
Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Порядок = СокрЛ(ПолучитьПорядокКода());
		
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры


