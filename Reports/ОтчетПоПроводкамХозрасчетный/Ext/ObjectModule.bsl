﻿#Если Клиент Тогда
	
Перем ИмяРегистраБухгалтерии Экспорт;
Перем МаксКоличествоСубконто Экспорт;
Перем ИмяПланаСчетов;

Перем Линия;
Перем ЛинияЖирная;


//////////////////////////////////////////////////////////
// ФОРМИРОВАНИЕ ЗАГОЛОВКА ОТЧЕТА
//

Функция ЗаголовокОтчета() Экспорт
	Возврат "Отчет по проводкам";
КонецФункции // ЗаголовокОтчета()

// Выводит заголовок отчета
//
// Параметры:
//	Нет.
//
Функция СформироватьЗаголовок() Экспорт

	ОписаниеПериода = БухгалтерскиеОтчеты.СформироватьСтрокуВыводаПараметровПоДатам(ДатаНач, ДатаКон);
	
	Макет = ПолучитьМакет("Макет");
	
	ЗаголовокОтчета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьЗаголовок=Макет.Область("Заголовок");
	
	// После удаления областей нужно установить свойства ПоВыделеннымКолонкам
	Для Сч = 1 По ЗаголовокОтчета.ВысотаТаблицы-1 Цикл
		
		Макет.Область(ОбластьЗаголовок.Верх+Сч, 2, ОбластьЗаголовок.Верх+Сч, 2).РазмещениеТекста = ТипРазмещенияТекстаТабличногоДокумента.Переносить;
		Макет.Область(ОбластьЗаголовок.Верх+Сч, 2, ОбластьЗаголовок.Верх+Сч, ОбластьЗаголовок.Право).ПоВыделеннымКолонкам = Истина;
		
	КонецЦикла;
	
	ЗаголовокОтчета = Макет.ПолучитьОбласть("Заголовок");

	НазваниеОрганизации = Организация.НаименованиеПолное;
	Если ПустаяСтрока(НазваниеОрганизации) Тогда
		НазваниеОрганизации = Организация;
	КонецЕсли;
	
	ОписаниеНастроек = ПолучитьОписаниеНастроек();
	
	ЗаголовокОтчета.Параметры.НазваниеОрганизации = НазваниеОрганизации;
	ЗаголовокОтчета.Параметры.ОписаниеПериода     = ОписаниеПериода;
	ЗаголовокОтчета.Параметры.ОписаниеНастроек    = ОписаниеНастроек;
	ЗаголовокОтчета.Параметры.Заголовок           = ЗаголовокОтчета();
	
	Возврат(ЗаголовокОтчета);

КонецФункции // СформироватьЗаголовок()

// Функция возвращает строку описания настроек отборов
//
// Параметры
//  Нет параметров
//
// Возвращаемое значение:
//   Строка   – Строка описания настроек, выводимая в шапку отчета
//
Функция ПолучитьОписаниеНастроек()
	
	СтрокаОписания = БухгалтерскиеОтчеты.СформироватьОписаниеКорреспондеции(Корреспонденции);
	
	Если ПоПодстрокеСодержание Тогда
		СтрокаОписания = СтрокаОписания + ?(ПустаяСтрока(СтрокаОписания),"","; ")+"Содержание содержит '"+Строка(Подстрока)+"'";
	КонецЕсли;
	Если ПоПодстрокеСубконто Тогда
		СтрокаОписания = СтрокаОписания + ?(ПустаяСтрока(СтрокаОписания),"","; ")+"Субконто содержит '"+Строка(Подстрока)+"'";
	КонецЕсли;
	Если ОтборПоВалюте Тогда
		СтрокаОписания = СтрокаОписания + ?(ПустаяСтрока(СтрокаОписания),"","; ")+"Валюта="+Строка(Валюта);
	КонецЕсли;
	Если ПоНомеруЖурнала Тогда
		СтрокаОписания = СтрокаОписания + ?(ПустаяСтрока(СтрокаОписания),"","; ")+"НомерЖурнала="+Строка(НомерЖурнала);
	КонецЕсли;
	Если ПоРегистратору Тогда
		СтрокаОписания = СтрокаОписания + ?(ПустаяСтрока(СтрокаОписания),"","; ")+"Регистратор="+Строка(Регистратор);
	КонецЕсли;
	
	СтрокаОписания = ?(ПустаяСтрока(СтрокаОписания), "фильтры не заданы", СтрокаОписания);
	
	Возврат СтрокаОписания;
	
