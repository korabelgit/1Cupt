﻿Перем мЭтоНовый;

Перем мОбъектКопирования Экспорт;

Перем мСтруктураДоступа Экспорт;

Перем НеВыдаватьСообщенияПриЗаписиОбъекта Экспорт;

Перем мРежимБезЗаписи Экспорт;

Перем мПереписыватьВложения;

Перем мОбъектОснование Экспорт;

Перем мУдалятьДвижения;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

Процедура ЗменитьЗапрещенныеСимволыИмени(ИмяФайла)

	Если Найти(ИмяФайла,  "\") > 0 Тогда
		ИмяФайла = СтрЗаменить(ИмяФайла, "\", " ");
	КонецЕсли;
	Если Найти(ИмяФайла,  "/") > 0 Тогда
		ИмяФайла = СтрЗаменить(ИмяФайла, "/", " ");
	КонецЕсли;
	Если Найти(ИмяФайла,  ":") > 0 Тогда
		ИмяФайла = СтрЗаменить(ИмяФайла, ":", " ");
	КонецЕсли;
	Если Найти(ИмяФайла,  "*") > 0 Тогда
		ИмяФайла = СтрЗаменить(ИмяФайла, "*", " ");
	КонецЕсли;
	Если Найти(ИмяФайла,  "?") > 0 Тогда
		ИмяФайла = СтрЗаменить(ИмяФайла, "?", " ");
	КонецЕсли;
	Если Найти(ИмяФайла, """") > 0 Тогда
		ИмяФайла = СтрЗаменить(ИмяФайла, """", " ");
	КонецЕсли;
	Если Найти(ИмяФайла,  "<") > 0 Тогда
		ИмяФайла = СтрЗаменить(ИмяФайла, "<", " ");
	КонецЕсли;
	Если Найти(ИмяФайла,  ">") > 0 Тогда
		ИмяФайла = СтрЗаменить(ИмяФайла, ">", " ");
	КонецЕсли;
	Если Найти(ИмяФайла,  "|") > 0 Тогда
		ИмяФайла = СтрЗаменить(ИмяФайла, "|", " ");
	КонецЕсли;

КонецПроцедуры

#Если Клиент Тогда

Функция ЗахватитьТекст() Экспорт
	
	ИмяФайла = "Электронное письмо " + СокрЛП(Номер) + ?(ЗначениеЗаполнено(Тема), (" (" + СокрЛП(Тема) + ")"), "");
	ЗменитьЗапрещенныеСимволыИмени(ИмяФайла);
	Если СтрДлина(ИмяФайла) > 256 Тогда
		ИмяФайла = Лев(ИмяФайла, 256);
	КонецЕсли; 
	
	ИмяСохраненияФайла = РаботаСФайлами.ПолучитьИмяФайла(РаботаСФайлами.ПолучитьИмяКаталога(), (РаботаСФайлами.УдалитьЗапрещенныеСимволыИмени(ИмяФайла) + ".HTM"));
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Вывод = ИспользованиеВывода.Разрешить;
	ТекстовыйДокумент.УстановитьТекст(ТекстПисьма);	
	Попытка
		ТекстовыйДокумент.Записать(ИмяСохраненияФайла);
	Исключение
		ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки(),, "Не удалось сохранить файл на диск!");
		Возврат Ложь;
	КонецПопытки;
	
	Если НЕ УправлениеЭлектроннойПочтой.ОткрытьФайлДляРедактированияВнешнимХТМЛРедактором(ИмяСохраненияФайла) Тогда
		Файл = Новый Файл(ИмяСохраненияФайла);
		Если Файл.Существует() Тогда
			УдалитьФайлы(ИмяСохраненияФайла);
		КонецЕсли; 
		Возврат Ложь;
	КонецЕсли; 
	
	ИмяФайлаРедактированияХТМЛТекста      = ИмяСохраненияФайла;
	ИмяКомпьютераРедактированияХТМЛТекста = ИмяКомпьютера();
	
	ТекстПисьма = "<HTML><HEAD>
	|<META http-equiv=Content-Type content=""" + "text/html; charset=utf-8""" + ">
	|<META content=""" + "MSHTML 6.00.2800.1458""" + " name=GENERATOR></HEAD>
	|<BODY>
	|<P>Текст данного письма редактируется внешним редактором HTML текстов.</P>
	|<P><A href=""" + "ИмяФайлаРедактированияХТМЛТекста" + """>Перейдите по гиперссылке для начала редактирования.</A></P>
	|<P>(" + ИмяФайлаРедактированияХТМЛТекста + ")</A></P>
	|</BODY></HTML>";
	
	Возврат Истина;
	
КонецФункции

Процедура ОсвободитьТекст() Экспорт

	Если ИмяКомпьютера() <> ИмяКомпьютераРедактированияХТМЛТекста Тогда
		Сообщить("Файл редактируется на копмьютере""" + ИмяКомпьютераРедактированияХТМЛТекста + """" + ". Редактирование на текущем комьютере невозможно.");
		Возврат;
	КонецЕсли;
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	Попытка
		ТекстовыйДокумент.Прочитать(ИмяФайлаРедактированияХТМЛТекста);
	Исключение
		ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки(),, "Файл редактирования не удалось открыть.");
		Возврат;
	КонецПопытки;
	
	ТекстПисьма = ТекстовыйДокумент.ПолучитьТекст();
	
	Если ЗначениеЗаполнено(ИмяФайлаРедактированияХТМЛТекста) И НЕ ЗначениеЗаполнено(Ссылка.ИмяФайлаРедактированияХТМЛТекста) Тогда
		Попытка
			УдалитьФайлы(ИмяФайлаРедактированияХТМЛТекста);
		Исключение
		КонецПопытки;
	КонецЕсли; 

	ИмяКомпьютераРедактированияХТМЛТекста = "";
	ИмяФайлаРедактированияХТМЛТекста      = "";

КонецПроцедуры

#КонецЕсли

// Процедура заполняет группу по умолчанию у нового письма.
//
Процедура УказатьГруппуПоУмолчанию() Экспорт

	Если НЕ ЗначениеЗаполнено(ГруппаУчетнойЗаписи) ИЛИ ГруппаУчетнойЗаписи.Владелец <> УчетнаяЗапись Тогда
		ГруппаУчетнойЗаписи = УчетнаяЗапись.ГруппаИсходящие;
	КонецЕсли; 
	
КонецПроцедуры

#Если Клиент Тогда
	
// Процедура инициирует отправку письма.
//
Процедура ОтправитьПисьмо(ФормаПисьма = Неопределено) Экспорт

	ШапкаСообщения = "Не отправлено: " + Строка(ЭтотОбъект);
	
	Если СтатусПисьма = Перечисления.СтатусыПисем.Полученное ИЛИ СтатусПисьма = Перечисления.СтатусыПисем.Отправленное Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(Кому) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не указан ни один получатель.",, ШапкаСообщения);
		Возврат;
	КонецЕсли;
	
	Если ПометкаУдаления Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Нельзя отправлять помеченное на удаление письмо.",, ШапкаСообщения);
		Возврат;
	КонецЕсли;
	
	СтатусПисьма = Перечисления.СтатусыПисем.Исходящее;
	Если НЕ ЗначениеЗаполнено(Ответственный) Тогда
		Ответственный = глЗначениеПеременной("глТекущийПользователь");
	КонецЕсли; 
	
	Если ФормаПисьма <> Неопределено Тогда
		Попытка
			ФормаПисьма.ЗаписатьВФорме();
			ФормаПисьма.Закрыть();
		Исключение
			ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки(),, ШапкаСообщения);
			Возврат;
		КонецПопытки;
	Иначе
		Попытка
			ЭтотОбъект.Записать();
		Исключение
			ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки(),, ШапкаСообщения);
			Возврат;
		КонецПопытки;
	КонецЕсли; 
	
	Если мСтруктураДоступа.Запись.НайтиПоЗначению(УчетнаяЗапись) <> Неопределено Тогда
		УчетныеЗаписи = Новый Массив;
		УчетныеЗаписи.Добавить(УчетнаяЗапись);
		Письма = Новый Соответствие;
		Письма.Вставить(Ссылка, ЭтотОбъект);
		УправлениеЭлектроннойПочтой.ПолучениеОтправкаПисем(глЗначениеПеременной("глСоответствиеТекстовЭлектронныхПисем"), глЗначениеПеременной("глТекущийПользователь"), УчетныеЗаписи, Письма, Истина);
	КонецЕсли;

КонецПроцедуры

#КонецЕсли

// <Описание функции>
//
// Параметры
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   – <описание возвращаемого значения>
//
Функция СтрокаТаблицы(Значение1, Значение2)

	СтрокаВозврата = "<TR>
	|<TD class=R0C0>" + Значение1 + "</TD>
	|<TD class=R0C1><STRONG>" + Значение2 + "</STRONG></TD>
	|<TD>&nbsp;</TD></TR>";
	
	Возврат СтрокаВозврата;

КонецФункции // СтрокаТаблицы("Дата создания", Строка(Дата))()

// <Описание функции>
//
// Параметры
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   – <описание возвращаемого значения>
//
Функция ПредставлениеСтрокиДляHTML(ИсходнаяСтрока)

	СтрокаВозврата = ИсходнаяСтрока;
	
	СтрокаВозврата = СтрЗаменить(СтрокаВозврата, "<", "&lt;");
	СтрокаВозврата = СтрЗаменить(СтрокаВозврата, ">", "&gt;");
	
	Возврат СтрокаВозврата;

КонецФункции // ПредставлениеСтрокиДляHTML()

Процедура НапечататьПисьмо() Экспорт

	КодЯзыкаПечать = Локализация.ПолучитьЯзыкФормированияПечатныхФорм(УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "РежимФормированияПечатныхФорм"));
	ТекстОписанияЭлектронногоПисьма = НСтр("ru='Электронное письмо № ';uk='Електронний лист № '", КодЯзыкаПечать) + СокрЛП(Номер) + ", " + Дата + "<BR>" + ПредставлениеСтрокиДляHTML((СокрЛП(УчетнаяЗапись) + " <" + УчетнаяЗапись.АдресЭлектроннойПочты + ">"));
	
	ТекстВыходногоДокумента = "<HTML><HEAD>
	|<META http-equiv=Content-Type content="+""""+"text/html; charset=utf-8" +"""" +  ">
	|<META content=" + """" + "MSHTML 6.00.2800.1458" + """" + " name=GENERATOR></HEAD>
	|<BODY>
	|<H3 class=" + """" + """" + ">" + ТекстОписанияЭлектронногоПисьма + "</H2>
	|<HR>
	|<TABLE cellSpacing=0>
	|<TBODY>
	|<TR class=invisible>
	|<TD width=250></TD>
	|<TD width=460></TD>
	|<TD></TD></TR>
	|";
	
	ТекстВыходногоДокумента = ТекстВыходногоДокумента + СтрокаТаблицы(НСтр("ru='Дата создания:';uk='Дата створення:'", КодЯзыкаПечать), Строка(Дата));
	ТекстВыходногоДокумента = ТекстВыходногоДокумента + СтрокаТаблицы(НСтр("ru='Дата отправления:';uk='Дата відправлення:'", КодЯзыкаПечать), Строка(ДатаОтправления));
	ТекстВыходногоДокумента = ТекстВыходногоДокумента + СтрокаТаблицы(НСтр("ru='Отправитель:';uk='Відправник:'", КодЯзыкаПечать), ПредставлениеСтрокиДляHTML(ОтправительПредставление));
	
	Если КомуТЧ.Количество() > 0 Тогда
		ТекстВыходногоДокумента = ТекстВыходногоДокумента + СтрокаТаблицы(НСтр("ru='Получатели:';uk='Одержувачі:'", КодЯзыкаПечать), ПредставлениеСтрокиДляHTML((КомуТЧ[0].Представление + " <" + КомуТЧ[0].АдресЭлектроннойПочты + ">")));
		Для а = 1 По КомуТЧ.Количество() - 1 Цикл
			ТекстВыходногоДокумента = ТекстВыходногоДокумента + СтрокаТаблицы("", ПредставлениеСтрокиДляHTML((КомуТЧ[а].Представление + " <" + КомуТЧ[а].АдресЭлектроннойПочты + ">")));
		КонецЦикла; 
	КонецЕсли;
	
	Если КопииТЧ.Количество() > 0 Тогда
		ТекстВыходногоДокумента = ТекстВыходногоДокумента + СтрокаТаблицы(НСтр("ru='Копии:';uk='Копії:'", КодЯзыкаПечать), ПредставлениеСтрокиДляHTML((КопииТЧ[0].Представление + " <" + КопииТЧ[0].АдресЭлектроннойПочты + ">")));
		Для а = 1 По КопииТЧ.Количество() - 1 Цикл
			ТекстВыходногоДокумента = ТекстВыходногоДокумента + СтрокаТаблицы("", ПредставлениеСтрокиДляHTML((КопииТЧ[а].Представление + " <" + КопииТЧ[а].АдресЭлектроннойПочты + ">")));
		КонецЦикла; 
	КонецЕсли;
	
	ТекстВыходногоДокумента = ТекстВыходногоДокумента + СтрокаТаблицы(НСтр("ru='Тема:';uk='Тема:'", КодЯзыкаПечать), ПредставлениеСтрокиДляHTML(Тема));
	
	Если ЗначениеЗаполнено(ЗаявкаКандидата) Тогда
		ТекстВыходногоДокумента = ТекстВыходногоДокумента + СтрокаТаблицы(НСтр("ru='Кандидат:';uk='Кандидат:'", КодЯзыкаПечать), ПредставлениеСтрокиДляHTML(Строка(ЗаявкаКандидата)));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПредметКонтакта) Тогда
		ТекстВыходногоДокумента = ТекстВыходногоДокумента + СтрокаТаблицы(НСтр("ru='Предмет:';uk='Предмет:'", КодЯзыкаПечать), ПредставлениеСтрокиДляHTML(Строка(ПредметКонтакта)));
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(Ответственный) Тогда
		ТекстВыходногоДокумента = ТекстВыходногоДокумента + СтрокаТаблицы(НСтр("ru='Ответственный:';uk='Відповідальний:'", КодЯзыкаПечать), ПредставлениеСтрокиДляHTML(Строка(Ответственный)));
	КонецЕсли;
	
	ТекстВыходногоДокумента = ТекстВыходногоДокумента + "</TBODY></TABLE>
	|";
	
	ТекстВыходногоДокумента = ТекстВыходногоДокумента + "<HR>
	|";
	
	
	ТекстПисьмаДляПечати = ТекстПисьма;
	Если ВидТекстаПисьма = Перечисления.ВидыТекстовЭлектронныхПисем.HTML ИЛИ ВидТекстаПисьма = Перечисления.ВидыТекстовЭлектронныхПисем.HTMLСКартинками Тогда
		НовыйHTMLДокумент = Новый COMОбъект("HtmlFile");
		НовыйHTMLДокумент.open("text/html");
		НовыйHTMLДокумент.write(ТекстПисьмаДляПечати);
		НовыйHTMLДокумент.close();
		ТегBODY = НовыйHTMLДокумент.all.Tags("BODY");
		Если ТегBODY.length > 0 Тогда
			ТекстПисьмаДляПечати = НовыйHTMLДокумент.all.Tags("Body").item(0).innerHTML;
		КонецЕсли;
	Иначе
		ТекстПисьмаДляПечати = СтрЗаменить(ТекстПисьмаДляПечати, Символы.ПС, "<BR>");
	КонецЕсли;
	
	ТекстВыходногоДокумента = ТекстВыходногоДокумента + "<P>" + ТекстПисьмаДляПечати + "</P>
	|<HR>
	|<P>
	|<TABLE cellSpacing=0>
	|<TBODY>
	|<TR class=invisible>
	|<TD width=250></TD>
	|<TD width=460></TD>
	|<TD></TD></TR>
	|<TR>
	|<TD class=R0C0>"+НСтр("ru='Напечатано::';uk='Роздруковано:'", КодЯзыкаПечать)+"</TD>
	|<TD class=R0C1><STRONG>" + Строка(ТекущаяДата()) + "</STRONG></TD>
	|<TD>&nbsp;</TD></TR></TBODY></TABLE></P></BODY></HTML>";

	ФормаПечати = ПолучитьФорму("ФормаПечати");
	ФормаПечати.ЭлементыФормы.ПолеHTMLДокумента.УстановитьТекст(ТекстВыходногоДокумента);
	ФормаПечати.Заголовок = Строка(ЭтотОбъект);
	ФормаПечати.Открыть();
	
КонецПроцедуры

Процедура ЗаполнитьПредставленияПолейКомуКопии() Экспорт
	
	КомуПредставление = "";
	Для каждого СтрокаКому Из КомуТЧ Цикл
		КомуПредставление = КомуПредставление + ", " + ?(ПустаяСтрока(СтрокаКому.Представление), СтрокаКому.АдресЭлектроннойПочты, СтрокаКому.Представление);
	КонецЦикла;
	Если НЕ ПустаяСтрока(КомуПредставление) Тогда
		КомуПредставление = Сред(КомуПредставление, 3);
	КонецЕсли; 
	
	КопииПредставление = "";
	Для каждого СтрокаКопии Из КопииТЧ Цикл
		КопииПредставление = КопииПредставление + ", " + ?(ПустаяСтрока(СтрокаКопии.Представление), СтрокаКопии.АдресЭлектроннойПочты, СтрокаКопии.Представление);
	КонецЦикла; 
	Если НЕ ПустаяСтрока(КопииПредставление) Тогда
		КопииПредставление = Сред(КопииПредставление, 3);
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ОБЪЕКТА


// Процедура - обработчик события "ПередЗаписью" объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 
	
	Если мРежимБезЗаписи Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	РассмотретьПосле = НачалоМинуты(РассмотретьПосле);
	
	мЭтоНовый = ЭтоНовый();
	
	ШапкаСообщения = "Не записано: " + Строка(ЭтотОбъект);
	
	Если СтатусПисьма = Перечисления.СтатусыПисем.Полученное Тогда
		Если НЕ ЗначениеЗаполнено(Ответственный) И НЕ НеРассмотрено Тогда
			НеРассмотрено = Истина;
		КонецЕсли;
	ИначеЕсли СтатусПисьма = Перечисления.СтатусыПисем.Отправленное Тогда
		Если ЭтоНовый() Тогда
			Если НЕ ЗначениеЗаполнено(Ответственный) Тогда
				Ответственный = глЗначениеПеременной("глТекущийПользователь");
			КонецЕсли;
		Иначе
			Если Ответственный <> Ссылка.Ответственный Тогда
				Если НЕ НеВыдаватьСообщенияПриЗаписиОбъекта Тогда
					ОбщегоНазначения.СообщитьОбОшибке("Нельзя менять ответственного в отправленном электронном письме.",, ШапкаСообщения);
				КонецЕсли; 
				Отказ = Истина;
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли;
	
	// В группу Удаленные и Черновики нельзя записывать письма
	ГруппаУдаленные = мСтруктураДоступа.ГруппыУдаленные.Получить(УчетнаяЗапись);
	Если ГруппаУчетнойЗаписи = ГруппаУдаленные Тогда
		Если НЕ НеВыдаватьСообщенияПриЗаписиОбъекта Тогда
			ОбщегоНазначения.СообщитьОбОшибке(("Нельзя выбирать в качестве группы письма группу """ + ГруппаУдаленные + """, потому что она предназначена только для отображения удаленных писем."),, ШапкаСообщения);
		КонецЕсли; 
		Отказ = Истина;
	КонецЕсли;
	
	ГруппаЧерновики = мСтруктураДоступа.ГруппыЧерновики.Получить(УчетнаяЗапись);
	Если ГруппаУчетнойЗаписи = ГруппаЧерновики Тогда
		Если НЕ НеВыдаватьСообщенияПриЗаписиОбъекта Тогда
			ОбщегоНазначения.СообщитьОбОшибке(("Нельзя выбирать в качестве группы письма группу """ + ГруппаЧерновики + """, потому что она предназначена только для отображения черновиков писем."),, ШапкаСообщения);
		КонецЕсли; 
		Отказ = Истина;
	КонецЕсли; 
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьПредставленияПолейКомуКопии();
	
	Если УчетнаяЗапись.ЗаполнятьПустойПредметДляНовыхПисемИзТемыПисьма И ЭтоНовый() И НЕ ЗначениеЗаполнено(ПредметКонтакта) Тогда
		ПредметКонтакта = УправлениеЭлектроннойПочтой.ИсключитьПрефиксыТемыПисьма(Тема);
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(СтатусПисьма) Тогда
		СтатусПисьма = Перечисления.СтатусыПисем.Сохраненное;
	КонецЕсли; 
	
	Если СтатусПисьма <> Перечисления.СтатусыПисем.Полученное Тогда
		ОтправительИмя                   = УчетнаяЗапись.Наименование;
		ОтправительАдресЭлектроннойПочты = УчетнаяЗапись.АдресЭлектроннойПочты;
	КонецЕсли; 
	
	Если ПустаяСтрока(ОтправительПредставление) Тогда
		УстановитьПредставлениеОтправителя();
	КонецЕсли;
	
	Если ПустаяСтрока(ОтправительИмя) Тогда
		ОтправительИмя = ОтправительАдресЭлектроннойПочты;
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(ПредметКонтакта) Тогда
		ПредметКонтакта = "";
	КонецЕсли; 
	
	#Если Клиент Тогда
	Если НЕ ЭтоНовый() Тогда
	
		Выборка = Справочники.ВложенияЭлектронныхПисем.Выбрать(,, Новый Структура("Объект", Ссылка));
		
		НаличиеВложенийКартинок = Ложь;
		ЕстьВложения = Ложь;
		
		НайденноеСоответствие = глЗначениеПеременной("глСоответствиеТекстовЭлектронныхПисем").Получить(Ссылка);
		
		ТаблицаКартинок = Новый ТаблицаЗначений;
		ТаблицаКартинок.Колонки.Добавить("Данные");
		ТаблицаКартинок.Колонки.Добавить("ИмяФайла");
		ТаблицаКартинок.Колонки.Добавить("ИДФайлаПочтовогоПисьма");
		
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.ПометкаУдаления <> ПометкаУдаления Тогда
				Объект = Выборка.ПолучитьОбъект();
				Попытка
					Объект.УстановитьПометкуУдаления(ПометкаУдаления);
				Исключение
				КонецПопытки;
			КонецЕсли;
			
			Если НЕ ПустаяСтрока(Выборка.ИДФайлаПочтовогоПисьма) Тогда
				НаличиеВложенийКартинок = Истина;
				Если НайденноеСоответствие = Неопределено Тогда
					НоваяСтрокаТЗ = ТаблицаКартинок.Добавить();
					НоваяСтрокаТЗ.Данные                 = Выборка.Хранилище;
					НоваяСтрокаТЗ.ИДФайлаПочтовогоПисьма = Выборка.ИДФайлаПочтовогоПисьма;
				КонецЕсли;
			Иначе
				ЕстьВложения = Истина;
			КонецЕсли; 
		
		КонецЦикла;
		
		Если НайденноеСоответствие = Неопределено И ТаблицаКартинок.Количество() > 0 Тогда
			КопияТекстаПисьма = ТекстПисьма;
			УправлениеЭлектроннойПочтой.ПропарситьHTMLИДВ_ТекстКартинки(глЗначениеПеременной("глСоответствиеТекстовЭлектронныхПисем"), глЗначениеПеременной("глТекущийПользователь"), ТаблицаКартинок, КопияТекстаПисьма);
			глЗначениеПеременной("глСоответствиеТекстовЭлектронныхПисем").Вставить(Ссылка, КопияТекстаПисьма);
		КонецЕсли; 
		
		Если ВидТекстаПисьма = Перечисления.ВидыТекстовЭлектронныхПисем.HTML ИЛИ ВидТекстаПисьма = Перечисления.ВидыТекстовЭлектронныхПисем.HTMLСКартинками Тогда
			Если НаличиеВложенийКартинок = Истина Тогда
				ВидТекстаПисьма = Перечисления.ВидыТекстовЭлектронныхПисем.HTMLСКартинками;
			Иначе
				ВидТекстаПисьма = Перечисления.ВидыТекстовЭлектронныхПисем.HTML;
			КонецЕсли; 
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ИмяФайлаРедактированияХТМЛТекста) И ЗначениеЗаполнено(Ссылка.ИмяФайлаРедактированияХТМЛТекста) Тогда
			Попытка
				УдалитьФайлы(Ссылка.ИмяФайлаРедактированияХТМЛТекста);
			Исключение
			КонецПопытки;
		КонецЕсли; 
		
		Если ПредметКонтакта <> Ссылка.ПредметКонтакта И (ТипЗнч(ПредметКонтакта) <> Тип("Строка") ИЛИ ТипЗнч(Ссылка.ПредметКонтакта) <> Тип("Строка")) Тогда
			мПереписыватьВложения = Истина;
		КонецЕсли; 
		
	КонецЕсли; 
	#КонецЕсли
	
	// если помечаем на удаление - снимим флаг не рассмотренности
	Если НЕ Ссылка.ПометкаУдаления И ПометкаУдаления И НеРассмотрено Тогда
		НеРассмотрено = Ложь;
		РассмотретьПосле = Неопределено;
	КонецЕсли;
	
	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры

// Процедура - обработчик события "ПриКопировании" объекта.
//
Процедура ПриКопировании(ОбъектКопирования)
	
	мОбъектКопирования = ОбъектКопирования.Ссылка;
	
КонецПроцедуры

// Процедура - обработчик события "ПриЗаписи" объекта.
//
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 
	
	ШапкаСообщения = "Не записано: " + Строка(ЭтотОбъект);
	
	Если ЗначениеЗаполнено(ОснованиеПисьма)
		И 
		(    ТипЗнч(ОснованиеПисьма) = Тип("ДокументСсылка.ЭлектронноеПисьмо")
		 ИЛИ ТипЗнч(ОснованиеПисьма) = Тип("ДокументОбъект.ЭлектронноеПисьмо") ) Тогда
		
		Попытка
			Если ТипЗнч(мОбъектОснование) = Тип("ДокументОбъект.ЭлектронноеПисьмо") Тогда
				УправлениеЭлектроннойПочтой.УстановитьСвойстваОбъектаОснования(мОбъектОснование, Ответ, Переадресация, СтатусПисьма, УчетнаяЗапись, мЭтоНовый);
			Иначе
				ПолныеПрава.УстановитьСвойстваОбъектаОснования(ОснованиеПисьма, Ответ, Переадресация, СтатусПисьма, УчетнаяЗапись, мЭтоНовый);
			КонецЕсли;
		Исключение
			ЗаписьЖурналаРегистрации("Запись электронного письма",
			                         УровеньЖурналаРегистрации.Ошибка, Метаданные.Документы.ЭлектронноеПисьмо, ,
			                         ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
	КонецЕсли;
	
	ГруппаУдаленные = УчетнаяЗапись.ГруппаУдаленные;
	ГруппаЧерновики = УчетнаяЗапись.ГруппаЧерновики;
	
	Если ПометкаУдаления И ЗначениеЗаполнено(ГруппаУдаленные) Тогда
		ТекГруппа = ГруппаУдаленные;
	ИначеЕсли НЕ ПометкаУдаления И ЗначениеЗаполнено(ГруппаЧерновики) И СтатусПисьма = Перечисления.СтатусыПисем.Сохраненное Тогда
		ТекГруппа = ГруппаЧерновики;
	Иначе
		ТекГруппа = ГруппаУчетнойЗаписи;
	КонецЕсли; 
	
	// Записи регистра для отображения соответствия Группа писем/Предмет
	Набор = Движения.ПредметыЭлектронныхПисем;
	
	Набор.Прочитать();
	
	Если мЭтоНовый Тогда
		СкрытыйПредмет = Ложь;
	Иначе
		Если Набор.Количество() > 0 Тогда
			СкрытыйПредмет = Набор[0].Скрытый;
		Иначе
			СкрытыйПредмет = Ложь;
		КонецЕсли; 
	КонецЕсли; 
	
	Набор.Очистить();
	
	Если УчетнаяЗапись.ИспользоватьКлассификациюПисемПоПредметам И ЗначениеЗаполнено(ТекГруппа) И ТекГруппа.ИспользоватьПредметыПисем Тогда
		Запись = Набор.Добавить();
		Запись.ГруппаПисемЭлектроннойПочты = ТекГруппа;
		Запись.Предмет                     = ?(НЕ ЗначениеЗаполнено(ПредметКонтакта), "", ПредметКонтакта);
		Запись.Период                      = Дата;
		Запись.Скрытый                     = СкрытыйПредмет;
	КонецЕсли; 
	
	Попытка
		Набор.Записать();
	Исключение
		ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки(),, ШапкаСообщения);
		Отказ = Истина;
	КонецПопытки;
	
	Если Не Отказ И мПереписыватьВложения Тогда
		Выборка = Справочники.ВложенияЭлектронныхПисем.Выбрать(,, Новый Структура("Объект", Ссылка));
		Пока Выборка.Следующий() Цикл
			Объект = Выборка.ПолучитьОбъект();
			Попытка
				Объект.Записать();
			Исключение
			КонецПопытки; 
		КонецЦикла; 
		мПереписыватьВложения = Ложь;
	КонецЕсли; 
	
	Набор = Движения.ОбъектыЭлектронныхПисемИСобытий;
	Набор.Очистить();
	
КонецПроцедуры

Процедура УстановитьПредставлениеОтправителя() Экспорт
	
	Если НЕ ПустаяСтрока(УчетнаяЗапись.Наименование) И ПустаяСтрока(УчетнаяЗапись.АдресЭлектроннойПочты) Тогда
		ОтправительПредставление = УчетнаяЗапись.Наименование;
	ИначеЕсли ПустаяСтрока(УчетнаяЗапись.Наименование) И НЕ ПустаяСтрока(УчетнаяЗапись.АдресЭлектроннойПочты) Тогда
		ОтправительПредставление = УчетнаяЗапись.АдресЭлектроннойПочты;
	Иначе
		ОтправительПредставление = УчетнаяЗапись.Наименование + " <" + УчетнаяЗапись.АдресЭлектроннойПочты + ">";
	КонецЕсли;
	
КонецПроцедуры


мСтруктураДоступа = УправлениеЭлектроннойПочтой.ПолучитьДоступныеУчетныеЗаписи(глЗначениеПеременной("глТекущийПользователь"));
НеВыдаватьСообщенияПриЗаписиОбъекта = Ложь;
мРежимБезЗаписи = Ложь;
мПереписыватьВложения = Ложь;

