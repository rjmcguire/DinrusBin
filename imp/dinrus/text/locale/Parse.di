﻿/*******************************************************************************

        copyright:      Copyright (c) 2005 John Chapman. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: 2005

        author:         John Chapman

******************************************************************************/

module text.locale.Parse;

private import  time.WallClock;

private import  exception;

private import  text.locale.Core;

private import  time.chrono.Calendar;

private struct РезультатРазбораДатыВремени {

  цел год = -1;
  цел месяц = -1;
  цел день = -1;
  цел час;
  цел минута;
  цел секунда;
  дво дробь;
  цел timeMark;
  Календарь Календарь;
  ИнтервалВремени timeZoneOffset;
  Время разобраннаяДата;

}

package Время разборВремени(ткст s, ФорматДатыВремени dtf) ;

package Время разборВремениТочно(ткст s, ткст форматируй, ФорматДатыВремени dtf);

package бул пробуйРазборВремени(ткст s, ФорматДатыВремени dtf, out Время результат) ;

package бул пробуйРазборВремениТочно(ткст s, ткст форматируй, ФорматДатыВремени dtf, out Время результат) ;

private бул пробуйРазборТочноНесколько(ткст s, ткст[] форматы, ФорматДатыВремени dtf, ref РезультатРазбораДатыВремени результат) ;

private бул пробуйРазборТочно(ткст s, ткст образец, ФорматДатыВремени dtf, ref РезультатРазбораДатыВремени результат) ;
