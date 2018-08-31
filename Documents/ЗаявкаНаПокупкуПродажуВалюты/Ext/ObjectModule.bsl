﻿Перем мВалютаРегламентированногоУчета Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда

Функция КурсККратности(Курс, Валюта) 

	Если ЗначениеЗаполнено(Валюта) Тогда
		Кратность = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(Дата, Новый Структура("Валюта", Валюта)).Кратность;
		Если Кратность <> 0 И Кратность <> 1 Тогда
			Возврат Курс / Кратность;
		Иначе
			Возврат Курс;
		КонецЕсли; 
	Иначе
		Возврат Курс;
	КонецЕсли;	

КонецФункции 
	
	
Функция ПечатьПокупка()
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаявкаНаПокупкуПродажуВалюты_Покупка";
	
	Макет = ПолучитьМакет("ЗаявкаНаПокупку");
	Обл   = Макет.ПолучитьОбласть("Шапка");
	
    Обл.Параметры.Номер = Номер;
	Обл.Параметры.Дата  = Дата;
	
	СведенияОбОрганизации = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Организация, Дата);
	Обл.Параметры.Организация = СведенияОбОрганизации.ПолноеНаименование;
	Обл.Параметры.Адрес = СведенияОбОрганизации.ЮридическийАдрес;
	Обл.Параметры.Телефоны = СведенияОбОрганизации.Телефоны;
	Обл.Параметры.Банк = Банк.НаименованиеПолное + ", " + УправлениеКонтактнойИнформацией.ПолучитьАдресИзКонтактнойИнформации(Банк,"Юридический");
	
	Обл.Параметры.Сотрудник = Сотрудник.Наименование;
	
	Обл.Параметры.Основание = Основание;
	
	Обл.Параметры.Комиссионные = Комиссионные;
	
	Обл.Параметры.Валюта = Валюта.НаименованиеПолное + ", " + Строка(Валюта.Код);
	Обл.Параметры.СуммаВалютная = СуммаВалютная;
	Обл.Параметры.Курс = ?(Курс = 0, "за  курсом уповноваженого банку", КурсККратности(Курс, Валюта));
	Обл.Параметры.СуммаГривневая = ?(СуммаГривневая = 0, " ", СуммаГривневая);
	
	Обл.Параметры.СчетБанкаНомер = СчетБанка.НомерСчета;
	Обл.Параметры.СчетБанкаБанк  = СчетБанка.Банк;
	Обл.Параметры.СчетБанкаКод   = СчетБанка.Банк.Код;
	
	Обл.Параметры.СчетВалютныйНомер = СчетВалютный.НомерСчета;
	Обл.Параметры.СчетВалютныйБанк  = СчетВалютный.Банк;
	Обл.Параметры.СчетВалютныйКод   = СчетВалютный.Банк.Код;
	
	Обл.Параметры.СчетВозвратаНомер = СчетВозврата.НомерСчета;
	Обл.Параметры.СчетВозвратаБанк  = СчетВозврата.Банк;
	Обл.Параметры.СчетВозвратаКод   = СчетВозврата.Банк.Код;
	
	Руководители = ФормированиеПечатныхФорм.ОтветственныеЛица(Организация, Дата);
	Обл.Параметры.ФИОГлавногоБухгалтера = Руководители.ГлавныйБухгалтер;
	Обл.Параметры.ФИОРуководителя = Руководители.Руководитель;

	ТабДокумент.Вывести(Обл);

	Возврат ТабДокумент;

КонецФункции

