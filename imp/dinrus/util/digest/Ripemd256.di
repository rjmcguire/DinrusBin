﻿/*******************************************************************************

        copyright:      Copyright (c) 2009 Dinrus. все rights reserved

        license:        BSD стиль: see doc/license.txt for details

        version:        Initial release: Sep 2009

        author:         Kai Nacke

        This module реализует the Ripemd256 algorithm by Hans Dobbertin, 
        Antoon Bosselaers и Bart Preneel.

        See http://homes.esat.kuleuven.be/~bosselae/rИПemd160.html for ещё
        information.
        
        The implementation is based on:        
        RИПEMD-160 software записано by Antoon Bosselaers, 
 		available at http://www.esat.kuleuven.ac.be/~cosicart/ps/AB-9601/

*******************************************************************************/

module util.digest.Ripemd256;

private import util.digest.MerkleDamgard;

public  import util.digest.Digest;

/*******************************************************************************

*******************************************************************************/

final class Ripemd256 : MerkleDamgard
{
        private бцел[8]        контекст;
        private const бцел     padChar = 0x80;

        /***********************************************************************

        ***********************************************************************/

        private static const бцел[8] начальное =
        [
  				0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476,
  				0x76543210, 0xfedcba98, 0x89abcdef, 0x01234567
        ];
        
        /***********************************************************************

        	Construct a Ripemd256

         ***********************************************************************/

        this() { }

        /***********************************************************************

        	The размер of a Ripemd256 дайджест is 32 байты
        
         ***********************************************************************/

        override бцел размерДайджеста() {return 32;}


        /***********************************************************************

        	Initialize the cИПher

        	Remarks:
        		Returns the cИПher состояние в_ it's начальное значение

         ***********************************************************************/

        override проц сбрось()
        {
        	super.сбрось();
        	контекст[] = начальное[];
        }

        /***********************************************************************

        	Obtain the дайджест

        	Возвращает:
        		the дайджест

        	Remarks:
        		Returns a дайджест of the текущ cИПher состояние, this may be the
        		final дайджест, or a дайджест of the состояние between calls в_ обнови()

         ***********************************************************************/

        override проц создайДайджест(ббайт[] буф)
        {
            version (БигЭндиан)
            	ПерестановкаБайт.своп32 (контекст.ptr, контекст.length * бцел.sizeof);

        	буф[] = cast(ббайт[]) контекст;
        }


        /***********************************************************************

         	блок размер

        	Возвращает:
        	the блок размер

        	Remarks:
        	Specifies the размер (in байты) of the блок of данные в_ пароль в_
        	each вызов в_ трансформируй(). For Ripemd256 the размерБлока is 64.

         ***********************************************************************/

        protected override бцел размерБлока() { return 64; }

        /***********************************************************************

        	Length паддинг размер

        	Возвращает:
        	the length паддинг размер

        	Remarks:
        	Specifies the размер (in байты) of the паддинг which uses the
        	length of the данные which имеется been cИПhered, this паддинг is
        	carried out by the padLength метод. For Ripemd256 the добавьРазмер is 8.

         ***********************************************************************/

        protected бцел добавьРазмер()   { return 8;  }

        /***********************************************************************

        	Pads the cИПher данные

        	Параметры:
        	данные = a срез of the cИПher буфер в_ заполни with паддинг

        	Remarks:
        	Fills the passed буфер срез with the appropriate паддинг for
        	the final вызов в_ трансформируй(). This паддинг will заполни the cИПher
        	буфер up в_ размерБлока()-добавьРазмер().

         ***********************************************************************/

        protected override проц padMessage(ббайт[] at)
        {
        	at[0] = padChar;
        	at[1..at.length] = 0;
        }

        /***********************************************************************

        	Performs the length паддинг

        	Параметры:
        	данные   = the срез of the cИПher буфер в_ заполни with паддинг
        	length = the length of the данные which имеется been cИПhered

        	Remarks:
        	Fills the passed буфер срез with добавьРазмер() байты of паддинг
        	based on the length in байты of the ввод данные which имеется been
        	cИПhered.

         ***********************************************************************/

        protected override проц padLength(ббайт[] at, бдол length)
        {
        	length <<= 3;
        	littleEndian64((cast(ббайт*)&length)[0..8],cast(бдол[]) at); 
        }

        /***********************************************************************

        	Performs the cИПher on a блок of данные

        	Параметры:
        	данные = the блок of данные в_ cИПher

        	Remarks:
        	The actual cИПher algorithm is carried out by this метод on
        	the passed блок of данные. This метод is called for every
        	размерБлока() байты of ввод данные и once ещё with the остаток
        	данные псеп_в_конце в_ размерБлока().

         ***********************************************************************/

