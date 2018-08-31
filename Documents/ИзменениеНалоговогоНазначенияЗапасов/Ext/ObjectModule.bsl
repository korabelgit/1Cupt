﻿Перем мУдалятьДвижения;

Перем мВалютаРегламентированногоУчета Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда


// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходимое количество копий.
//
// Название макета печати передается в качестве параметра,
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

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект, ЭтотОбъект.Метаданные().Представление()), Ссылка);

КонецПроцедуры // Печать

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт

	СтруктураМакетов = Новый Структура;
	Возврат СтруктураМакетов;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

#КонецЕсли


#Если Клиент Тогда
Процедура ЗаполнитьНалоговыеНазначенияЗапасов() Экспорт 
	
	НалоговыйУчет.ЗаполнитьНалоговыеНазначенияЗапасов(ЭтотОбъект, "Товары", Истина);

КонецПроцедуры // ЗаполнитьНалоговыеНазначенияЗапасов
#КонецЕсли


//Выполняет заполнение счетов учета в переданной строке табличной части
//
Процедура ЗаполнитьСчетаУчетаВСтрокеТабЧастиРегл(СтрокаТЧ, ИмяТабЧасти, ЗаполнятьБУ) Экспорт
	
	ЗаполнитьСчетаУчетаВТабЧасти(СтрокаТЧ, ИмяТабЧасти, ЗаполнятьБУ);
	
КонецПроцедуры

// Процедура заполняет счета учета в строке табличной части или всей табличной части
//
Процедура ЗаполнитьСчетаУчетаВТабЧасти(ДанныеТабличнойЧасти, ИмяТабЧасти, ЗаполнятьБУ) Экспорт
	
	СчетаУчетаВДокументах.ЗаполнитьСчетаУчетаТабличнойЧасти(ИмяТабЧасти, ДанныеТабличнойЧасти, ЭтотОбъект, ЗаполнятьБУ);

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

Процедура ПодготовитьПараметрыУчетнойПолитики(СтруктураШапкиДокумента, Отказ, Заголовок)

	ПодготовитьПараметрыУчетнойПолитикиРегл(СтруктураШапкиДокумента, Отказ, Заголовок);
	
КонецПроцедуры // ПодготовитьПараметрыУчетнойПолитики()

// Процедура определяет параметры регл. учетной политики
//
Процедура ПодготовитьПараметрыУчетнойПолитикиРегл(СтруктураШапкиДокумента, Отказ, Заголовок)

	
	Если СтруктураШапкиДокумента.ОтражатьВБухгалтерскомУчете Тогда
		
		мУчетнаяПолитикаРегл = ОбщегоНазначения.ПолучитьПараметрыУчетнойПолитикиРегл(КонецМесяца(Дата), Организация);
		
		Если НЕ ЗначениеЗаполнено(мУчетнаяПолитикаРегл) Тогда
			Отказ = Истина;
		КонецЕсли;
		
		Если НЕ Отказ Тогда
			СтруктураШапкиДокумента.Вставить("ЕстьНалогНаПрибыль", мУчетнаяПолитикаРегл.ЕстьНалогНаПрибыль);
			СтруктураШапкиДокумента.Вставить("ЕстьНалогНаПрибыльДо2015", мУчетнаяПолитикаРегл.ЕстьНалогНаПрибыльДо2015);
			СтруктураШапкиДокумента.Вставить("ЕстьНДС"           , мУчетнаяПолитикаРегл.ЕстьНДС);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ПодготовитьПараметрыУчетнойПолитикиРегл()

// Выгружает результат запроса в табличную часть, добавляет ей необходимые колонки для проведения.
//
// Параметры: 
//  РезультатЗапросаПоТоварам - результат запроса по табличной части "Товары",
//  СтруктураШапкиДокумента   - выборка по результату запроса по шапке документа.
//
// Возвращаемое значение:
//  Сформированная таблица значений.
//
Функция ПодготовитьТаблицуТоваров(РезультатЗапросаПоТоварам, СтруктураШапкиДокумента)

	ТаблицаТоваров = РезультатЗапросаПоТоварам.Выгрузить();
	
	Возврат ТаблицаТоваров;

КонецФункции // ПодготовитьТаблицуТоваров()

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверяется также правильность заполнения реквизитов ссылочных полей документа.
// Проверка выполняется по объекту и по выборке из результата запроса по шапке.
//
// Параметры: 
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении,
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	ОбязательныеРеквизитыШапки = "Организация";
	
	СтруктураОбязательныхПолей = Новый Структура(ОбязательныеРеквизитыШапки);
	
	// Теперь вызовем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);
	
КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения строк табличной части "Товары".
//
// Параметры:
// Параметры: 
//  ТаблицаПоТоварам        - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеТабличнойЧастиТовары(ТаблицаПоТоварам, СтруктураШапкиДокумента, Отказ, Заголовок)

	ИмяТабличнойЧасти = "Товары";

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("Номенклатура, Количество");
	СтруктураОбязательныхПолей.Вставить("Склад");
	СтруктураОбязательныхПолей.Вставить("Качество");
	СтруктураОбязательныхПолей.Вставить("СчетУчетаБУ");
	
	СтруктураОбязательныхПолей.Вставить("НалоговоеНазначение");
	СтруктураОбязательныхПолей.Вставить("НалоговоеНазначениеНовое");

	// Теперь вызовем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Товары", СтруктураОбязательныхПолей, Отказ, Заголовок);

	// Здесь бланков быть не должно.
	УправлениеЗапасами.ПроверитьЧтоНетБланковСтрогогоУчета(ЭтотОбъект, "Товары", ТаблицаПоТоварам, Отказ, Заголовок);
	
	// Здесь услуг быть не должно.
	УправлениеЗапасами.ПроверитьЧтоНетУслуг(ЭтотОбъект, "Товары", ТаблицаПоТоварам, Отказ, Заголовок);

	// Здесь наборов быть не должно.
	УправлениеЗапасами.ПроверитьЧтоНетНаборов(ЭтотОбъект, "Товары", ТаблицаПоТоварам, Отказ, Заголовок);

	// Здесь комплектов быть не должно.
	УправлениеЗапасами.ПроверитьЧтоНетКомплектов(ЭтотОбъект, "Товары", ТаблицаПоТоварам, Отказ, Заголовок);
	
	
	НалоговыйУчет.ПроверитьЗаполнениеНалоговыхНазначений(
					СтруктураШапкиДокумента, 
					ТаблицаПоТоварам, 
					ИмяТабличнойЧасти,
					Отказ, 
					Заголовок, 
					"ИзменениеНалоговогоНазначения",   // ВидОперации
					Ложь             // ЭтоЗатраты 
	);	
	
	
КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиТовары()

// По результату запроса по шапке документа формируем движения по регистрам.
//
// Параметры: 
//  РежимПроведения           - режим проведения документа (оперативный или неоперативный),
//  СтруктураШапкиДокумента   - выборка из результата запроса по шапке документа,
//  ТаблицаПоТоварам          - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  ТаблицаПоТаре             - таблица значений, содержащая данные для проведения и проверки ТЧ "Возвратная тара",
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//
Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок);

	ДвиженияПоРегиструСписанныеТовары(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок);
	ДвиженияПоРегиструТоварыОрганизацийРегл(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок);
	
	ТаблицаДвиженийПоСписаннымТоварам = Движения.СписанныеТовары.Выгрузить();
	Если ТаблицаДвиженийПоСписаннымТоварам.Количество()>0 Тогда
		
		УправлениеЗапасами.ЗарегистрироватьДокументВПоследовательностяхПартионногоУчета(ЭтотОбъект, Дата, СтруктураШапкиДокумента.Организация,Ложь,Ложь,СтруктураШапкиДокумента.СпособВеденияПартионногоУчетаПоОрганизации);
		
		УправлениеЗапасамиПартионныйУчет.ДвижениеПартийТоваров(Ссылка, ТаблицаДвиженийПоСписаннымТоварам);

	КонецЕсли;
	
	
КонецПроцедуры // ДвиженияПоРегистрам()

