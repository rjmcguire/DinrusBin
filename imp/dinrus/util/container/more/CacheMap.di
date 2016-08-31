﻿/*******************************************************************************

        copyright:      Copyright (c) 2008 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)
        
        version:        Initial release: April 2008      
        
        author:         Kris

        Since:          0.99.7

*******************************************************************************/

module util.container.more.CacheMap;

private import cidrus;

private import util.container.HashMap;

public  import util.container.Container;

/******************************************************************************

        КэшКарта extends the basic hashmap тип by добавьing a предел в_ 
        the число of items contained at any given время. In добавьition, 
        КэшКарта sorts the кэш записи such that those записи 
        frequently использовался are at the голова of the queue, и those
        least frequently использовался are at the хвост. When the queue 
        becomes full, old записи are dropped из_ the хвост и are 
        reused в_ house new кэш записи. 

        In другой words, it retains MRU items while dropping LRU when
        ёмкость is reached.

        This is great for keeping commonly использовался items around, while
        limiting the amount of память использован. Typically, the queue размер 
        would be установи in the thousands (via the ctor)

******************************************************************************/

class КэшКарта (K, V, alias Хэш = Контейнер.хэш, 
                      alias Извл = Контейнер.извлеки, 
                      alias Куча = Контейнер.Сбор) 
{
        private alias ЗаписьВОчереди       Тип;
        private alias Тип              *Реф;
        private alias ХэшКарта!(K, Реф, Хэш, рипер, куча) Карта;
        private Карта                     хэш;
        private Тип[]                  линки;

        // extents of queue
        private Реф                     голова,
                                        хвост;
        // дименсия of queue
        private бцел                    ёмкость;

       /**********************************************************************

                Construct a кэш with the specified maximum число of 
                записи. добавьitions в_ the кэш beyond this число will
                reuse the slot of the least-recently-referenced кэш
                Запись. 

        **********************************************************************/

        this (бцел ёмкость);

        /***********************************************************************

                Извлing обрвызов for the hashmap, acting as a trampoline

        ***********************************************************************/

        static проц рипер(K, R) (K k, R r) 
        {
                Извл (k, r.значение);
        }

        /***********************************************************************


        ***********************************************************************/

        final бцел размер ();

        /***********************************************************************

                Iterate из_ MRU в_ LRU записи

        ***********************************************************************/

        final цел opApply (цел delegate(ref K ключ, ref V значение) дг)
        {
                        K   ключ;
                        V   значение;
                        цел результат;

                        auto узел = голова;
                        auto i = хэш.размер;
                        while (i--)
                              {
                              ключ = узел.ключ;
                              значение = узел.значение;
                              if ((результат = дг(ключ, значение)) != 0)
                                   break;
                              узел = узел.следщ;
                              }
                        return результат;
        }

        /**********************************************************************

                Get the кэш Запись опрentified by the given ключ

        **********************************************************************/

        бул получи (K ключ, ref V значение)
        {
                Реф Запись = пусто;

                // if we найди 'ключ' then перемести it в_ the список голова
                if (хэш.получи (ключ, Запись))
                   {
                   значение = Запись.значение;
                   переРеферируй (Запись);
                   return да;
                   }
                return нет;
        }

        /**********************************************************************

                Place an Запись преобр_в the кэш и associate it with the
                provопрed ключ. Note that there can be only one Запись for
                any particular ключ. If two записи are добавьed with the 
                same ключ, the секунда effectively overwrites the первый.

                Returns да if we добавьed a new Запись; нет if we just
                replaced an existing one

        **********************************************************************/

        final бул добавь (K ключ, V значение)
        {
                Реф Запись = пусто;

                // already in the список? -- замени Запись
                if (хэш.получи (ключ, Запись))
                   {
                   // установи the new item for this ключ и перемести в_ список голова
                   переРеферируй (Запись.установи (ключ, значение));
                   return нет;
                   }

                // создай a new Запись at the список голова 
                добавьЗапись (ключ, значение);
                return да;
        }

        /**********************************************************************

                Удали the кэш Запись associated with the provопрed ключ. 
                Returns нет if there is no such Запись.

        **********************************************************************/

        final бул возьми (K ключ)
        {
                V значение;

                return возьми (ключ, значение);
        }

        /**********************************************************************

                Удали (и return) the кэш Запись associated with the 
                provопрed ключ. Returns нет if there is no such Запись.

        **********************************************************************/

        final бул возьми (K ключ, ref V значение)
        {
                Реф Запись = пусто;
                if (хэш.получи (ключ, Запись))
                   {
                   значение = Запись.значение;

                   // don't actually затуши the список Запись -- just place
                   // it at the список 'хвост' ready for subsequent reuse
                   разРеферируй (Запись);

                   // удали the Запись из_ хэш
                   хэш.удалиКлюч (ключ);
                   return да;
                   }
                return нет;
        }

        /**********************************************************************

                Place a кэш Запись at the хвост of the queue. This makes
                it the least-recently referenced.

        **********************************************************************/

        private Реф разРеферируй (Реф Запись);

        /**********************************************************************

                Move a кэш Запись в_ the голова of the queue. This makes
                it the most-recently referenced.

        **********************************************************************/

        private Реф переРеферируй (Реф Запись);

        /**********************************************************************

                Добавь an Запись преобр_в the queue. If the queue is full, the
                least-recently-referenced Запись is reused for the new
                добавьition. 

        **********************************************************************/

        private Реф добавьЗапись (K ключ, V значение)
        {
                assert (ёмкость);

                if (хэш.размер < ёмкость)
                    хэш.добавь (ключ, хвост);
                else
                   {
                   // we're re-using a приор ЗаписьВОчереди, so извлеки и
                   // relocate the existing хэш-таблица Запись первый
                   Извл (хвост.ключ, хвост.значение);
                   if (! хэш.replaceKey (хвост.ключ, ключ))
                         throw new Исключение ("ключ missing!");
                   }

                // place at голова of список
                return переРеферируй (хвост.установи (ключ, значение));
        }

        /**********************************************************************
        
                A doubly-linked список Запись, использован as a wrapper for queued 
                кэш записи
        
        **********************************************************************/
        
        private struct ЗаписьВОчереди
        {
                private K               ключ;
                private Реф             предш,
                                        следщ;
                private V               значение;
        
                /**************************************************************
        
                        Набор this linked-список Запись with the given аргументы. 

                **************************************************************/
        
                Реф установи (K ключ, V значение)
                {
                        this.значение = значение;
                        this.ключ = ключ;
                        return this;
                }
        
                /**************************************************************
        
                        Insert this Запись преобр_в the linked-список just in 
                        front of the given Запись.
        
                **************************************************************/
        
                Реф приставь (Реф before);
        
                /**************************************************************
                        
                        Добавь this Запись преобр_в the linked-список just after 
                        the given Запись.
        
                **************************************************************/
        
                Реф добавь (Реф after);
        
                /**************************************************************
        
                        Удали this Запись из_ the linked-список. The 
                        previous и следщ записи are patched together 
                        appropriately.
        
                **************************************************************/
        
                Реф выкинь ();
        }
}


