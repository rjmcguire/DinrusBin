﻿/**
 * Authors: The D DBI project
 * Copyright: BSD license
 */

module dbi.mysql.MysqlDatabase;

private import dbi.model.Database,dbi.mysql.imp, lib.mysql,
               dbi.model.Result,
               dbi.model.Constants;

private import dbi.DBIException,
               dbi.AbstractDatabase,
               dbi.ValidityToken;

private import dbi.mysql.MysqlError,
               dbi.mysql.MysqlResult,
               dbi.mysql.MysqlStatement;

private import lib.mysql;

private import util.log.Log,
               util.log.Config;
private import core.Variant;
private import Integer = text.convert.Integer;
private import text.convert.Format;

private import stringz;

class МайЭсКюЭлБД : БДсПротекциейДоступа, ПоддержкаМультиРезультата
{

private:

    Логгер лог;
    static бул[ВозможностьДби] _поддерживаемыеВозможности;
    бул[ВозможностьДби] _имеющиесяВозможности;

    ТокенВалидности токен;
    ТокеноДерж токеноДерж;

    static this()
    {
        _поддерживаемыеВозможности[ВозможностьДби.МультиИнструкции] = да;
        _поддерживаемыеВозможности[ВозможностьДби.МультиРезультаты] = да;
    }

package:
    MYSQL* подключение = пусто;

public:

    this ();
	
    this (ткст имя, ткст пользователь = пусто, 
          ткст пароль = пусто,
          ткст[ткст] парамы = пусто,
          ВозможностьДби[] возможности = пусто);
		  
		  
    ~this();
	

    проц подключись (ткст имя, 
                  ткст[ткст] парамы = пусто, 
                  ВозможностьДби[] возможности = пусто);
				  
				  
    проц подключись (ткст имя, ткст пользователь = пусто, 
                  ткст пароль = пусто,
                  ткст[ткст] парамы = пусто, 
                  ВозможностьДби[] возможности = пусто);
				  
				  
    бул естьВозможность(ВозможностьДби возможность);
	
	
    бул включен(ВозможностьДби возможность);
	
	
    проц включи(ВозможностьДби возможность);
	
	
    проц отключи(ВозможностьДби возможность);	
	
    проц закрой();	
	
    ткст искейп(in ткст инстр, ткст приёмн = пусто);
	
	проц выполни(in ткст эскюэл);
	
	РезультатМайЭсКюЭл запрос(in ткст эскюэл);
	
    ИнструкцияМайЭсКюЭл подготовь(in ткст эскюэл);
	
	ТаблицыМайЭсКюЭл таблицы(in ткст фильтр = пусто);
	
    override бул естьТаблица(ткст имя);
	
	override бдол идПоследнейВставки();
	
    override бдол задействованныеРяды();
	
    override проц стартТранзакции();

    override проц откат();

    override проц коммит();

	private проц проверь(ткст сообКраша, ткст эскюэл = "");

	private проц краш(ткст сообКраша, ткст эскюэл = "", бцел номош = 0);
}

private проц инструкцияКраша(MYSQL_STMT* инстр, ткст сообКраша, ткст эскюэл = "", бцел номош = 0);

class ТаблицыМайЭсКюЭл : Таблицы
{
private:

    РядыМайЭсКюЭл _ряды;
    МайЭсКюЭлБД _дбаза;

public:

    this (МайЭсКюЭлБД дбаза, РезультатМайЭсКюЭл результаты);

    цел opApply (цел delegate(inout Таблица) дг);

    т_мера таблицы() ;
}

class MysqlТаблица : АбстрактнаяТаблица
{
private:

    МайЭсКюЭлБД _дбаза;

public:

    this(МайЭсКюЭлБД дбаза) ;

    this(МайЭсКюЭлБД дбаза, ткст имя);

    override ИнфОСтолбце[] метаданные();
	
    ИнфОСтолбце метаданные(т_мера инд);
	
    бдол члоПолей() ;
	
    бдол члоРядов() ;

    РядыМайЭсКюЭл ряды();
	
    ткст вТкст() ;
}