        protected override проц трансформируй(ббайт[] ввод)
        {
        	бцел al, bl, cl, dl;
        	бцел ar, br, cr, dr;
            бцел[16] x;
            бцел t;

            littleEndian32(ввод,x);

            al = контекст[0];
            bl = контекст[1];
            cl = контекст[2];
            dl = контекст[3];
            ar = контекст[4];
            br = контекст[5];
            cr = контекст[6];
            dr = контекст[7];

            // Round 1 и parallel округли 1
            al = вращайВлево(al + (bl ^ cl ^ dl) + x[0], 11);
            ar = вращайВлево(ar + ((br & dr) | (cr & ~(dr))) + x[5] + 0x50a28be6, 8);
            dl = вращайВлево(dl + (al ^ bl ^ cl) + x[1], 14);
            dr = вращайВлево(dr + ((ar & cr) | (br & ~(cr))) + x[14] + 0x50a28be6, 9);
            cl = вращайВлево(cl + (dl ^ al ^ bl) + x[2], 15);
            cr = вращайВлево(cr + ((dr & br) | (ar & ~(br))) + x[7] + 0x50a28be6, 9);
            bl = вращайВлево(bl + (cl ^ dl ^ al) + x[3], 12);
            br = вращайВлево(br + ((cr & ar) | (dr & ~(ar))) + x[0] + 0x50a28be6, 11);
            al = вращайВлево(al + (bl ^ cl ^ dl) + x[4], 5);
            ar = вращайВлево(ar + ((br & dr) | (cr & ~(dr))) + x[9] + 0x50a28be6, 13);
            dl = вращайВлево(dl + (al ^ bl ^ cl) + x[5], 8);
            dr = вращайВлево(dr + ((ar & cr) | (br & ~(cr))) + x[2] + 0x50a28be6, 15);
            cl = вращайВлево(cl + (dl ^ al ^ bl) + x[6], 7);
            cr = вращайВлево(cr + ((dr & br) | (ar & ~(br))) + x[11] + 0x50a28be6, 15);
            bl = вращайВлево(bl + (cl ^ dl ^ al) + x[7], 9);
            br = вращайВлево(br + ((cr & ar) | (dr & ~(ar))) + x[4] + 0x50a28be6, 5);
            al = вращайВлево(al + (bl ^ cl ^ dl) + x[8], 11);
            ar = вращайВлево(ar + ((br & dr) | (cr & ~(dr))) + x[13] + 0x50a28be6, 7);
            dl = вращайВлево(dl + (al ^ bl ^ cl) + x[9], 13);
            dr = вращайВлево(dr + ((ar & cr) | (br & ~(cr))) + x[6] + 0x50a28be6, 7);
            cl = вращайВлево(cl + (dl ^ al ^ bl) + x[10], 14);
            cr = вращайВлево(cr + ((dr & br) | (ar & ~(br))) + x[15] + 0x50a28be6, 8);
            bl = вращайВлево(bl + (cl ^ dl ^ al) + x[11], 15);
            br = вращайВлево(br + ((cr & ar) | (dr & ~(ar))) + x[8] + 0x50a28be6, 11);
            al = вращайВлево(al + (bl ^ cl ^ dl) + x[12], 6);
            ar = вращайВлево(ar + ((br & dr) | (cr & ~(dr))) + x[1] + 0x50a28be6, 14);
            dl = вращайВлево(dl + (al ^ bl ^ cl) + x[13], 7);
            dr = вращайВлево(dr + ((ar & cr) | (br & ~(cr))) + x[10] + 0x50a28be6, 14);
            cl = вращайВлево(cl + (dl ^ al ^ bl) + x[14], 9);
            cr = вращайВлево(cr + ((dr & br) | (ar & ~(br))) + x[3] + 0x50a28be6, 12);
            bl = вращайВлево(bl + (cl ^ dl ^ al) + x[15], 8);
            br = вращайВлево(br + ((cr & ar) | (dr & ~(ar))) + x[12] + 0x50a28be6, 6);
            
            t = al; al = ar; ar = t;
            
            // Round 2 и parallel округли 2
            al = вращайВлево(al + (((cl ^ dl) & bl) ^ dl) + x[7] + 0x5a827999, 7);
            ar = вращайВлево(ar + ((br | ~(cr)) ^ dr) + x[6] + 0x5c4dd124, 9);
            dl = вращайВлево(dl + (((bl ^ cl) & al) ^ cl) + x[4] + 0x5a827999, 6);
            dr = вращайВлево(dr + ((ar | ~(br)) ^ cr) + x[11] + 0x5c4dd124, 13);
            cl = вращайВлево(cl + (((al ^ bl) & dl) ^ bl) + x[13] + 0x5a827999, 8);
            cr = вращайВлево(cr + ((dr | ~(ar)) ^ br) + x[3] + 0x5c4dd124, 15);
            bl = вращайВлево(bl + (((dl ^ al) & cl) ^ al) + x[1] + 0x5a827999, 13);
            br = вращайВлево(br + ((cr | ~(dr)) ^ ar) + x[7] + 0x5c4dd124, 7);
            al = вращайВлево(al + (((cl ^ dl) & bl) ^ dl) + x[10] + 0x5a827999, 11);
            ar = вращайВлево(ar + ((br | ~(cr)) ^ dr) + x[0] + 0x5c4dd124, 12);
            dl = вращайВлево(dl + (((bl ^ cl) & al) ^ cl) + x[6] + 0x5a827999, 9);
            dr = вращайВлево(dr + ((ar | ~(br)) ^ cr) + x[13] + 0x5c4dd124, 8);
            cl = вращайВлево(cl + (((al ^ bl) & dl) ^ bl) + x[15] + 0x5a827999, 7);
            cr = вращайВлево(cr + ((dr | ~(ar)) ^ br) + x[5] + 0x5c4dd124, 9);
            bl = вращайВлево(bl + (((dl ^ al) & cl) ^ al) + x[3] + 0x5a827999, 15);
            br = вращайВлево(br + ((cr | ~(dr)) ^ ar) + x[10] + 0x5c4dd124, 11);
            al = вращайВлево(al + (((cl ^ dl) & bl) ^ dl) + x[12] + 0x5a827999, 7);
            ar = вращайВлево(ar + ((br | ~(cr)) ^ dr) + x[14] + 0x5c4dd124, 7);
            dl = вращайВлево(dl + (((bl ^ cl) & al) ^ cl) + x[0] + 0x5a827999, 12);
            dr = вращайВлево(dr + ((ar | ~(br)) ^ cr) + x[15] + 0x5c4dd124, 7);
            cl = вращайВлево(cl + (((al ^ bl) & dl) ^ bl) + x[9] + 0x5a827999, 15);
            cr = вращайВлево(cr + ((dr | ~(ar)) ^ br) + x[8] + 0x5c4dd124, 12);
            bl = вращайВлево(bl + (((dl ^ al) & cl) ^ al) + x[5] + 0x5a827999, 9);
            br = вращайВлево(br + ((cr | ~(dr)) ^ ar) + x[12] + 0x5c4dd124, 7);
            al = вращайВлево(al + (((cl ^ dl) & bl) ^ dl) + x[2] + 0x5a827999, 11);
            ar = вращайВлево(ar + ((br | ~(cr)) ^ dr) + x[4] + 0x5c4dd124, 6);
            dl = вращайВлево(dl + (((bl ^ cl) & al) ^ cl) + x[14] + 0x5a827999, 7);
            dr = вращайВлево(dr + ((ar | ~(br)) ^ cr) + x[9] + 0x5c4dd124, 15);
            cl = вращайВлево(cl + (((al ^ bl) & dl) ^ bl) + x[11] + 0x5a827999, 13);
            cr = вращайВлево(cr + ((dr | ~(ar)) ^ br) + x[1] + 0x5c4dd124, 13);
            bl = вращайВлево(bl + (((dl ^ al) & cl) ^ al) + x[8] + 0x5a827999, 12);
            br = вращайВлево(br + ((cr | ~(dr)) ^ ar) + x[2] + 0x5c4dd124, 11);
            
            t = bl; bl = br; br = t;
            
            // Round 3 и parallel округли 3
            al = вращайВлево(al + ((bl | ~(cl)) ^ dl) + x[3] + 0x6ed9eba1, 11);
            ar = вращайВлево(ar + (((cr ^ dr) & br) ^ dr) + x[15] + 0x6d703ef3, 9);
            dl = вращайВлево(dl + ((al | ~(bl)) ^ cl) + x[10] + 0x6ed9eba1, 13);
            dr = вращайВлево(dr + (((br ^ cr) & ar) ^ cr) + x[5] + 0x6d703ef3, 7);
            cl = вращайВлево(cl + ((dl | ~(al)) ^ bl) + x[14] + 0x6ed9eba1, 6);
            cr = вращайВлево(cr + (((ar ^ br) & dr) ^ br) + x[1] + 0x6d703ef3, 15);
            bl = вращайВлево(bl + ((cl | ~(dl)) ^ al) + x[4] + 0x6ed9eba1, 7);
            br = вращайВлево(br + (((dr ^ ar) & cr) ^ ar) + x[3] + 0x6d703ef3, 11);
            al = вращайВлево(al + ((bl | ~(cl)) ^ dl) + x[9] + 0x6ed9eba1, 14);
            ar = вращайВлево(ar + (((cr ^ dr) & br) ^ dr) + x[7] + 0x6d703ef3, 8);
            dl = вращайВлево(dl + ((al | ~(bl)) ^ cl) + x[15] + 0x6ed9eba1, 9);
            dr = вращайВлево(dr + (((br ^ cr) & ar) ^ cr) + x[14] + 0x6d703ef3, 6);
            cl = вращайВлево(cl + ((dl | ~(al)) ^ bl) + x[8] + 0x6ed9eba1, 13);
            cr = вращайВлево(cr + (((ar ^ br) & dr) ^ br) + x[6] + 0x6d703ef3, 6);
            bl = вращайВлево(bl + ((cl | ~(dl)) ^ al) + x[1] + 0x6ed9eba1, 15);
            br = вращайВлево(br + (((dr ^ ar) & cr) ^ ar) + x[9] + 0x6d703ef3, 14);
            al = вращайВлево(al + ((bl | ~(cl)) ^ dl) + x[2] + 0x6ed9eba1, 14);
            ar = вращайВлево(ar + (((cr ^ dr) & br) ^ dr) + x[11] + 0x6d703ef3, 12);
            dl = вращайВлево(dl + ((al | ~(bl)) ^ cl) + x[7] + 0x6ed9eba1, 8);
            dr = вращайВлево(dr + (((br ^ cr) & ar) ^ cr) + x[8] + 0x6d703ef3, 13);
            cl = вращайВлево(cl + ((dl | ~(al)) ^ bl) + x[0] + 0x6ed9eba1, 13);
            cr = вращайВлево(cr + (((ar ^ br) & dr) ^ br) + x[12] + 0x6d703ef3, 5);
            bl = вращайВлево(bl + ((cl | ~(dl)) ^ al) + x[6] + 0x6ed9eba1, 6);
            br = вращайВлево(br + (((dr ^ ar) & cr) ^ ar) + x[2] + 0x6d703ef3, 14);
            al = вращайВлево(al + ((bl | ~(cl)) ^ dl) + x[13] + 0x6ed9eba1, 5);
            ar = вращайВлево(ar + (((cr ^ dr) & br) ^ dr) + x[10] + 0x6d703ef3, 13);
            dl = вращайВлево(dl + ((al | ~(bl)) ^ cl) + x[11] + 0x6ed9eba1, 12);
            dr = вращайВлево(dr + (((br ^ cr) & ar) ^ cr) + x[0] + 0x6d703ef3, 13);
            cl = вращайВлево(cl + ((dl | ~(al)) ^ bl) + x[5] + 0x6ed9eba1, 7);
            cr = вращайВлево(cr + (((ar ^ br) & dr) ^ br) + x[4] + 0x6d703ef3, 7);
            bl = вращайВлево(bl + ((cl | ~(dl)) ^ al) + x[12] + 0x6ed9eba1, 5);
            br = вращайВлево(br + (((dr ^ ar) & cr) ^ ar) + x[13] + 0x6d703ef3, 5);
            
            t = cl; cl = cr; cr = t;
            
            // Round 4 и parallel округли 4
            al = вращайВлево(al + ((bl & dl) | (cl & ~(dl))) + x[1] + 0x8f1bbcdc, 11);
            ar = вращайВлево(ar + (br ^ cr ^ dr) + x[8], 15);
            dl = вращайВлево(dl + ((al & cl) | (bl & ~(cl))) + x[9] + 0x8f1bbcdc, 12);
            dr = вращайВлево(dr + (ar ^ br ^ cr) + x[6], 5);
            cl = вращайВлево(cl + ((dl & bl) | (al & ~(bl))) + x[11] + 0x8f1bbcdc, 14);
            cr = вращайВлево(cr + (dr ^ ar ^ br) + x[4], 8);
            bl = вращайВлево(bl + ((cl & al) | (dl & ~(al))) + x[10] + 0x8f1bbcdc, 15);
            br = вращайВлево(br + (cr ^ dr ^ ar) + x[1], 11);
            al = вращайВлево(al + ((bl & dl) | (cl & ~(dl))) + x[0] + 0x8f1bbcdc, 14);
            ar = вращайВлево(ar + (br ^ cr ^ dr) + x[3], 14);
            dl = вращайВлево(dl + ((al & cl) | (bl & ~(cl))) + x[8] + 0x8f1bbcdc, 15);
            dr = вращайВлево(dr + (ar ^ br ^ cr) + x[11], 14);
            cl = вращайВлево(cl + ((dl & bl) | (al & ~(bl))) + x[12] + 0x8f1bbcdc, 9);
            cr = вращайВлево(cr + (dr ^ ar ^ br) + x[15], 6);
            bl = вращайВлево(bl + ((cl & al) | (dl & ~(al))) + x[4] + 0x8f1bbcdc, 8);
            br = вращайВлево(br + (cr ^ dr ^ ar) + x[0], 14);
            al = вращайВлево(al + ((bl & dl) | (cl & ~(dl))) + x[13] + 0x8f1bbcdc, 9);
            ar = вращайВлево(ar + (br ^ cr ^ dr) + x[5], 6);
            dl = вращайВлево(dl + ((al & cl) | (bl & ~(cl))) + x[3] + 0x8f1bbcdc, 14);
            dr = вращайВлево(dr + (ar ^ br ^ cr) + x[12], 9);
            cl = вращайВлево(cl + ((dl & bl) | (al & ~(bl))) + x[7] + 0x8f1bbcdc, 5);
            cr = вращайВлево(cr + (dr ^ ar ^ br) + x[2], 12);
            bl = вращайВлево(bl + ((cl & al) | (dl & ~(al))) + x[15] + 0x8f1bbcdc, 6);
            br = вращайВлево(br + (cr ^ dr ^ ar) + x[13], 9);
            al = вращайВлево(al + ((bl & dl) | (cl & ~(dl))) + x[14] + 0x8f1bbcdc, 8);
            ar = вращайВлево(ar + (br ^ cr ^ dr) + x[9], 12);
            dl = вращайВлево(dl + ((al & cl) | (bl & ~(cl))) + x[5] + 0x8f1bbcdc, 6);
            dr = вращайВлево(dr + (ar ^ br ^ cr) + x[7], 5);
            cl = вращайВлево(cl + ((dl & bl) | (al & ~(bl))) + x[6] + 0x8f1bbcdc, 5);
            cr = вращайВлево(cr + (dr ^ ar ^ br) + x[10], 15);
            bl = вращайВлево(bl + ((cl & al) | (dl & ~(al))) + x[2] + 0x8f1bbcdc, 12);
            br = вращайВлево(br + (cr ^ dr ^ ar) + x[14], 8);
            
            // Do not обменяй dl и dr; simply добавь the right значение в_ контекст 

            контекст[0] += al;
            контекст[1] += bl;
            контекст[2] += cl;
            контекст[3] += dr;
            контекст[4] += ar;
            контекст[5] += br;
            контекст[6] += cr;
            контекст[7] += dl;

            x[] = 0;
        }

}

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
            "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
            "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
            "12345678901234567890123456789012345678901234567890123456789012345678901234567890"
    ];

    static ткст[] results =
    [
            "02ba4c4e5f8ecd1877fc52d64d30e37a2d9774fb1e5d026380ae0168e3c5522d",
            "f9333e45d857f5d90a91bab70a1eba0cfb1be4b0783c9acfcd883a9134692925",
            "afbd6e228b9d8cbbcef5ca2d03e6dba10ac0bc7dcbe4680e1e42d2e975459b65",
            "87e971759a1ce47a514d5c914c392c9018c7c46bc14465554afcdf54a5070c0e",
            "649d3034751ea216776bf9a18acc81bc7896118a5197968782dd1fd97d8d5133",
            "3843045583aac6c8c8d9128573e7a9809afb2a0f34ccc36ea9e72f16f6368e3f",
            "5740a408ac16b720b84424ae931cbb1fe363d1d0bf4017f1a89f7ea6de77a0b8",
            "06fdcc7a409548aaf91368c06a6275b553e3f099bf0ea4edfd6778df89a890dd"
    ];

    Ripemd256 h = new Ripemd256();

    foreach (цел i, ткст s; strings)
            {
            h.обнови(cast(ббайт[]) s);
            ткст d = h.гексДайджест;

            assert(d == results[i],":("~s~")("~d~")!=("~results[i]~")");
            }

    ткст s = new сим[1000000];
    for (auto i = 0; i < s.length; i++) s[i] = 'a';
    ткст результат = "ac953744e10e31514c150d4d8d7b677342e33399788296e43ae4850ce4f97978";
    h.обнови(cast(ббайт[]) s);
    ткст d = h.гексДайджест;

    assert(d == результат,":(1 million times \"a\")("~d~")!=("~результат~")");
    }
	
}