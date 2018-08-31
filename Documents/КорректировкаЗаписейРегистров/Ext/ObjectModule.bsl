﻿Перем ЗапретОткрытияДокумента Экспорт;
////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

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

	Если ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда

		ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
		
		Если ТабДокумент = Неопределено Тогда
			Возврат
		КонецЕсли; 
		
	КонецЕсли;

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект), Ссылка);

КонецПроцедуры // Печать

// Возвращает доступные табличные части для заполнения
//
// Возвращаемое значение:
//   Список значений с именами табличных частей
//
Функция ПолучитьТабличныеЧастиДляЗаполнения() Экспорт

	ТабличныеЧасти = Новый СписокЗначений;
	
	Возврат ТабличныеЧасти;

КонецФункции // ПолучитьТабличныеЧастиДляЗаполнения()

#КонецЕсли

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

// Копирует значения движения в строку сторно нового движения
// для измерений и реквизитов. Ресурсы инвертируются
//
Процедура ЗаполнитьДвижениеСторно(Движение, Строка, МетаданныеОбъект)

	ЗаполнитьЗначенияСвойств(Движение, Строка,,"Период,Регистратор,ВидДвижения");
	
	// вид движения
	Если МетаданныеОбъект.ВидРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки Тогда
		Движение.ВидДвижения = Строка.ВидДвижения;
	КонецЕсли;
	
	// ресурсы
	Для Каждого МДОбъект из МетаданныеОбъект.Ресурсы Цикл
		Движение[МДОбъект.Имя] = - Строка[МДОбъект.Имя];
	КонецЦикла;

КонецПроцедуры // ЗаполнитьДвижениеСторно

// Копирует значения движения по регистру бухгалтерии в строку сторно я
// нового движени для измерений и реквизитов. Ресурсы инвертируются
//
Процедура ЗаполнитьДвиженияСторноПоРегиструБухгалтерии(Движение, Строка, МетаданныеОбъект)

	ЗаполнитьЗначенияСвойств(Движение, Строка,,"Период,Регистратор");
	
	// субконто
	Если МетаданныеОбъект.Корреспонденция Тогда

		Для каждого Субконто Из Строка.СубконтоДт Цикл
			Движение.СубконтоДт[Субконто.Ключ] = Субконто.Значение;
		КонецЦикла;

		Для каждого Субконто Из Строка.СубконтоКт Цикл
			Движение.СубконтоКт[Субконто.Ключ] = Субконто.Значение;
		КонецЦикла;

	Иначе

		Для каждого Субконто Из Строка.Субконто Цикл
			Движение.Субконто[Субконто.Ключ] = Субконто.Значение;
		КонецЦикла;

	КонецЕсли;
	
	// ресурсы
	Для Каждого МДОбъект из МетаданныеОбъект.Ресурсы Цикл

		Если МДОбъект.ПризнакУчета = Неопределено Тогда
			Движение[МДОбъект.Имя] = - Строка[МДОбъект.Имя];
		Иначе

			Если ЗначениеЗаполнено(Строка[МДОбъект.Имя + "Дт"]) Тогда
				Движение[МДОбъект.Имя + "Дт"] = - Строка[МДОбъект.Имя + "Дт"];
			КонецЕсли;

			Если ЗначениеЗаполнено(Строка[МДОбъект.Имя + "Кт"]) Тогда
				Движение[МДОбъект.Имя + "Кт"] = - Строка[МДОбъект.Имя + "Кт"];
			КонецЕсли;

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры // ЗаполнитьДвиженияСторноПоРегиструБухгалтерии()

// Копирует значения движения в строку сторно нового движения
// для измерений и реквизитов. Ресурсы инвертируются
//
Процедура ЗаполнитьДвижениеСторноПоРегиструРасчета(Движение, Строка, МетаданныеОбъект)

	ЗаполнитьЗначенияСвойств(Движение, Строка);
	
	// ресурсы
	Для Каждого МДОбъект из МетаданныеОбъект.Ресурсы Цикл
		Движение[МДОбъект.Имя] = - Строка[МДОбъект.Имя];
	КонецЦикла;
	
	// сторно отдельно
	Движение.Сторно = НЕ Строка.Сторно;

КонецПроцедуры // ЗаполнитьДвижениеСторноПоРегиструРасчета

// Процедура выполняет сторнирование документа
//
Процедура СторнированиеДокумента(СторнируемыйДокумент, ДействиеНеВыполнено, СторнироватьРегистры = истина, СторнироватьПроводки = истина) 
	
	Если НЕ ЗначениеЗаполнено(СторнируемыйДокумент) Тогда
		Сообщить("Не выбран сторнируемый документ.");
		ДействиеНеВыполнено = Истина;
		Возврат;
	КонецЕсли;
	
	МетаданныеДокумент	= СторнируемыйДокумент.Метаданные();
	МетаданныеДвиженияКорректировкаЗаписейРегистров = ЭтотОбъект.Метаданные().Движения;

	Для Каждого МетаданныеРегистр Из МетаданныеДокумент.Движения Цикл

		// если документ "Корректировка записей регистров" не может иметь таких движений,
		// то это не сторнируемый регистр
		Если НЕ МетаданныеДвиженияКорректировкаЗаписейРегистров.Содержит(МетаданныеРегистр) Тогда
			Продолжить;
		КонецЕсли;
		
		НаборДвижений = Движения[МетаданныеРегистр.Имя];
		
		ЭтоРегистрБухгалтерии = Ложь;
		ЭтоРегистрРасчета = Ложь;
		Если СторнироватьПроводки И Метаданные.РегистрыБухгалтерии.Содержит(МетаданныеРегистр) Тогда
			
			СторнируемыйНаборЗаписей = РегистрыБухгалтерии[МетаданныеРегистр.Имя].СоздатьНаборЗаписей();
			ЭтоРегистрБухгалтерии = Истина;
			
		ИначеЕсли СторнироватьРегистры И Метаданные.РегистрыНакопления.Содержит(МетаданныеРегистр) Тогда
		   
			СторнируемыйНаборЗаписей = РегистрыНакопления[МетаданныеРегистр.Имя].СоздатьНаборЗаписей();
			
		ИначеЕсли СторнироватьРегистры И Метаданные.РегистрыРасчета.Содержит(МетаданныеРегистр) Тогда
		   
			СторнируемыйНаборЗаписей = РегистрыРасчета[МетаданныеРегистр.Имя].СоздатьНаборЗаписей();
			ЭтоРегистрРасчета = Истина;
		
		Иначе
			Продолжить;
		КонецЕсли;
		
		СторнируемыйНаборЗаписей.Отбор.Регистратор.Значение = СторнируемыйДокумент;
		СторнируемыйНаборЗаписей.Прочитать();
		
		Для Каждого ДвижениеСторнируемое Из СторнируемыйНаборЗаписей Цикл

			ДвижениеСторно = НаборДвижений.Добавить();
			
			// реквизиты
			Если ЭтоРегистрБухгалтерии Тогда
				ЗаполнитьДвиженияСторноПоРегиструБухгалтерии(ДвижениеСторно, ДвижениеСторнируемое, МетаданныеРегистр);
				ДвижениеСторно.Период = Дата;

			ИначеЕсли ЭтоРегистрРасчета Тогда
				ЗаполнитьДвижениеСторноПоРегиструРасчета(ДвижениеСторно, ДвижениеСторнируемое, МетаданныеРегистр);
				ДвижениеСторно.ПериодРегистрации = НачалоМесяца(Дата);

			Иначе
				ЗаполнитьДвижениеСторно(ДвижениеСторно, ДвижениеСторнируемое, МетаданныеРегистр);
				ДвижениеСторно.Период = Дата;
				
			КонецЕсли;

			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры


// Копирует значения движения в строку нового движения
// для измерений и реквизитов
Процедура ЗаполнитьДвижениеКопия(Движение, Строка, МетаданныеОбъект)

	ЗаполнитьЗначенияСвойств(Движение, Строка,,"Период,Регистратор,ВидДвижения");
	
	// вид движения
	Если МетаданныеОбъект.ВидРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки Тогда
		Движение.ВидДвижения = Строка.ВидДвижения;
	КонецЕсли;
	
	// ресурсы
	Для Каждого МДОбъект из МетаданныеОбъект.Ресурсы Цикл
		Движение[МДОбъект.Имя] = Строка[МДОбъект.Имя];
	КонецЦикла;

КонецПроцедуры // ЗаполнитьДвижениеКопия

// Копирует значения движения по регистру бухгалтерии в строку копии
// нового движения для измерений и реквизитов.
Процедура ЗаполнитьДвиженияКопияПоРегиструБухгалтерии(Движение, Строка, МетаданныеОбъект)

	ЗаполнитьЗначенияСвойств(Движение, Строка,,"Период,Регистратор");
	
	// субконто
	Если МетаданныеОбъект.Корреспонденция Тогда

		Для каждого Субконто Из Строка.СубконтоДт Цикл
			Движение.СубконтоДт[Субконто.Ключ] = Субконто.Значение;
		КонецЦикла;

		Для каждого Субконто Из Строка.СубконтоКт Цикл
			Движение.СубконтоКт[Субконто.Ключ] = Субконто.Значение;
		КонецЦикла;

	Иначе

		Для каждого Субконто Из Строка.Субконто Цикл
			Движение.Субконто[Субконто.Ключ] = Субконто.Значение;
		КонецЦикла;

	КонецЕсли;
	
	// ресурсы
	Для Каждого МДОбъект из МетаданныеОбъект.Ресурсы Цикл

		Если МДОбъект.ПризнакУчета = Неопределено Тогда
			Движение[МДОбъект.Имя] = Строка[МДОбъект.Имя];
		Иначе

			Если ЗначениеЗаполнено(Строка[МДОбъект.Имя + "Дт"]) Тогда
				Движение[МДОбъект.Имя + "Дт"] = Строка[МДОбъект.Имя + "Дт"];
			КонецЕсли;

			Если ЗначениеЗаполнено(Строка[МДОбъект.Имя + "Кт"]) Тогда
				Движение[МДОбъект.Имя + "Кт"] = Строка[МДОбъект.Имя + "Кт"];
			КонецЕсли;

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры // ЗаполнитьДвиженияКопияПоРегиструБухгалтерии()

// Копирует значения движения в строку копии нового движения
// для измерений и реквизитов. 
Процедура ЗаполнитьДвижениеКопияПоРегиструРасчета(Движение, Строка, МетаданныеОбъект)

	ЗаполнитьЗначенияСвойств(Движение, Строка);
	
	// ресурсы
	Для Каждого МДОбъект из МетаданныеОбъект.Ресурсы Цикл
		Движение[МДОбъект.Имя] = Строка[МДОбъект.Имя];
	КонецЦикла;
	
	// сторно отдельно
	Движение.Сторно = Строка.Сторно;

КонецПроцедуры // ЗаполнитьДвижениеКопияПоРегиструРасчета


