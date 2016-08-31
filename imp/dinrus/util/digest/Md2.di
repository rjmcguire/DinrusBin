﻿/*******************************************************************************

        copyright:      Copyright (c) 2006 Dinrus. все rights reserved

        license:        BSD стиль: see doc/license.txt for details

        version:        Initial release: Feb 2006

        author:         Regan Heath, Oskar Linde

        This module реализует the MD2 Message Дайджест Algorithm as described 
        by RFC 1319 The MD2 Message-Дайджест Algorithm. B. Kaliski. April 1992.

*******************************************************************************/

module util.digest.Md2;

public  import util.digest.Digest;

private import util.digest.MerkleDamgard;

/*******************************************************************************

*******************************************************************************/

class Md2 : MerkleDamgard
{
        private ббайт[16] C,
                          состояние;

        /***********************************************************************

                Construct an Md2

        ***********************************************************************/

        this() { }

        /***********************************************************************

                Initialize the cИПher

                Remarks:
                Returns the cИПher состояние в_ it's начальное значение

        ***********************************************************************/

        protected override проц сбрось()
        {
                super.сбрось();
                состояние[] = 0;
                C[] = 0;
        }

        /***********************************************************************

                Obtain the дайджест

                Возвращает:
                the дайджест

                Remarks:
                Returns a дайджест of the текущ cИПher состояние, this may 
                be the final дайджест, or a дайджест of the состояние between 
                calls в_ обнови()

        ***********************************************************************/

        protected override проц создайДайджест(ббайт[] буф)
        {
                буф[] = состояние;                  
        }

        /***********************************************************************

                The MD 2 дайджест размер is 16 байты
 
        ***********************************************************************/

        бцел размерДайджеста() { return 16; }

        /***********************************************************************

                 блок размер

                Возвращает:
                the блок размер

                Remarks:
                Specifies the размер (in байты) of the блок of данные в_ пароль в_
                each вызов в_ трансформируй(). For MD2 the размерБлока is 16.

        ***********************************************************************/

        protected override бцел размерБлока()
        {
                return 16;
        }

        /***********************************************************************

                Length паддинг размер

                Возвращает:
                the length паддинг размер

                Remarks:
                Specifies the размер (in байты) of the паддинг which uses the
                length of the данные which имеется been cИПhered, this паддинг is
                carried out by the padLength метод. For MD2 the добавьРазмер is 
                0

        ***********************************************************************/

        protected override бцел добавьРазмер()
        {
                return 0;
        }

        /***********************************************************************

                Pads the cИПher данные

                Параметры:
                данные = a срез of the cИПher буфер в_ заполни with паддинг

                Remarks:
                Fills the passed буфер срез with the appropriate паддинг 
                for the final вызов в_ трансформируй(). This паддинг will заполни 
                the cИПher буфер up в_ размерБлока()-добавьРазмер().

        ***********************************************************************/

        protected override проц padMessage (ббайт[] данные)
        {
                /* Pдобавьing is performed as follows: "i" байты of значение "i" 
                 * are appended в_ the сообщение so that the length in байты 
                 * of the псеп_в_конце сообщение becomes congruent в_ 0, modulo 16. 
                 * At least one байт и at most 16 байты are appended.
                 */
                данные[0..$] = cast(ббайт) данные.length;
        }

        /***********************************************************************

                Performs the cИПher on a блок of данные

                Параметры:
                данные = the блок of данные в_ cИПher

                Remarks:
                The actual cИПher algorithm is carried out by this метод on
                the passed блок of данные. This метод is called for every
                размерБлока() байты of ввод данные и once ещё with the 
                остаток данные псеп_в_конце в_ размерБлока().

        ***********************************************************************/

