﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ МЕХАНИЗМА УПРАВЛЕНИЯ НАСТРОЙКАМИ

Функция ЗаполнитьНастройкиПриОткрытииОтчета(ОтчетОбъект) Экспорт
	
	ВсеПользователиИБ = Новый Массив;
	ВсеПользователиИБ.Добавить(ПараметрыСеанса.ТекущийПользователь);
	ВсеПользователиИБ.Добавить(Справочники.ГруппыПользователей.ВсеПользователи);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1
	|	СохраненныеНастройки.Ссылка КАК СохраненнаяНастройка
	|ИЗ
	|	Справочник.СохраненныеНастройки.Пользователи КАК СохраненныеНастройкиПользователи
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СохраненныеНастройки КАК СохраненныеНастройки
	|		ПО СохраненныеНастройкиПользователи.Ссылка = СохраненныеНастройки.Ссылка
	|ГДЕ
	|	СохраненныеНастройки.ИспользоватьПриОткрытии = ИСТИНА
	|	И СохраненныеНастройки.НастраиваемыйОбъект = &НастраиваемыйОбъект
	|	И СохраненныеНастройкиПользователи.Пользователь В(&Пользователи)";
	
	Запрос.УстановитьПараметр("Пользователи", ВсеПользователиИБ);
	Запрос.УстановитьПараметр("НастраиваемыйОбъект", "ОтчетОбъект." + ОтчетОбъект.Метаданные().Имя);
	ТаблицаРезультата = Запрос.Выполнить().Выгрузить();
	
	Если ТаблицаРезультата.Количество() > 0 Тогда
		ОтчетОбъект.СохраненнаяНастройка = ТаблицаРезультата[0].СохраненнаяНастройка;
		ОтчетОбъект.ПрименитьНастройку();
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Процедура сохраняет настройки формы.
//
// Параметры:
//  СохраненнаяНастройка       - СправочникСсылка.СохраненныеНастройки - сохраняемая настройка.
//  СохраняемыеНастройки - параметры настройки формы.
//
Процедура СохранитьНастройкуОбъекта(СохраненнаяНастройка, СохраняемыеНастройки) Экспорт

	ОбъектСохраненнаяНастройка = СохраненнаяНастройка.ПолучитьОбъект();
	
	Если СохраненнаяНастройка.Предопределенный тогда
		СохраняемыеНастройки.Вставить("Изменялась", истина);
	КонецЕсли;
	
	ОбъектСохраненнаяНастройка.ХранилищеНастроек = Новый ХранилищеЗначения(СохраняемыеНастройки);
	
	Попытка
		ОбъектСохраненнаяНастройка.Записать();
	Исключение
		ОбщегоНазначения.СообщитьОбОшибке("Настройка формы не записана:" + Символы.ПС + "- " + ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры

#Если ТолстыйКлиентОбычноеПриложение Тогда
	
// Процедура открывает форму выбора настройки форм.
//
// Параметры:
//  ФормаВладелец            - Форма - форма, которая является владельцем формы выбора.
//  НастраиваемыйОбъект       - объект, для которой выбирается настройка.
//  РежимСохраненияНастройки - Истина - форма открыта для выбора сохраняемой настройки.
//
Процедура ВыбратьНастройкуФормы(СохраненнаяНастройка, ФормаВладелец, НастраиваемыйОбъект, РежимСохраненияНастройки, Наименование = "") Экспорт

	ФормаВыбора = Справочники.СохраненныеНастройки.ПолучитьФормуВыбора(, ФормаВладелец);
	ФормаВыбора.Отбор.НастраиваемыйОбъект.Установить(НастраиваемыйОбъект);
	Если Найти(НастраиваемыйОбъект, "ОтчетОбъект") > 0 Тогда
		ФормаВыбора.Отбор.ТипНастройки.Установить(Перечисления.ТипыНастроек.НастройкиОтчета);
	КонецЕсли;
	ФормаВыбора.Отбор.НастраиваемыйОбъект.Установить(НастраиваемыйОбъект);
	ФормаВыбора.Отбор.Ссылка.Использование = Истина;
	ФормаВыбора.Отбор.Ссылка.ВидСравнения = ВидСравнения.ВСписке;
	Попытка
		Если ТипЗнч(ФормаВладелец) = Тип("Форма") Тогда
			ОтчетОбъект = ФормаВладелец.ОтчетОбъект;
		Иначе
			ОтчетОбъект = Неопределено;
		КонецЕсли;
	Исключение
		ОтчетОбъект = Неопределено;	
	КонецПопытки;
	
	СписокДоступныхВариантов = ТиповыеОтчеты.ПолучитьСписокДоступныхВариантов(НастраиваемыйОбъект,,, ОтчетОбъект); 
	Для каждого ДоступныйВариант Из СписокДоступныхВариантов Цикл
		Если ДоступныйВариант.Пометка или НЕ РежимСохраненияНастройки Тогда
			ФормаВыбора.Отбор.Ссылка.Значение.Добавить(ДоступныйВариант.Значение);
		КонецЕсли;
	КонецЦикла;
	ФормаВыбора.Наименование             = Наименование;
	ФормаВыбора.ПараметрТекущаяСтрока    = СохраненнаяНастройка;
	ФормаВыбора.РежимСохраненияНастройки = РежимСохраненияНастройки;
	ФормаВыбора.ОткрытьМодально();
	ФормаВыбора.Активизировать();

КонецПроцедуры

// Возвращает настройки отбора списка в виде таблицы
//
// Параметры:
//  Отбор - (Отбор) - отбор, по которому строится таблица
//
// Возвращаемое значение:
//  (ТаблицаЗначений) - таблица с значениями отбора
//
Функция ПолучитьНастройкуОтбораСписка(Отбор) Экспорт

	// Сохранение настроек отборов
	ТаблицаНастроек = Новый ТаблицаЗначений();

	ТаблицаНастроек.Колонки.Добавить("ИмяОтбора");
	ТаблицаНастроек.Колонки.Добавить("Использование");
	ТаблицаНастроек.Колонки.Добавить("ВидСравнения");
	ТаблицаНастроек.Колонки.Добавить("Значение");
	ТаблицаНастроек.Колонки.Добавить("ЗначениеС");
	ТаблицаНастроек.Колонки.Добавить("ЗначениеПо");

	Для Каждого ЭлементОтбора Из Отбор Цикл
		СтрокаПараметров = ТаблицаНастроек.Добавить();

		СтрокаПараметров.ИмяОтбора     = ЭлементОтбора.Имя;
		СтрокаПараметров.Использование = ЭлементОтбора.Использование;
		СтрокаПараметров.ВидСравнения  = ЭлементОтбора.ВидСравнения;
		СтрокаПараметров.Значение      = ЭлементОтбора.Значение;
		СтрокаПараметров.ЗначениеС     = ЭлементОтбора.ЗначениеС;
		СтрокаПараметров.ЗначениеПо    = ЭлементОтбора.ЗначениеПо;
	КонецЦикла;

	Возврат ТаблицаНастроек;

КонецФункции

// Возвращает натсройки сортировок списка в виде таблицы
//
// Параметры:
//  Порядок - (Порядок) - Порядок, по которому строится таблица
//
// Возвращаемое значение:
//  (ТаблицаЗначений) - таблица с значениями сортировок
//
Функция ПолучитьНастройкуПорядкаСписка(Порядок) Экспорт

	// Сохранение настроек сортировок
	ТаблицаНастроек = Новый ТаблицаЗначений();

	ТаблицаНастроек.Колонки.Добавить("Данные");
	ТаблицаНастроек.Колонки.Добавить("Направление");

	Для Каждого ЭлементПорядка Из Порядок Цикл
		СтрокаПараметров = ТаблицаНастроек.Добавить();

		СтрокаПараметров.Данные      = ЭлементПорядка.Данные;
		СтрокаПараметров.Направление = ЭлементПорядка.Направление;
	КонецЦикла;

	Возврат ТаблицаНастроек;

КонецФункции

// Возвращает натсройки колонок списка в виде таблицы.
//
// Параметры:
//  Колонки - (Колонки) - колонки списка, по которым строится таблица
//
// Возвращаемое значение:
//  (ТаблицаЗначений) - таблица с значениями настройк
//
Функция ПолучитьНастройкуКолонокСписка(Колонки) Экспорт

	// Сохранение настроек отборов
	ТаблицаНастроек = Новый ТаблицаЗначений();

	ТаблицаНастроек.Колонки.Добавить("ИмяКолонки");
	ТаблицаНастроек.Колонки.Добавить("Видимость");
	ТаблицаНастроек.Колонки.Добавить("Положение");
	ТаблицаНастроек.Колонки.Добавить("ИзменениеРазмера");
	ТаблицаНастроек.Колонки.Добавить("Ширина");
	ТаблицаНастроек.Колонки.Добавить("ВысотаЯчейки");
	ТаблицаНастроек.Колонки.Добавить("АвтоВысотаЯчейки");

	Для Каждого Колонка Из Колонки Цикл
		СтрокаПараметров = ТаблицаНастроек.Добавить();

		СтрокаПараметров.ИмяКолонки       = Колонка.Имя;
		СтрокаПараметров.Видимость        = Колонка.Видимость;
		СтрокаПараметров.Положение        = Колонка.Положение;
		СтрокаПараметров.ИзменениеРазмера = Колонка.ИзменениеРазмера;
		СтрокаПараметров.Ширина           = Колонка.Ширина;
		СтрокаПараметров.ВысотаЯчейки     = Колонка.ВысотаЯчейки;
		СтрокаПараметров.АвтоВысотаЯчейки = Колонка.АвтоВысотаЯчейки;
	КонецЦикла;

	Возврат ТаблицаНастроек;

КонецФункции
 
// Устанавливает настройки отбора списка по сохраненным значениям из таблицы.
//
// Параметры:
//  СтруктураНастроек - Структура - структура применяемых настроек.
//  КлючЗначения      - Строка - ключ применяемой настройки.
//  Отбор             - (Отбор) - Настройка отбора формы
//
Процедура ПрименитьНастройкуОтбораСписка(СтруктураНастроек, КлючЗначения, Отбор) Экспорт
	
	Перем ТаблицаНастроек;
	
	Если ТипЗнч(СтруктураНастроек) = Тип("Структура") Тогда
		СтруктураНастроек.Свойство(КлючЗначения, ТаблицаНастроек);
	КонецЕсли;
	
	Если ТаблицаНастроек = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ЭлементОтбора Из Отбор Цикл
		СтрокаТаблицы = ТаблицаНастроек.Найти(ЭлементОтбора.Имя , "ИмяОтбора");
		
		Если СтрокаТаблицы = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ОбщегоНазначения.УстановитьНовоеЗначение(ЭлементОтбора.Использование, СтрокаТаблицы.Использование);
		Если ЭлементОтбора.ТипЗначения.СодержитТип(Тип("Строка")) И ЭлементОтбора.ТипЗначения.КвалификаторыСтроки.Длина = 0 Тогда
			Если СтрокаТаблицы.ВидСравнения = ВидСравнения.НеРавно или СтрокаТаблицы.ВидСравнения = ВидСравнения.НеСодержит Тогда
				ОбщегоНазначения.УстановитьНовоеЗначение(ЭлементОтбора.ВидСравнения,  ВидСравнения.НеСодержит);
			Иначе
				ОбщегоНазначения.УстановитьНовоеЗначение(ЭлементОтбора.ВидСравнения,  ВидСравнения.Содержит);
			КонецЕсли;
		Иначе
			ОбщегоНазначения.УстановитьНовоеЗначение(ЭлементОтбора.ВидСравнения,  СтрокаТаблицы.ВидСравнения);
		КонецЕсли;
		
		Если ТипЗнч(ЭлементОтбора.Значение) = Тип("СписокЗначений") Тогда
			Если ТипЗнч(СтрокаТаблицы.Значение) = Тип("СписокЗначений") И СтрокаТаблицы.Значение.ТипЗначения = ЭлементОтбора.ТипЗначения Тогда
				ЭлементОтбора.Значение = СтрокаТаблицы.Значение;
			КонецЕсли;
		Иначе
			ОбщегоНазначения.УстановитьНовоеЗначение(ЭлементОтбора.Значение, ЭлементОтбора.ТипЗначения.ПривестиЗначение(СтрокаТаблицы.Значение));
		КонецЕсли;
		
		ОбщегоНазначения.УстановитьНовоеЗначение(ЭлементОтбора.ЗначениеС,  ЭлементОтбора.ТипЗначения.ПривестиЗначение(СтрокаТаблицы.ЗначениеС));
		ОбщегоНазначения.УстановитьНовоеЗначение(ЭлементОтбора.ЗначениеПо, ЭлементОтбора.ТипЗначения.ПривестиЗначение(СтрокаТаблицы.ЗначениеПо));
	КонецЦикла;
	
КонецПроцедуры

// Устанавливает настройки сортировки списка по сохраненным значениям из таблицы
//
// Параметры:
//  СтруктураНастроек - Структура - структура применяемых настроек.
//  КлючЗначения      - Строка - ключ применяемой настройки.
//  Порядок           - (Порядок) - настройка порядка формы.
//
Процедура ПрименитьНастройкуПорядкаСписка(СтруктураНастроек, КлючЗначения, Порядок, НастройкаПорядка) Экспорт

	Перем ТаблицаНастроек;
	
	Если ТипЗнч(СтруктураНастроек) = Тип("Структура") Тогда
		СтруктураНастроек.Свойство(КлючЗначения, ТаблицаНастроек);
	КонецЕсли;

	Если ТаблицаНастроек = Неопределено Тогда
		Возврат;
	КонецЕсли;

	СтрокаПорядка = "";

	Для каждого СтрокаТаблицы Из ТаблицаНастроек Цикл
		Если НастройкаПорядка.Найти(СтрокаТаблицы.Данные) = Неопределено Тогда
			Продолжить;
		КонецЕсли;

		СтрокаПорядка = СтрокаПорядка + СтрокаТаблицы.Данные;
		
		Если СтрокаТаблицы.Направление = НаправлениеСортировки.Убыв Тогда
			СтрокаПорядка = СтрокаПорядка + " Убыв";
		КонецЕсли;
		
		СтрокаПорядка = СтрокаПорядка + ",";
	КонецЦикла;

	СтрокаПорядка = Лев(СтрокаПорядка, СтрДлина(СтрокаПорядка) - 1);

	Если СтрокаПорядка <> "" Тогда
		Порядок.Установить(СтрокаПорядка);
	КонецЕсли;

КонецПроцедуры

// Устанавливает настройки колонок списка по сохраненным значениям из таблицы.
//
// Параметры:
//  СтруктураНастроек - Структура - структура применяемых настроек.
//  КлючЗначения      - Строка - ключ применяемой настройки.
//  Колонки           - (Колонки) - настраиваемые колонки списка.
//
Процедура ПрименитьНастройкуКолонокСписка(СтруктураНастроек, КлючЗначения, Колонки) Экспорт

	Перем ТаблицаНастроек;
	
	Если ТипЗнч(СтруктураНастроек) = Тип("Структура") Тогда
		СтруктураНастроек.Свойство(КлючЗначения, ТаблицаНастроек);
	КонецЕсли;

	Если ТаблицаНастроек = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Для каждого СтрокаТаблицы Из ТаблицаНастроек Цикл
		Колонка = Колонки.Найти(СтрокаТаблицы.ИмяКолонки);
		
		Если Колонка = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Колонки.Сдвинуть(Колонка, ТаблицаНастроек.Индекс(СтрокаТаблицы) - Колонки.Индекс(Колонка));
		
		Колонка.Видимость        = СтрокаТаблицы.Видимость;
		Колонка.Положение        = СтрокаТаблицы.Положение;
		Колонка.ИзменениеРазмера = ИзменениеРазмераКолонки.Изменять; // это чтобы сработало присвоение ширины
		Колонка.Ширина           = СтрокаТаблицы.Ширина;
		Колонка.ИзменениеРазмера = СтрокаТаблицы.ИзменениеРазмера;
		Колонка.ВысотаЯчейки     = СтрокаТаблицы.ВысотаЯчейки;
		Колонка.АвтоВысотаЯчейки = СтрокаТаблицы.АвтоВысотаЯчейки;
	КонецЦикла;

КонецПроцедуры

// Проверяет, были ли изменены указанные реквизиты объекта.
// Предназначена для установки Отказ в проверках перед записью объекта.
//
// Параметры:
//  Объект    - проверяемый объект.
//  Реквизиты - строка - список проверяемых реквизитов через запятую.
//  Отказ     - устанавливается в Истина, если реквизит был изменен.
//
Процедура ОтказПриИзмененииРеквизитов(Объект, Знач Реквизиты, Отказ) Экспорт
	
	Если ПустаяСтрока(Реквизиты) Тогда
		Возврат;
		
	ИначеЕсли Объект.Ссылка.Пустая() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	СтруктураРеквизитов = Новый Структура(Реквизиты);
	
	Для каждого ЭлементСтруктуры Из СтруктураРеквизитов Цикл
		ИмяРеквизита = ЭлементСтруктуры.Ключ;
		
		Если Объект[ИмяРеквизита] <> Объект.Ссылка[ИмяРеквизита] Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура НастроитьВидСписка(ТабличноеПоле, Пользователь) Экспорт
	
	ТабличноеПоле.РежимВыделения = РежимВыделенияТабличногоПоля.Одиночный;
	
КонецПроцедуры

// Функция проверяет, переданный параметр, пустой он, или нет.
//
// Параметры:
//  Параметр - параметр, значение которого проверяется.
//
// Возвращаемое значение:
//  Истина - параметр пустой;
//  Ложь   - параметр не пустой.
//
Функция ПустоеЗначениеЗначения(Значение) Экспорт

	МассивТипов    = Новый Массив(1);
	МассивТипов[0] = ТипЗнч(Значение);

	ОписаниеТипов  = Новый ОписаниеТипов(МассивТипов,,,);

	Если Значение = ОписаниеТипов.ПривестиЗначение() Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;

КонецФункции

Процедура УстановитьДоступностьОтбора(ТабличноеПоле, Знач ОбязательныеОтборы = "") Экспорт
	
	ОбязательныеОтборы = Врег(ОбязательныеОтборы) + ", ";

	Для каждого ЭлементУправленияОтбором Из ТабличноеПоле.НастройкаОтбора Цикл
		ОбязательныйОтбор = Найти(ОбязательныеОтборы, Врег(ЭлементУправленияОтбором.Имя)) > 0;
		
		ЭлементУправленияОтбором.Доступность = НЕ ОбязательныйОтбор;
	КонецЦикла;

КонецПроцедуры

// Процедура устанавливает доступность всех элементов управления порядком списка.
//
// Параметры:
//  ТабличноеПоле - табличное поле списка.
//
Процедура УстановитьДоступностьПорядка(ТабличноеПоле, Доступность = Истина) Экспорт

	Для каждого ЭлементУправленияПорядком Из ТабличноеПоле.НастройкаПорядка Цикл
		ЭлементУправленияПорядком.Доступность = Доступность;
	КонецЦикла;

КонецПроцедуры

#КонецЕсли