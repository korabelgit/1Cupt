﻿Перем мУдалятьДвижения;

// Текущие курс и кратность валюты документа для расчетов
Перем КурсДокумента Экспорт;
Перем КратностьДокумента Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

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
Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт

	Если ЭтоНовый() Тогда
		Предупреждение("Документ можно распечатать только после его записи");
		Возврат;
	ИначеЕсли Не УправлениеДопПравамиПользователей.РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
		Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
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

#КонецЕсли

// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()


// Формирует структуру полей, обязательных для заполнения при отражении движения средств.
//
// Возвращаемое значение:
//   СтруктураОбязательныхПолей   – структура для проверки
//
Функция СтруктураОбязательныхПолей()

	СтруктураПолей=Новый Структура;
	СтруктураПолей.Вставить("Касса");
	СтруктураПолей.Вставить("КассаПолучатель");
	СтруктураПолей.Вставить("СуммаДокумента");

	Возврат СтруктураПолей;

КонецФункции // СтруктураОбязательныхПолейОплатаУпр()

// Формирует движения по регистрам
// СтруктураКурсыВалют - структура, содержащая курсы необходимых для расчетов валют.
//
Процедура ДвиженияПоРегистрам(СтруктураКурсыВалют)
	
	СуммаУпр = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(СуммаДокумента, СтруктураКурсыВалют.ВалютаДокумента,
			СтруктураКурсыВалют.ВалютаУпрУчета, 
			СтруктураКурсыВалют.ВалютаДокументаКурс,
			СтруктураКурсыВалют.ВалютаУпрУчетаКурс, 
			СтруктураКурсыВалют.ВалютаДокументаКратность,
			СтруктураКурсыВалют.ВалютаУпрУчетаКратность);
			
	// По регистру "Денежные средства к получению"
	НаборДвижений = Движения.ДенежныеСредстваКПолучению;
	ТаблицаДвижений = НаборДвижений.Выгрузить();

	СтрокаДвижений = ТаблицаДвижений.Добавить();
	СтрокаДвижений.БанковскийСчетКасса = КассаПолучатель;
	СтрокаДвижений.Организация 		   = КассаПолучатель.Владелец;
	СтрокаДвижений.ВидДенежныхСредств  = Перечисления.ВидыДенежныхСредств.Наличные;
	СтрокаДвижений.Сумма               = СуммаДокумента;
	СтрокаДвижений.СуммаУпр            = СуммаУпр;
	СтрокаДвижений.ДокументПолучения   = Ссылка;
	СтрокаДвижений.СтатьяДвиженияДенежныхСредств    = СтатьяДвиженияДенежныхСредств;
	
	НаборДвижений.мПериод          = Дата;
	НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;

	Движения.ДенежныеСредстваКПолучению.ВыполнитьПриход();
	
	// По регистру "Денежные средства к списанию"
	НаборДвижений = Движения.ДенежныеСредстваКСписанию;
	ТаблицаДвижений = НаборДвижений.Выгрузить();

	СтрокаДвижений = ТаблицаДвижений.Добавить();
	СтрокаДвижений.БанковскийСчетКасса = Касса;
	СтрокаДвижений.Организация 		   = Касса.Владелец;
	СтрокаДвижений.ВидДенежныхСредств  = Перечисления.ВидыДенежныхСредств.Наличные;
	СтрокаДвижений.Сумма               = СуммаДокумента;
	СтрокаДвижений.ДокументСписания    = Ссылка;
	СтрокаДвижений.СтатьяДвиженияДенежныхСредств    = СтатьяДвиженияДенежныхСредств;
	
	НаборДвижений.мПериод          = Дата;
	НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;

	Движения.ДенежныеСредстваКСписанию.ВыполнитьПриход();
	
	Если Оплачено Тогда
		
		// По регистру "Денежные средства"
		НаборДвижений = Движения.ДенежныеСредства;
		ТаблицаДвижений = НаборДвижений.Выгрузить();
		
		ТаблицаДвижений.Очистить();

		СтрокаДвижений = ТаблицаДвижений.Добавить();
		СтрокаДвижений.БанковскийСчетКасса = Касса;
		СтрокаДвижений.Организация 		   = Касса.Владелец;
		СтрокаДвижений.ВидДенежныхСредств  = Перечисления.ВидыДенежныхСредств.Наличные;
		СтрокаДвижений.Сумма               = СуммаДокумента;
		СтрокаДвижений.СуммаУпр    		   = СуммаУпр;
		СтрокаДвижений.Активность		   = Истина;
		СтрокаДвижений.ВидДвижения         = ВидДвиженияНакопления.Расход;
		СтрокаДвижений.Период              = Дата;
		
		СтрокаДвижений = ТаблицаДвижений.Добавить();
		СтрокаДвижений.БанковскийСчетКасса = КассаПолучатель;
		СтрокаДвижений.Организация 		   = КассаПолучатель.Владелец;
		СтрокаДвижений.ВидДенежныхСредств  = Перечисления.ВидыДенежныхСредств.Наличные;
		СтрокаДвижений.Сумма               = СуммаДокумента;
		СтрокаДвижений.СуммаУпр    		   = СуммаУпр;
		СтрокаДвижений.Активность		   = Истина;
		СтрокаДвижений.ВидДвижения         = ВидДвиженияНакопления.Приход;
		СтрокаДвижений.Период              = Дата;

		Движения.ДенежныеСредства.мТаблицаДвижений=ТаблицаДвижений;
		Движения.ДенежныеСредства.ВыполнитьДвижения();
		
		// По регистру "Денежные средства к получению"
		НаборДвижений = Движения.ДенежныеСредстваКПолучению;
		ТаблицаДвижений = НаборДвижений.Выгрузить();
		ТаблицаДвижений.Очистить();

		СтрокаДвижений = ТаблицаДвижений.Добавить();
		СтрокаДвижений.БанковскийСчетКасса = КассаПолучатель;
		СтрокаДвижений.Организация 		   = КассаПолучатель.Владелец;
		СтрокаДвижений.ВидДенежныхСредств  = Перечисления.ВидыДенежныхСредств.Наличные;
		СтрокаДвижений.Сумма               = СуммаДокумента;
		СтрокаДвижений.СуммаУпр            = СуммаУпр;
		СтрокаДвижений.ДокументПолучения   = Ссылка;
		СтрокаДвижений.СтатьяДвиженияДенежныхСредств    = СтатьяДвиженияДенежныхСредств;
		
		НаборДвижений.мПериод          = Дата;
		НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;

		Движения.ДенежныеСредстваКПолучению.ВыполнитьРасход();
		
		// По регистру "Денежные средства к списанию"
		НаборДвижений = Движения.ДенежныеСредстваКСписанию;
		ТаблицаДвижений = НаборДвижений.Выгрузить();
		ТаблицаДвижений.Очистить();

		СтрокаДвижений = ТаблицаДвижений.Добавить();
		СтрокаДвижений.БанковскийСчетКасса = Касса;
		СтрокаДвижений.Организация 		   = Касса.Владелец;
		СтрокаДвижений.ВидДенежныхСредств  = Перечисления.ВидыДенежныхСредств.Наличные;
		СтрокаДвижений.Сумма               = СуммаДокумента;
		СтрокаДвижений.ДокументСписания    = Ссылка;
		СтрокаДвижений.СтатьяДвиженияДенежныхСредств    = СтатьяДвиженияДенежныхСредств;
		
		НаборДвижений.мПериод          = Дата;
		НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;

		Движения.ДенежныеСредстваКСписанию.ВыполнитьРасход();
		
		// По регистру "Движения денежных средств"
		НаборДвижений = Движения.ДвиженияДенежныхСредств;
		
		// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
		ТаблицаДвижений = НаборДвижений.Выгрузить();
		ТаблицаДвижений.Очистить();
		
		СтрокаДвижение=ТаблицаДвижений.Добавить();
		
		СтрокаДвижение.ВидДенежныхСредств=Перечисления.ВидыДенежныхСредств.Наличные;
		СтрокаДвижение.ПриходРасход=Перечисления.ВидыДвиженийПриходРасход.Расход;
		СтрокаДвижение.БанковскийСчетКасса=Касса;
		СтрокаДвижение.Организация = Касса.Владелец;
		СтрокаДвижение.ДокументДвижения=Ссылка;
		СтрокаДвижение.СтатьяДвиженияДенежныхСредств=СтатьяДвиженияДенежныхСредств;
		СтрокаДвижение.Сумма=СуммаДокумента;
		СтрокаДвижение.СуммаУпр=СуммаУпр;
		
		СтрокаДвижение=ТаблицаДвижений.Добавить();
		
		СтрокаДвижение.ВидДенежныхСредств=Перечисления.ВидыДенежныхСредств.Наличные;
		СтрокаДвижение.ПриходРасход=Перечисления.ВидыДвиженийПриходРасход.Приход;
		СтрокаДвижение.БанковскийСчетКасса=КассаПолучатель;
		СтрокаДвижение.Организация 	= КассаПолучатель.Владелец;
		СтрокаДвижение.ДокументДвижения=Ссылка;
		СтрокаДвижение.СтатьяДвиженияДенежныхСредств=СтатьяДвиженияДенежныхСредств;
		СтрокаДвижение.Сумма=СуммаДокумента;
		СтрокаДвижение.СуммаУпр=СуммаУпр;
		
		НаборДвижений.мПериод            = КонецДня(Дата);
		НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;
		
		Движения.ДвиженияДенежныхСредств.ВыполнитьДвижения();
		
	КонецЕсли;
	
