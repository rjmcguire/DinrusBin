﻿module io.stream.TextFile;

public  import io.device.File;
private import io.stream.Text;

class ТекстФайлВвод : ТекстВвод
{

        this (ткст путь, Файл.Стиль стиль = Файл.ЧитСущ);
        this (Файл файл);
}

class ТекстФайлВывод : ТекстВывод
{

        this (ткст путь, Файл.Стиль стиль = Файл.ЗапСозд);
        this (Файл файл);
 }


/*******************************************************************************

*******************************************************************************/

debug (TextFile)
{
        import io.Console;

        проц main()
        {
                auto t = new ТекстФайлВвод ("TextFile.d");
                foreach (строка; t)
                         Квывод(строка).нс;                  
        }
}
