﻿
////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
//

// Формирует запрос по документу
//
// Параметры: 
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса
//
Функция СформироватьЗапросДляПечатиТрудовогоДоговора()

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("СправочникСсылка", Ссылка);
	Запрос.УстановитьПараметр("Руководитель",	Перечисления.ОтветственныеЛицаОрганизаций.Руководитель);
    Запрос.УстановитьПараметр("ДатаДокумента",	 ДатаДоговора);
	Запрос.УстановитьПараметр("ВидАдресаРегистрации" , Справочники.ВидыКонтактнойИнформации.ЮрАдресФизЛица);
	//Запрос.УстановитьПараметр("ВидТелефонаДомашний" , Справочники.ВидыКонтактнойИнформации.ТелефонФизЛица);
	Запрос.УстановитьПараметр("ВидТелефонаДомашний" , Справочники.ВидыКонтактнойИнформации.ТелефонФизЛицаДомашний);
 	Запрос.УстановитьПараметр("ВидАдресаОрганизации" , Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации);
	Запрос.УстановитьПараметр("ВидТелефонаОрганизации" , Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации);
	Запрос.УстановитьПараметр("ОсновноеМестоРаботы",	Перечисления.ВидыЗанятостиВОрганизации.ОсновноеМестоРаботы);

		Запрос.Текст =
		"ВЫБРАТЬ
		|	ОтветственныеЛицаОрганизацийСрезПоследних.Должность КАК ДолжностьРуководителя,
		|	ТрудовойДоговор.НомерДоговора КАК НомерДок,
		|	ТрудовойДоговор.ДатаДоговора КАК ДатаДок,
		|	ТрудовойДоговор.Организация.НаименованиеПолное КАК ПолноеНазваниеОрганизации,
		|	ЕСТЬNULL(ФИООтветственныхЛиц.Фамилия + "" "" + ФИООтветственныхЛиц.Имя + "" "" + ФИООтветственныхЛиц.Отчество, ОтветственныеЛицаОрганизацийСрезПоследних.ФизическоеЛицо.Наименование) КАК ФИОРуководителя,
		|	ЕСТЬNULL(ФИОФизЛиц.Фамилия + "" "" + ФИОФизЛиц.Имя + "" "" + ФИОФизЛиц.Отчество, ТрудовойДоговор.Физлицо.Наименование) КАК ФИОРаботника,
		|	ТрудовойДоговор.ДатаОкончания КАК ДатаУвольнения,
		|	ТрудовойДоговор.ДатаНачала КАК ДатаПриема,
		|	ТрудовойДоговор.Должность.Наименование КАК Должность,
		|	ТрудовойДоговор.ЗанимаемыхСтавок,
		|	ТрудовойДоговор.ИспытательныйСрок,
		|	ТрудовойДоговор.ПодразделениеОрганизации.Наименование КАК Подразделение,
		|	ТрудовойДоговор.ВидЗанятости КАК ВидЗанятости,
		|	ТрудовойДоговор.Физлицо.КодПоДРФО КАК КодПоДРФО,
		|	ПаспортныеДанныеФизЛицСрезПоследних.ДокументСерия,
		|	ПаспортныеДанныеФизЛицСрезПоследних.ДокументНомер,
		|	ПаспортныеДанныеФизЛицСрезПоследних.ДокументДатаВыдачи,
		|	ПаспортныеДанныеФизЛицСрезПоследних.ДокументКемВыдан,
		|	АдресРегистрации.Представление КАК АдресРегистрации,
		|	ТелефонДомашний.Представление КАК Телефоны,
		|	КонтактнаяИнформация.Представление КАК АдресОрганизации,
		|	ТелефонОрганизации.Представление КАК ТелефоныОрганизации,
		|	ТрудовойДоговор.Организация.Наименование КАК НазваниеОрганизации,
		|	ТрудовойДоговор.ГрафикРаботы.ВидГрафика КАК ВидГрафика,
		|	ТрудовойДоговор.ГрафикРаботы.ДлительностьРабочейНедели КАК ДлительностьРабочейНедели,
		|	ТрудовойДоговор.ВидРасчета,
		|	ТрудовойДоговор.ТарифнаяСтавка,
		|	ТрудовойДоговор.ВалютаТарифнойСтавки.Наименование КАК ВалютаТарифнойСтавки,
		|	ТрудовойДоговор.ПерсональныеНадбавки.(
		|		Ссылка,
		|		НомерСтроки,
		|		Надбавка КАК Надбавка,
		|		Показатель1
		|	)
		|ИЗ
		|	Справочник.СотрудникиОрганизаций КАК ТрудовойДоговор
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОтветственныеЛицаОрганизаций.СрезПоследних(&ДатаДокумента, ОтветственноеЛицо = &Руководитель) КАК ОтветственныеЛицаОрганизацийСрезПоследних
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизЛиц.СрезПоследних(&ДатаДокумента, ) КАК ФИООтветственныхЛиц
		|			ПО ОтветственныеЛицаОрганизацийСрезПоследних.ФизическоеЛицо = ФИООтветственныхЛиц.ФизЛицо
		|		ПО ТрудовойДоговор.Организация = ОтветственныеЛицаОрганизацийСрезПоследних.СтруктурнаяЕдиница
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизЛиц.СрезПоследних(&ДатаДокумента, ) КАК ФИОФизЛиц
		|		ПО ТрудовойДоговор.Физлицо = ФИОФизЛиц.ФизЛицо
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПаспортныеДанныеФизЛиц.СрезПоследних(&ДатаДокумента, ) КАК ПаспортныеДанныеФизЛицСрезПоследних
		|		ПО ТрудовойДоговор.Физлицо = ПаспортныеДанныеФизЛицСрезПоследних.ФизЛицо
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК АдресРегистрации
		|		ПО ТрудовойДоговор.Физлицо = АдресРегистрации.Объект
		|			И (АдресРегистрации.Вид = &ВидАдресаРегистрации)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК ТелефонДомашний
		|		ПО ТрудовойДоговор.Физлицо = ТелефонДомашний.Объект
		|			И (АдресРегистрации.Вид = &ВидТелефонаДомашний)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
		|		ПО ТрудовойДоговор.Организация = КонтактнаяИнформация.Объект
		|			И (КонтактнаяИнформация.Вид = &ВидАдресаОрганизации)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК ТелефонОрганизации
		|		ПО ТрудовойДоговор.Организация = ТелефонОрганизации.Объект
		|			И (ТелефонОрганизации.Вид = &ВидТелефонаОрганизации)
		|ГДЕ
		|	ТрудовойДоговор.Ссылка = &СправочникСсылка";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросДляПечати()