КонецФункции // ПолучитьОписаниеНастроек()


//////////////////////////////////////////////////////////
// ПОСТРОЕНИЕ ОТЧЕТА
//

// Формирование текста запроса для выборки проводок
//
// Параметры
//
// Возвращаемое значение:
//   Строка   – Сформированный текст запроса
//
Функция ПолучитьТекстЗапроса()
	
	ТекстЗапроса = "";
	
	ТекстПолей = 
	"
	|	Проводки.Период,
	|	Проводки.НомерСтроки,
	|	Проводки.Регистратор,
	|	Проводки.ВалютаДт,
	|	Проводки.ВалютаКт,
	|	Проводки.Сумма,
	|	Проводки.ВалютнаяСуммаДт,
	|	Проводки.ВалютнаяСуммаКт,
	|	Проводки.КоличествоДт,
	|	Проводки.КоличествоКт,
	|	Проводки.Содержание,
	|	Проводки.НомерЖурнала,
	|	Проводки.СчетДт,
	|	Проводки.СчетКт";
	
	СтрокаОграниченийПоРеквизитам = "Активность = ИСТИНА";
	БухгалтерскиеОтчеты.ДополнитьСтрокуОграниченийПоРеквизитам(СтрокаОграниченийПоРеквизитам, "Организация", Организация);
		
	Если ОтборПоВалюте Тогда
		СтрокаОграниченийПоРеквизитам = БухгалтерскиеОтчеты.ОбъединитьОграничения(СтрокаОграниченийПоРеквизитам, "Валюта = &Валюта");
	КонецЕсли;
	
	Если ПоНомеруЖурнала Тогда
		СтрокаОграниченийПоРеквизитам = БухгалтерскиеОтчеты.ОбъединитьОграничения(СтрокаОграниченийПоРеквизитам, "НомерЖурнала = &НомерЖурнала");
	КонецЕсли;
	
	Если ПоРегистратору Тогда
		СтрокаОграниченийПоРеквизитам = БухгалтерскиеОтчеты.ОбъединитьОграничения(СтрокаОграниченийПоРеквизитам, "Регистратор = &Регистратор");
	КонецЕсли;
	
	ТекстСубконто = "";
	
	Для н=1 По МаксКоличествоСубконто Цикл
		ТекстСубконто = ТекстСубконто+","+Символы.ПС+"	Проводки.СубконтоДт"+н+" КАК СубконтоДт"+н;
		ТекстСубконто = ТекстСубконто+","+Символы.ПС+"	Проводки.СубконтоКт"+н+" КАК СубконтоКт"+н;
	КонецЦикла;
	
	Если Корреспонденции.Количество()>0 Тогда
		
		Для каждого стр Из Корреспонденции Цикл
			НомерСтроки = Корреспонденции.Индекс(стр) + 1;
			
			ТекстОтбораСчетов = "";
			Если ЗначениеЗаполнено(стр.СчетДт) Тогда
				ТекстОтбораСчетов = ТекстОтбораСчетов+" И СчетДт В ИЕРАРХИИ(&СчетДт"+НомерСтроки+")";
			КонецЕсли;
			Если ЗначениеЗаполнено(стр.СчетКт) Тогда
				ТекстОтбораСчетов = ТекстОтбораСчетов+" И СчетКт В ИЕРАРХИИ(&СчетКт"+НомерСтроки+")";
			КонецЕсли;
			
			ТекстОтбораСубконто = "";
			Для каждого Элемент Из стр.Субконто Цикл
				
				НомерОтбора = ""+НомерСтроки+"_"+(стр.Субконто.Индекс(Элемент)+1);
				
				ИмяВидаСубконта = Сред(Элемент.ПутьКДанным,0,Найти(Элемент.ПутьКДанным,".")-1);
				Если (Найти(ИмяВидаСубконта,"Дт")<>0 И ЗначениеЗаполнено(стр.СчетДт))
					ИЛИ (Найти(ИмяВидаСубконта,"Кт")<>0 И ЗначениеЗаполнено(стр.СчетКт)) Тогда
					ТекстОтбораСубконто = ТекстОтбораСубконто+" И Вид"+ИмяВидаСубконта+"=&Вид"+ИмяВидаСубконта; 
				КонецЕсли;
				ТекстОтбораСубконто = ТекстОтбораСубконто+" И "+УправлениеОтчетами.ПолучитьСтрокуОтбора(Элемент.ВидСравнения, 
																	"&Значение"+НомерОтбора,
																	Элемент.ПутьКДанным,
																	"&ЗначениеС"+НомерОтбора,
																	"&ЗначениеПо"+НомерОтбора, Элемент.Значение, Элемент.ЗначениеС, Элемент.ЗначениеПо);
				
			КонецЦикла;
			
			ТекстИсточника = "РегистрБухгалтерии."+ИмяРегистраБухгалтерии+".ДвиженияССубконто(&ДатаНач, &ДатаКон, "+СтрокаОграниченийПоРеквизитам+ТекстОтбораСчетов+ТекстОтбораСубконто+") КАК Проводки";
			
			ТекстПодзапроса = 
			"ВЫБРАТЬ 
			|"+ТекстПолей+ТекстСубконто+"
			|ИЗ
			|	"+ТекстИсточника;
			
			ТекстПодзапроса = СтрЗаменить(ТекстПодзапроса,"Проводки","Проводки"+НомерСтроки);
			
			ТекстЗапроса = ТекстЗапроса
			+?(ПустаяСтрока(ТекстЗапроса),"",Символы.ПС+" ОБЪЕДИНИТЬ "+Символы.ПС)
			+ТекстПодзапроса;
		КонецЦикла;
		
	Иначе
		
		ТекстИсточника = "РегистрБухгалтерии."+ИмяРегистраБухгалтерии+".ДвиженияССубконто(&ДатаНач, &ДатаКон, "+СтрокаОграниченийПоРеквизитам+") КАК Проводки";
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|"+ТекстПолей+ТекстСубконто+"
		|ИЗ
		|	"+ТекстИсточника;
		
	КонецЕсли;
	
	// обернем наш запрос еще одним и добавим свойства счетов
	ТекстПолейВнеш = 
	"
	|	Проводки.Период,
	|	Проводки.НомерСтроки,
	|	Проводки.Регистратор,
	|	ПРЕДСТАВЛЕНИЕ(Проводки.Регистратор) КАК РегистраторПредставление,
	|	Проводки.ВалютаДт,
	|	Проводки.ВалютаКт,
	|	Проводки.Сумма,
	|	Проводки.ВалютнаяСуммаДт,
	|	Проводки.ВалютнаяСуммаКт,
	|	Проводки.КоличествоДт,
	|	Проводки.КоличествоКт,
	|	Проводки.Содержание,
	|	Проводки.НомерЖурнала,
	|	ЕСТЬNULL(СчетаДт.Количественный, Ложь) КАК КоличественныйДт,
	|	ЕСТЬNULL(СчетаКт.Количественный, Ложь) КАК КоличественныйКт,
	|	ЕСТЬNULL(СчетаДт.Валютный, Ложь) КАК ВалютныйДт,
	|	ЕСТЬNULL(СчетаКт.Валютный, Ложь) КАК ВалютныйКт,
	|	ЕСТЬNULL(СчетаДт.КолвоСубконто, 0) КАК КолвоСубконтоДт,
	|	ЕСТЬNULL(СчетаКт.КолвоСубконто, 0) КАК КолвоСубконтоКт,
	|	Проводки.СчетДт,
	|	ПРЕДСТАВЛЕНИЕ(Проводки.СчетДт) КАК СчетДтПредставление,
	|	Проводки.СчетКт,
	|	ПРЕДСТАВЛЕНИЕ(Проводки.СчетКт) КАК СчетКтПредставление";
	
	ТекстСубконтоВнеш = "";
	
	Для н=1 По МаксКоличествоСубконто Цикл
		
		ТекстСубконтоВнеш = ТекстСубконтоВнеш + "," + Символы.ПС + "	ПРЕДСТАВЛЕНИЕ(Проводки.СубконтоДт"+н+") КАК СубконтоДт"+н;
		ТекстСубконтоВнеш = ТекстСубконтоВнеш + "," + Символы.ПС + "	ПРЕДСТАВЛЕНИЕ(Проводки.СубконтоКт"+н+") КАК СубконтоКт"+н;
		
	КонецЦикла;
	
	ТекстВыбораСчетов = 
	"	ВЫБРАТЬ
	|		Счета.Ссылка КАК ССЫЛКА,
	|		Счета.Количественный КАК Количественный,
	|		Счета.Валютный КАК Валютный,
	|		КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Субконто.ВидСубконто) КАК КолвоСубконто
	|	ИЗ
	|		ПланСчетов." + ИмяПланаСчетов + " КАК Счета
	|			ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов." + ИмяПланаСчетов + ".ВидыСубконто КАК Субконто
	|			ПО Субконто.Ссылка = Счета.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	Счета.Ссылка";
	
	ТекстЗапросаВнеш = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|"+ТекстПолейВнеш+ТекстСубконтоВнеш+"
	|ИЗ
	|	("+ТекстЗапроса+") КАК Проводки
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ (
	|" + ТекстВыбораСчетов + "
	|) КАК СчетаДт
	|	ПО Проводки.СчетДт = СчетаДт.Ссылка
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ (
	|" + ТекстВыбораСчетов + "
	|) КАК СчетаКт
	|	ПО Проводки.СчетКт = СчетаКт.Ссылка
	|";
	
	
	ТекстЗапросаВнеш = ТекстЗапросаВнеш+"
	|Упорядочить По Период, Регистратор";
	
	Возврат ТекстЗапросаВнеш;
	
