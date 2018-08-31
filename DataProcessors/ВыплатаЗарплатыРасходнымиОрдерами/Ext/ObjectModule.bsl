﻿
////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Производит автозаполнение табличной части РКО
//
Процедура Автозаполнение() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка",ПлатежнаяВедомость);
	Запрос.УстановитьПараметр("ПустойРКО",Документы.РасходныйКассовыйОрдер.ПустаяСсылка());
	Запрос.УстановитьПараметр("Выплачено",Перечисления.ВыплаченностьЗарплаты.Выплачено);	
	Запрос.УстановитьПараметр("ЧерезКассу",Перечисления.СпособыВыплатыЗарплаты.ЧерезКассу);	
	Запрос.УстановитьПараметр("ВыплатаЗаработнойПлатыРаботнику",Перечисления.ВидыОперацийРКО.ВыплатаЗаработнойПлатыРаботнику);
	Запрос.УстановитьПараметр("ВыплатаЗаработнойПлатыПоВедомостям",Перечисления.ВидыОперацийРКО.ВыплатаЗаработнойПлатыПоВедомостям);
	      
	
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
    |	Работники.Сотрудник КАК Сотрудник
	|ПОМЕСТИТЬ
	|	ВТРаботникиОрганизации
	|ИЗ
	|	Документ.ЗарплатаКВыплатеОрганизаций.РаботникиОрганизации КАК Работники
	|ГДЕ
	|	Работники.Ссылка = &Ссылка
	|	И Работники.ВыплаченностьЗарплаты = &Выплачено
	|	И Работники.СпособВыплаты = &ЧерезКассу
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудник ";
	Запрос.Выполнить();
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗарплатаКВыплатеОрганизаций.Сотрудник,
	|	ЕСТЬNULL(ЕСТЬNULL(РасходныйКассовыйОрдер.Ссылка, РасходныйКассовыйОрдерВыплатаЗаработнойПлаты.Ссылка), &ПустойРКО) КАК РКО,
	|	(НЕ ЕСТЬNULL(ЕСТЬNULL(РасходныйКассовыйОрдер.Проведен, РасходныйКассовыйОрдерВыплатаЗаработнойПлаты.Ссылка.Проведен), ЛОЖЬ)) КАК Отметка,
	|	СУММА(ЗарплатаКВыплатеОрганизаций.Сумма) КАК Сумма,
	|	ЗарплатаКВыплатеОрганизаций.СчетУчета
	|
	|ИЗ	Документ.ЗарплатаКВыплатеОрганизаций.ПараметрыОплаты КАК ЗарплатаКВыплатеОрганизаций
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РасходныйКассовыйОрдер КАК РасходныйКассовыйОрдер
	|		ПО ЗарплатаКВыплатеОрганизаций.Ссылка = РасходныйКассовыйОрдер.РасчетныйДокумент
	|			И ЗарплатаКВыплатеОрганизаций.Сотрудник = РасходныйКассовыйОрдер.Контрагент
	|			И ЗарплатаКВыплатеОрганизаций.СчетУчета = РасходныйКассовыйОрдер.СчетУчетаРасчетовСКонтрагентом
	|			И (РасходныйКассовыйОрдер.ВидОперации = &ВыплатаЗаработнойПлатыРаботнику)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РасходныйКассовыйОрдер.ВыплатаЗаработнойПлаты КАК РасходныйКассовыйОрдерВыплатаЗаработнойПлаты
	|		ПО ЗарплатаКВыплатеОрганизаций.Ссылка = РасходныйКассовыйОрдерВыплатаЗаработнойПлаты.Ведомость
	|			И (РасходныйКассовыйОрдерВыплатаЗаработнойПлаты.Ссылка.ВидОперации = &ВыплатаЗаработнойПлатыПоВедомостям)
	|ГДЕ
	|	ЗарплатаКВыплатеОрганизаций.Сотрудник в (ВЫБРАТЬ Сотрудник ИЗ ВТРаботникиОрганизации)
	|	И ЗарплатаКВыплатеОрганизаций.Ссылка = &Ссылка
	|		
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗарплатаКВыплатеОрганизаций.Сотрудник,
	|	РасходныйКассовыйОрдер.Ссылка,
	|	РасходныйКассовыйОрдерВыплатаЗаработнойПлаты.Ссылка,	
	|	ЗарплатаКВыплатеОрганизаций.СчетУчета
	|   ";

	
   
	РКО.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры
