﻿////////////////////////////////////////////////////////////////////////////////
//     МОДУЛЬ ФОРМЫ ЭЛЕМЕНТА СПРАВОЧНИКА УЧЕТНЫЕ ЗАПИСИ ЭЛЕКТРОННОЙ ПОЧТЫ     //
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЕКЦИЯ ОБРАБОТЧИКОВ СОБЫТИЙ ФОРМЫ И ЭЛЕМЕНТОВ ФОРМЫ
//

// Обработчик события "при создании на сервере" формы
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Ссылка = Параметры.Ссылка;
	
	УчетнаяЗаписьСтруктура = Параметры.УчетнаяЗаписьСтруктура;
	
	ПортSMTP = УчетнаяЗаписьСтруктура.ПортSMTP;
	ПортPOP3 = УчетнаяЗаписьСтруктура.ПортPOP3;
	
	ДлительностьОжиданияСервера 		= УчетнаяЗаписьСтруктура.ВремяОжиданияСервера;
	ОставлятьКопииСообщенийНаСервере 	= УчетнаяЗаписьСтруктура.ОставлятьКопииСообщенийНаСервере;
	УдалятьПисьмаССервераЧерез 			= УчетнаяЗаписьСтруктура.УдалятьПисьмаССервераЧерез;
	КоличествоДнейУдаленияПисемССервера	= УчетнаяЗаписьСтруктура.КоличествоДнейУдаленияПисемССервера;
	УдалятьСообщенияССервер				= ?(УдалятьПисьмаССервераЧерез = 0, Ложь, Истина);
	
	ТребуетсяSMTPАутентификация = УчетнаяЗаписьСтруктура.ТребуетсяSMTPАутентификация;
	ПортSMTP = УчетнаяЗаписьСтруктура.ПортSMTP;
	ПортPOP3 = УчетнаяЗаписьСтруктура.ПортPOP3;
	
	ПользовательSMTP         = УчетнаяЗаписьСтруктура.ЛогинSMTP;
	ПарольSMTP               = УчетнаяЗаписьСтруктура.ПарольSMTP;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидимостьДоступностьЭлементовФормы();
	
КонецПроцедуры

// Обработчик события "при изменении" элемента формы "ТребуетсяДополнительнаяSMTPАутентификация".
// Устанавливает параметры аутентификации "по умолчанию", а так же
// снимает их при снятии флага необходимости дополнительной SMTP аутентификации.
//
&НаКлиенте
Процедура ТребуетсяSMTPАутентификацияПриИзменении(Элемент)
	
	УстановитьВидимостьДоступностьЭлементовФормы();
	
КонецПроцедуры


// Обработчик события нажатия на кнопку "УстановитьПортыПоУмолчанию".
// Устанавливает порты POP3 и SMTP серверов по умолчанию:
// для SMTP - 25, для POP3 - 110.
//
&НаКлиенте
Процедура УстановитьПортыПоУмолчаниюВыполнить()
	
	ПортSMTP = 25;
	ПортPOP3 = 110;
	
КонецПроцедуры

// Обработчик события "при изменении" элемента формы "ОставлятьКопииСообщенийНаСервере".
//
&НаКлиенте
Процедура ОставлятьКопииСообщенийНаСервереПриИзменении(Элемент)
	
	Если Не ОставлятьКопииСообщенийНаСервере Тогда
		УдалятьПисьмаССервераЧерез = Ложь;
	КонецЕсли;
	
	УстановитьВидимостьДоступностьЭлементовФормы();
	
КонецПроцедуры

// Обработчик события "при изменении" элемента формы "УдалятьСообщенияССервера".
//
&НаКлиенте
Процедура УдалятьСообщенияССервераПриИзменении(Элемент)
	
	УстановитьВидимостьДоступностьЭлементовФормы();
	
	Если УдалятьПисьмаССервераЧерез 
			И НЕ ЗначениеЗаполнено(КоличествоДнейУдаленияПисемССервера) Тогда
		КоличествоДнейУдаленияПисемССервера = 1;
	КонецЕсли;
	
КонецПроцедуры

