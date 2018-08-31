﻿// Процедура заполняет табличную часть "ИсходныеКомплектующие" по спецификациям выпуска,
// указанным в табличной части на закладке "Продукция.
//
Процедура ЗаполнитьИсходныеКомплектующиеПоСпецификации() Экспорт
	Если Продукция.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаИсходныеКомплектующие = ИсходныеКомплектующие.Выгрузить();
	
	Параметры = Новый Структура("ДатаСпецификации");
	
	Для Каждого СтрокаТабличнойЧасти Из Продукция Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Спецификация) Тогда
			Продолжить;
		КонецЕсли;
		
		РезультатРазузлования = Новый Структура("ИсходныеКомплектующие");
		
		СтруктураИсточник = Новый Структура("Номенклатура, ХарактеристикаНоменклатуры, ЕдиницаИзмерения, Коэффициент, Количество, Спецификация");
		ЗаполнитьЗначенияСвойств(СтруктураИсточник, СтрокаТабличнойЧасти);
		СтруктураИсточник.Коэффициент = СтруктураИсточник.ЕдиницаИзмерения.Коэффициент;

		Параметры.ДатаСпецификации = Дата;
		
		МассивОшибок = РазузлованиеНоменклатуры.РазузловатьНоменклатуру(СтруктураИсточник, РезультатРазузлования, Параметры);
		
		Если МассивОшибок.Количество() > 0 Тогда
			
			Для каждого Ошибка из МассивОшибок Цикл
				
				ОбщегоНазначения.Сообщение("Ошибка: " + Ошибка.Причина, Ошибка.СтатусОшибки);
				ОбщегоНазначения.Сообщение(" Спецификация: " + Ошибка.Спецификация);
				ОбщегоНазначения.Сообщение(" Номер строки: " + Ошибка.НомерСтроки);
				ОбщегоНазначения.Сообщение(" Описание ошибки: " + Ошибка.ОписаниеОшибки);
			
			КонецЦикла;
			
		КонецЕсли;
		
		Если РезультатРазузлования.ИсходныеКомплектующие = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		РезультатИсходныеКомплектующие = РезультатРазузлования.ИсходныеКомплектующие;
		
		РезультатИсходныеКомплектующие.Колонки.Добавить("Продукция");
		РезультатИсходныеКомплектующие.Колонки.Добавить("ХарактеристикаПродукции");
		РезультатИсходныеКомплектующие.Колонки.Добавить("Цена");
		
		РезультатИсходныеКомплектующие.ЗаполнитьЗначения(СтрокаТабличнойЧасти.Номенклатура, "Продукция");
		РезультатИсходныеКомплектующие.ЗаполнитьЗначения(СтрокаТабличнойЧасти.ХарактеристикаНоменклатуры, "ХарактеристикаПродукции");
		РезультатИсходныеКомплектующие.ЗаполнитьЗначения(СтрокаТабличнойЧасти.Спецификация, "Спецификация");
		
		
		ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(РезультатИсходныеКомплектующие, ТаблицаИсходныеКомплектующие);
		
	КонецЦикла;
	
	ТаблицаИсходныеКомплектующие.Свернуть("Номенклатура, ХарактеристикаНоменклатуры, Спецификация, Продукция, ХарактеристикаПродукции, Цена, ЕдиницаИзмерения", "Количество");
	ИсходныеКомплектующие.Загрузить(ТаблицаИсходныеКомплектующие);
КонецПроцедуры // ЗаполнитьМатериалыПоСпецификации()

//Процедура заполняет цену и стоимость исходных комплектующих по типу цен
//
Процедура ЗаполнитьЦеныИсходныхКомплектующих() Экспорт
	Если НЕ ЗначениеЗаполнено(ТипЦен) ИЛИ ИсходныеКомплектующие.Количество()=0 Тогда
		Возврат;
	КонецЕсли;
	ТаблицаИсходныеКомплектующие = ИсходныеКомплектующие.Выгрузить();
	ТаблицаИсходныеКомплектующие.ЗаполнитьЗначения(0,"Цена");
	ТаблицаИсходныеКомплектующие.Индексы.Добавить("Номенклатура");
	ТаблицаИсходныеКомплектующие.Индексы.Добавить("ХарактеристикаНоменклатуры");
	ТаблицаИсходныеКомплектующие.Индексы.Добавить("ЕдиницаИзмерения");
	
	ТаблицаЦен = ТаблицаИсходныеКомплектующие.Скопировать();
	ТаблицаЦен.Свернуть("Номенклатура, ХарактеристикаНоменклатуры, ЕдиницаИзмерения");
	Для Каждого СтрокаТаблицыЦен Из ТаблицаЦен Цикл
		Цена = Ценообразование.ПолучитьЦенуНоменклатуры(СтрокаТаблицыЦен.Номенклатура, СтрокаТаблицыЦен.ХарактеристикаНоменклатуры,
			                                ТипЦен, Дата, СтрокаТаблицыЦен.ЕдиницаИзмерения,
			                                ТипЦен.ВалютаЦены, 1, 1);
		Если Цена = 0 Тогда
			Продолжить;
		КонецЕсли;
		МассивСтрок = ТаблицаИсходныеКомплектующие.НайтиСтроки(Новый Структура("Номенклатура, ХарактеристикаНоменклатуры, ЕдиницаИзмерения",СтрокаТаблицыЦен.Номенклатура, СтрокаТаблицыЦен.ХарактеристикаНоменклатуры, СтрокаТаблицыЦен.ЕдиницаИзмерения));
		Для Каждого СтрокаКомплектующих Из МассивСтрок Цикл
			СтрокаКомплектующих.Цена = Цена;
			СтрокаКомплектующих.Себестоимость = Цена * СтрокаКомплектующих.Количество;
		КонецЦикла;
	КонецЦикла;
	ИсходныеКомплектующие.Загрузить(ТаблицаИсходныеКомплектующие);
