﻿module std.file;

public import std.console;
private import stdrus;

alias stdrus.читайФайл read;
alias stdrus.пишиФайл write;
alias stdrus.допишиФайл append;
alias stdrus.переименуйФайл rename;
alias stdrus.удалиФайл remove;
alias stdrus.копируйФайл copy;
alias stdrus.дайРазмерФайла getSize;
alias stdrus.дайВременаФайла getTimes;
alias stdrus.естьФайл exists;
alias stdrus.дайАтрибутыФайла getAttributes;
alias stdrus.файл_ли isfile;
alias stdrus.папка_ли isdir;
alias stdrus.сменипап chdir;
alias stdrus.сделайпап mkdir;
alias stdrus.удалипап rmdir;
alias stdrus.дайтекпап getcwd;
alias stdrus.списпап listdir;
alias stdrus.вМБТ_0 toMBSz;