// Процедура выполняет копирование движений документа
Процедура КопированиеДвиженийДокумента(КопируемыйДокумент, ДействиеНеВыполнено) 
	
	Если НЕ ЗначениеЗаполнено(КопируемыйДокумент) Тогда
		Сообщить("Не выбран копируемый документ.");
		ДействиеНеВыполнено = Истина;
		Возврат;
	КонецЕсли;
	
	МетаданныеДокумент	= КопируемыйДокумент.Метаданные();
	МетаданныеДвиженияКорректировкаЗаписейРегистров = ЭтотОбъект.Метаданные().Движения;

	Для Каждого МетаданныеРегистр Из МетаданныеДокумент.Движения Цикл

		// если документ "Корректировка записей регистров" не может иметь таких движений,
		// то это не копируемый регистр
		Если НЕ МетаданныеДвиженияКорректировкаЗаписейРегистров.Содержит(МетаданныеРегистр) Тогда
			Продолжить;
		КонецЕсли;
		
		НаборДвижений = Движения[МетаданныеРегистр.Имя];
		
		ЭтоРегистрБухгалтерии = Ложь;
		ЭтоРегистрРасчета = Ложь;
		Если Метаданные.РегистрыБухгалтерии.Содержит(МетаданныеРегистр) Тогда
			
			КопируемыйНаборЗаписей = РегистрыБухгалтерии[МетаданныеРегистр.Имя].СоздатьНаборЗаписей();
			ЭтоРегистрБухгалтерии = Истина;
			
		ИначеЕсли Метаданные.РегистрыНакопления.Содержит(МетаданныеРегистр) Тогда
		   
			КопируемыйНаборЗаписей = РегистрыНакопления[МетаданныеРегистр.Имя].СоздатьНаборЗаписей();
			
		ИначеЕсли Метаданные.РегистрыРасчета.Содержит(МетаданныеРегистр) Тогда
		   
			КопируемыйНаборЗаписей = РегистрыРасчета[МетаданныеРегистр.Имя].СоздатьНаборЗаписей();
			ЭтоРегистрРасчета = Истина;
		
		Иначе
			Продолжить;
		КонецЕсли;
		
		КопируемыйНаборЗаписей.Отбор.Регистратор.Значение = КопируемыйДокумент;
		КопируемыйНаборЗаписей.Прочитать();
		
		Для Каждого ДвижениеКопируемое Из КопируемыйНаборЗаписей Цикл

			ДвижениеКопия = НаборДвижений.Добавить();
			
			// реквизиты
			Если ЭтоРегистрБухгалтерии Тогда
				
				ЗаполнитьДвиженияКопияПоРегиструБухгалтерии(ДвижениеКопия, ДвижениеКопируемое, МетаданныеРегистр);
				ДвижениеКопия.Период = Дата;

			ИначеЕсли ЭтоРегистрРасчета Тогда
				
				ЗаполнитьДвижениеКопияПоРегиструРасчета(ДвижениеКопия, ДвижениеКопируемое, МетаданныеРегистр);
				ДвижениеКопия.ПериодРегистрации = НачалоМесяца(Дата);

			Иначе
				
				ЗаполнитьДвижениеКопия(ДвижениеКопия, ДвижениеКопируемое, МетаданныеРегистр);
				ДвижениеКопия.Период = Дата;
				
			КонецЕсли;

		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры // КопированиеДвиженийДокумента