КонецПроцедуры

//Процедура рассчитыает себестоимость продукции исходя из стоимости входящих в нее комплектующих
//
Процедура РассчитатьСебестоимостьПродукции() Экспорт
	Если ИсходныеКомплектующие.Количество() = 0 ИЛИ Продукция.Количество() = 0
		ИЛИ ИсходныеКомплектующие.Итог("Себестоимость") = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаИсходныеКомплектующие = ИсходныеКомплектующие.Выгрузить();
	ТаблицаИсходныеКомплектующие.Свернуть("Продукция, ХарактеристикаПродукции, Спецификация", "Себестоимость");
	ТаблицаИсходныеКомплектующие.Индексы.Добавить("Продукция");
	ТаблицаИсходныеКомплектующие.Индексы.Добавить("ХарактеристикаПродукции");
	ТаблицаИсходныеКомплектующие.Индексы.Добавить("Спецификация");
	КоэффициентНакладныхРасходов = (1 + ПроцентНакладныхРасходов / 100);
	Для Каждого СтрокаПродукция Из Продукция Цикл
		СтрокаПродукция.Себестоимость = 0;
		СтруктураПоиска = Новый Структура("Продукция, ХарактеристикаПродукции, Спецификация",
							СтрокаПродукция.Номенклатура, 
							СтрокаПродукция.ХарактеристикаНоменклатуры,
							СтрокаПродукция.Спецификация);
		МассивСтрокКомплектующие = ТаблицаИсходныеКомплектующие.НайтиСтроки(СтруктураПоиска);
		Если МассивСтрокКомплектующие.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		//В массиве строк должна быть одна строка, т.к. таблица свернута 
		СтрокаПродукция.Себестоимость = (СтрокаПродукция.Себестоимость + МассивСтрокКомплектующие[0].Себестоимость) * КоэффициентНакладныхРасходов;
	КонецЦикла;
КонецПроцедуры

//Процедура заполняет табличную часть с продукцией, для которой будет рассчитана себестоимость
//	Используются отборы, заданные в документе на закладке Параметры расчета
//
Процедура ЗаполнитьПродукцию(КомпоновщикНастроекКомпоновкиДанных) Экспорт
	СхемаКомпоновкиДанных = ПолучитьМакет("НастройкаЗаполненияПродукции"); 
	КомпоновщикМакетаКомпоновкиДанных = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновкиДанных = КомпоновщикМакетаКомпоновкиДанных.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроекКомпоновкиДанных.ПолучитьНастройки());
	Запрос = Новый Запрос(МакетКомпоновкиДанных.НаборыДанных.Продукция.Запрос);
	ОписаниеПараметровЗапроса = Запрос.НайтиПараметры();
	Для каждого ОписаниеПараметраЗапроса из ОписаниеПараметровЗапроса Цикл
		Запрос.УстановитьПараметр(ОписаниеПараметраЗапроса.Имя, МакетКомпоновкиДанных.ЗначенияПараметров[ОписаниеПараметраЗапроса.Имя].Значение);
	КонецЦикла;

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Продукция.Добавить();
		НоваяСтрока.Номенклатура = Выборка.Продукция;
		НоваяСтрока.Спецификация = УправлениеПроизводством.ОпределитьСпецификациюПоУмолчанию(НоваяСтрока.Номенклатура, , Дата);
		ЗаполнитьЕдиницуИКоличествоПродукции(НоваяСтрока);
	КонецЦикла;
КонецПроцедуры

//По спецификации номенклатуры заполняется единица измерения и количество в ТЧ Продукция
//	
Процедура ЗаполнитьЕдиницуИКоличествоПродукции(СтрокаПродукции) Экспорт
	//Первичное заполнение - из  карточки номенклатуры
	СтрокаПродукции.ЕдиницаИзмерения = СтрокаПродукции.Номенклатура.ЕдиницаХраненияОстатков;
	СтрокаПродукции.Количество = 1;
	Если НЕ ЗначениеЗаполнено(СтрокаПродукции.Спецификация) Тогда
		Возврат;
	КонецЕсли;
	Для Каждого СтрокаВыходногоИзделия ИЗ СтрокаПродукции.Спецификация.ВыходныеИзделия Цикл
		Если СтрокаВыходногоИзделия.Номенклатура = СтрокаПродукции.Номенклатура Тогда
			СтрокаПродукции.ЕдиницаИзмерения = СтрокаВыходногоИзделия.ЕдиницаИзмерения;
			СтрокаПродукции.Количество = СтрокаВыходногоИзделия.Количество;
			Возврат;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры


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
	КонецЕсли;

	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	// Получить экземпляр документа на печать
	Если ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда

		ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
		
		Если ТабДокумент = Неопределено Тогда
			Возврат
		КонецЕсли; 
		
	КонецЕсли;

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект, ""), Ссылка);

КонецПроцедуры // Печать()
#КонецЕсли

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура();

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	НастройкиКомпоновщика = Новый ХранилищеЗначения(ОбъектКопирования.НастройкиКомпоновщика.Получить());
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект,,ОбъектКопирования.Ссылка);
КонецПроцедуры