        protected override проц трансформируй (ббайт[] ввод)
        {
                ббайт[48] X;
                бцел t,i,j;

                X[0..16] = состояние[];
                X[16..32] = ввод[];

                for (i = 0; i < 16; i++)
                     X[i+32] = cast(ббайт) (состояние[i] ^ ввод[i]);

                t = 0;
                for (i = 0; i < 18; i++) 
                    {
                    for (j = 0; j < 48; j++)
                         t = X[j] ^= ПИ[t];
                    t = (t + i) & 0xff;
                    }

                состояние[] = X[0..16];

                t = C[15];

                for (i = 0; i < 16; i++)
                     t = C[i] ^= ПИ[ввод[i] ^ t];
        }

        /***********************************************************************

                Final processing of cИПher.

                Remarks:
                This метод is called after the final трансформируй just приор в_
                the creation of the final дайджест. The MD2 algorithm требует
                an добавьitional step at this stage. Future cИПhers may or may not
                require this метод.

        ***********************************************************************/

        protected override проц extend()
        {
                трансформируй(C);
        }
}


/*******************************************************************************

*******************************************************************************/

private const ббайт[256] ПИ =
[
         41,  46,  67, 201, 162, 216, 124,   1,  61,  54,  84, 161, 236, 240,   6,
         19,  98, 167,   5, 243, 192, 199, 115, 140, 152, 147,  43, 217, 188,
         76, 130, 202,  30, 155,  87,  60, 253, 212, 224,  22, 103,  66, 111,  24,
        138,  23, 229,  18, 190,  78, 196, 214, 218, 158, 222,  73, 160, 251,
        245, 142, 187,  47, 238, 122, 169, 104, 121, 145,  21, 178,   7,  63,
        148, 194,  16, 137,  11,  34,  95,  33, 128, 127,  93, 154,  90, 144,  50,
         39,  53,  62, 204, 231, 191, 247, 151,  3,  255,  25,  48, 179,  72, 165,
        181, 209, 215,  94, 146,  42, 172,  86, 170, 198,  79, 184,  56, 210,
        150, 164, 125, 182, 118, 252, 107, 226, 156, 116,   4, 241,  69, 157,
        112,  89, 100, 113, 135,  32, 134,  91, 207, 101, 230,  45, 168,   2,  27,
         96,  37, 173, 174, 176, 185, 246,  28,  70,  97, 105,  52,  64, 126,  15,
         85,  71, 163,  35, 221,  81, 175,  58, 195,  92, 249, 206, 186, 197,
        234,  38,  44,  83,  13, 110, 133,  40, 132,   9, 211, 223, 205, 244,  65,
        129,  77,  82, 106, 220,  55, 200, 108, 193, 171, 250,  36, 225, 123,
          8,  12, 189, 177,  74, 120, 136, 149, 139, 227,  99, 232, 109, 233,
        203, 213, 254,  59,   0,  29,  57, 242, 239, 183,  14, 102,  88, 208, 228,
        166, 119, 114, 248, 235, 117,  75,  10,  49,  68,  80, 180, 143, 237,
         31,  26, 219, 153, 141,  51, 159,  17, 131,  20
];


/*******************************************************************************

*******************************************************************************/

debug(UnitTest)
{
        unittest 
        {
        static ткст[] strings = 
        [
                "",
                "a",
                "abc",
                "сообщение дайджест",
                "abcdefghijklmnopqrstuvwxyz",
                "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
                "12345678901234567890123456789012345678901234567890123456789012345678901234567890"
        ];

        static ткст[] results = 
        [
                "8350e5a3e24c153df2275c9f80692773",
                "32ec01ec4a6dac72c0ab96fb34c0b5d1",
                "da853b0d3f88d99b30283a69e6ded6bb",
                "ab4f496bfb2a530b219ff33031fe06b0",
                "4e8ddff3650292ab5a4108c3aa47940b",
                "da33def2a42df13975352846c30338cd",
                "d5976f79d83d3a0dc9806c3c66f3efd8"
        ];

        Md2 h = new Md2();

        foreach (цел i, ткст s; strings) 
                {
                h.обнови(s);
                ткст d = h.гексДайджест();
                assert(d == results[i],":("~s~")("~d~")!=("~results[i]~")");
                }
        }
}