КонецФункции // ПолучитьТекстЗапроса()

// Установка значений параметров запроса
//
// Параметры
//  Запрос  – Запрос – Запрос, в котором устанавливаются значения параметров
//
Процедура УстановитьПараметрыЗапроса(Запрос)
	
	Запрос.УстановитьПараметр("ДатаНач",      ДатаНач);
	Запрос.УстановитьПараметр("ДатаКон",      ?(ДатаКон='00010101', ДатаКон, КонецДня(ДатаКон)));
	Запрос.УстановитьПараметр("Организация",  Организация);
	Запрос.УстановитьПараметр("Валюта",       Валюта);
	Запрос.УстановитьПараметр("НомерЖурнала", НомерЖурнала);
	Запрос.УстановитьПараметр("Регистратор",  Регистратор);
	
	Для каждого стр Из Корреспонденции Цикл
		НомерСтроки = Корреспонденции.Индекс(стр) + 1;
		Номер =0;
		
		Запрос.УстановитьПараметр("СчетДт" + НомерСтроки, стр.СчетДт);
		Запрос.УстановитьПараметр("СчетКт" + НомерСтроки, стр.СчетКт);
		
		Для каждого Вид из стр.СчетДт.ВидыСубконто Цикл
			номер=номер+1;
			Запрос.УстановитьПараметр("ВидСубконтоДт" + номер, Вид.ВидСубконто);
		КонецЦикла;
		
		Номер =0;
		Для каждого Вид из стр.СчетКт.ВидыСубконто Цикл
			номер=номер+1;
			Запрос.УстановитьПараметр("ВидСубконтоКт" + номер, Вид.ВидСубконто);
		КонецЦикла;
		
		Для каждого Элемент Из стр.Субконто Цикл
			
			НомерОтбора = "" + НомерСтроки + "_" + (стр.Субконто.Индекс(Элемент) + 1);
			
			БухгалтерскиеОтчеты.УстановитьПараметрыЗапросаПоСтрокеПостроителяОтчета(Запрос, Элемент, НомерОтбора);
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// Формирование отчета
Процедура СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок = Истина, ВысотаЗаголовка = 0) Экспорт

	ОграничениеПоДатамКорректно = БухгалтерскиеОтчеты.ПроверитьКорректностьОграниченийПоДатам(ДатаНач, ДатаКон);
	Если НЕ ОграничениеПоДатамКорректно Тогда
        Возврат;
	КонецЕсли;

	ДокументРезультат.Очистить();

	Запрос = Новый Запрос();
	Запрос.Текст = ПолучитьТекстЗапроса();
	
	УстановитьПараметрыЗапроса(Запрос);

	Состояние("Выполнение запроса");
	Результат = Запрос.Выполнить();
	
	Макет = ПолучитьМакет("Макет");

	// Вывод заголовка отчета
	БухгалтерскиеОтчеты.СформироватьИВывестиЗаголовокОтчета(ЭтотОбъект, ДокументРезультат, ВысотаЗаголовка, ПоказыватьЗаголовок);
	
	ОбластьШапки = Макет.ПолучитьОбласть("Шапка");
	ДокументРезультат.Вывести(ОбластьШапки, 1);
	
	ОблСтрока           = Макет.ПолучитьОбласть("Строка");
	ОблСтрокаСубконто   = Макет.ПолучитьОбласть("СтрокаСубконто");
	ОблСтрокаКоличество = Макет.ПолучитьОбласть("СтрокаКоличество");
	ОблСтрокаВалюта     = Макет.ПолучитьОбласть("СтрокаВалюта");
	ОблИтого            = Макет.ПолучитьОбласть("Итого");
	
	СуммаИтого = 0;
	
	Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.Прямой);
	Пока Выборка.Следующий() Цикл
		
		Если БухгалтерскиеОтчеты.ОпределитьНеобходимоПропуститьСтрокуПриВыводеДанных(Выборка, ПоПодстрокеСодержание, ПоПодстрокеСубконто,
			БезУчетаРегистра, Подстрока, МаксКоличествоСубконто) Тогда
			
			Продолжить;
			
		КонецЕсли;
			
		Расшифровка = Новый Структура;
		Расшифровка.Вставить("Регистратор", Выборка.Регистратор);
		Расшифровка.Вставить("НомерСтроки", Выборка.НомерСтроки);
			
		ОблСтрока.Параметры.Заполнить(Выборка);
		ОблСтрока.Параметры.СубконтоДт = Выборка.СубконтоДт1;
		ОблСтрока.Параметры.СубконтоКт = Выборка.СубконтоКт1;
		ОблСтрока.Параметры.Расшифровка = Расшифровка;
		ДокументРезультат.Вывести(ОблСтрока, 1);
		
		УжеВыведено = 1;
			
		СуммаИтого = СуммаИтого + Выборка.Сумма;
			
		НачалоСекции = ДокументРезультат.ВысотаТаблицы;
			
		КолвоСубконтоДт = ?(Выборка.КолвоСубконтоДт <> NULL, Выборка.КолвоСубконтоДт, 0);
		КолвоСубконтоКт = ?(Выборка.КолвоСубконтоКт <> NULL, Выборка.КолвоСубконтоКт, 0);
			
		КолвоСтрокСубконто = Макс(КолвоСубконтоДт, КолвоСубконтоКт);
			
		ЕстьВалюта = Выборка.ВалютныйДт       Или Выборка.ВалютныйКт;
		ЕстьКолво  = Выборка.КоличественныйДт Или Выборка.КоличественныйКт;
			
		КолвоСтрокПрочих = 1 + ?(ЕстьВалюта, 1, 0) + ?(ЕстьКолво, 1, 0);
			
		ВыводитьСтрокСубконто = КолвоСтрокСубконто - КолвоСтрокПрочих;
		ВсегоСтрок = Макс(КолвоСтрокСубконто, КолвоСтрокПрочих);
			
		Если УжеВыведено < ВсегоСтрок Тогда
			ДокументРезультат.Область(ДокументРезультат.ВысотаТаблицы,,ДокументРезультат.ВысотаТаблицы).ВместеСоСледующим = Истина;
		КонецЕсли;
			
		Для н=1 По ВыводитьСтрокСубконто Цикл
			
			ОблСтрокаСубконто.Параметры.СубконтоДт  = Выборка["СубконтоДт"+Строка(1+н)];
			ОблСтрокаСубконто.Параметры.СубконтоКт  = Выборка["СубконтоКт"+Строка(1+н)];
				
			ОблСтрокаСубконто.Параметры.Расшифровка = Расшифровка;
				
			ДокументРезультат.Вывести(ОблСтрокаСубконто, 1);
				
			УжеВыведено = УжеВыведено + 1;
				
			Если УжеВыведено<ВсегоСтрок Тогда
				ДокументРезультат.Область(ДокументРезультат.ВысотаТаблицы,,ДокументРезультат.ВысотаТаблицы).ВместеСоСледующим = Истина;
			КонецЕсли;
				
		КонецЦикла;
			
		Если ЕстьКолво Тогда
				
			ОблСтрокаКоличество.Параметры.КоличествоДт = Выборка.КоличествоДт;
			ОблСтрокаКоличество.Параметры.КоличествоКт = Выборка.КоличествоКт;
			ОблСтрокаКоличество.Параметры.СубконтоДт  = Выборка["СубконтоДт"+Строка(УжеВыведено+1)];
			ОблСтрокаКоличество.Параметры.СубконтоКт  = Выборка["СубконтоКт"+Строка(УжеВыведено+1)];
				
			ОблСтрокаКоличество.Параметры.Расшифровка = Расшифровка;
				
			ДокументРезультат.Вывести(ОблСтрокаКоличество, 1);
				
			УжеВыведено = УжеВыведено + 1;
				
			Если УжеВыведено<ВсегоСтрок Тогда
				ДокументРезультат.Область(ДокументРезультат.ВысотаТаблицы,,ДокументРезультат.ВысотаТаблицы).ВместеСоСледующим = Истина;
			КонецЕсли;
				
		КонецЕсли;
			
		Если ЕстьВалюта Тогда
				
			ОблСтрокаВалюта.Параметры.ВалютнаяСуммаДт = Выборка.ВалютнаяСуммаДт;
			ОблСтрокаВалюта.Параметры.ВалютнаяСуммаКт = Выборка.ВалютнаяСуммаКт;
				
			ОблСтрокаВалюта.Параметры.ВалютаДт = Выборка.ВалютаДт;
			ОблСтрокаВалюта.Параметры.ВалютаКт = Выборка.ВалютаКт;
				
			ОблСтрокаВалюта.Параметры.СубконтоДт  = Выборка["СубконтоДт"+Строка(УжеВыведено+1)];
			ОблСтрокаВалюта.Параметры.СубконтоКт  = Выборка["СубконтоКт"+Строка(УжеВыведено+1)];
				
			ОблСтрокаВалюта.Параметры.Расшифровка = Расшифровка;
				
			ДокументРезультат.Вывести(ОблСтрокаВалюта, 1);
				
		КонецЕсли;
			
		БухгалтерскиеОтчеты.ОбвестиОбластиОтчета(ДокументРезультат, НачалоСекции, Линия, ЛинияЖирная);
		
	КонецЦикла;

	ОблИтого.Параметры.Сумма = СуммаИтого;
	ДокументРезультат.Вывести(ОблИтого);
	
	// Зафиксируем заголовок отчета
	ДокументРезультат.ФиксацияСверху = ВысотаЗаголовка + 1;

	// Шапку таблицы печатаем на всех страницах
	ДокументРезультат.ПовторятьПриПечатиСтроки = ДокументРезультат.Область(ВысотаЗаголовка + 1,,ВысотаЗаголовка + 1);
	
	// Первую колонку не печатаем
	ДокументРезультат.ОбластьПечати = ДокументРезультат.Область(1,2,ДокументРезультат.ВысотаТаблицы+1,ДокументРезультат.ШиринаТаблицы);
	
	// Печатать отчет будем ландшафтом
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	// Присвоим имя для сохранения параметров печати табличного документа
	ДокументРезультат.ИмяПараметровПечати = "ОтчетПоПроводкам " + ИмяРегистраБухгалтерии;

	УправлениеОтчетами.УстановитьКолонтитулыПоУмолчанию(ДокументРезультат, ЗаголовокОтчета(), Строка(глЗначениеПеременной("глТекущийПользователь")));
	