// Процедура запускает выполнение действий, указанных в табличной части "Выполняемые действия"
//
Процедура ВыполнитьДействияДокумента() Экспорт
	
	Если ЗаполнениеДвижений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли; 
	
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	// проверка заполнения ТЧ "Выполняемые действия"
	ЕстьОшибки = Ложь;
	СтруктураОбязательныхПолей = Новый Структура("Действие");
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "ЗаполнениеДвижений", СтруктураОбязательныхПолей, ЕстьОшибки, Заголовок);
	Если ЕстьОшибки Тогда
		Сообщить("Указанные в табличной части действия не выполнены");
		Возврат;
	КонецЕсли;
	
	// очистка существующих движений
	ОчищатьДвижения = Ложь;
	Для каждого Набор Из Движения Цикл
		
		Если Набор.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		#Если Клиент Тогда		
			
		Если НЕ ОчищатьДвижения Тогда
			
			Ответ = Вопрос("Существующие движения регистров и проводки будут очищены. Продолжить?", РежимДиалогаВопрос.ДаНет,,,"Заполнить движения");
			Если Ответ = КодВозвратаДиалога.Нет Тогда
				Возврат;
			КонецЕсли;
			
			ОчищатьДвижения = Истина;
		КонецЕсли;
		
		#КонецЕсли
		
		Набор.Очистить();
		
	КонецЦикла;
	Если ТаблицаРегистровНакопления.Количество() > 0 Тогда
		ТаблицаРегистровНакопления.Очистить();
	КонецЕсли;
	Если ТаблицаРегистровСведений.Количество() > 0 Тогда
		ТаблицаРегистровСведений.Очистить();
	КонецЕсли;
	Если ТаблицаРегистровРасчета.Количество() > 0 Тогда
		ТаблицаРегистровРасчета.Очистить();
	КонецЕсли;
	Если ТаблицаРегистровБухгалтерии.Количество() > 0 Тогда
		ТаблицаРегистровБухгалтерии.Очистить();
	КонецЕсли;
	
	// выполнение действий указанных в ТЧ "Выполняемые действия" документа
	Для каждого СтрокаТЧ из ЗаполнениеДвижений Цикл
		
		ДействиеНеВыполнено = Ложь;
		Если ТипЗнч(СтрокаТЧ.Действие) = Тип("Строка") Тогда
			
			Если СтрокаТЧ.Действие = "Сторно движений документа" Тогда
				СторнированиеДокумента(СтрокаТЧ.Документ,ДействиеНеВыполнено);
				Если ДействиеНеВыполнено Тогда
					Сообщить("Действие в строке "+СтрокаТЧ.НомерСтроки+" не выполнено!",СтатусСообщения.Важное);
				КонецЕсли;
			ИначеЕсли СтрокаТЧ.Действие = "Копирование движений документа" Тогда
				КопированиеДвиженийДокумента(СтрокаТЧ.Документ, ДействиеНеВыполнено);
				Если ДействиеНеВыполнено Тогда
					Сообщить("Действие в строке "+СтрокаТЧ.НомерСтроки+" не выполнено!",СтатусСообщения.Важное);
				КонецЕсли;
			Иначе
				Сообщить("Неправильное наименование базового действия, строка № "+СтрокаТЧ.НомерСтроки+" не обработана.");
			КонецЕсли;
			
		Иначе
			
			#Если Клиент Тогда
				
			ИмяФайла = КаталогВременныхФайлов()+"PrnForm.tmp";
			ОбъектВнешнейФормы = СтрокаТЧ.Действие.ПолучитьОбъект();
			
			Если ОбъектВнешнейФормы = Неопределено Тогда
				Сообщить("Строка "+СтрокаТЧ.НомерСтроки+". Ошибка получения внешней обработки действия. Возможно обработка была удалена", СтатусСообщения.Важное);
				Возврат;
			КонецЕсли;
			
			ДвоичныеДанные = ОбъектВнешнейФормы.ХранилищеВнешнейОбработки.Получить();
			ДвоичныеДанные.Записать(ИмяФайла);
			Попытка
				Обработка = ВнешниеОбработки.Создать(ИмяФайла);
			Исключение
				Сообщить("Строка "+СтрокаТЧ.НомерСтроки+". Ошибка исполнения внешней обработки действия."+Символы.ПС+ОписаниеОшибки(), СтатусСообщения.Важное);
				Возврат;
			КонецПопытки;
			
			Попытка
				Обработка.Инициализировать(СтрокаТЧ.Документ, ЭтотОбъект,ДействиеНеВыполнено);
				Если ДействиеНеВыполнено Тогда
					Сообщить("Действие в строке "+СтрокаТЧ.НомерСтроки+" не выполнено!",СтатусСообщения.Важное);
				КонецЕсли;
			Исключение
				ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки(),, "Действие в строке "+СтрокаТЧ.НомерСтроки+" не выполнено!");
			КонецПопытки;
			
			#КонецЕсли
			
		КонецЕсли;
	КонецЦикла;
	
	//обновить настройки
	Для каждого Набор Из Движения Цикл
		Если Набор.Количество() > 0 Тогда
			МетаданныеРегистр = Набор.Метаданные();
			
			Если Метаданные.РегистрыНакопления.Содержит(МетаданныеРегистр) Тогда
				НоваяСтрока = ТаблицаРегистровНакопления.Добавить();
				НоваяСтрока.Имя = МетаданныеРегистр.Имя;
				НоваяСтрока.Представление = МетаданныеРегистр.Синоним;
			ИначеЕсли Метаданные.РегистрыСведений.Содержит(МетаданныеРегистр) Тогда
				НоваяСтрока = ТаблицаРегистровСведений.Добавить();
				НоваяСтрока.Имя = МетаданныеРегистр.Имя;
				НоваяСтрока.Представление = МетаданныеРегистр.Синоним;
			ИначеЕсли Метаданные.РегистрыРасчета.Содержит(МетаданныеРегистр) Тогда
				НоваяСтрока = ТаблицаРегистровРасчета.Добавить();
				НоваяСтрока.Имя = МетаданныеРегистр.Имя;
				НоваяСтрока.Представление = МетаданныеРегистр.Синоним;
			ИначеЕсли Метаданные.РегистрыБухгалтерии.Содержит(МетаданныеРегистр) Тогда
				НоваяСтрока = ТаблицаРегистровБухгалтерии.Добавить();
				НоваяСтрока.Имя = МетаданныеРегистр.Имя;
				НоваяСтрока.Представление = МетаданныеРегистр.Синоним;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Процедура устанавливает/снимает признак активности движений документа
