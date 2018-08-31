﻿#Если Клиент Тогда
////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Хранит таблицу значений - состав показателей отчета.
Перем мТаблицаСоставПоказателей Экспорт;

// Хранит структуру - состав показателей отчета,
// значение которых автоматически заполняется по учетным данным.
Перем мСтруктураВариантыЗаполнения Экспорт;

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

Перем мТаблицаФормОтчета Экспорт;

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
мТаблицаСоставПоказателей.Колонки.Добавить("ИмяПоляТаблДокумента",    ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоСоставу",  ОписаниеТиповСтрока254);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоФорме",    ОписаниеТиповСтрока254);
мТаблицаСоставПоказателей.Колонки.Добавить("ПризнМногострочности",    ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("ТипДанныхПоказателя",     ОписаниеТиповСтрока15);

// Таблица значений хранит данные дополнительной страницы многостраничных разделов отчета.
// В колонках таблицы хранятся следующие данные:
//    - имя дополнительной страницы (отображается в списке дополнительных страниц);
//    - булево, признак текущей страницы (отображенной в поле табличного документа);
//    - структура, содержащая имена и значения редактируемых ячеек дополнительной страницы.
//
ТаблицаСтраницыРаздела            = Новый ТаблицаЗначений;
ТаблицаСтраницыРаздела.Колонки.Добавить("Представление",              ОписаниеТиповСтрока254, НСтр("ru='Наименование';uk='Найменування'"));
ТаблицаСтраницыРаздела.Колонки.Добавить("АктивнаяСтраница",           ОписаниеТиповБулево);
ТаблицаСтраницыРаздела.Колонки.Добавить("Данные");

мСтруктураВариантыЗаполнения      = Новый Структура;

ОписаниеТиповСтрока = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(254);

МассивТипов = Новый Массив;
МассивТипов.Добавить(Тип("Дата"));
ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));

мТаблицаФормОтчета = Новый ТаблицаЗначений;
мТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
мТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, НСтр("ru='Утверждена';uk='Затверджена'"),  20);
мТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   НСтр("ru='Действует с';uk='Діє з'"), 5);
мТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   НСтр("ru='         по';uk='         по'"), 5);

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2011";
НоваяФорма.ОписаниеОтчета     = НСтр("ru = 'Приложение 4 к Порядку формирования и подачи страхователями  отчета относительно сумм начисленного
                                      |единого взноса  на общеобязательное государственное социальное страхование, 
                                      |утвержденному постановлением правления ПФУ №22-2 от 8.10.2010 года.'; uk = 'Додаток 4 до Порядку формування та подання страхувальниками  звіту щодо сум нарахованого 
                                      |єдиного внеску на загальнообов’язкове державне соціальне страхування,
                                      |затвержденому постановою правління ПФУ №22-2 від 8.10.2010 року.'");
НоваяФорма.ДатаНачалоДействия = '20110101';
НоваяФорма.ДатаКонецДействия  = '20110731';
	
НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2011Мес8";
НоваяФорма.ОписаниеОтчета     = НСтр("ru = 'Приложение 4 к Порядку формирования и подачи страхователями  отчета (Постановление правления ПФУ №22-2 от 8.10.2010 года в редакции Постановления правления ПФУ №18-1 от 23.06.2011 г.)'; uk = 'Додаток 4 до Порядку формування та подання страхувальниками звіту (Постанова правління ПФУ №22-2 від 8.10.2010 року у редакції постанови правління ПФУ №18-1 від 23.06.2011 р.)'");
НоваяФорма.ДатаНачалоДействия = '20110801';
НоваяФорма.ДатаКонецДействия  = '20111130';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2011Мес12";
НоваяФорма.ОписаниеОтчета     = НСтр("ru = 'Приложение 4 к Порядку формирования и подачи страхователями  отчета (Постановление правления ПФУ №22-2 от 8.10.2010 г. с изменениями, внесенными Постановлением №32-3 от 25.10.2011 г.)'; uk = 'Додаток 4 до Порядку формування та подання страхувальниками звіту (Постанова правління ПФУ №22-2 від 8.10.2010 р. зі змінами що внесені Постановою №32-3 від 25.10.2011р.)'");
НоваяФорма.ДатаНачалоДействия = '20111201';
НоваяФорма.ДатаКонецДействия  = '2012-12-31';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2013";
НоваяФорма.ОписаниеОтчета     = НСтр("ru = 'Приложение 4 к Порядку формирования и подачи страхователями  отчета (Постановление правления ПФУ №22-2 от 8.10.2010 г. с изменениями, внесенными Постановлением №24-1 от 10.12.2012 г.)'; uk = 'Додаток 4 до Порядку формування та подання страхувальниками звіту (Постанова правління ПФУ №22-2 від 8.10.2010 р. зі змінами що внесені Постановою №24-1 від 10.12.2012р.)'");
НоваяФорма.ДатаНачалоДействия = '2013-01-01';
НоваяФорма.ДатаКонецДействия  = '2013-06-30';
	
НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2013Мес7";
НоваяФорма.ОписаниеОтчета     = НСтр("ru = 'Приложение 4 к Порядку формирования и подачи страхователями  отчета 
                                      |(Постановление правления ПФУ №22-2 от 8.10.2010 г. 
                                      |с изменениями, внесенными Постановлением № 12-1 от 22.07.2013 г.)'; uk = 'Додаток 4 до Порядку формування та подання страхувальниками звіту 
                                      |(Постанова правління ПФУ №22-2 від 8.10.2010 р. 
                                      |зі змінами що внесені Постановою № 12-1 від 22.07.2013р.)'");
НоваяФорма.ДатаНачалоДействия = '2013-07-01';
НоваяФорма.ДатаКонецДействия  = '2013-08-31';
	
	
НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2013Мес9";
НоваяФорма.ОписаниеОтчета     = НСтр("ru = 'Приложение 4 к Приказу Миндоходов  №454 от 09.09.2013 г.'; uk = 'Додаток 4 до наказу Міндоходів  №454 від 09.09.2013 р.'");
НоваяФорма.ДатаНачалоДействия = '2013-09-01';
НоваяФорма.ДатаКонецДействия  = '2015-04-30';
	
НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2015";
НоваяФорма.ОписаниеОтчета     = НСтр("ru = 'Приложение 4 к Приказу Миндоходов  №435 от 14.04.2015 г.'; uk = 'Додаток 4 до наказу Міндоходів  №435 від 14.04.2015 р.'");
НоваяФорма.ДатаНачалоДействия = '2015-05-01';
НоваяФорма.ДатаКонецДействия  = '2016-05-31';
	
НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2016";
НоваяФорма.ОписаниеОтчета     = НСтр("ru = 'Приложение 4 к Приказу Миндоходов  №435 от 14.04.2015 г. (в редакции Приказу Миндоходов от 11.04.2016 г. № 441)'; uk = 'Додаток 4 до наказу Міндоходів  №435 від 14.04.2015 р. (у редакції наказу Мінфіна від 11.04.2016 р. № 441)'");
НоваяФорма.ДатаНачалоДействия = '2016-06-01';
НоваяФорма.ДатаКонецДействия  = ОбщегоНазначения.ПустоеЗначениеТипа(Тип("Дата"));
#КонецЕсли
