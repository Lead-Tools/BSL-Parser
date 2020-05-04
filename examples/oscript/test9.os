// Нагрузочный тест.
// Сравнение общего времени анализа на одном плагине и на сотне.
// ожидаемый результат:
// ДетекторНеиспользуемыхПеременных - 100 плагинов в 10 раз дольше чем один
// ДетекторОшибочныхЗамыкающихКомментариев - 100 плагинов в 2 раза дольше чем один

КоличествоПлагинов = 100;

ПодключитьСценарий("..\..\src\ПарсерВстроенногоЯзыка\Ext\ObjectModule.bsl", "Парсер");
Для Индекс = 0 По КоличествоПлагинов - 1 Цикл
	// ПодключитьСценарий("..\plugins\ДетекторНеиспользуемыхПеременных\src\ДетекторНеиспользуемыхПеременных\Ext\ObjectModule.bsl", "Плагин" + Индекс);
	ПодключитьСценарий("..\plugins\ДетекторОшибочныхЗамыкающихКомментариев\src\ДетекторОшибочныхЗамыкающихКомментариев\Ext\ObjectModule.bsl", "Плагин" + Индекс);
КонецЦикла;


Если АргументыКоманднойСтроки.Количество() = 0 Тогда
	ВызватьИсключение "Укажите в качестве параметра путь к папке с общими модулями bsl";
КонецЕсли;

ПутьКМодулям = АргументыКоманднойСтроки[0];
Файлы = НайтиФайлы(ПутьКМодулям, "*.bsl", Истина);

// ------------------------------------------------------------------------------------------------

Старт = ТекущаяУниверсальнаяДатаВМиллисекундах();

Парсер = Новый Парсер;

Плагин = Новый Плагин0;

ЧтениеТекста = Новый ЧтениеТекста;
Отчет = Новый Массив;
Для Каждого Файл Из Файлы Цикл
	Если Файл.ЭтоФайл() Тогда
		ЧтениеТекста.Открыть(Файл.ПолноеИмя, "UTF-8");
		Исходник = ЧтениеТекста.Прочитать();
		Попытка
			Парсер.Пуск(Исходник, Плагин);
		Исключение
		КонецПопытки;
		ЧтениеТекста.Закрыть();
	КонецЕсли;
КонецЦикла;

Финиш = ТекущаяУниверсальнаяДатаВМиллисекундах() - Старт;

Сообщить(СтрШаблон("Время 1 плагина: %1 сек", Финиш / 1000));

// ------------------------------------------------------------------------------------------------

Старт = ТекущаяУниверсальнаяДатаВМиллисекундах();

Парсер = Новый Парсер;

Плагины = Новый Массив;
Для Индекс = 0 По КоличествоПлагинов - 1 Цикл
	Плагины.Добавить(Новый("Плагин" + Индекс));
КонецЦикла;

ЧтениеТекста = Новый ЧтениеТекста;
Отчет = Новый Массив;
Для Каждого Файл Из Файлы Цикл
	Если Файл.ЭтоФайл() Тогда
		ЧтениеТекста.Открыть(Файл.ПолноеИмя, "UTF-8");
		Исходник = ЧтениеТекста.Прочитать();
		Попытка
			Парсер.Пуск(Исходник, Плагины);
		Исключение
		КонецПопытки;
		ЧтениеТекста.Закрыть();
	КонецЕсли;
КонецЦикла;

Финиш = ТекущаяУниверсальнаяДатаВМиллисекундах() - Старт;

Сообщить(СтрШаблон("Время %1 плагинов: %2 сек", КоличествоПлагинов, Финиш / 1000));