Процедура ДвиженияПоРегиструСписанныеТовары(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок)

	Если СтруктураШапкиДокумента.ИспользоватьРАУЗ Тогда 
		Возврат; 
	КонецЕсли;	
	
	// ТОВАРЫ ПО РЕГИСТРУ СписанныеТовары.
	НаборДвижений = Движения.СписанныеТовары;
	
	// Получим таблицу значений, совпадающую со структурой набора записей регистра.
	ТаблицаДвижений = НаборДвижений.ВыгрузитьКолонки();
	
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаПоТоварам, ТаблицаДвижений);
	
	ТаблицаДвижений.ЗаполнитьЗначения(СтруктураШапкиДокумента.ОтражатьВБухгалтерскомУчете, "ОтражатьВБухгалтерскомУчете");
	
	// Недостающие поля.
	Инд = 0;
	Для каждого Строка Из ТаблицаДвижений Цикл
		Инд = Инд+1;
		Строка.НомерСтрокиДокумента = Инд;
	КонецЦикла;	
		
	
	ТаблицаДвижений.ЗаполнитьЗначения(Дата,"Период");
	ТаблицаДвижений.ЗаполнитьЗначения(Ссылка,"Регистратор");
	ТаблицаДвижений.ЗаполнитьЗначения(Истина,"Активность");
	
	ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.СтатусыПартийТоваров.Купленный,"ДопустимыйСтатус1");
	ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.СтатусыПартийТоваров.Продукция,"ДопустимыйСтатус2");
	ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.СтатусыПартийТоваров.НаКомиссию,"ДопустимыйСтатус3");
	ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.СтатусыПартийТоваров.ВПереработку,"ДопустимыйСтатус4");
	
	ТаблицаДвижений.ЗаполнитьЗначения(Подразделение,"Подразделение");
	
	ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.КодыОперацийПартииТоваров.ИзменениеНалоговогоНазначенияЗапасов, "КодОперацииПартииТоваров");
	
	ТаблицаДвижений.ЗаполнитьЗначения(Организация,    "Организация");
	
	НаборДвижений.мПериод            = Дата;
	НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;
	
	Если Не Отказ Тогда
		Движения.СписанныеТовары.ВыполнитьДвижения();
	КонецЕсли;
	
	Движения.СписанныеТовары.Записать(Истина);

КонецПроцедуры// ДвиженияПоРегиструСписанныеТовары

Процедура ДвиженияПоРегиструТоварыОрганизацийРегл(РежимПроведения, СтруктураШапкиДокумента, 
	                          ТаблицаПоТоварам, Отказ, Заголовок)

							  
	Если НЕ СтруктураШапкиДокумента.ОтражатьВРегламентированномУчете Тогда
	  	Возврат;
	КонецЕсли;
	
	Если НЕ СтруктураШапкиДокумента.ОтражатьВБухгалтерскомУчете Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ОбщегоНазначения.ИспользоватьРегистрТоварыОрганизацийРегл(СтруктураШапкиДокумента.Дата) Тогда
		Возврат;
	КонецЕсли; 
	
	ВестиПартионныйУчетПоСкладамРегл = глЗначениеПеременной("ПараметрыПартионногоУчета").ВестиПартионныйУчетПоСкладамРегл;
							  
	// ТОВАРЫ ПО РЕГИСТРУ ТоварыОрганизацийРегл.
	НаборДвижений = Движения.ТоварыОрганизацийРегл;

	ТаблицаДвиженийРасход = НаборДвижений.ВыгрузитьКолонки();
	ТаблицаДвиженийПриход = НаборДвижений.ВыгрузитьКолонки();
	
	ТабИмен = Неопределено;
	ОбщегоНазначения.ПереименоватьКолонкуТаблицыЗначений(ТаблицаПоТоварам, ТабИмен, "НалоговоеНазначениеПоФакту", "НалоговоеНазначение");
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаПоТоварам, ТаблицаДвиженийРасход);
	ОбщегоНазначения.ВосстановитьИменаКолонокТаблицыЗначений(ТаблицаПоТоварам, ТабИмен);
	
	ТаблицаДвиженийРасход.ЗаполнитьЗначения(Организация, "Организация");
	ТаблицаДвиженийРасход.ЗаполнитьЗначения(Неопределено,"Комиссионер");
	Если НЕ ВестиПартионныйУчетПоСкладамРегл Тогда
		ТаблицаДвиженийРасход.ЗаполнитьЗначения(Неопределено, "Склад");
	КонецЕсли; 
	
	ОбщегоНазначения.ПереименоватьКолонкуТаблицыЗначений(ТаблицаПоТоварам, ТабИмен, "НалоговоеНазначениеНовое", "НалоговоеНазначение");
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаПоТоварам, ТаблицаДвиженийПриход);
	ОбщегоНазначения.ВосстановитьИменаКолонокТаблицыЗначений(ТаблицаПоТоварам, ТабИмен);
	
	ТаблицаДвиженийПриход.ЗаполнитьЗначения(Организация, "Организация");
	ТаблицаДвиженийПриход.ЗаполнитьЗначения(Неопределено,"Комиссионер");
	Если НЕ ВестиПартионныйУчетПоСкладамРегл Тогда
		ТаблицаДвиженийПриход.ЗаполнитьЗначения(Неопределено, "Склад");
	КонецЕсли; 
	
	НаборДвижений.мПериод          = Дата;
	НаборДвижений.мТаблицаДвижений = ТаблицаДвиженийРасход;

	Если Не Отказ Тогда
		Движения.ТоварыОрганизацийРегл.ВыполнитьРасход();
	КонецЕсли;
	
	НаборДвижений.мПериод          = Дата;
	НаборДвижений.мТаблицаДвижений = ТаблицаДвиженийПриход;

	Если Не Отказ Тогда
		Движения.ТоварыОрганизацийРегл.ВыполнитьПриход();
	КонецЕсли;
	