Процедура СформироватьСправкуОПриемеНаНовоеРабочееМесто() Экспорт  
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МИНИМУМ(РаботникиОрганизацийСрезПервых.Период) КАК ДатаПриема
	|ИЗ
	|	РегистрСведений.РаботникиОрганизаций.СрезПервых(
	|			,
	|			Сотрудник = &парамСотрудник
	|				И ПринятНаНовоеРабочееМесто) КАК РаботникиОрганизацийСрезПервых
	|
	|СГРУППИРОВАТЬ ПО
	|	РаботникиОрганизацийСрезПервых.Сотрудник";
	Запрос.УстановитьПараметр("парамСотрудник",Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		ДатаПриема = Выборка.ДатаПриема;
		
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СведенияОЛицахСДополнительнымиГарантиямиСрезПоследних.НаличиеГарантий КАК НаличиеГарантий
		|ИЗ РегистрСведений.СведенияОЛицахСДополнительнымиГарантиями.СрезПоследних(&Период, Физлицо = &Физлицо ) КАК СведенияОЛицахСДополнительнымиГарантиямиСрезПоследних
		|";		
		Запрос.УстановитьПараметр("Период",ДатаПриема);
		Запрос.УстановитьПараметр("Физлицо",Ссылка.Физлицо);
		
		ВыборкаГарантии = Запрос.Выполнить().Выбрать();
		Если ВыборкаГарантии.Следующий() Тогда
			Если ВыборкаГарантии.НаличиеГарантий И ПоНаправлениюОргановЗанятости Тогда
				ВидСправки = "Для принятых по направлению и имеющих гарантии трудоустройства (порядок 347)";	
			ИначеЕсли (ВыборкаГарантии.НаличиеГарантий И НЕ ПоНаправлениюОргановЗанятости)
				ИЛИ (НЕ ВыборкаГарантии.НаличиеГарантий И ПоНаправлениюОргановЗанятости) Тогда
				ВидСправки = "Для принятых на новое место работы (порядок 153)"				
			КонецЕсли;
		Иначе
			ВидСправки = "Для принятых на новое место работы (порядок 153)"				
		КонецЕсли;
		
		Отчет = Отчеты.СправкаОПриемеНаНовоеРабочееМесто.Создать();
		
		КомпоновщикНастроек = Отчет.КомпоновщикНастроек;
		
		ВидСправкиОтчета = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВидСправки"));
		ПериодОтчета = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));	
		
		ВидСправкиОтчета.Значение = ВидСправки;
		ВидСправкиОтчета.Использование = Истина;
		ПериодОтчета.Значение = ТекущаяДата();
		ПериодОтчета.Использование = Истина;
		
		ЭлементыОтбора = КомпоновщикНастроек.Настройки.Отбор.Элементы;
		Для Каждого Элемент ИЗ ЭлементыОтбора Цикл
			Если Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Сотрудник") Тогда
				Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
				Элемент.ПравоеЗначение = Ссылка;
				Элемент.Использование = Истина;	
			ИначеЕсли Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация") Тогда
				Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
				Элемент.ПравоеЗначение = Ссылка.Организация;
				Элемент.Использование = Истина;	
			Иначе
				Элемент.Использование = Ложь;
			КонецЕсли;
		КонецЦикла;
		
		Отчет.КомпоновщикНастроек.ЗагрузитьНастройки(КомпоновщикНастроек.ПолучитьНастройки());
		
		ФормаОтчета = Отчет.ПолучитьФорму();
		ФормаОтчета.Открыть();
		
		Отчет.ИнициализацияОтчета();
		Отчет.СформироватьОтчет(ФормаОтчета);
	Иначе	
		Сообщить("Работник " + Ссылка.Наименование + " не работает на новом рабочем месте");
		Возврат;
	КонецЕсли;
	
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