// Единая процедура для установки доступности элементов формы в зависимости от условий
//
&НаКлиенте
Процедура УстановитьВидимостьДоступностьЭлементовФормы()
	
	Если ОставлятьКопииСообщенийНаСервере Тогда
		Элементы.УдалятьПисьмаССервераЧерез.Доступность = Истина;
		
		Если УдалятьПисьмаССервераЧерез Тогда
			Элементы.КоличествоДнейУдаленияПисемССервера.Доступность = Истина;
		Иначе
			Элементы.КоличествоДнейУдаленияПисемССервера.Доступность = Ложь;
		КонецЕсли;
		
	Иначе
		
		Элементы.УдалятьПисьмаССервераЧерез.Доступность = Ложь;
		Элементы.КоличествоДнейУдаленияПисемССервера.Доступность = Ложь;
		
	КонецЕсли;
	
	Элементы.ГруппаПараметры.Видимость = ТребуетсяSMTPАутентификация;
	
КонецПроцедуры

// Обработчик события нажатия на кнопку "ЗаполнитьДопПараметрыИВернуться".
// Выполняет проверку корректности значений реквизитов формы и возвращает
// управление в вызывающую среду с дополнительными заполненными параметрами
// учетной записи.
// 
&НаКлиенте
Процедура ЗаполнитьДопПараметрыИВернутьсяВыполнить()
	
	Оповестить("УстановкаДополнительныхПараметровУчетнойЗаписи", ЗаполнитьДополнительныеПараметры(), Ссылка);
	
	Закрыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЕКЦИЯ СЕРВИСНЫХ ФУНКЦИЙ
//

// Функция, формирующая параметры настроек перед передачей их в вызывающую среду.
//
// Возвращаемое значение:
// структура
// ключ "ПортSMTP", значение - число, порт SMTP
// ключ "ПортPOP3", значение - число, порт POP3
// ключ "ОставлятьКопииСообщенийНаСервере" - булево - признак того, что необходимо оставлять на сервере сообщения
// ключ "ПериодХраненияСообщенийНаСервере" - число - число дней, которое сообщение должно храниться на сервере
// ключ "ДлительностьОжиданияСервера", значение - число секунд ожидания успешного выполнения операции на сервере
// ключ "SMTPАутентификация", Перечисление.SMTPАутентификация
// ключ "ПользовательSMTP", значение - строка, имя пользователя SMTP аутентификации
// ключ "ПарольSMTP", значение - строка, пароль SMTP аутентификации
// ключ "СпособSMTPАутентификации"*, Перечисление.СпособSMTPАутентификации
//
// ключ "СпособPOP3Аутентификации" - Перечисление.СпособPOP3Аутентификации
//
// *- при аутентификации "АналогичноPOP3" тип аутентификации не устанавливается,
//    тем не менее происходит его копирование
//
// Все поля, при любых параметрах аутентификации заполняются. Таким образом в вызывающей
// среде остается только взять их как есть без дополнительной обработки.
//
&НаКлиенте
Функция ЗаполнитьДополнительныеПараметры()
	
	Результат = Новый Структура;
	
	Результат.Вставить("ПортSMTP", 				ПортSMTP);
	Результат.Вставить("ПортPOP3", 				ПортPOP3);
	Результат.Вставить("ВремяОжиданияСервера", 	ДлительностьОжиданияСервера);
	
	Результат.Вставить("ОставлятьКопииСообщенийНаСервере", ОставлятьКопииСообщенийНаСервере);
	
	Если УдалятьПисьмаССервераЧерез Тогда
		КоличествоДнейУдаленияПисемССервера = КоличествоДнейУдаленияПисемССервера;
	Иначе
		КоличествоДнейУдаленияПисемССервера = 0;
	КонецЕсли;
	Результат.Вставить("ОставлятьКопииСообщенийНаСервере", 		ОставлятьКопииСообщенийНаСервере);
	Результат.Вставить("УдалятьПисьмаССервераЧерез", 			УдалятьПисьмаССервераЧерез);
	Результат.Вставить("КоличествоДнейУдаленияПисемССервера", 	КоличествоДнейУдаленияПисемССервера);
	
	Результат.Вставить("ВремяОжиданияСервера", ДлительностьОжиданияСервера);
	
	Результат.Вставить("ТребуетсяSMTPАутентификация", ТребуетсяSMTPАутентификация);
	Результат.Вставить("ЛогинSMTP", ?(ТребуетсяSMTPАутентификация, ПользовательSMTP, ""));
	Результат.Вставить("ПарольSMTP", ?(ТребуетсяSMTPАутентификация, ПарольSMTP, ""));
	
	Возврат Результат;
	
КонецФункции

