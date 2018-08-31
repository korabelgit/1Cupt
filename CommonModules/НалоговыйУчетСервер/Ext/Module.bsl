﻿&НаСервере
Функция ЗаполнитьНалоговуюНакладнуюПоОснованиюУФ(НалоговаяНакладнаяОбъект, Основание, УИД) Экспорт
	
	ТипОснования = ТипЗнч(Основание);
	
	мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");
	
	СтруктураВозврата = Новый Структура("Ошибка, СтрокаВозврата, АдресВременногоХранилища, ВариантыОтветов");
	
	СтруктураВозврата.Ошибка = Истина;
	СтруктураВозврата.АдресВременногоХранилища = "";
	СтруктураВозврата.ВариантыОтветов = "";

	// при вводе на основании запускается специальная обработка, которая и
	// формирует налоговые накладные
	
	Если ((   ТипОснования = Тип("ДокументСсылка.ПлатежноеПоручениеВходящее")
		  ИЛИ ТипОснования = Тип("ДокументСсылка.ПлатежноеТребованиеВыставленное")
		  ИЛИ ТипОснования = Тип("ДокументСсылка.ПлатежныйОрдерПоступлениеДенежныхСредств")
		  ИЛИ ТипОснования = Тип("ДокументСсылка.ПлатежноеТребованиеПоручениеВыставленное")
		  ИЛИ ТипОснования = Тип("ДокументСсылка.АккредитивПолученный")
		  ) И Основание.ВидОперации = Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ВозвратДенежныхСредствПоставщиком)
		  ИЛИ
		  (  ТипОснования = Тип("ДокументСсылка.ПриходныйКассовыйОрдер") 
		   И Основание.ВидОперации = Перечисления.ВидыОперацийПКО.ВозвратДенежныхСредствПоставщиком) Тогда
		   
			СтруктураВозврата.СтрокаВозврата = "По данному документу не возникают налоговые обязательства!";
			Возврат СтруктураВозврата;
			
	КонецЕсли;
	
	ОбработкаФормированияНН = Обработки.ФормированиеНалоговыхНакладных.Создать();
	ОбработкаФормированияНН.Дата = Основание.Дата;
	
	Если НЕ ЗначениеЗаполнено(Основание.Организация) Тогда
		СтруктураВозврата.СтрокаВозврата = "В документе не указана организация! Заполнение невозможно.";
		Возврат СтруктураВозврата;
	Иначе
		ОбработкаФормированияНН.Организация = Основание.Организация;
	КонецЕсли;
	
	// Основание может содержать номенклатуру для заполнения налоговой накладной
	ОснованиеСодержитНоменклатуру = Ложь;
  	Для каждого ДопустимыйТип Из ОбработкаФормированияНН.ДопустимыеТипыДокументов Цикл
		Если ТипОснования = ДопустимыйТип Тогда
			ОснованиеСодержитНоменклатуру = Истина;
			Прервать;
  		КонецЕсли;
   	КонецЦикла; 

	ОтборДоговоров = Новый ТаблицаЗначений;
	ОтборДоговоров.Колонки.Добавить("РасчетыВозврат");
	ОтборДоговоров.Колонки.Добавить("ДоговорКонтрагента");
	ОтборДоговоров.Колонки.Добавить("Сделка");                                           
	ОтборДоговоров.Колонки.Добавить("Дата", 		Новый ОписаниеТипов("Дата"));	
	ОтборДоговоров.Колонки.Добавить("ЗаТару", 		Новый ОписаниеТипов("Булево"));
	ОтборДоговоров.Колонки.Добавить("СтавкаНДС", 	Новый ОписаниеТипов("ПеречислениеСсылка.СтавкиНДС"));
	ОтборДоговоров.Колонки.Добавить("НалоговоеНазначение", 	Новый ОписаниеТипов("СправочникСсылка.НалоговыеНазначенияАктивовИЗатрат"));
	
	Если ОснованиеСодержитНоменклатуру Тогда
		
		Если НЕ ЗначениеЗаполнено(Основание.ДоговорКонтрагента) Тогда
			
			СтруктураВозврата.СтрокаВозврата = "В документе не указан договор контрагента! Заполнение невозможно.";
			Возврат СтруктураВозврата;
			
		КонецЕсли;	
			
		СтрокаОтбора 					= ОтборДоговоров.Добавить();
		
		СтрокаОтбора.ДоговорКонтрагента = Основание.ДоговорКонтрагента;
		СтрокаОтбора.РасчетыВозврат		= Перечисления.РасчетыВозврат.Расчеты;
		СтрокаОтбора.Дата               = Основание.Дата;
		
		Если     ТипЗнч(Основание) = Тип("ДокументСсылка.СчетНаОплатуПокупателю")
			 ИЛИ ТипЗнч(Основание) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
			
			СделкаНалоговыйУчет  = Основание;	
			Если  Основание.ДоговорКонтрагента.ВедениеВзаиморасчетовРегл = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказам 
				И ТипЗнч(Основание) = Тип("ДокументСсылка.СчетНаОплатуПокупателю") Тогда
				СделкаНалоговыйУчет = Основание.ЗаказПокупателя;
			КонецЕсли;			
			
			СтрокаОтбора.Дата 	 = '00010101';	
			ОбработкаФормированияНН.Дата = '00010101';	
			
		ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ОтчетКомиссионераОПродажах") Тогда
				
			СделкаНалоговыйУчет = Основание.Сделка;
			// налоговые обязательства - по оплате
			СтрокаОтбора.Дата 	 		 = '00010101';	
			ОбработкаФормированияНН.Дата = '00010101';	
				
		Иначе
					
			СделкаНалоговыйУчет = Основание.Сделка;	
					
		КонецЕсли;
					
		Если    Основание.ДоговорКонтрагента.ВедениеВзаиморасчетовРегл = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоСчетам Тогда
			
			СтрокаОтбора.Сделка = СделкаНалоговыйУчет;
			
			
		ИначеЕсли Основание.ДоговорКонтрагента.ВедениеВзаиморасчетовРегл = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказам Тогда
			// возможно указание заказов в табличной части.		
			СтрокаОтбора.Сделка = СделкаНалоговыйУчет;
			 
			Если ОбработкаФормированияНН.мОтбиратьНоменклатуруПоЗаказам Тогда
				
				ОтборДоговоров.Удалить(СтрокаОтбора);
				
				МетаданныеОснования = Основание.Метаданные();
				
				МассивЗаказов = Новый Массив;
				Для каждого ТЧОснования Из МетаданныеОснования.ТабличныеЧасти Цикл
					Если НЕ (ТЧОснования.Реквизиты.Найти("ЗаказПокупателя") = Неопределено) Тогда
						Для каждого СтрокаТЧ Из Основание[ТЧОснования.Имя] Цикл
							МассивЗаказов.Добавить(СтрокаТЧ.ЗаказПокупателя);
						КонецЦикла;
					ИначеЕсли ЗначениеЗаполнено(СделкаНалоговыйУчет) Тогда
						МассивЗаказов.Добавить(СделкаНалоговыйУчет);
					КонецЕсли;						
				КонецЦикла;
				МассивЗаказов = ОбщегоНазначения.УдалитьПовторяющиесяЭлементыМассива(МассивЗаказов);				
				
				Для каждого Заказ Из МассивЗаказов Цикл
				
					СтрокаОтбора = ОтборДоговоров.Добавить();
					СтрокаОтбора.РасчетыВозврат		= Перечисления.РасчетыВозврат.Расчеты;
					СтрокаОтбора.ДоговорКонтрагента = Основание.ДоговорКонтрагента;
					СтрокаОтбора.Сделка 			= Заказ;
					Если     ТипЗнч(Основание) = Тип("ДокументСсылка.СчетНаОплатуПокупателю")
						 ИЛИ ТипЗнч(Основание) = Тип("ДокументСсылка.ЗаказПокупателя")
						 ИЛИ ТипЗнч(Основание) = Тип("ДокументСсылка.ОтчетКомиссионераОПродажах") Тогда
                        СтрокаОтбора.Дата 				= '00010101';
					Иначе
						СтрокаОтбора.Дата 				= Основание.Дата;
					КонецЕсли;
				
				КонецЦикла;				
			КонецЕсли;			
					
		Иначе
			
			СтрокаОтбора.Сделка = Неопределено;
					
		КонецЕсли;
			
	Иначе
		
	   Если НЕ Основание.Метаданные().ТабличныеЧасти.Найти("РасшифровкаПлатежа") = Неопределено Тогда
				
			// платежные документы
			Для каждого СтрокаТЧ Из Основание.РасшифровкаПлатежа  Цикл
				СтрокаОтбора = ОтборДоговоров.Добавить();
									
				СтрокаОтбора.РасчетыВозврат		= Перечисления.РасчетыВозврат.Расчеты;
				СтрокаОтбора.ДоговорКонтрагента = СтрокаТЧ.ДоговорКонтрагента;
				СтрокаОтбора.Дата 				= Основание.Дата;
					
				СделкаНалоговыйУчет 			= СтрокаТЧ.Сделка;	
					
				Если    СтрокаТЧ.ДоговорКонтрагента.ВедениеВзаиморасчетовРегл = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоСчетам
					ИЛИ СтрокаТЧ.ДоговорКонтрагента.ВедениеВзаиморасчетовРегл = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказам Тогда
					
					СтрокаОтбора.Сделка = СделкаНалоговыйУчет
					
				Иначе
					
					СтрокаОтбора.Сделка = Неопределено;
						
				КонецЕсли;
					
			КонецЦикла;
			
			ОтборДоговоров.Свернуть("Сделка, ДоговорКонтрагента, РасчетыВозврат, Дата, Затару, СтавкаНДС, НалоговоеНазначение","");
			
		Иначе
			
			СтруктураВозврата.СтрокаВозврата = "В документе не указан договор контрагента! Заполнение невозможно.";
			Возврат СтруктураВозврата;
				
		КонецЕсли;		
		
	КонецЕсли;

	// получим данные регистра ОжидаемыйИПодтвержденныйНДСПродаж на текущий момент
	ОбработкаФормированияНН.ОбновитьДоговора(ОтборДоговоров);
	
	// укажем номенклатурный состав
	Для каждого СтрокаОтбора Из ОтборДоговоров Цикл
		
		ДокументИсточникНоменклатуры = Неопределено;
	
		Если ОснованиеСодержитНоменклатуру Тогда
				
			ДокументИсточникНоменклатуры = Основание; 	
				
		Иначе
				
			СделкаСодержитНоменклатуру = Ложь;
				
			Для каждого ДопустимыйТип Из ОбработкаФормированияНН.ДопустимыеТипыДокументов Цикл
				Если ТипЗнч(СтрокаОтбора.Сделка) = ДопустимыйТип Тогда
					СделкаСодержитНоменклатуру = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
				
			Если СделкаСодержитНоменклатуру Тогда
				ДокументИсточникНоменклатуры = СтрокаОтбора.Сделка;
			КонецЕсли;
				
		КонецЕсли;
						
		СтруктураОтбора = Новый Структура();
		СтруктураОтбора.Вставить("Документ", 			ДокументИсточникНоменклатуры);
		СтруктураОтбора.Вставить("ДоговорКонтрагента", 	СтрокаОтбора.ДоговорКонтрагента);
		СтруктураОтбора.Вставить("Сделка", 				СтрокаОтбора.Сделка);
		СтруктураОтбора.Вставить("РасчетыВозврат", 		СтрокаОтбора.РасчетыВозврат);
		СтруктураОтбора.Вставить("Дата", 				СтрокаОтбора.Дата);
		
		Если НЕ ДокументИсточникНоменклатуры = Неопределено Тогда
			
			СтрокаИсточниковНоменклатуры = ОбработкаФормированияНН.ИсточникиНоменклатуры.Добавить();
			СтрокаИсточниковНоменклатуры.Документ 			= ДокументИсточникНоменклатуры;
			СтрокаИсточниковНоменклатуры.ДоговорКонтрагента = СтрокаОтбора.ДоговорКонтрагента;
			СтрокаИсточниковНоменклатуры.Сделка 			= СтрокаОтбора.Сделка;
			СтрокаИсточниковНоменклатуры.РасчетыВозврат 	= СтрокаОтбора.РасчетыВозврат;
			СтрокаИсточниковНоменклатуры.Дата			 	= СтрокаОтбора.Дата;
				
			ОбработкаФормированияНН.ЗаполнитьТабличныеЧасти(СтруктураОтбора);
			
		КонецЕсли;
			
	КонецЦикла;	
	
	МожноФормироватьНалоговыеНакладные  = Истина;
	БудутСформированыНалоговыеНакладные = Истина;

	// Проверим, можно ли не открывать форму обработки для корректировок
	Для каждого СтрокаОтбора Из ОтборДоговоров Цикл
						
		СтруктураОтбора = Новый Структура();
		СтруктураОтбора.Вставить("ДоговорКонтрагента", 	СтрокаОтбора.ДоговорКонтрагента);
		СтруктураОтбора.Вставить("Сделка", 				СтрокаОтбора.Сделка);
		СтруктураОтбора.Вставить("РасчетыВозврат", 		СтрокаОтбора.РасчетыВозврат);
		СтруктураОтбора.Вставить("Дата", 				СтрокаОтбора.Дата);
		
		ТаблицаЧастичнойОтгрузки = Неопределено;
		ОбязательствБольшеЧемНоменклатуры = ОбработкаФормированияНН.МожноФормироватьНалоговыеНакладные(СтруктураОтбора, ТаблицаЧастичнойОтгрузки);
		
		Если  ТаблицаЧастичнойОтгрузки.Количество() = 0 Тогда
			
			// вообще нет номенклатуры для заполнения
			МожноФормироватьНалоговыеНакладные = Ложь;
			Прервать;
			
		ИначеЕсли НЕ ОбязательствБольшеЧемНоменклатуры Тогда                     
			
			МожноФормироватьНалоговыеНакладные  = Ложь;
			
			// есть номенклатурный состав для заполнения
			Если НЕ ОбработкаФормированияНН.БудутСформированыНалоговыеНакладные(ТаблицаЧастичнойОтгрузки) Тогда
				
				БудутСформированыНалоговыеНакладные = Ложь;
				
			КонецЕсли;
			
			Прервать;
			
		КонецЕсли;	
		
	КонецЦикла;	
	
	Если НЕ МожноФормироватьНалоговыеНакладные Тогда
		// необходимо подкорректировать номенклатурный состав.
		// откроем обработку. Но в ТЧ Договора может не быть строк - если остатков по регистру НДСПродаж не текущий момент нет
		// Добавим строки при необходимости
		Для каждого СтрокаОтбораДоговоров Из ОтборДоговоров Цикл
			
			Если ОбработкаФормированияНН.Договора.НайтиСтроки(Новый Структура("ДоговорКонтрагента, Сделка",СтрокаОтбораДоговоров.ДоговорКонтрагента,СтрокаОтбораДоговоров.Сделка)).Количество() = 0 Тогда
				
				СтрокаДоговоров = ОбработкаФормированияНН.Договора.Добавить();
				СтрокаДоговоров.ДоговорКонтрагента 	= СтрокаОтбораДоговоров.ДоговорКонтрагента;
				СтрокаДоговоров.Сделка 				= СтрокаОтбораДоговоров.Сделка;
				СтрокаДоговоров.РасчетыВозврат 		= СтрокаОтбораДоговоров.РасчетыВозврат;
				СтрокаДоговоров.Дата 				= СтрокаОтбораДоговоров.Дата;

				
				СтрокаИсточниковНоменклатуры = ОбработкаФормированияНН.ИсточникиНоменклатуры.Добавить();
				СтрокаИсточниковНоменклатуры.ДоговорКонтрагента 	= СтрокаОтбораДоговоров.ДоговорКонтрагента;
				СтрокаИсточниковНоменклатуры.Сделка 				= СтрокаОтбораДоговоров.Сделка;
				СтрокаИсточниковНоменклатуры.РасчетыВозврат 		= СтрокаОтбораДоговоров.РасчетыВозврат;
				СтрокаИсточниковНоменклатуры.Дата 					= СтрокаОтбораДоговоров.Дата;
				
			КонецЕсли; 
			
		КонецЦикла; 
	КонецЕсли; 	
	
	
	Если МожноФормироватьНалоговыеНакладные Тогда
			
	ИначеЕсли НЕ БудутСформированыНалоговыеНакладные Тогда
		
		СтруктураВозврата.СтрокаВозврата = "По данному документу не возникают налоговые обязательства!";
		СтруктураВозврата.АдресВременногоХранилища = ПоместитьВоВременноеХранилище(ОбработкаФормированияНН, УИД);
		Возврат СтруктураВозврата;

				
	Иначе
		
    	ТекстВопроса = "На текущий момент сумма неподтвержденных налоговых обязательств (в разрезе Ставок НДС, налоговых назначений или Счетов НДС н/о) меньше соответствующей суммы документа. 
						|Заполнить налоговую накладную автоматически номенклатурным составом невозможно. 
						|Открыть налоговые накладные, заполненные полностью номенклатурным составом документа-основания?";

		СтруктураВозврата.ВариантыОтветов = "ОКОтмена";
		
		МассивПараметров = Новый Массив(3);
		
		МассивПараметров[0] = ПоместитьВоВременноеХранилище(ОбработкаФормированияНН, УИД);
		СтруктураОтбора.Вставить("Документ", ДокументИсточникНоменклатуры);
		МассивПараметров[1] = ПоместитьВоВременноеХранилище(СтруктураОтбора, УИД);
		МассивПараметров[2] = ПоместитьВоВременноеХранилище(ТаблицаЧастичнойОтгрузки, УИД);
		
		СтруктураВозврата.Ошибка = Ложь;
		СтруктураВозврата.СтрокаВозврата = ТекстВопроса;
		СтруктураВозврата.АдресВременногоХранилища = МассивПараметров;
		
		Возврат СтруктураВозврата;

	КонецЕсли;
	
	// сюда мы попадаем только, если по всем договорам можно сформировать налоговые накладные
	Если МожноФормироватьНалоговыеНакладные Тогда
		
		ОбработкаФормированияНН.ОткрыватьДокументы = Ложь;
		ОбработкаФормированияНН.ОткрытиеИзУФ = Истина;
				
		// сформированные документы не будут записаны в базу
		ОбработкаФормированияНН.мНеЗаписыватьДокументы = Истина;
		
		ОбработкаФормированияНН.СформироватьНалоговыеДокументы(УИД);
		
		СтруктураВозврата.Ошибка = Ложь;
		СтруктураВозврата.СтрокаВозврата = "Сформированы документы";
		СтруктураВозврата.АдресВременногоХранилища = ОбработкаФормированияНН.АдресВременногоХранилища;
		
		Возврат СтруктураВозврата;
		

	КонецЕсли;
	
	СтруктураВозврата = Новый Структура("Ошибка, СтрокаВозврата, АдресВременногоХранилища");
	
	СтруктураВозврата.Ошибка = Ложь;
	СтруктураВозврата.СтрокаВозврата = "Открыть обработку";
	СтруктураВозврата.АдресВременногоХранилища = ПоместитьВоВременноеХранилище(ОбработкаФормированияНН, УИД);
	
	Возврат СтруктураВозврата;
	
КонецФункции
 



