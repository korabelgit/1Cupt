﻿Перем мУдалятьДвижения;

#Если Клиент Тогда

Процедура ПечатьОтчетаПланыДвиженияДенежныхСредств()
	
	Если НЕ Проведен Тогда
	
		ТекстВопроса = "Отчет по непроведенному документу будет всегда выводиться пустым. 
		|Провести документ?";
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		Если Ответ = КодВозвратаДиалога.Да Тогда
		
			Записать(РежимЗаписиДокумента.Проведение);
		
		ИначеЕсли Ответ <> КодВозвратаДиалога.Нет Тогда
		
			Возврат;
		
		КонецЕсли;
		
	КонецЕсли;
	
	Отчет = Отчеты.ПланыДвиженияДенежныхСредств.Создать();
	
	Отчет.УстановитьНачальныеНастройки();
		
	Пока Отчет.УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Количество() > 0 Цикл
			
		Отчет.УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Удалить(Отчет.УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки[0]);
			
	КонецЦикла;
		
	Пока Отчет.УниверсальныйОтчет.ПостроительОтчета.ИзмеренияКолонки.Количество() > 0 Цикл
			
		Отчет.УниверсальныйОтчет.ПостроительОтчета.ИзмеренияКолонки.Удалить(Отчет.УниверсальныйОтчет.ПостроительОтчета.ИзмеренияКолонки[0]);
			
	КонецЦикла;
		
	Пока Отчет.УниверсальныйОтчет.ПостроительОтчета.ВыбранныеПоля.Количество() > 0 Цикл
			
		Отчет.УниверсальныйОтчет.ПостроительОтчета.ВыбранныеПоля.Удалить(Отчет.УниверсальныйОтчет.ПостроительОтчета.ВыбранныеПоля[0]);
			
	КонецЦикла;
		
	Отчет.УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ВалютаДенежныхСредств");
	Отчет.УниверсальныйОтчет.ДобавитьИзмерениеСтроки("СтатьяДвиженияДенежныхСредств");
		
	ЭлементОтбора = Отчет.УниверсальныйОтчет.ПостроительОтчета.Отбор.Добавить("ДокументПланирования");
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ВидСравнения = ВидСравнения.Равно;
	ЭлементОтбора.Значение = Ссылка;
	
	ЭлементОтбора = Отчет.УниверсальныйОтчет.ПостроительОтчета.Отбор.Добавить("Сценарий");
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ВидСравнения = ВидСравнения.Равно;
	ЭлементОтбора.Значение = Сценарий;
	
	Отчет.УниверсальныйОтчет.ДатаНач = ДатаПланирования;
	Отчет.УниверсальныйОтчет.ДатаКон = ОбщегоНазначения.ДобавитьИнтервал(ДатаПланирования, Сценарий.Периодичность, 1) - 1;
	
	Отчет.УниверсальныйОтчет.ДобавитьПоказатель("СуммаРасходВал", "Платежи", Истина, "ЧЦ = 15 ; ЧДЦ = 2", "ВВалютепланирования");
	Отчет.УниверсальныйОтчет.ДобавитьПоказатель("СуммаРасходУпр", "Платежи", Истина, "ЧЦ = 15 ; ЧДЦ = 2", "ВВалютеУпрУчета");
	
	Отчет.УниверсальныйОтчет.мВосстанавливатьНастройкиПриОткрытии = Ложь;
		
	ФормаОтчета = Отчет.ПолучитьФорму();
	ФормаОтчета.Открыть();
	ФормаОтчета.ОбновитьОтчет();

КонецПроцедуры // ПечатьОтчетаПланыДвиженияДенежныхСредств()

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

	// Получить экземпляр документа на печать
	Если ИмяМакета = "ПланыДвиженияДенежныхСредств" тогда

		ПечатьОтчетаПланыДвиженияДенежныхСредств();

	КонецЕсли;

КонецПроцедуры // Печать

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура("ПланыДвиженияДенежныхСредств", "План движения денежных средств");

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

#КонецЕсли