// Функция формирует уникальный номер трудового договора
// уникальность в пределах года
// 
Функция ПолучитьНомерТрудовогоДоговора() Экспорт
	
	Если Организация.Пустая() Тогда
		Возврат "0000000001";
	КонецЕсли;
	
	Если ВидДоговора <> Перечисления.ВидыДоговоровСФизЛицами.ТрудовойДоговор Тогда
		Возврат НомерДоговора;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("парамОрганизация",Организация);
	Запрос.УстановитьПараметр("парамНачалоГода" ,НачалоГода(НачалоДня(ДатаДоговора)));
	Запрос.УстановитьПараметр("парамКонецГода"  ,КонецГода(КонецДня(ДатаДоговора)));
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	МАКСИМУМ(СотрудникиОрганизаций.НомерДоговора) КАК НомерДок
	|ИЗ
	|	Справочник.СотрудникиОрганизаций КАК СотрудникиОрганизаций
	|ГДЕ
	|	СотрудникиОрганизаций.Организация = &парамОрганизация
	|	И СотрудникиОрганизаций.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровСФизЛицами.ТрудовойДоговор)
	|	И СотрудникиОрганизаций.ДатаДоговора МЕЖДУ &парамНачалоГода И &парамКонецГода";
	
	Запрос.Текст = ТекстЗапроса;
	Если Запрос.Выполнить().Пустой() Тогда
		Возврат Организация.Префикс + "0000001";
	Иначе
		
		СтрокаРезультата = Запрос.Выполнить().Выгрузить()[0];
		Если НЕ ЗначениеЗаполнено(СтрокаРезультата.НомерДок) Тогда
			Возврат Организация.Префикс + "0000001";
		Иначе
			Возврат ПроцедурыУправленияПерсоналом.ПолучитьСледующийНомер(СокрП(СтрокаРезультата.НомерДок));
		КонецЕсли;
		
	КонецЕсли;
	
	
КонецФункции // ПолучитьНомерТрудовогоДоговора()

Процедура ПроверитьНомерТрудовогоДоговора(НачальнаяДатаДокумента) Экспорт
	
	//определяем разность старой и новой даты договора
	РазностьДат = НачалоГода(НачальнаяДатаДокумента) - НачалоГода(ДатаДоговора);

	Если РазностьДат <> 0 Тогда
		НомерДоговора = ПолучитьНомерТрудовогоДоговора();
	КонецЕсли;

КонецПроцедуры // ПроверитьНомерТрудовогоДоговора