КонецПроцедуры // ДвиженияПоРегиструТоварыОрганизацийРегл()

Процедура ЗаполнитьТоварыПоДокументуОснованию(Основание) Экспорт 
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда

		// Заполнение таб.части
		ТабЧасть = Основание.Товары;
		Для Каждого ТекСтрокаТовары Из ТабЧасть Цикл

			НоваяСтрока = Товары.Добавить();
					
			НоваяСтрока.Номенклатура               = ТекСтрокаТовары.Номенклатура;
			НоваяСтрока.ХарактеристикаНоменклатуры = ТекСтрокаТовары.ХарактеристикаНоменклатуры;
			НоваяСтрока.СерияНоменклатуры          = ТекСтрокаТовары.СерияНоменклатуры;
			НоваяСтрока.ЕдиницаИзмерения           = ТекСтрокаТовары.ЕдиницаИзмерения;
			НоваяСтрока.ЕдиницаИзмеренияМест       = ТекСтрокаТовары.ЕдиницаИзмеренияМест;
			НоваяСтрока.Количество                 = ТекСтрокаТовары.Количество;
			НоваяСтрока.КоличествоМест             = ТекСтрокаТовары.КоличествоМест;
			НоваяСтрока.Коэффициент                = ТекСтрокаТовары.Коэффициент;
			НоваяСтрока.Качество                   = Справочники.Качество.Новый;  			
			
			НоваяСтрока.Склад = ТекСтрокаТовары.Склад;
			НоваяСтрока.Заказ = ТекСтрокаТовары.Заказ;
			НоваяСтрока.НалоговоеНазначение = ТекСтрокаТовары.НалоговоеНазначение;
			НоваяСтрока.СчетУчетаБУ = ТекСтрокаТовары.СчетУчетаБУ;
			
		КонецЦикла;

	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ОприходованиеТоваров") Тогда

		// Заполнение таб.части
		ТабЧасть = Основание.Товары;
		Для Каждого ТекСтрокаТовары Из ТабЧасть Цикл

			НоваяСтрока = Товары.Добавить();
					
			НоваяСтрока.Номенклатура               = ТекСтрокаТовары.Номенклатура;
			НоваяСтрока.ХарактеристикаНоменклатуры = ТекСтрокаТовары.ХарактеристикаНоменклатуры;
			НоваяСтрока.СерияНоменклатуры          = ТекСтрокаТовары.СерияНоменклатуры;
			НоваяСтрока.ЕдиницаИзмерения           = ТекСтрокаТовары.ЕдиницаИзмерения;
			НоваяСтрока.ЕдиницаИзмеренияМест       = ТекСтрокаТовары.ЕдиницаИзмеренияМест;
			НоваяСтрока.Количество                 = ТекСтрокаТовары.Количество;
			НоваяСтрока.КоличествоМест             = ТекСтрокаТовары.КоличествоМест;
			НоваяСтрока.Коэффициент                = ТекСтрокаТовары.Коэффициент;
			НоваяСтрока.Качество                   = Справочники.Качество.Новый;  			
			
			НоваяСтрока.Склад = Основание.Склад;

			НоваяСтрока.НалоговоеНазначение = ТекСтрокаТовары.НалоговоеНазначение;
			НоваяСтрока.СчетУчетаБУ = ТекСтрокаТовары.СчетУчетаБУ;
			
		КонецЦикла;

	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ОтчетПроизводстваЗаСмену") Тогда

		ИспользоватьНаработку 			= Основание.ИспользоватьНаработку;
		ИспользоватьНаправленияВыпуска 	= Основание.ИспользоватьНаправленияВыпуска;
		
		// Заполнение таб.части
		Для Каждого ТекСтрокаПродукция Из Основание.Продукция Цикл
			
			Если ИспользоватьНаработку И ТекСтрокаПродукция.ВидВыпуска <> Перечисления.ВидыВыпуска.Выпуск Тогда
				Продолжить;
			КонецЕсли;
			Если ИспользоватьНаправленияВыпуска И ТекСтрокаПродукция.НаправлениеВыпуска <> Перечисления.НаправленияВыпуска.НаСклад Тогда
				Продолжить; // Выпуск в другое подразделение
			КонецЕсли;
			
			НоваяСтрока = Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрокаПродукция);
			
			НоваяСтрока.СчетУчетаБУ = ТекСтрокаПродукция.Счет;
			
			НоваяСтрока.Склад = Основание.Склад;
			

		КонецЦикла;
	
	КонецЕсли;
	