// Выполняет движения по регистру "ПланыДвиженияДенежныхСредств"
//
Процедура ДвиженияПоРегистрамУпр()
	
	ВалютаУпрУчета = глЗначениеПеременной("ВалютаУправленческогоУчета");
	
	// Получим коэффициент пересчета сумм документа в валюту упр. учета.
	Если ВалютаДокумента=ВалютаУпрУчета Тогда
		КоэффициентПересчетаУпр=1;
	Иначе
		
		Если Сценарий.ИспользоватьКурсыСценария Тогда
			РегистрКурсов=РегистрыСведений.КурсыВалютПоСценариям;
			
			ОтборПоВалютеУпр=Новый Структура;
			ОтборПоВалютеУпр.Вставить("Валюта",ВалютаУпрУчета);
			ОтборПоВалютеУпр.Вставить("Сценарий",Сценарий);
			
			ОтборПоВалютеДок=Новый Структура;
			ОтборПоВалютеДок.Вставить("Валюта",ВалютаДокумента);
			ОтборПоВалютеДок.Вставить("Сценарий",Сценарий);
			
		Иначе
			
			РегистрКурсов=РегистрыСведений.КурсыВалют;
			
			ОтборПоВалютеУпр=Новый Структура;
			ОтборПоВалютеУпр.Вставить("Валюта",ВалютаУпрУчета);
			
			ОтборПоВалютеДок=Новый Структура;
			ОтборПоВалютеДок.Вставить("Валюта",ВалютаДокумента);
			
		КонецЕсли;
		
		СтруктураКурсовУпр=РегистрКурсов.ПолучитьПоследнее(ДатаПланирования,ОтборПоВалютеУпр);
		КурсУпрУчета=СтруктураКурсовУпр.Курс;
		КратностьУпрУчета= СтруктураКурсовУпр.Кратность;
		
		СтруктураКурсовДок=РегистрКурсов.ПолучитьПоследнее(ДатаПланирования,ОтборПоВалютеДок);
		КурсДок=СтруктураКурсовДок.Курс;
		КратностьДок= СтруктураКурсовДок.Кратность;
		
		Если КурсДок     		= 0 
			или КратностьДок     	= 0 
			или КурсУпрУчета 		= 0 
			или КратностьУпрУчета 	= 0 Тогда
			ОбщегоНазначения.СообщитьОбОшибке("При пересчете в валюту упр. учета обнаружен нулевой курс.");
			Возврат;
		Иначе	
			КоэффициентПересчетаУпр=(КурсДок * КратностьУпрУчета) / (КурсУпрУчета * КратностьДок)
		КонецЕсли;
		
	КонецЕсли;
	
	// По регистру "ПланыДвиженийДенежныхСредств"
	НаборДвижений = Движения.ПланыДвиженияДенежныхСредств;
	
	// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
	ТаблицаДвижений = НаборДвижений.Выгрузить();
	ТаблицаДвижений.Очистить();
	
	Для Каждого Строка ИЗ ДвиженияДенежныхСредств Цикл
		
		СтрокаДвижение=ТаблицаДвижений.Добавить();
		СтрокаДвижение.Сценарий=Сценарий;
		СтрокаДвижение.ВидДенежныхСредств=ВидДенежныхСредств;
		СтрокаДвижение.ПриходРасход=Строка.ПриходРасход;
		СтрокаДвижение.ВалютаДенежныхСредств=ВалютаДокумента;
		СтрокаДвижение.СтатьяДвиженияДенежныхСредств=Строка.СтатьяДвиженияДенежныхСредств;
		СтрокаДвижение.Проект=Строка.Проект;
		СтрокаДвижение.Контрагент=Строка.Контрагент;
		СтрокаДвижение.ДоговорКонтрагента=Строка.ДоговорКонтрагента;
		СтрокаДвижение.Сделка=Строка.Сделка;
		СтрокаДвижение.ДокументПланирования=Ссылка;
		
		СтрокаДвижение.Сумма=Строка.Сумма;
		СтрокаДвижение.СуммаУпр=Строка.Сумма*КоэффициентПересчетаУпр;
		
	КонецЦикла;
	
	НаборДвижений.мПериод            = ДатаПланирования;
	НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;
	
	Движения.ПланыДвиженияДенежныхСредств.ВыполнитьДвижения();
	
КонецПроцедуры // ДвиженияПоРегистрамУпр()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	 
	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	Отказ=Ложь;
	
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, Новый Структура("ВалютаДокумента,ДатаПланирования,ВидДенежныхСредств"), Отказ, Заголовок);
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "ДвиженияДенежныхСредств", Новый Структура("ПриходРасход,СтатьяДвиженияДенежныхСредств",
													"Вид движения","Статья движения денежных средств"),Отказ, Заголовок);
													
													
													
	Если Не Отказ Тогда
		
		ДвиженияПоРегистрамУпр();
		
	КонецЕсли;
														
	
КонецПроцедуры

