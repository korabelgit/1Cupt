﻿
// Обработчик события "ПередЗаписью" Объекта
//
Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ПользовательДляОграниченияПравДоступа = глЗначениеПеременной("глТекущийПользователь");
	
КонецПроцедуры