КонецПроцедуры// ДвиженияПоРегистрам()

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	СтруктураКурсаДокумента = МодульВалютногоУчета.ПолучитьКурсВалюты(ВалютаДокумента,Дата);
	КурсДокумента      = СтруктураКурсаДокумента.Курс;
	КратностьДокумента = СтруктураКурсаДокумента.Кратность;
	
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей(), Отказ, Заголовок);
		
	Если НЕ Оплачено И РежимПроведения=РежимПроведенияДокумента.Оперативный Тогда
		
		// Проверяем остаток доступных денежных средств
		СвободныйОстаток = УправлениеДенежнымиСредствами.ПолучитьСвободныйОстатокДС(Касса,Дата,);
		
		Если СвободныйОстаток < СуммаДокумента Тогда
			
			Сообщить(Заголовок+"
			|Сумма документа превышает возможный к использованию остаток денежных средств
			|по " + Касса.Наименование + ".
			|Возможный к использованию остаток: " + Формат(СвободныйОстаток,"ЧЦ=15; ЧДЦ=2; ЧН=0")+" "+ВалютаДокумента+"
			|Сумма документа = "+Формат(СуммаДокумента,"ЧЦ=15; ЧДЦ=2")+" "+ВалютаДокумента);
			
			Если НЕ УправлениеДопПравамиПользователей.ПравоРазрешитьПревышениеСвободногоОстаткаДС() Тогда
				Отказ = Истина;
			КонецЕсли;	
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Ответственный.Пустая() Тогда
		Ответственный = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнойОтветственный");	КонецЕсли;
	Если ОрганизацияОтправитель<>ОрганизацияПолучатель Тогда
		Если ОрганизацияОтправитель.ОтражатьВРегламентированномУчете ИЛИ ОрганизацияПолучатель.ОтражатьВРегламентированномУчете Тогда
			Отказ = истина;
			ТекстСообщения = "У одной из организаций, между которыми происходит перемещение, установлен признак отражения в регл.учете
			|	Такие операции следует оформлять парой документов 'Приходный касс.ордер', 'Расходный касс.ордер'";
			Сообщить(ТекстСообщения, СтатусСообщения.Важное);
		КонецЕсли;
	КонецЕсли;

	
	Если Не Отказ Тогда
		
		СтруктураГруппаВалют = Новый Структура;
		СтруктураГруппаВалют.Вставить("ВалютаУпрУчета",глЗначениеПеременной("ВалютаУправленческогоУчета").Код);
		СтруктураГруппаВалют.Вставить("ВалютаДокумента",ВалютаДокумента.Код);
		СтруктураКурсыВалют=УправлениеДенежнымиСредствами.ПолучитьКурсыДляГруппыВалют(СтруктураГруппаВалют,Дата);
		
		ДвиженияПоРегистрам(СтруктураКурсыВалют);
		
	КонецЕсли;
		
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;


	 
	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью


Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры



