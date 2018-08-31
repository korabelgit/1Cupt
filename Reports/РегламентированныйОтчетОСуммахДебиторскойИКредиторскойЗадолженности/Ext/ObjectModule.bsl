﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Хранит таблицу значений - состав показателей отчета.
Перем мТаблицаСоставПоказателей Экспорт;

Перем мТаблицаФормОтчета Экспорт;

// Хранит структуру - состав показателей отчета,
// значение которых автоматически заполняется по учетным данным.
Перем мСтруктураВариантыЗаполнения Экспорт;

// Хранит структуру многостраничных разделов.
Перем мСтруктураМногостраничныхРазделов Экспорт;

// Хранит дерево значений - структуру листов отчета.
Перем мДеревоСтраницОтчета Экспорт;

// Хранит признак выбора печатных листов.
Перем мЕстьВыбранные Экспорт;

// Хранит имя выбранной формы отчета
Перем мВыбраннаяФорма Экспорт;

// Хранит признак скопированной формы.
Перем мСкопированаФорма Экспорт;

// Хранит ссылку на документ, хранящий данные отчета
Перем мСохраненныйДок Экспорт;

// Следующие переменные хранят границы
// периода построения отчета
Перем мДатаНачалаПериодаОтчета Экспорт;
Перем мДатаКонцаПериодаОтчета  Экспорт;

Перем мПолноеИмяФайлаВнешнейОбработки Экспорт;
Перем мЗаписьЗапрещена                Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ


////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ 

ОписаниеТиповСтрока15  = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(15);

ОписаниеТиповСтрока254 = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(254);

МассивБулево = Новый Массив;
МассивБулево.Добавить(Тип("Булево"));
ОписаниеТиповБулево    = Новый ОписаниеТипов(МассивБулево);

// Таблица значений хранит состав показателей отчета.
// В колонках таблицы хранятся следующие данные:
//    - имя поля табличного документа;
//    - код показатели по составу показателей;
//    - код показателя по форме (имя области табличного документа);
//    - признак многострочности;
//    - тип данных показателя.
//
мТаблицаСоставПоказателей         = Новый ТаблицаЗначений;
мТаблицаСоставПоказателей.Колонки.Добавить("ИмяПоляТаблДокумента",    ОписаниеТиповСтрока254);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоСоставу",  ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоФорме",    ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("ПризнМногострочности",    ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("ТипДанныхПоказателя",     ОписаниеТиповСтрока15);

МассивТипов = Новый Массив; 
МассивТипов.Добавить(Тип("Строка"));
ОписаниеТиповСтрока = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыСтроки(254, ДопустимаяДлина.Переменная));

МассивТипов = Новый Массив;
МассивТипов.Добавить(Тип("Дата"));
ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));

мТаблицаФормОтчета = Новый ТаблицаЗначений;
мТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
мТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, НСтр("ru='Утверждена';uk='Затверджена'"),  20);
мТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   НСтр("ru='Действует с';uk='Діє з'"), 5);
мТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   НСтр("ru='         по';uk='         по'"), 5);

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета";
НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Госкомстата Украины от 03.07.2006 р. № 296';uk='Затверджена наказом Держкомстату України від 03.07.2006 р. № 296'"); 
НоваяФорма.ДатаНачалоДействия = '20051102';
НоваяФорма.ДатаКонецДействия  = '20071130';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2007";
НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Госкомстата Украины от 27.06.2007 р. № 187';uk='Затверджена наказом Держкомстату України від 27.06.2007 р. № 187'"); 
НоваяФорма.ДатаНачалоДействия = '20071201';
НоваяФорма.ДатаКонецДействия  = '20081130';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2008";
НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Госкомстата Украины от 04.08.2008 р. № 264';uk='Затверджена наказом Держкомстату України від 04.08.2008 р. № 264'"); 
НоваяФорма.ДатаНачалоДействия = '20081201';
НоваяФорма.ДатаКонецДействия  = '20091130';


НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2009";
НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Госкомстата Украины от 20.07.2009 р. № 270';uk='Затверджена наказом Держкомстату України від 20.07.2009 р. № 270'"); 
НоваяФорма.ДатаНачалоДействия = '20091201';
НоваяФорма.ДатаКонецДействия  = '20120131';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2012";
НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Госкомстата Украины от 15.08.2011 р. № 209';uk='Затверджена наказом Держкомстату України від 15.08.2011 р. № 209'");  
НоваяФорма.ДатаНачалоДействия = '20120201';
НоваяФорма.ДатаКонецДействия  = '20121231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2013";
НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Госкомстата Украины от 07.07.2012 р. № 286';uk='Затверджена наказом Держкомстату України від 07.07.2012 р. № 286'"); 
НоваяФорма.ДатаНачалоДействия = '20130101';
НоваяФорма.ДатаКонецДействия  = ОбщегоНазначения.ПустоеЗначениеТипа(Тип("Дата"));


мСтруктураВариантыЗаполнения      = Новый Структура;