/*******************************************************************************

*******************************************************************************/

debug (КэшКарта)
{
        import io.Stdout;
        import time.StopWatch;

        проц main()
        {
                цел v;
                auto карта = new КэшКарта!(ткст, цел)(2);
                карта.добавь ("foo", 1);
                карта.добавь ("bar", 2);
                карта.добавь ("wumpus", 3);
                foreach (k, v; карта)
                         Стдвыв.форматнс ("{} {}", k, v);

                Стдвыв.нс;
                карта.получи ("bar", v);
                foreach (k, v; карта)
                         Стдвыв.форматнс ("{} {}", k, v);

                Стдвыв.нс;
                карта.получи ("bar", v);
                foreach (k, v; карта)
                         Стдвыв.форматнс ("{} {}", k, v);

                Стдвыв.нс;
                карта.получи ("foo", v);
                foreach (k, v; карта)
                         Стдвыв.форматнс ("{} {}", k, v);

                Стдвыв.нс;
                карта.получи ("wumpus", v);
                foreach (k, v; карта)
                         Стдвыв.форматнс ("{} {}", k, v);


                // установи for benchmark, with a кэш of целыйs
                auto тест = new КэшКарта!(цел, цел, Контейнер.хэш, Контейнер.извлеки, Контейнер.Чанк) (1000);
                const счёт = 1_000_000;
                Секундомер w;

                // benchmark добавьing
                w.старт;
                for (цел i=счёт; i--;)
                     тест.добавь (i, i);
                Стдвыв.форматнс ("{} добавьs: {}/s", счёт, счёт/w.stop);

                // benchmark reading
                w.старт;
                for (цел i=счёт; i--;)
                     тест.получи (i, v);
                Стдвыв.форматнс ("{} lookups: {}/s", счёт, счёт/w.stop);

                // benchmark iteration
                w.старт;
                foreach (ключ, значение; тест) {}
                Стдвыв.форматнс ("{} элемент iteration: {}/s", тест.размер, тест.размер/w.stop);

                тест.хэш.проверь;
        }
}
        