// Функция формирует очередной табельный номер сотрудника
// уникальность в пределах организации и вида договора
// Возвращаемое значение:
//   Строка   – табельный номер
//
Функция ПолучитьОчереднойТабельныйНомер() Экспорт

	Если Не ЗначениеЗаполнено(ВидДоговора) Тогда
		Возврат "";
	КонецЕсли;
	
	Префикс = "";
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("парамОрганизация",Организация);
	парамВидДоговора = Новый Массив;
	Если ВидДоговора = Перечисления.ВидыДоговоровСФизЛицами.ТрудовойДоговор Тогда
		парамВидДоговора.Добавить(Перечисления.ВидыДоговоровСФизЛицами.ТрудовойДоговор);
	ИначеЕсли ВидДоговора = Перечисления.ВидыДоговоровСФизЛицами.ДоговорУправленческий Тогда
		парамВидДоговора.Добавить(Перечисления.ВидыДоговоровСФизЛицами.ДоговорУправленческий);
	Иначе
		Префикс = "д";
		парамВидДоговора.Добавить(Перечисления.ВидыДоговоровСФизЛицами.Авторский);
		парамВидДоговора.Добавить(Перечисления.ВидыДоговоровСФизЛицами.Подряда);
	КонецЕсли;
	Запрос.УстановитьПараметр("парамВидДоговора",парамВидДоговора);
	Запрос.УстановитьПараметр("Ссылка",Ссылка);
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(СотрудникиОрганизаций.Код) КАК Код
	|ИЗ
	|	Справочник.СотрудникиОрганизаций КАК СотрудникиОрганизаций
	|ГДЕ
	|	СотрудникиОрганизаций.Организация = &парамОрганизация
	|	И СотрудникиОрганизаций.ВидДоговора В(&парамВидДоговора)
	|	И СотрудникиОрганизаций.Ссылка <> &Ссылка";
	
	Запрос.Текст = ТекстЗапроса;
	РезультатаЗапроса = Запрос.Выполнить();
	Если РезультатаЗапроса.Пустой() Тогда
		Возврат ?(ЗначениеЗаполнено(Префикс), Префикс + "000000001", "0000000001");
	Иначе
		СтрокаРезультата = РезультатаЗапроса.Выгрузить()[0];
		Если НЕ ЗначениеЗаполнено(СтрокаРезультата.Код) Тогда
			Возврат ?(ЗначениеЗаполнено(Префикс), Префикс + "000000001", "0000000001");
		Иначе
			Возврат ПроцедурыУправленияПерсоналом.ПолучитьСледующийНомер(СокрП(СтрокаРезультата.Код));
		КонецЕсли;
	КонецЕсли;

КонецФункции // ПолучитьОчереднойТабельныйНомер()


#Если Клиент Тогда

// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходмое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Функция Печать(ИмяМакета = "Печать", КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт
	
	// Получить экземпляр документа на печать
	Если ИмяМакета = "Печать" Тогда
		
		ТабДокумент = Новый ТабличныйДокумент;
		ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ТрудовойДоговор_Печать";
		
		// получаем данные для печати
		Выборка = СформироватьЗапросДляПечатиТрудовогоДоговора().Выбрать();
		
		// получаем макет
		Макет = ПолучитьМакет("Макет");
		
		// печать производится на языке, указанном в настройках пользователя
		КодЯзыкаПечать = Локализация.ПолучитьЯзыкФормированияПечатныхФорм(УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "РежимФормированияПечатныхФорм"));
		Макет.КодЯзыкаМакета = КодЯзыкаПечать;

		// выводим данные 
		Если Выборка.Следующий() Тогда
			Макет.Параметры.Заполнить(Выборка);
			Макет.Параметры.ИспытательныйСрокСтрокой = ?(НЕ ЗначениеЗаполнено(Выборка.ИспытательныйСрок),НСтр("ru='             месяцев';uk='             місяців'",КодЯзыкаПечать), "" + Выборка.ИспытательныйСрок + НСтр("ru=' месяца(ев)';uk=' місяця(ів)'",КодЯзыкаПечать));
			Если Выборка.ВидГрафика = Перечисления.ВидыРабочихГрафиков.Пятидневка Тогда
				ВидГрафика = НСтр("ru='Пятидневка';uk='П''ятиденка'",КодЯзыкаПечать);
			ИначеЕсли Выборка.ВидГрафика = Перечисления.ВидыРабочихГрафиков.Шестидневка Тогда
				ВидГрафика = НСтр("ru='Шестидневка';uk='Шостиденка'",КодЯзыкаПечать);
			ИначеЕсли Выборка.ВидГрафика = Перечисления.ВидыРабочихГрафиков.Сменный Тогда
				ВидГрафика = НСтр("ru='Сменный';uk='Змінний'",КодЯзыкаПечать);
			Иначе
				ВидГрафика = "";
			КонецЕсли;	
			Макет.Параметры.РежимРаботы = "" + ВидГрафика + "; " + Выборка.ДлительностьРабочейНедели + НСтр("ru=' - часовая рабочая неделя';uk=' - годинний робочий тиждень'",КодЯзыкаПечать);
			Макет.Параметры.ФормаОплаты = НСтр("ru='Форма оплаты: ';uk='Форма оплати: '",КодЯзыкаПечать) + Выборка.ВидРасчета + НСтр("ru='; Оклад (тариф) = ';uk='; Оклад (тариф) = '",КодЯзыкаПечать) + Выборка.ТарифнаяСтавка + " ("+Выборка.ВалютаТарифнойСтавки+")";  
			
			Если Выборка.ВидЗанятости = Перечисления.ВидыЗанятостиВОрганизации.ОсновноеМестоРаботы Тогда
				Макет.Параметры.ВидЗанятости = НСтр("ru='основной работе';uk='основною роботою'",КодЯзыкаПечать);
			ИначеЕсли Выборка.ВидЗанятости = Перечисления.ВидыЗанятостиВОрганизации.ВнутреннееСовместительство ИЛИ Выборка.ВидЗанятости = Перечисления.ВидыЗанятостиВОрганизации.Совместительство Тогда	
				Макет.Параметры.ВидЗанятости = НСтр("ru='совместительству';uk='сумісництвом'",КодЯзыкаПечать);
			Иначе
				Макет.Параметры.ВидЗанятости = "";
			КонецЕсли;	
				
			ВыборкаПерсональныхНадбавок = Выборка.ПерсональныеНадбавки.Выбрать();
			Если ВыборкаПерсональныхНадбавок.Количество()>0 Тогда
				СтрокаНадбавки = НСтр("ru='Персональные надбавки: ';uk='Персональні надбавки: '",КодЯзыкаПечать);
				Пока ВыборкаПерсональныхНадбавок.Следующий() Цикл
					СтрокаНадбавки = СтрокаНадбавки + ВыборкаПерсональныхНадбавок.Надбавка + "- " + ВыборкаПерсональныхНадбавок.Показатель1 + "; ";
				КонецЦикла; 
				Макет.Параметры.Надбавки = СтрокаНадбавки;
			КонецЕсли; 
		КонецЕсли;
		
		// выводим готовый документ
		ТабДокумент.Вывести(Макет);
		
	ИначеЕсли ИмяМакета = "ЛичнаяКарточка" Тогда	
		
		ТабДокумент1 = Новый ТабличныйДокумент;
		ТабДокумент2 = Новый ТабличныйДокумент;
		ТабДокумент  = Новый ТабличныйДокумент;

		Отчет = Отчеты.ЛичнаяКарточка.Создать();
		Отчет.ПечатьФорма2009(ТабДокумент, РабочаяДата, Ссылка, Организация, Ссылка);
		
	ИначеЕсли ИмяМакета = "СправкаОПриемеНаНовоеРабочееМесто" Тогда 
		
		СформироватьСправкуОПриемеНаНовоеРабочееМесто();	
		
	КонецЕсли;
	
	Если ИмяМакета = "ЛичнаяКарточка" Тогда 
		УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, "Личная карточка");
	Иначе
		УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, "Трудовой договор");
	КонецЕсли;
	
КонецФункции // Печать

#КонецЕсли

// Возвращает доступные варианты печати 
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура("ЛичнаяКарточка, Печать, СправкаОПриемеНаНовоеРабочееМесто","Личная карточка (форма П-2)","Трудовой договор","Справка о приеме на новое рабочее место");

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "Копирование" объекта
Процедура ПриКопировании(ОбъектКопирования)
	
	Если Не ЭтоГруппа Тогда
		Физлицо = Справочники.ФизическиеЛица.ПустаяСсылка();
		Наименование = "";
		Если ВидДоговора = Перечисления.ВидыДоговоровСФизЛицами.ТрудовойДоговор Тогда
			НомерДоговора = ПолучитьНомерТрудовогоДоговора();	
		КонецЕсли;
	КонецЕсли;
	
	
КонецПроцедуры

// Процедура - обработчик события "Заполнение" объекта
Процедура ОбработкаЗаполнения(Основание)

	ТипОснования = ТипЗнч(Основание);
	
	Если ТипОснования = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		Физлицо = Основание;
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события "ПередЗаписью" объекта
//
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ТекстИсключения = "";
	
	Если Не ЭтоГруппа И Физлицо.Пустая() Тогда
		ТекстИсключения = "Для сотрудника не задано физическое лицо!";
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ТекстИсключения) Тогда
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
		
КонецПроцедуры // ПередЗаписью()

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