//
Процедура УстановитьАктивностьДвижений(ФлагАктивности)
	
	ТаблицаДвижений = ПолныеПрава.ОпределитьНаличиеДвиженийПоРегистратору(Ссылка);
	
	Для Каждого СтрокаТаблицыДвижений Из ТаблицаДвижений Цикл
		
		// Имя регистра передается как значение, 
		// полученное с помощью функции ПолноеИмя() метаданных регистра
		ПозицияТочки = Найти(СтрокаТаблицыДвижений.Имя, ".");
		ТипРегистра = Лев(СтрокаТаблицыДвижений.Имя, ПозицияТочки - 1);
		ИмяРегистра = СокрП(Сред(СтрокаТаблицыДвижений.Имя, ПозицияТочки + 1));
		
		Движение = Движения[ИмяРегистра];
		Движение.Прочитать();

		Для Каждого Строка Из Движение Цикл
			Строка.Активность = ФлагАктивности;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры // УстановитьАктивностьДвижений()

Процедура ПриКопировании(ОбъектКопирования)
	
	Если ТипЗнч(ОбъектКопирования) <> Тип("ДокументОбъект.КорректировкаЗаписейРегистров") Тогда
		Возврат;
	КонецЕсли;
	Заголовок = "Копирование документа: "+СокрЛП(ОбъектКопирования);
	ТаблицаРегистров_ДвиженияДокументаОснования = ПолныеПрава.ОпределитьНаличиеДвиженийПоРегистратору(ОбъектКопирования.Ссылка);
	Для каждого Строка из ТаблицаРегистров_ДвиженияДокументаОснования цикл
		//В таблице имя регистра хранится в виде РегистрСведений.<ИмяРегистра>, РегистрНакопления.<ИмяРегистра> и т.д.
		ПолноеИмяРегистра = СокрЛП(Строка.Имя);
		ПозицияТочки = Найти(ПолноеИмяРегистра,".");
		ТипРегистра = Лев(ПолноеИмяРегистра,ПозицияТочки-1);
		//Для получения метаданных тип регистра должен быть не РегистрНакопления а РегистрыНакопления - необходимо изменить тип регистра
		ТипРегистра = СтрЗаменить(ТипРегистра,"Регистр","Регистры");
		ИмяРегистра = Прав(СокрЛП(Строка.Имя),стрДлина(СокрЛП(Строка.Имя))-ПозицияТочки);
		МетаданныеРегистра = Метаданные[ТипРегистра][ИмяРегистра];
		Если НЕ (ПравоДоступа("Изменение", МетаданныеРегистра) И ПравоДоступа("Чтение", МетаданныеРегистра)) Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Недостаточно прав доступа к регистру """+ИмяРегистра+"""",ЗапретОткрытияДокумента,Заголовок);
			Продолжить;
		КонецЕсли;
		Набор = ОбъектКопирования.Движения[ИмяРегистра];
		//Используется попытка на случай наличия ограничений доступа к регистру на уровне записей
		Попытка
			Набор.Прочитать();
		Исключение
			ОбщегоНазначения.СообщитьОбОшибке("Установлено ограничение доступа на уровне записей к регистру """+ИмяРегистра+"""",ЗапретОткрытияДокумента,Заголовок);
			Продолжить;
		КонецПопытки;
		
		НаборТекущегоОбъекта = Движения[ИмяРегистра];
		Если Найти(нрег(ТипРегистра),"бухгалтерии")<>0 Тогда
			Для каждого ЗаписьНабора Из Набор Цикл
				
				НоваяЗапись = НаборТекущегоОбъекта.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяЗапись, ЗаписьНабора,,"Период,Регистратор,СубконтоДт,СубконтоКт");
				
				Для каждого Субконто Из ЗаписьНабора.СубконтоДт Цикл
					НоваяЗапись.СубконтоДт[Субконто.Ключ] = Субконто.Значение;
				КонецЦикла;

				Для каждого Субконто Из ЗаписьНабора.СубконтоКт Цикл
					НоваяЗапись.СубконтоКт[Субконто.Ключ] = Субконто.Значение;
				КонецЦикла;
				НоваяЗапись.Период      = ТекущаяДата();
			КонецЦикла;
		Иначе
			Для каждого ЗаписьНабора Из Набор Цикл
			
				НоваяЗапись = НаборТекущегоОбъекта.Добавить();
				Если Найти(нрег(ТипРегистра),"накопления")<>0 Тогда
					Если МетаданныеРегистра.ВидРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки Тогда
						НоваяЗапись.ВидДвижения = ЗаписьНабора.ВидДвижения;
					КонецЕсли;
					ЗаполнитьЗначенияСвойств(НоваяЗапись, ЗаписьНабора,,"Период,Регистратор,ВидДвижения")
				Иначе
					Если Найти(нрег(ТипРегистра), "расчета") <> 0 Тогда
						ЗаполнитьЗначенияСвойств(НоваяЗапись, ЗаписьНабора,,"Регистратор");
					Иначе
						ЗаполнитьЗначенияСвойств(НоваяЗапись, ЗаписьНабора,,"Период,Регистратор");
					КонецЕсли;	
				КонецЕсли;
				Если Найти(нрег(ТипРегистра), "расчета") = 0 Тогда
					НоваяЗапись.Период      = ТекущаяДата();
				КонецЕсли;	
			КонецЦикла; 
		КонецЕсли;
	КонецЦикла;
	Если  ЗапретОткрытияДокумента Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Документ не может быть скопирован!",ЗапретОткрытияДокумента,Заголовок);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоНовый() И ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "ПометкаУдаления") <> ПометкаУдаления Тогда
		УстановитьАктивностьДвижений(НЕ ПометкаУдаления);
	ИначеЕсли ПометкаУдаления Тогда
		//запись помеченного на удаление документа с активными записями
		УстановитьАктивностьДвижений(Ложь);
	КонецЕсли;
	
КонецПроцедуры

ЗапретОткрытияДокумента = Ложь;