Функция ПечатьПродажа()
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаявкаНаПокупкуПродажуВалюты_Продажа";
	
	Макет = ПолучитьМакет("ЗаявкаНаПродажу");
	Обл   = Макет.ПолучитьОбласть("Шапка");
	
    Обл.Параметры.Номер = Номер;
	Обл.Параметры.Дата  = Дата;
	
	СведенияОбОрганизации = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Организация, Дата);
	Обл.Параметры.Организация = СведенияОбОрганизации.ПолноеНаименование;
	Обл.Параметры.Адрес = СведенияОбОрганизации.ЮридическийАдрес;
	Обл.Параметры.Телефоны = СведенияОбОрганизации.Телефоны;
	Обл.Параметры.Банк = Банк.НаименованиеПолное + ", " + УправлениеКонтактнойИнформацией.ПолучитьАдресИзКонтактнойИнформации(Банк,"Юридический");
	
	Обл.Параметры.Сотрудник = Сотрудник.Наименование;
	
	Обл.Параметры.Комиссионные = Комиссионные;
	
	Обл.Параметры.Валюта = Валюта.НаименованиеПолное + ", " + Строка(Валюта.Код);
	Обл.Параметры.СуммаВалютная = СуммаВалютная;
	Обл.Параметры.Курс = ?(Курс = 0, "за  курсом уповноваженого банку", КурсККратности(Курс, Валюта));
	Обл.Параметры.СуммаГривневая = ?(СуммаГривневая = 0, " ", СуммаГривневая);
	
	Обл.Параметры.СчетБанкаНомер = СчетБанка.НомерСчета;
	Обл.Параметры.СчетБанкаБанк  = СчетБанка.Банк;
	Обл.Параметры.СчетБанкаКод   = СчетБанка.Банк.Код;
	
	Обл.Параметры.СчетВалютныйНомер = СчетВалютный.НомерСчета;
	Обл.Параметры.СчетВалютныйБанк  = СчетВалютный.Банк;
	Обл.Параметры.СчетВалютныйКод   = СчетВалютный.Банк.Код;
	
	Обл.Параметры.СчетГривневыйНомер = СчетГривневый.НомерСчета;
	Обл.Параметры.СчетГривневыйБанк  = СчетГривневый.Банк;
	Обл.Параметры.СчетГривневыйКод   = СчетГривневый.Банк.Код;
	
	Обл.Параметры.СчетВозвратаНомер = СчетВозврата.НомерСчета;
	Обл.Параметры.СчетВозвратаБанк  = СчетВозврата.Банк;
	Обл.Параметры.СчетВозвратаКод   = СчетВозврата.Банк.Код;
	
	Руководители = ФормированиеПечатныхФорм.ОтветственныеЛица(Организация, Дата);
	Обл.Параметры.ФИОГлавногоБухгалтера = Руководители.ГлавныйБухгалтер;
	Обл.Параметры.ФИОРуководителя = Руководители.Руководитель;

	ТабДокумент.Вывести(Обл);

	Возврат ТабДокумент;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

Процедура Печать(НазваниеМакета = "", КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт
	
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

	Если НазваниеМакета = "Покупка" Тогда
		ТабДокумент = ПечатьПокупка();
	ИначеЕсли НазваниеМакета = "Продажа" Тогда
		ТабДокумент = ПечатьПродажа();
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПокупкаПродажаВалюты.ПокупкаВалюты Тогда
		ТабДокумент = ПечатьПокупка();
	Иначе	
		ТабДокумент = ПечатьПродажа();
	КонецЕсли;

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект, Строка(ВидОперации)));
	
КонецПроцедуры //Печать()	

#КонецЕсли

Функция СтруктураОбязательныхПолейШапки()

	СтруктураПолей=Новый Структура;
	СтруктураПолей.Вставить("Организация","Не указана организация!");
	СтруктураПолей.Вставить("СчетГривневый","Не указан гривневый счет организации!");
	СтруктураПолей.Вставить("СчетВалютный","Не указан валютный счет организации!");
	СтруктураПолей.Вставить("СчетВозврата","Не указан счет организации для возврата денежных средств!");
	
	СтруктураПолей.Вставить("Банк","Не указан уполномоченный банк!");
	СтруктураПолей.Вставить("СчетБанка","Не указан счет уполномоченного банка!");
	
	СтруктураПолей.Вставить("Валюта","Не указана валюта документа!");
	СтруктураПолей.Вставить("СуммаВалютная","Не указана валютная сумма!");
	
	Возврат СтруктураПолей;

КонецФункции // СтруктураОбязательныхПолейШапки()

Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Если ВидОперации = Перечисления.ВидыОперацийПокупкаПродажаВалюты.ПокупкаВалюты Тогда
		Возврат Новый Структура("ЗаявкаНаПокупку","Заявка на покупку валюты");
	Иначе	
		Возврат Новый Структура("ЗаявкаНаПродажу","Заявка на продажу валюты");
	КонецЕсли;
КонецФункции // ПолучитьСписокПечатныхФорм()


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолейШапки(), Отказ, Заголовок);
    	
	// Движения по документу
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");