КонецПроцедуры


//////////////////////////////////////////////////////////
// ПРОЧИЕ ПРОЦЕДУРЫ И ФУНКЦИИ
//

// Настраивает отчет по заданным параметрам (например, для расшифровки)
Процедура Настроить(СтруктураПараметров) Экспорт
	
	Параметры = БухгалтерскиеОтчеты.СоздатьПоСтруктуреСоответствие(СтруктураПараметров); 

	Организация = Параметры["Организация"];
	ДатаНач = Параметры["ДатаНач"];
	ДатаКон = Параметры["ДатаКон"];
	
	Валюта = Параметры["Валюта"];
	Если НЕ ЗначениеЗаполнено(Валюта) Тогда
		ОтборПоВалюте = Параметры["ОтборПоВалюте"];
	Иначе
		ОтборПоВалюте = Истина;
	КонецЕсли;
	
	Регистратор = Параметры["Регистратор"];
	Если НЕ ЗначениеЗаполнено(Регистратор) Тогда
		ПоРегистратору = Параметры["ПоРегистратору"];
	Иначе
		ПоРегистратору = Истина;
	КонецЕсли;
	
	БухгалтерскиеОтчеты.НастроитьОтборыДанныхПопараметрам(Параметры, Корреспонденции, Валюта, ОтборПоВалюте);	
	
КонецПроцедуры

//////////////////////////////////////////////////////////
// ТЕКСТ МОДУЛЯ ОБЪЕКТА
//

ИмяРегистраБухгалтерии = "Хозрасчетный";

ИмяПланаСчетов = Метаданные.РегистрыБухгалтерии[ИмяРегистраБухгалтерии].ПланСчетов.Имя;

МаксКоличествоСубконто = Метаданные.ПланыСчетов[ИмяПланаСчетов].МаксКоличествоСубконто;

БухгалтерскиеОтчеты.СоздатьКолонкиОграниченийДляКорреспонденцииПланаСчетов(Корреспонденции, ИмяПланаСчетов);

Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
ЛинияЖирная = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 2);

#КонецЕсли