КонецПроцедуры	

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(Основание)

	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда

		// Заполнение шапки
		ОтражатьВУправленческомУчете = Основание.ОтражатьВУправленческомУчете;
		ОтражатьВБухгалтерскомУчете  = Основание.ОтражатьВБухгалтерскомУчете;
		Организация                  = Основание.Организация;
		Ответственный                = Основание.Ответственный;
		Подразделение                = Основание.Подразделение;
		Комментарий                  = Основание.Комментарий;

	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ОприходованиеТоваров") Тогда

		// Заполнение шапки
		ОтражатьВУправленческомУчете = Основание.ОтражатьВУправленческомУчете;
		ОтражатьВБухгалтерскомУчете  = Основание.ОтражатьВБухгалтерскомУчете;
		Организация                  = Основание.Организация;
		Ответственный                = Основание.Ответственный;
		Подразделение                = Основание.Подразделение;
		Комментарий                  = Основание.Комментарий;
		
		Если Основание.ВидОперации = Перечисления.ВидыОперацийОприходованиеТоваров.Оборудование Тогда
			ВидОперации = Перечисления.ВидыОперацийИзменениеНалоговогоНазначенияЗапасов.Оборудование;
		КонецЕсли;	


	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ОтчетПроизводстваЗаСмену") Тогда

		// Заполним реквизиты из стандартного набора по документу основанию.
		ЗаполнениеДокументов.ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, Основание);
		ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);
		
	КонецЕсли;	
	
	ЗаполнитьТоварыПоДокументуОснованию(Основание);
	
КонецПроцедуры // ОбработкаЗаполнения()

// Процедура вызывается перед записью документа 
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	ОтражатьВУправленческомУчете = Ложь;

	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью

// Процедура - обработчик события "ПриЗаписи"
//
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// Дерево значений, содержащее имена необходимых полей в запросе по шапке.
	Перем ДеревоПолейЗапросаПоШапке;

	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);

	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокументаИПроверитьОтражениеВУчете(ЭтотОбъект, Отказ, Заголовок);
	

	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке      = УправлениеЗапасами.СформироватьДеревоПолейЗапросаПоШапке();
	УправлениеЗапасами.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "УчетнаяПолитика",      "ВестиПартионныйУчетПоСкладам",     "ВестиПартионныйУчетПоСкладам");
	УправлениеЗапасами.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "УчетнаяПолитика", "ВестиУчетТоваровОрганизацийВРазрезеСкладов", "ВестиУчетТоваровОрганизацийВРазрезеСкладов");
	УправлениеЗапасами.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "Организация",     "ОтражатьВРегламентированномУчете",      "ОтражатьВРегламентированномУчете");
    УправлениеЗапасами.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "НастройкаСпособовВеденияУправленческогоПартионногоУчета", "СпособВеденияПартионногоУчетаПоОрганизации", "СпособВеденияПартионногоУчетаПоОрганизации");

	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, мВалютаРегламентированногоУчета);
	
	// Регл. учетная политика
	ПодготовитьПараметрыУчетнойПолитики(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	// Проверим правильность заполнения шапки документа
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);

	// Получим необходимые данные для проведения и проверки заполнения данные по табличной части "Товары".
	СтруктураПолей = Новый Структура;
	СтруктураПростыхПолей = Новый Структура;
	
	СтруктураПолей.Вставить("Номенклатура"					, "Номенклатура");
	СтруктураПолей.Вставить("ЕдиницаИзмерения"              , "ЕдиницаИзмерения");
	СтруктураПолей.Вставить("Количество"					, "Количество * Коэффициент /Номенклатура.ЕдиницаХраненияОстатков.Коэффициент");
	СтруктураПолей.Вставить("ХарактеристикаНоменклатуры"	, "ХарактеристикаНоменклатуры");
	СтруктураПолей.Вставить("СерияНоменклатуры"				, "СерияНоменклатуры");
	СтруктураПолей.Вставить("Услуга"						, "Номенклатура.Услуга");
	СтруктураПолей.Вставить("Набор"							, "Номенклатура.Набор");
	СтруктураПолей.Вставить("Качество"						, "Качество");
	СтруктураПолей.Вставить("Комплект"                      , "Номенклатура.Комплект");
	СтруктураПолей.Вставить("Заказ"			             	, "Заказ");
	СтруктураПолей.Вставить("ДокументОприходования"         , "ДокументОприходования");
	СтруктураПолей.Вставить("Склад"		                    , "Склад");
	СтруктураПолей.Вставить("СчетУчетаБУ"	               	, "СчетУчетаБУ");
	СтруктураПолей.Вставить("КорСчетБУ"	               	    , "СчетУчетаБУ");
	СтруктураПолей.Вставить("НалоговоеНазначениеНовое"	    , "НалоговоеНазначениеНовое");
	СтруктураПолей.Вставить("НалоговоеНазначениеПоФакту"	, "НалоговоеНазначение");
	СтруктураПолей.Вставить("ВидНалоговойДеятельностиПоФакту", "НалоговоеНазначение.ВидНалоговойДеятельности");
	СтруктураПолей.Вставить("ВидДеятельностиНДСПоФакту"  	, "НалоговоеНазначение.ВидДеятельностиНДС");
	
	РезультатЗапросаПоТоварам = УправлениеЗапасами.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "Товары", СтруктураПолей,СтруктураПростыхПолей);
	
	// Подготовим таблицу товаров для проведения.
	ТаблицаПоТоварам = ПодготовитьТаблицуТоваров(РезультатЗапросаПоТоварам, СтруктураШапкиДокумента);
	
	// Проверить заполнение ТЧ "Товары"
	ПроверитьЗаполнениеТабличнойЧастиТовары(ТаблицаПоТоварам, СтруктураШапкиДокумента, Отказ, Заголовок);
	
	// Движения по документу
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок);
	КонецЕсли;	
	
	//Сделаем переменные доступными из подписок на события
	ДополнительныеСвойства.Вставить("СтруктураШапкиДокумента", СтруктураШапкиДокумента);
	ДополнительныеСвойства.Вставить("СтруктураТабличныхЧастей", Новый Структура("ТаблицаПоТоварам", ТаблицаПоТоварам));
	
КонецПроцедуры // ОбработкаПроведения()

мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");


