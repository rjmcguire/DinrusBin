﻿module sys.memory;
import sys.DConsts;


/**
Установка типа кучи
*/
enum Тип
{
СТД = 0,//стандартная
НФК = 2,// низко фрагментированная (LFH)
ЛА = 1, // с поддержкой look aside
}

const ФЛ = (ППамять.КучВклВып|ППамять.КучГенИскл);

export extern (D):

/**
Проверка действенности указателя на функцию
**/
проц проверь (ук процедура);

/**
Проверка действенности указателя на строку Анзи
**/
проц проверь (усим текст);	

/**
Проверка действенности указателя на широкосимвольную строку 
**/
проц проверь (ушим текст);

/**
Проверка открытости доступа для чтения блока памяти 
**/
проц проверьЧитается(ук первБайтБлока);

/**
Проверка открытости доступа для записи блока памяти 
**/
проц проверьЗаписывается(ук первБайтБлока);

/**
Заполнить нулями память по указателю на указанное число байт 
**/
проц занули(ук где, т_мера сколько);

/**
Заполнить память символами,указанными в параметре "чем",
по указателю на указанное число байт 
**/
проц  заполни(ук где, т_мера сколько, ббайт чем);

/**
Перемещение указанного числа байт с одного адреса на другой
**/

проц перемести (ук куда, ук откуда, т_мера сколько);


struct Куча
{
	
	/**
	Чтобы получить доступ к куче текущего процесса или создать кучу, 
	достаточно указать
	..................
	Куча куча;
	 
	 куча.процесса;
	 .................
	 или
	 .................
	 куча.новая;
	..................

	Теперь куча.сожми, куча.удали и другие
	операции будут относиться либо к созданной новой,
	либо к куче процесса.

	**/
	проц процесса();	
	проц новая( т_мера начРазм = 0, т_мера максРазм = 0,  ППамять опц = ФЛ);

	/**
	Установка типа кучи
	*/
	проц тип(бцел типКучи);

	/**
	Выполняет удаление кучи
	*/
	проц удали();
	/**
	Выводит указатель на созданную кучу
	*/
	ук укз();

	/**
	Блокирует эту кучу
	*/
	проц блокируй();

	/**
	Разблокирует эту кучу
	*/
	проц разблокируй();

	/**
	Выделяет из этой кучи указанное число байтов для использования
	*/					
	ук размести( т_мера байты, ППамять флаги = ФЛ);

	/**
	Изменяет указанное число байтов и атрибуты блока
	*/	
	ук измени( ук блок, т_мера байты, ППамять флаги = ФЛ);

	/**
	Удаляет указанный блок
	*/
	проц освободи ( ук блок, ППамять флаги = ФЛ);

	/**
	Выводит размер указанного блока
	*/
	т_мера размер( ук блок, ППамять флаги = ФЛ);

	/**
	Выполняет проверку консистентности памяти блока
	*/
	бул проверь( ук блок, ППамять флаги = ФЛ);

	/**
	Выполняет сжатие кучи за счёт удаления нулевых пространств
	*/
	т_мера сожми(ППамять флаги = ФЛ);

	//проц обход();
					
}

