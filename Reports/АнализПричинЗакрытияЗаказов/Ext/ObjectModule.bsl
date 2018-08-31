﻿#Если Клиент Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ НАЧАЛЬНОЙ НАСТРОЙКИ ОТЧЕТА

// Процедура установки начальных настроек отчета с использованием текста запроса
//
Процедура УстановитьНачальныеНастройки(ДополнительныеПараметры = Неопределено) Экспорт
	
	// Настройка общих параметров универсального отчета
	УправлениеОтчетами.ВосстановитьРеквизитыОтчета(ЭтотОбъект, ДополнительныеПараметры);
	
	УниверсальныйОтчет.мНазваниеОтчета = СокрЛП(ЭтотОбъект.Метаданные().Синоним);
	УниверсальныйОтчет.мВыбиратьИмяРегистра = Ложь;
	УниверсальныйОтчет.ВыводитьДетальныеЗаписи = Ложь;
	УниверсальныйОтчет.мВыбиратьИспользованиеСвойств = Истина;
	
	ТекстЗапроса = "
	|
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ 
	|
	|	ПричиныЗакрытияЗаказов.СуммаВзаиморасчетов 						КАК СуммаВзаиморасчетов,
	|	ПричиныЗакрытияЗаказов.СуммаУпрУчета 							КАК СуммаУпрУчета,
	|	ПричиныЗакрытияЗаказов.ВидЗаказа								КАК ВидЗаказа,
	|   ПричиныЗакрытияЗаказов.СуммаЗаказа 								КАК СуммаЗаказа,
	|   ПричиныЗакрытияЗаказов.ВалютаДокумента 							КАК ВалютаДокумента,
	|   ПРЕДСТАВЛЕНИЕ(ПричиныЗакрытияЗаказов.ВалютаДокумента) 			КАК ВалютаДокументаПредставление,
	|   ПричиныЗакрытияЗаказов.ВалютаВзаиморасчетов 					КАК ВалютаВзаиморасчетов,
	|   ПРЕДСТАВЛЕНИЕ(ПричиныЗакрытияЗаказов.ВалютаВзаиморасчетов) 		КАК ВалютаВзаиморасчетовПредставление,
	|   ПричиныЗакрытияЗаказов.КурсВзаиморасчетов 						КАК КурсВзаиморасчетов,
	|   ПричиныЗакрытияЗаказов.Контрагент 								КАК Контрагент,
	|   ПРЕДСТАВЛЕНИЕ(ПричиныЗакрытияЗаказов.Контрагент) 				КАК КонтрагентПредставление,
	|   ПричиныЗакрытияЗаказов.ДоговорКонтрагента  						КАК ДоговорКонтрагента,
	|   ПРЕДСТАВЛЕНИЕ(ПричиныЗакрытияЗаказов.ДоговорКонтрагента)  		КАК ДоговорКонтрагентаПредставление,
	|	ПричиныЗакрытияЗаказов.Регистратор.Ответственный 				КАК ОтветственныйЗаЗакрытиеЗаказа,
    |	ПРЕДСТАВЛЕНИЕ(ПричиныЗакрытияЗаказов.Регистратор.Ответственный) КАК ОтветственныйЗаЗакрытиеЗаказаПредставление,
	|	ПричиныЗакрытияЗаказов.ПричинаЗакрытияЗаказа                    КАК ПричинаЗакрытияЗаказа,
	|	ПРЕДСТАВЛЕНИЕ(ПричиныЗакрытияЗаказов.ПричинаЗакрытияЗаказа)     КАК ПричинаЗакрытияЗаказаПредставление,
	|	ПричиныЗакрытияЗаказов.Заказ                                    КАК Заказ,
	|	ПРЕДСТАВЛЕНИЕ(ПричиныЗакрытияЗаказов.Заказ)                     КАК ЗаказПредставление,
	|	ПричиныЗакрытияЗаказов.Заказ.Ответственный                      КАК ОтветственныйЗаЗаказ,
	|	ПРЕДСТАВЛЕНИЕ(ПричиныЗакрытияЗаказов.Заказ.Ответственный)       КАК ОтветственныйЗаЗаказПредставление,
	|	ПричиныЗакрытияЗаказов.Заказ.Подразделение 						КАК Подразделение,
	|	ПРЕДСТАВЛЕНИЕ(ПричиныЗакрытияЗаказов.Заказ.Подразделение) 		КАК ПодразделениеПредставление
    |	//ПОЛЯ_СВОЙСТВА
	|	//ПОЛЯ_КАТЕГОРИИ
	|{ВЫБРАТЬ
	|	ПричинаЗакрытияЗаказа,
	|	Заказ.*,
	|	Подразделение.*,
	|   Контрагент.*,    
	|	ДоговорКонтрагента.*,
	|	ВидЗаказа,
	|	СуммаЗаказа,
	|	СуммаУпрУчета,
	|	СуммаВзаиморасчетов,
	|	ВалютаДокумента,
	|	ВалютаВзаиморасчетов,
	|	КурсВзаиморасчетов,
	|	ОтветственныйЗаЗакрытиеЗаказа,
	|	ОтветственныйЗаЗаказ
	|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
	|}
	|ИЗ
	|(  ВЫБРАТЬ
	|	СуммаВзаиморасчетов 					КАК СуммаВзаиморасчетов,
	|	СуммаУпрУчета 							КАК СуммаУпрУчета,
	|	ВЫБОР КОГДА Заказ ССЫЛКА Документ.ЗаказПоставщику ТОГДА
	|" 			+ НСтр("ru='""Заказ поставщику""';uk='""Замовлення постачальникові""'", ЛокализацияПовтИсп.ПолучитьЯзыкФормированияПечатныхФормОтчетов()) + " 
	|		  КОГДА Заказ ССЫЛКА Документ.ЗаказПокупателя ТОГДА
	|" 			+ НСтр("ru='""Заказ покупателя""';uk='""Замовлення покупця""'", ЛокализацияПовтИсп.ПолучитьЯзыкФормированияПечатныхФормОтчетов()) + " 	
	|		  КОГДА Заказ ССЫЛКА Документ.ЗаказНаПроизводство ТОГДА
	|" 			+ НСтр("ru='""Заказ на производство""';uk='""Замовлення на виробництво""'", ЛокализацияПовтИсп.ПолучитьЯзыкФормированияПечатныхФормОтчетов()) + " 
	|		  КОГДА Заказ ССЫЛКА Документ.ВнутреннийЗаказ ТОГДА
	|" 			+ НСтр("ru='""Внутренний заказ""';uk='""Внутрішнє замовлення""'", ЛокализацияПовтИсп.ПолучитьЯзыкФормированияПечатныхФормОтчетов()) + " 	
	|		  ИНАЧЕ
	|			""""
	|	КОНЕЦ 									КАК ВидЗаказа,
	|   ВЫБОР КОГДА Заказ ССЫЛКА Документ.ЗаказНаПроизводство ИЛИ Заказ ССЫЛКА Документ.ВнутреннийЗаказ ТОГДА
	|		0
	|	ИНАЧЕ
	|		Заказ.КурсВзаиморасчетов  
	|	КОНЕЦ 									КАК КурсВзаиморасчетов,
	|   ВЫБОР КОГДА Заказ ССЫЛКА Документ.ЗаказНаПроизводство ИЛИ Заказ ССЫЛКА Документ.ВнутреннийЗаказ ТОГДА
	|		0
	|	ИНАЧЕ
	|		Заказ.СуммаДокумента                                           
	|	КОНЕЦ 									КАК СуммаЗаказа,
	|   ВЫБОР КОГДА Заказ ССЫЛКА Документ.ЗаказНаПроизводство ИЛИ Заказ ССЫЛКА Документ.ВнутреннийЗаказ ТОГДА
	|		&ПустаяВалюта
	|	ИНАЧЕ
	|		Заказ.ВалютаДокумента                                         
	|	КОНЕЦ 									 КАК ВалютаДокумента,
	|	ПричинаЗакрытияЗаказа                    КАК ПричинаЗакрытияЗаказа,
	|	Заказ                                    КАК Заказ,
	|   ВЫБОР КОГДА Заказ ССЫЛКА Документ.ЗаказНаПроизводство ИЛИ Заказ ССЫЛКА Документ.ВнутреннийЗаказ ТОГДА
	|		&ПустаяВалюта
	|	ИНАЧЕ
	|		Заказ.ДоговорКонтрагента.ВалютаВзаиморасчетов    
	|	КОНЕЦ 										КАК ВалютаВзаиморасчетов,
	|	Заказ.Подразделение 						КАК Подразделение,
	|   ВЫБОР КОГДА Заказ ССЫЛКА Документ.ЗаказНаПроизводство ИЛИ Заказ ССЫЛКА Документ.ВнутреннийЗаказ ТОГДА
	|		&ПустойКонтрагент
	|	ИНАЧЕ
	|		Заказ.Контрагент    
	|	КОНЕЦ 										КАК Контрагент,
	|   ВЫБОР КОГДА Заказ ССЫЛКА Документ.ЗаказНаПроизводство ИЛИ Заказ ССЫЛКА Документ.ВнутреннийЗаказ ТОГДА
	|		&ПустойДоговор
	|	ИНАЧЕ
	|		Заказ.ДоговорКонтрагента    
	|	КОНЕЦ 										КАК ДоговорКонтрагента,
	|	Регистратор,
	|	Регистратор.Ответственный 					КАК ОтветственныйЗаЗакрытиеЗаказа
	|ИЗ
	|	РегистрСведений.ПричиныЗакрытияЗаказов 
	|ГДЕ
	|	((&ДатаКонца = &ПустаяДата И &ДатаНачала = &ПустаяДата)
	|	ИЛИ
	|	((&ДатаКонца = &ПустаяДата И &ДатаНачала <> &ПустаяДата) И Регистратор.Дата >= &ДатаНачала)
	|	ИЛИ
	|	((&ДатаКонца <> &ПустаяДата И &ДатаНачала = &ПустаяДата) И Регистратор.Дата <= &ДатаКонца)
	|	ИЛИ
	|	((&ДатаКонца <> &ПустаяДата И &ДатаНачала <> &ПустаяДата) И (Регистратор.Дата <= &ДатаКонца И Регистратор.Дата >= &ДатаНачала)))
	|	И ( &ЗаказыПокупателей И Заказ ССЫЛКА Документ.ЗаказПокупателя
	|		ИЛИ &ЗаказыПоставщикам И Заказ ССЫЛКА Документ.ЗаказПоставщику
	|		ИЛИ &ЗаказыНаПроизводство И Заказ ССЫЛКА Документ.ЗаказНаПроизводство
	|   	ИЛИ &ВнутренниеЗаказы И Заказ ССЫЛКА Документ.ВнутреннийЗаказ
	|	)
	|) КАК ПричиныЗакрытияЗаказов
	|//СОЕДИНЕНИЯ
	|
	|{ГДЕ
	|	ПричиныЗакрытияЗаказов.СуммаВзаиморасчетов 				КАК СуммаВзаиморасчетов,
	|	ПричиныЗакрытияЗаказов.СуммаУпрУчета 					КАК СуммаУпрУчета,
	|   ПричиныЗакрытияЗаказов.СуммаЗаказа 						КАК СуммаЗаказа,
	|	ПричиныЗакрытияЗаказов.ПричинаЗакрытияЗаказа            КАК ПричинаЗакрытияЗаказа,
	|	ПричиныЗакрытияЗаказов.Заказ.*                          КАК Заказ,
	|	ПричиныЗакрытияЗаказов.Подразделение.*                  КАК Подразделение,
	|   ПричиныЗакрытияЗаказов.Контрагент.*                     КАК Контрагент,
	|	ПричиныЗакрытияЗаказов.ДоговорКонтрагента.*             КАК ДоговорКонтрагента,
	|	ПричиныЗакрытияЗаказов.ВалютаДокумента                  КАК ВалютаДокумента,
	|	ПричиныЗакрытияЗаказов.ВалютаВзаиморасчетов             КАК ВалютаВзаиморасчетов,
	|	ПричиныЗакрытияЗаказов.КурсВзаиморасчетов               КАК КурсВзаиморасчетов,
	|	ПричиныЗакрытияЗаказов.ОтветственныйЗаЗакрытиеЗаказа    КАК ОтветственныйЗаЗакрытиеЗаказа,
	|	ПричиныЗакрытияЗаказов.Заказ.Ответственный              КАК ОтветственныйЗаЗаказ
	|	//УСЛОВИЯ_СВОЙСТВА
	|	//УСЛОВИЯ_КАТЕГОРИИ
	|	}
	|{УПОРЯДОЧИТЬ ПО
	|	ПричиныЗакрытияЗаказов.СуммаВзаиморасчетов 				КАК СуммаВзаиморасчетов,
	|	ПричиныЗакрытияЗаказов.СуммаУпрУчета 					КАК СуммаУпрУчета,
	|   ПричиныЗакрытияЗаказов.СуммаЗаказа 						КАК СуммаЗаказа,
	|	ПричиныЗакрытияЗаказов.ПричинаЗакрытияЗаказа            КАК ПричинаЗакрытияЗаказа,
	|	ПричиныЗакрытияЗаказов.Заказ.*                          КАК Заказ,
	|	ПричиныЗакрытияЗаказов.Подразделение.*                  КАК Подразделение,
	|   ПричиныЗакрытияЗаказов.Контрагент.*                     КАК Контрагент,
	|	ПричиныЗакрытияЗаказов.ДоговорКонтрагента.*             КАК ДоговорКонтрагента,
	|	ПричиныЗакрытияЗаказов.ВидЗаказа                        КАК ВидЗаказа,
	|	ПричиныЗакрытияЗаказов.ВалютаДокумента                  КАК ВалютаДокумента,
	|	ПричиныЗакрытияЗаказов.ВалютаВзаиморасчетов             КАК ВалютаВзаиморасчетов,
	|	ПричиныЗакрытияЗаказов.КурсВзаиморасчетов               КАК КурсВзаиморасчетов,
	|	ПричиныЗакрытияЗаказов.ОтветственныйЗаЗакрытиеЗаказа    КАК ОтветственныйЗаЗакрытиеЗаказа,
	|	ПричиныЗакрытияЗаказов.Заказ.Ответственный              КАК ОтветственныйЗаЗаказ
	|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
	|	}
	|
	|ИТОГИ СУММА(СуммаВзаиморасчетов),
	|	   СУММА(СуммаУпрУчета),
	|	   СУММА(СуммаЗаказа) 
	|	//ИТОГИ_СВОЙСТВА
	|	//ИТОГИ_КАТЕГОРИИ
	|ПО
	|	ПричинаЗакрытияЗаказа,
	|	ВидЗаказа,
	|	Заказ,
	|	Контрагент,
	|	ОтветственныйЗаЗаказ

	|{ИТОГИ ПО
	|	ПричинаЗакрытияЗаказа.*,
	|	Заказ.*,
	|	Подразделение.*,
	|   Контрагент.*,    
	|	ДоговорКонтрагента.*, 
	|	ВидЗаказа,
	|	ОтветственныйЗаЗаказ.*,
	|	ОтветственныйЗаЗакрытиеЗаказа.*
	|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
	|	}
	|";


	
	// В универсальном отчете включен флаг использования свойств и категорий.
	Если УниверсальныйОтчет.ИспользоватьСвойстваИКатегории Тогда
		
		// Добавление свойств и категорий поля запроса в таблицу полей.
		// Необходимо вызывать для каждого поля запроса, предоставляющего возможность использования свойств и категорий.
		
		// УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля(<ПсевдонимТаблицы>.<Поле> , <ПсевдонимПоля>, <Представление>, <Назначение>);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля( "ПричиныЗакрытияЗаказов.Контрагент", 			"Контрагент", 			"Контрагент",          ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Контрагенты);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля( "ПричиныЗакрытияЗаказов.ДоговорКонтрагента",  "ДоговорКонтрагента",   "Договор контрагента", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_ДоговорыКонтрагентов);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля( "ПричиныЗакрытияЗаказов.Заказ",             	"Заказ",            	"Заказ",               ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Документы);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля( "ПричиныЗакрытияЗаказов.Заказ",             	"Заказ",            	"Заказ",               ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Документ_ЗаказПокупателя);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля( "ПричиныЗакрытияЗаказов.Подразделение",       "Подразделение",        "Подразделение",       ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Подразделения);

		// Добавление свойств и категорий в исходный текст запроса.
		УниверсальныйОтчет.ДобавитьВТекстЗапросаСвойстваИКатегории(ТекстЗапроса);
		
	КонецЕсли;
		
	// Инициализация текста запроса построителя отчета
	УниверсальныйОтчет.ПостроительОтчета.Текст = ТекстЗапроса;
	
	Пока УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Количество() > 0 Цикл
		
		УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Удалить(УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки[0]);
		
	КонецЦикла;
	
	// Представления полей отчета.
	// Необходимо вызывать для каждого поля запроса.
	// УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить(<ИмяПоля>, <ПредставлениеПоля>);
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДоговорКонтрагента", "Договор");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ВалютаВзаиморасчетов",           "Валюта взаиморасчетов");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ПричинаЗакрытияЗаказа",           "Причина закрытия заказа");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ВалютаДокумента", "Валюта документа");
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаЗаказа",      "Сумма заказа");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("КурсВзаиморасчетов",  "Курс взаиморасчетов");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ВидЗаказа",           "Вид заказа");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаУпрУчета",           "Сумма упр. учета");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаВзаиморасчетов", "Сумма взаиморасчетов");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ОтветственныйЗаЗаказ", "Ответственный за заказ");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ОтветственныйЗаЗакрытиеЗаказа", "Ответственный за закрытие заказа");

	
	// Добавление показателей
	// Необходимо вызывать для каждого добавляемого показателя.
	// УниверсальныйОтчет.ДобавитьПоказатель(<ИмяПоказателя>, <ПредставлениеПоказателя>, <ВключенПоУмолчанию>, <Формат>, <ИмяГруппы>, <ПредставлениеГруппы>);
	
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаУпрУчета",        "Сумма упр. учета",     Истина, "ЧЦ=15; ЧДЦ=2", "СуммаЗакрытияЗаказа", "Сумма закрытия заказа");
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаВзаиморасчетов",  "Сумма взаиморасчетов", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаЗакрытияЗаказа", "Сумма закрытия заказа");
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаЗаказа",          "Сумма заказа",         Истина, "ЧЦ=15; ЧДЦ=2");
	
	// Добавление предопределенных группировок строк отчета.
	// Необходимо вызывать для каждой добавляемой группировки строки.
	// УниверсальныйОтчет.ДобавитьИзмерениеСтроки(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ПричинаЗакрытияЗаказа");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Заказ");
	
	// Добавление предопределенных группировок колонок отчета.
	// Необходимо вызывать для каждой добавляемой группировки колонки.
	УниверсальныйОтчет.ДобавитьИзмерениеКолонки("ВидЗаказа");
	
	// Добавление предопределенных отборов отчета.
	// Необходимо вызывать для каждого добавляемого отбора.
	// УниверсальныйОтчет.ДобавитьОтбор(<ПутьКДанным>);
	
	УниверсальныйОтчет.ДобавитьОтбор("Контрагент");
	УниверсальныйОтчет.ДобавитьОтбор("Подразделение");
	УниверсальныйОтчет.ДобавитьОтбор("Заказ");
	
	// Добавление предопределенных полей порядка отчета.
	// Необходимо вызывать для каждого добавляемого поля порядка.
	// УниверсальныйОтчет.ДобавитьПорядок(<ПутьКДанным>);
	
	// Установка связи подчиненных и родительских полей
	 УниверсальныйОтчет.УстановитьСвязьПолей("ОтветственныйЗаЗаказ", "Заказ");
	
	// Установка связи полей и измерений
	// УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения(<ИмяПоля>, <ИмяИзмерения>);
	
	// Установка представлений полей
	УниверсальныйОтчет.УстановитьПредставленияПолей(УниверсальныйОтчет.мСтруктураПредставлениеПолей, УниверсальныйОтчет.ПостроительОтчета);
	
	// Установка типов значений свойств в отборах отчета
	УниверсальныйОтчет.УстановитьТипыЗначенийСвойствДляОтбора();
	
	// Заполнение начальных настроек универсального отчета
	УниверсальныйОтчет.УстановитьНачальныеНастройки(Ложь);
	
	// Добавление дополнительных полей
	// Необходимо вызывать для каждого добавляемого дополнительного поля.
	// УниверсальныйОтчет.ДобавитьДополнительноеПоле(<ПутьКДанным>, <Размещение>, <Положение>);
	УниверсальныйОтчет.ВыводитьОбщиеИтоги = ложь;

КонецПроцедуры // УстановитьНачальныеНастройки()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ОТЧЕТА 
	
// Процедура формирования отчета
//
Процедура СформироватьОтчет(ТабличныйДокумент) Экспорт
	Если НЕ (ЗаказыПокупателей ИЛИ ЗаказыПоставщикам ИЛИ ЗаказыНаПроизводство ИЛИ ВнутренниеЗаказы) Тогда
		Сообщить("Должен быть выбран хотя бы один вид заказа. Отчет не сформирован.");
		Возврат;
	КонецЕсли;

	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ЗаказыПокупателей", ЗаказыПокупателей);
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ЗаказыПоставщикам", ЗаказыПоставщикам);
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ЗаказыНаПроизводство", ЗаказыНаПроизводство);
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ВнутренниеЗаказы", ВнутренниеЗаказы);

    УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ПустаяДата", '00010101000000');
    УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ПустаяВалюта", Справочники.Валюты.ПустаяСсылка());
    УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ПустойКонтрагент", Справочники.Контрагенты.ПустаяСсылка());
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ПустойДоговор", Справочники.ДоговорыКонтрагентов.ПустаяСсылка());
	УниверсальныйОтчет.СформироватьОтчет(ТабличныйДокумент,,, ЭтотОбъект);
	
КонецПроцедуры // СформироватьОтчет()

Функция ПолучитьТекстСправкиФормы() Экспорт
	
	Возврат "";
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура обработки расшифровки
//
Процедура ОбработкаРасшифровки(Расшифровка, Объект) Экспорт
	
	// Дополнительные параметры в расшифровывающий отчет можно передать
	// посредством инициализации переменной "ДополнительныеПараметры".
	
	ДополнительныеПараметры = УправлениеОтчетами.СохранитьРеквизитыОтчета(ЭтотОбъект);
	УниверсальныйОтчет.ОбработкаРасшифровкиУниверсальногоОтчета(Расшифровка, Объект, ДополнительныеПараметры);
	
КонецПроцедуры // ОбработкаРасшифровки()

// Формирует структуру для сохранения настроек отчета
//
Процедура СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками) Экспорт
	
	УниверсальныйОтчет.СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками);
	УправлениеОтчетами.СохранитьРеквизитыОтчета(ЭтотОбъект, СтруктураСНастройками);
	
КонецПроцедуры // СформироватьСтруктуруДляСохраненияНастроек()

// Заполняет настройки отчета из структуры сохраненных настроек
//
Функция ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками) Экспорт
	
	УправлениеОтчетами.ВосстановитьРеквизитыОтчета(ЭтотОбъект, СтруктураСНастройками);
	Возврат УниверсальныйОтчет.ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками, ЭтотОбъект);
	
КонецФункции // ВосстановитьНастройкиИзСтруктуры()

// Содержит значение используемого режима ввода периода.
// Тип: Число.
// Возможные значения: // (-1) - не выбирать период, 0 - произвольный период, 1 - на дату, 2 - неделя, 3 - декада, 4 - месяц, 5 - квартал, 6 - полугодие, 7 - год
// Значение по умолчанию: 0
// Пример:
УниверсальныйОтчет.мРежимВводаПериода = 0;

#КонецЕсли
