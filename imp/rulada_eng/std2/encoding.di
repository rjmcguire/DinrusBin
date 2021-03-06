﻿// Written in the D programming language.

/**
Classes and functions for handling and transcoding between various encodings.

For cases where the _encoding is known at compile-time, functions are provided
for arbitrary _encoding and decoding of characters, arbitrary transcoding
between strings of different type, as well as validation and sanitization.

Encodings currently supported are UTF-8, UTF-16, UTF-32, ASCII, ISO-8859-1
(also known as LATIN-1), and WINDOWS-1252.

$(UL
$(LI The type $(D AsciiChar) represents an ASCII character.)
$(LI The type $(D AsciiString) represents an ASCII string.)
$(LI The type $(D Latin1Char) represents an ISO-8859-1 character.)
$(LI The type $(D Latin1String) represents an ISO-8859-1 string.)
$(LI The type $(D Windows1252Char) represents a Windows-1252 character.)
$(LI The type $(D Windows1252String) represents a Windows-1252 string.))

For cases where the _encoding is not known at compile-time, but is
known at run-time, we provide the abstract class $(D EncodingScheme)
and its subclasses.  To construct a run-time encoder/decoder, one does
e.g.

----------------------------------------------------
    auto e = EncodingScheme.create("utf-8");
----------------------------------------------------

This library supplies $(D EncodingScheme) subclasses for ASCII,
ISO-8859-1 (also known as LATIN-1), WINDOWS-1252, UTF-8, and (on
little-endian architectures) UTF-16LE and UTF-32LE; or (on big-endian
architectures) UTF-16BE and UTF-32BE.

This library provides a mechanism whereby other modules may add $(D
EncodingScheme) subclasses for any other _encoding.

Authors: Janice Caron

Date: 2008.02.27 - 2008.05.07

License: Public Domain

Macros:
    WIKI=Phobos/StdEncoding
*/

module std2.encoding;
import std.string;
import std.traits;


//=============================================================================

/** Special value returned by $(D safeDecode) */
const dchar INVALID_SEQUENCE =  cast(dchar)0xFFFFFFFF;

template EncoderFunctions()
{
    // Various forms of read

    template ReadFromString()
    {
        bool canRead() { return s.length != 0; }
        E peek() { return s[0]; }
        E read() { E t = s[0]; s = s[1..$]; return t; }
    }

    template ReverseReadFromString()
    {
        bool canRead() { return s.length != 0; }
        E peek() { return s[$-1]; }
        E read() { E t = s[$-1]; s = s[0..$-1]; return t; }
    }

    // Various forms of Write

    template WriteToString()
    {
        E[] s;
        void write(E c) { s ~= c; }
    }
    
    template WriteToArray()
    {
    	void write(E c) { array[0] = c; array = array[1..$]; }
    }

    deprecated template WriteToBuffer()
    {
        void write(E c) { buffer ~= c; }
    }

    template WriteToDelegate()
    {
        void write(E c) { dg(c); }
    }

    // Functions we will export

    template EncodeViaWrite()
    {
        mixin encodeViaWrite;
        void encode(dchar c) { encodeViaWrite(c); }
    }

    template SkipViaRead()
    {
        mixin skipViaRead;
        void skip() { skipViaRead(); }
    }

    template DecodeViaRead()
    {
        mixin decodeViaRead;
        dchar decode() { return decodeViaRead(); }
    }

    template SafeDecodeViaRead()
    {
        mixin safeDecodeViaRead;
        dchar safeDecode() { return safeDecodeViaRead(); }
    }

    template DecodeReverseViaRead()
    {
        mixin decodeReverseViaRead;
        dchar decodeReverse() { return decodeReverseViaRead(); }
    }

    // Encoding to different destinations

    template EncodeToString()
    {
        mixin WriteToString;
        mixin EncodeViaWrite;
    }
    
    template EncodeToArray()
    {
    	mixin WriteToArray;
    	mixin EncodeViaWrite;
    }

    deprecated template EncodeToBuffer()
    {
        mixin WriteToBuffer;
        mixin EncodeViaWrite;
    }

    template EncodeToDelegate()
    {
        mixin WriteToDelegate;
        mixin EncodeViaWrite;
    }

    // Decoding functions

    template SkipFromString()
    {
        mixin ReadFromString;
        mixin SkipViaRead;
    }

    template DecodeFromString()
    {
        mixin ReadFromString;
        mixin DecodeViaRead;
    }

    template SafeDecodeFromString()
    {
        mixin ReadFromString;
        mixin SafeDecodeViaRead;
    }

    template DecodeReverseFromString()
    {
        mixin ReverseReadFromString;
        mixin DecodeReverseViaRead;
    }

    //=========================================================================

    // Below are the functions we will ultimately expose to the user
    
    E[] encode(dchar c)
    {
        mixin EncodeToString e;
        e.encode(c);
        return e.s;
    }

    void encode(dchar c, ref E[] array)
    {
    	mixin EncodeToArray e;
    	e.encode(c);
    }

    void encode(dchar c, void delegate(E) dg)
    {
        mixin EncodeToDelegate e;
        e.encode(c);
    }

    void skip(ref E[] s)
    {
        mixin SkipFromString e;
        e.skip();
    }

    dchar decode(S)(ref S s)
    {
        mixin DecodeFromString e;
        return e.decode();
    }

    dchar safeDecode(S)(ref S s)
    {
        mixin SafeDecodeFromString e;
        return e.safeDecode();
    }

    dchar decodeReverse(ref E[] s)
    {
        mixin DecodeReverseFromString e;
        return e.decodeReverse();
    }
}

//=========================================================================

struct CodePoints(E)
{
    E[] s;

    static CodePoints opCall(E[] s)
    in
    {
        assert(isValid(s));
    }
    body
    {
        CodePoints codePoints;
        codePoints.s = s;
        return codePoints;
    }

    int opApply(int delegate(ref dchar) dg)
    {
        int result = 0;
        while (s.length != 0)
        {
            dchar c = decode(s);
            result = dg(c);
            if (result != 0) break;
        }
        return result;
    }

    int opApply(int delegate(ref uint, ref dchar) dg)
    {
        uint i = 0;
        int result = 0;
        while (s.length != 0)
        {
            uint len = s.length;
            dchar c = decode(s);
            uint j = i; // We don't want the delegate corrupting i
            result = dg(j,c);
            if (result != 0) break;
            i += len - s.length;
        }
        return result;
    }

    int opApplyReverse(int delegate(ref dchar) dg)
    {
        int result = 0;
        while (s.length != 0)
        {
            dchar c = decodeReverse(s);
            result = dg(c);
            if (result != 0) break;
        }
        return result;
    }

    int opApplyReverse(int delegate(ref uint, ref dchar) dg)
    {
        int result = 0;
        while (s.length != 0)
        {
            dchar c = decodeReverse(s);
            uint i = s.length;
            result = dg(i,c);
            if (result != 0) break;
        }
        return result;
    }
}

struct CodeUnits(E)
{
    E[] s;

    static CodeUnits opCall(dchar d)
    in
    {
        assert(isValidCodePoint(d));
    }
    body
    {
        CodeUnits codeUnits;
        codeUnits.s = encode!(E)(d);
        return codeUnits;
    }

    int opApply(int delegate(ref E) dg)
    {
        int result = 0;
        foreach(E c;s)
        {
            result = dg(c);
            if (result != 0) break;
        }
        return result;
    }

    int opApplyReverse(int delegate(ref E) dg)
    {
        int result = 0;
        foreach_reverse(E c;s)
        {
            result = dg(c);
            if (result != 0) break;
        }
        return result;
    }
}

//=============================================================================

template EncoderInstance(E)
{
    static assert(false,"Cannot instantiate EncoderInstance for type "
        ~ E.stringof);
}

//=============================================================================
//          ASCII
//=============================================================================

/** Defines various character sets. */
typedef ubyte AsciiChar;
/// Ditto
alias AsciiChar[] AsciiString; 

template EncoderInstance(CharType : AsciiChar)
{
    alias AsciiChar E;
    alias AsciiString EString;

    string encodingName()
    {
        return "ASCII";
    }

    bool canEncode(dchar c)
    {
        return c < 0x80;
    }

    bool isValidCodeUnit(AsciiChar c)
    {
        return c < 0x80;
    }
    
    uint encodedLength(dchar c)
    in
    {
    	assert(canEncode(c));
    }
    body
    {
        return 1;
    }

    void encodeX(Range)(dchar c, Range r)
    {
        if (!canEncode(c)) c = '?';
        r.write(cast(AsciiChar) c);
    }

    void encodeViaWrite()(dchar c)
    {
        if (!canEncode(c)) c = '?';
        write(cast(AsciiChar)c);
    }

    void skipViaRead()()
    {
        read();
    }

    dchar decodeViaRead()()
    {
        return read;
    }

    dchar safeDecodeViaRead()()
    {
        dchar c = read;
        return canEncode(c) ? c : INVALID_SEQUENCE;
    }

    dchar decodeReverseViaRead()()
    {
        return read;
    }

    EString replacementSequence()
    {
        return cast(EString)("?");
    }

    mixin EncoderFunctions;
}

//=============================================================================
//          ISO-8859-1
//=============================================================================

/** Defines an Latin1-encoded character. */
typedef ubyte Latin1Char;
/**
Defines an Latin1-encoded string (as an array of $(D
invariant(Latin1Char))).
 */
alias Latin1Char[] Latin1String; ///

template EncoderInstance(CharType : Latin1Char)
{
    alias Latin1Char E;
    alias Latin1String EString;

    string encodingName()
    {
        return "ISO-8859-1";
    }

    bool canEncode(dchar c)
    {
        return c < 0x100;
    }

    bool isValidCodeUnit(Latin1Char c)
    {
        return true;
    }

    uint encodedLength(dchar c)
    in
    {
    	assert(canEncode(c));
    }
    body
    {
		return 1;
    }

    void encodeViaWrite()(dchar c)
    {
        if (!canEncode(c)) c = '?';
        write(cast(Latin1Char)c);
    }

    void skipViaRead()()
    {
        read();
    }

    dchar decodeViaRead()()
    {
        return read;
    }

    dchar safeDecodeViaRead()()
    {
        return read;
    }

    dchar decodeReverseViaRead()()
    {
        return read;
    }

    EString replacementSequence()
    {
        return cast(EString)("?");
    }

    mixin EncoderFunctions;
}

//=============================================================================
//          WINDOWS-1252
//=============================================================================

/** Defines a Windows1252-encoded character. */
typedef ubyte Windows1252Char;
/**
Defines an Windows1252-encoded string (as an array of $(D
invariant(Windows1252Char))).
 */
alias Windows1252Char[] Windows1252String; ///

template EncoderInstance(CharType : Windows1252Char)
{
    alias Windows1252Char E;
    alias Windows1252String EString;

    string encodingName()
    {
        return "windows-1252";
    }

    static const wstring charMap =
        "\u20AC\uFFFD\u201A\u0192\u201E\u2026\u2020\u2021"
        "\u02C6\u2030\u0160\u2039\u0152\uFFFD\u017D\uFFFD"
        "\uFFFD\u2018\u2019\u201C\u201D\u2022\u2103\u2014"
        "\u02DC\u2122\u0161\u203A\u0153\uFFFD\u017E\u0178";

    bool canEncode(dchar c)
    {
        if (c < 0x80 || (c >= 0xA0 && c < 0x100)) return true;
        if (c >= 0xFFFD) return false;
        foreach(wchar d;charMap) { if (c == d) return true; }
        return false;
    }

    bool isValidCodeUnit(Windows1252Char c)
    {
        if (c < 0x80 || c >= 0xA0) return true;
        return (charMap[c-0x80] != 0xFFFD);
    }

    uint encodedLength(dchar c)
    in
    {
    	assert(canEncode(c));
    }
    body
    {
        return 1;
    }

    void encodeViaWrite()(dchar c)
    {
        if (c < 0x80 || (c >= 0xA0 && c < 0x100)) {}
        else if (c >= 0xFFFD) { c = '?'; }
        else
        {
            int n = -1;
            foreach(i,wchar d;charMap)
            {
                if (c == d)
                {
                    n = i;
                    break;
                }
            }
            c = n == -1 ? '?' : 0x80 + n;
        }
        write(cast(Windows1252Char)c);
    }

    void skipViaRead()()
    {
        read();
    }

    dchar decodeViaRead()()
    {
        Windows1252Char c = read;
        return (c >= 0x80 && c < 0xA0) ? charMap[c-0x80] : c;
    }

    dchar safeDecodeViaRead()()
    {
        Windows1252Char c = read;
        dchar d = (c >= 0x80 && c < 0xA0) ? charMap[c-0x80] : c;
        return d == 0xFFFD ? INVALID_SEQUENCE : d;
    }

    dchar decodeReverseViaRead()()
    {
        Windows1252Char c = read;
        return (c >= 0x80 && c < 0xA0) ? charMap[c-0x80] : c;
    }

    EString replacementSequence()
    {
        return cast(EString)("?");
    }

    mixin EncoderFunctions;
}

//=============================================================================
//          UTF-8
//=============================================================================

template EncoderInstance(CharType : char)
{
    alias char E;
    alias char[] EString;

    string encodingName()
    {
        return "UTF-8";
    }

    bool canEncode(dchar c)
    {
        return isValidCodePoint(c);
    }

    bool isValidCodeUnit(char c)
    {
        return (c < 0xC0 || (c >= 0xC2 && c < 0xF5));
    }

    static const ubyte[128] tailTable =
    [
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
        1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
        2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
        3,3,3,3,3,3,3,3,4,4,4,4,5,5,6,0,
    ];

    private int tails(char c)
    in
    {
        assert(c >= 0x80);
    }
    body
    {
        return tailTable[c-0x80];
    }

    uint encodedLength(dchar c)
    in
    {
    	assert(canEncode(c));
    }
    body
    {
        if (c < 0x80) return 1;
        if (c < 0x800) return 2;
        if (c < 0x10000) return 3;
        return 4;
    }

    void encodeViaWrite()(dchar c)
    {
        if (c < 0x80)
        {
            write(cast(char)c);
        }
        else if (c < 0x800)
        {
            write(cast(char)((c >> 6) + 0xC0));
            write(cast(char)((c & 0x3F) + 0x80));
        }
        else if (c < 0x10000)
        {
            write(cast(char)((c >> 12) + 0xE0));
            write(cast(char)(((c >> 6) & 0x3F) + 0x80));
            write(cast(char)((c & 0x3F) + 0x80));
        }
        else
        {
            write(cast(char)((c >> 18) + 0xF0));
            write(cast(char)(((c >> 12) & 0x3F) + 0x80));
            write(cast(char)(((c >> 6) & 0x3F) + 0x80));
            write(cast(char)((c & 0x3F) + 0x80));
        }
    }

    void skipViaRead()()
    {
        auto c = read;
        if (c < 0xC0) return;
        int n = tails(cast(char) c);
        for (uint i=0; i<n; ++i)
        {
            read();
        }
    }

    dchar decodeViaRead()()
    {
        dchar c = read;
        if (c < 0xC0) return c;
        int n = tails(cast(char) c);
        c &= (1 << (6 - n)) - 1;
        for (uint i=0; i<n; ++i)
        {
            c = (c << 6) + (read & 0x3F);
        }
        return c;
    }

    dchar safeDecodeViaRead()()
    {
        dchar c = read;
        if (c < 0x80) return c;
        int n = tails(cast(char) c);
        if (n == 0) return INVALID_SEQUENCE;

        if (!canRead) return INVALID_SEQUENCE;
        uint d = peek;
        bool err =
        (
            (c < 0xC2)                              // fail overlong 2-byte sequences
        ||  (c > 0xF4)                              // fail overlong 4-6-byte sequences
        ||  (c == 0xE0 && ((d & 0xE0) == 0x80))     // fail overlong 3-byte sequences
        ||  (c == 0xED && ((d & 0xE0) == 0xA0))     // fail surrogates
        ||  (c == 0xF0 && ((d & 0xF0) == 0x80))     // fail overlong 4-byte sequences
        ||  (c == 0xF4 && ((d & 0xF0) >= 0x90))     // fail code points > 0x10FFFF
        );

        c &= (1 << (6 - n)) - 1;
        for (uint i=0; i<n; ++i)
        {
            if (!canRead) return INVALID_SEQUENCE;
            d = peek;
            if ((d & 0xC0) != 0x80) return INVALID_SEQUENCE;
            c = (c << 6) + (read & 0x3F);
        }

        return err ? INVALID_SEQUENCE : c;
    }

    dchar decodeReverseViaRead()()
    {
        //auto feed_char = read;
	//dchar c = feed_char;
	dchar c = read;
        if (c < 0x80) return c;
        uint shift = 0;
        c &= 0x3F;
        for (uint i=0; i<4; ++i)
        {
            shift += 6;
            auto d = read;
            uint n = tails(cast(char) d);
            uint mask = n == 0 ? 0x3F : (1 << (6 - n)) - 1;
            c += ((d & mask) << shift);
            if (n != 0) break;
        }
        return c;
    }

    EString replacementSequence()
    {
        return "\uFFFD";
    }

    mixin EncoderFunctions;
}

//=============================================================================
//          UTF-16
//=============================================================================

template EncoderInstance(CharType : wchar)
{
    alias wchar E;
    alias wchar[] EString;

    string encodingName()
    {
        return "UTF-16";
    }

    bool canEncode(dchar c)
    {
        return isValidCodePoint(c);
    }

    bool isValidCodeUnit(wchar c)
    {
        return true;
    }

    uint encodedLength(dchar c)
    in
    {
    	assert(canEncode(c));
    }
    body
    {
		return (c < 0x10000) ? 1 : 2;
    }

    void encodeViaWrite()(dchar c)
    {
        if (c < 0x10000)
        {
            write(cast(wchar)c);
        }
        else
        {
            uint n = c - 0x10000;
            write(cast(wchar)(0xD800 + (n >> 10)));
            write(cast(wchar)(0xDC00 + (n & 0x3FF)));
        }
    }

    void skipViaRead()()
    {
        wchar c = read;
        if (c < 0xD800 || c >= 0xE000) return;
        read();
    }

    dchar decodeViaRead()()
    {
        wchar c = read;
        if (c < 0xD800 || c >= 0xE000) return cast(dchar)c;
        wchar d = read;
        c &= 0x3FF;
        d &= 0x3FF;
        return 0x10000 + (c << 10) + d;
    }

    dchar safeDecodeViaRead()()
    {
        wchar c = read;
        if (c < 0xD800 || c >= 0xE000) return cast(dchar)c;
        if (c >= 0xDC00) return INVALID_SEQUENCE;
        if (!canRead) return INVALID_SEQUENCE;
        wchar d = peek;
        if (d < 0xDC00 || d >= 0xE000) return INVALID_SEQUENCE;
        d = read;
        c &= 0x3FF;
        d &= 0x3FF;
        return 0x10000 + (c << 10) + d;
    }

    dchar decodeReverseViaRead()()
    {
        wchar c = read;
        if (c < 0xD800 || c >= 0xE000) return cast(dchar)c;
        wchar d = read;
        c &= 0x3FF;
        d &= 0x3FF;
        return 0x10000 + (d << 10) + c;
    }

    EString replacementSequence()
    {
        return "\uFFFD"w;
    }

    mixin EncoderFunctions;
}

//=============================================================================
//          UTF-32
//=============================================================================

template EncoderInstance(CharType : dchar)
{
    alias dchar E;
    alias dchar[] EString;

    string encodingName()
    {
        return "UTF-32";
    }

    bool canEncode(dchar c)
    {
        return isValidCodePoint(c);
    }

    bool isValidCodeUnit(dchar c)
    {
        return isValidCodePoint(c);
    }

    uint encodedLength(dchar c)
    in
    {
    	assert(canEncode(c));
    }
    body
    {
		return 1;
    }

    void encodeViaWrite()(dchar c)
    {
        write(c);
    }

    void skipViaRead()()
    {
        read();
    }

    dchar decodeViaRead()()
    {
        return cast(dchar)read;
    }

    dchar safeDecodeViaRead()()
    {
        dchar c = read;
        return isValidCodePoint(c) ? c : INVALID_SEQUENCE;
    }

    dchar decodeReverseViaRead()()
    {
        return cast(dchar)read;
    }

    EString replacementSequence()
    {
        return "\uFFFD"d;
    }

    mixin EncoderFunctions;
}

//=============================================================================
// Below are forwarding functions which expose the function to the user

/**
Returns true if c is a valid code point

 Note that this includes the non-character code points U+FFFE and U+FFFF,
 since these are valid code points (even though they are not valid
 characters).

 Supercedes:
 This function supercedes $(D std.utf.startsValidDchar()).

 Standards: Unicode 5.0, ASCII, ISO-8859-1, WINDOWS-1252

 Params:
    c = the code point to be tested
 */
bool isValidCodePoint(dchar c)
{
    return c < 0xD800 || (c >= 0xE000 && c < 0x110000);
}

/**
 Returns the name of an encoding.

 The type of encoding cannot be deduced. Therefore, it is necessary to
 explicitly specify the encoding type.

 Standards: Unicode 5.0, ASCII, ISO-8859-1, WINDOWS-1252

 Examples:
 -----------------------------------
 assert(encodingName!(Latin1Char) == "ISO-8859-1");
 -----------------------------------
 */
string encodingName(T)()
{
    return EncoderInstance!(T).encodingName;
}

unittest
{
    assert(encodingName!(char) == "UTF-8");
    assert(encodingName!(wchar) == "UTF-16");
    assert(encodingName!(dchar) == "UTF-32");
    assert(encodingName!(AsciiChar) == "ASCII");
    assert(encodingName!(Latin1Char) == "ISO-8859-1");
    assert(encodingName!(Windows1252Char) == "windows-1252");
}

/**
 Returns true iff it is possible to represent the specifed codepoint
 in the encoding.

 The type of encoding cannot be deduced. Therefore, it is necessary to
 explicitly specify the encoding type.

 Standards: Unicode 5.0, ASCII, ISO-8859-1, WINDOWS-1252

 Examples:
 -----------------------------------
 assert(canEncode!(Latin1Char)('A'));
 -----------------------------------
 */
bool canEncode(E)(dchar c)
{
    return EncoderInstance!(E).canEncode(c);
}

unittest
{
    assert(!canEncode!(AsciiChar)('\u00A0'));
    assert(canEncode!(Latin1Char)('\u00A0'));
    assert(canEncode!(Windows1252Char)('\u20AC'));
    assert(!canEncode!(Windows1252Char)('\u20AD'));
    assert(!canEncode!(Windows1252Char)('\uFFFD'));
    assert(!canEncode!(char)(cast(dchar)0x110000));
}

/**
 Returns true if the code unit is legal. For example, the byte 0x80 would
 not be legal in ASCII, because ASCII code units must always be in the range
 0x00 to 0x7F.

 Standards: Unicode 5.0, ASCII, ISO-8859-1, WINDOWS-1252

 Params:
    c = the code unit to be tested
 */
bool isValidCodeUnit(E)(E c)
{
    return EncoderInstance!(E).isValidCodeUnit(c);
}

unittest
{
    assert(!isValidCodeUnit(cast(AsciiChar)0xA0));
    assert( isValidCodeUnit(cast(Windows1252Char)0x80));
    assert(!isValidCodeUnit(cast(Windows1252Char)0x81));
    assert(!isValidCodeUnit(cast(char)0xC0));
    assert(!isValidCodeUnit(cast(char)0xFF));
    assert( isValidCodeUnit(cast(wchar)0xD800));
    assert(!isValidCodeUnit(cast(dchar)0xD800));
}

/**
 Returns true if the string is encoded correctly

 Supercedes:
 This function supercedes std.utf.validate(), however note that this
 function returns a bool indicating whether the input was valid or not,
 wheras the older funtion would throw an exception.

 Standards: Unicode 5.0, ASCII, ISO-8859-1, WINDOWS-1252

 Params:
    s = the string to be tested
 */
bool isValid(E)(E[] s)
{
    return s.length == validLength(s);
}

unittest
{
    assert(isValid("\u20AC100"));
}

/**
 Returns the length of the longest possible substring, starting from
 the first code unit, which is validly encoded.

 Standards: Unicode 5.0, ASCII, ISO-8859-1, WINDOWS-1252

 Params:
    s = the string to be tested
 */
uint validLength(E)(E[] s)
{
    uint result, before = void;
    while ((before = s.length) > 0)
    {
        if (EncoderInstance!(E).safeDecode(s) == INVALID_SEQUENCE)
            break;
        result += before - s.length;
    }
    return result;
}

/**
 Sanitizes a string by replacing malformed code unit sequences with valid
 code unit sequences. The result is guaranteed to be valid for this encoding.

 If the input string is already valid, this function returns the original,
 otherwise it constructs a new string by replacing all illegal code unit
 sequences with the encoding's replacement character, Invalid sequences will
 be replaced with the Unicode replacement character (U+FFFD) if the
 character repertoire contains it, otherwise invalid sequences will be
 replaced with '?'.

 Standards: Unicode 5.0, ASCII, ISO-8859-1, WINDOWS-1252

 Params:
    s = the string to be sanitized
 */

E[] sanitize(E)(E[] s)
{
    uint n = validLength(s);
    if (n == s.length) return s;

    auto repSeq = EncoderInstance!(E).replacementSequence;

    // Count how long the string needs to be.
    // Overestimating is not a problem
    uint len = s.length;
    E[] t = s[n..$];
    while (t.length != 0)
    {
        dchar c = EncoderInstance!(E).safeDecode(t);
        assert(c == INVALID_SEQUENCE);
        len += repSeq.length;
        t = t[validLength(t)..$];
    }

    // Now do the write
    E[] array = new E[len];
    array[0..n] = s[0..n];
    uint offset = n;

    t = s[n..$];
    while (t.length != 0)
    {
        dchar c = EncoderInstance!(E).safeDecode(t);
        assert(c == INVALID_SEQUENCE);
        array[offset..offset+repSeq.length] = repSeq[];
        offset += repSeq.length;
        n = validLength(t);
        array[offset..offset+n] = t[0..n];
        offset += n;
        t = t[n..$];
    }
    return cast(E[])array[0..offset];
}

unittest
{
    assert(sanitize("hello \xF0\x80world") == "hello \xEF\xBF\xBDworld");
}

/**
Returns the length of the first encoded sequence.

The input to this function MUST be validly encoded.
This is enforced by the function's in-contract.

Standards: Unicode 5.0, ASCII, ISO-8859-1, WINDOWS-1252

Params:
s = the string to be sliced
 */
uint firstSequence(E)(E[] s)
in
{
    assert(s.length != 0);
    E[] u = s;
    assert(safeDecode(u) != INVALID_SEQUENCE);
}
body
{
    auto before = s.length;
    EncoderInstance!(E).skip(s);
    return before - s.length;
}

unittest
{
    assert(firstSequence("\u20AC1000") == "\u20AC".length);
}

/**
 Returns the length the last encoded sequence.

 The input to this function MUST be validly encoded.
 This is enforced by the function's in-contract.

 Standards: Unicode 5.0, ASCII, ISO-8859-1, WINDOWS-1252

 Params:
    s = the string to be sliced
 */
uint lastSequence(E)(E[] s)
in
{
    assert(s.length != 0);
    assert(isValid(s));
}
body
{
    E[] t = s;
    EncoderInstance!(E).decodeReverse(s);
    return t.length - s.length;
}

unittest
{
    assert(lastSequence("1000\u20AC") == "\u20AC".length);
}

/**
Returns the total number of code points encoded in a string.

The input to this function MUST be validly encoded.  This is enforced
by the function's in-contract.

Supercedes: This function supercedes $(D std.utf.toUCSindex()).

Standards: Unicode 5.0, ASCII, ISO-8859-1, WINDOWS-1252

Params:
s = the string to be counted
 */
uint codepoints_count(E)(E[] s)
in
{
    assert(isValid(s));
}
body
{
    uint n = 0;
    while (s.length != 0)
    {
        EncoderInstance!(E).skip(s);
        ++n;
    }
    return n;
}

unittest
{
    assert(codepoints_count("\u20AC100") == 4);
}

/**
 Returns the array index at which the (n+1)th code point begins.

 The input to this function MUST be validly encoded.
 This is enforced by the function's in-contract.

 Supercedes:
 This function supercedes std.utf.toUTFindex().

 Standards: Unicode 5.0, ASCII, ISO-8859-1, WINDOWS-1252

 Params:
    s = the string to be counted
 */
int index(E)(E[] s,int n)
in
{
    assert(isValid(s));
    assert(n >= 0);
}
body
{
    E[] t = s;
    for (uint i=0; i<n; ++i) EncoderInstance!(E).skip(s);
    return t.length - s.length;
}

unittest
{
    assert(index("\u20AC100",1) == 3);
}

/**
 Decodes a single code point.

 This function removes one or more code units from the start of a string,
 and returns the decoded code point which those code units represent.

 The input to this function MUST be validly encoded.
 This is enforced by the function's in-contract.

 Supercedes:
 This function supercedes std.utf.decode(), however, note that the
 function codePoints() supercedes it more conveniently.

 Standards: Unicode 5.0, ASCII, ISO-8859-1, WINDOWS-1252

 Params:
    s = the string whose first code point is to be decoded
 */
dchar decode(S)(ref S s)
in
{
    assert(s.length != 0);
    auto u = s;
    assert(safeDecode(u) != INVALID_SEQUENCE);
}
body
{
    return EncoderInstance!(typeof(s[0])).decode(s);
}

/**
 Decodes a single code point from the end of a string.

 This function removes one or more code units from the end of a string,
 and returns the decoded code point which those code units represent.

 The input to this function MUST be validly encoded.
 This is enforced by the function's in-contract.

 Standards: Unicode 5.0, ASCII, ISO-8859-1, WINDOWS-1252

 Params:
    s = the string whose first code point is to be decoded
 */
dchar decodeReverse(E)(ref E[] s)
in
{
    assert(s.length != 0);
    assert(isValid(s));
}
body
{
    return EncoderInstance!(E).decodeReverse(s);
}

/**
 Decodes a single code point. The input does not have to be valid.

 This function removes one or more code units from the start of a string,
 and returns the decoded code point which those code units represent.

 This function will accept an invalidly encoded string as input.
 If an invalid sequence is found at the start of the string, this
 function will remove it, and return the value INVALID_SEQUENCE.

 Standards: Unicode 5.0, ASCII, ISO-8859-1, WINDOWS-1252

 Params:
    s = the string whose first code point is to be decoded
 */
dchar safeDecode(S)(ref S s)
in
{
    assert(s.length != 0);
}
body
{
    return EncoderInstance!(typeof(s[0])).safeDecode(s);
}

/**
 Returns the number of code units required to encode a single code point.

 The input to this function MUST be a valid code point.
 This is enforced by the function's in-contract.

 The type of the output cannot be deduced. Therefore, it is necessary to
 explicitly specify the encoding as a template parameter.

 Standards: Unicode 5.0, ASCII, ISO-8859-1, WINDOWS-1252

 Params:
    c = the code point to be encoded
 */
uint encodedLength(E)(dchar c)
in
{
    assert(isValidCodePoint(c));
}
body
{
    return EncoderInstance!(E).encodedLength(c);
}

/**
 Encodes a single code point.

 This function encodes a single code point into one or more code units.
 It returns a string containing those code units.

 The input to this function MUST be a valid code point.
 This is enforced by the function's in-contract.

 The type of the output cannot be deduced. Therefore, it is necessary to
 explicitly specify the encoding as a template parameter.

 Supercedes:
 This function supercedes std.utf.encode(), however, note that the
 function codeUnits() supercedes it more conveniently.

 Standards: Unicode 5.0, ASCII, ISO-8859-1, WINDOWS-1252

 Params:
    c = the code point to be encoded
 */
E[] encode(E)(dchar c)
in
{
    assert(isValidCodePoint(c));
}
body
{
    return EncoderInstance!(E).encode(c);
}

/**
 Encodes a single code point into an array.

 This function encodes a single code point into one or more code units
 The code units are stored in a user-supplied fixed-size array,
 which must be passed by reference.

 The input to this function MUST be a valid code point.
 This is enforced by the function's in-contract.

 The type of the output cannot be deduced. Therefore, it is necessary to
 explicitly specify the encoding as a template parameter.

 Supercedes:
 This function supercedes std.utf.encode(), however, note that the
 function codeUnits() supercedes it more conveniently.

 Standards: Unicode 5.0, ASCII, ISO-8859-1, WINDOWS-1252

 Params:
    c = the code point to be encoded

 Returns:
	  the number of code units written to the array
 */
uint encode(E)(dchar c, E[] array)
in
{
    assert(isValidCodePoint(c));
}
body
{
	E[] t = array;
    EncoderInstance!(E).encode(c,t);
    return array.length - t.length;
}

// /**
//  * Encodes a single code point into a Buffer.
//  *
//  * This function encodes a single code point into one or more code units
//  * The code units are stored in a growable buffer.
//  *
//  * The input to this function MUST be a valid code point.
//  * This is enforced by the function's in-contract.
//  *
//  * The type of the output cannot be deduced. Therefore, it is necessary to
//  * explicitly specify the encoding as a template parameter.
//  *
//  * Supercedes:
//  * This function supercedes std.utf.encode(), however, note that the
//  * function codeUnits() supercedes it more conveniently.
//  *
//  * Standards: Unicode 5.0, ASCII, ISO-8859-1, WINDOWS-1252
//  *
//  * Params:
//  *    c = the code point to be encoded
//  */
// deprecated void encode(E)(dchar c, ref Buffer!(E) buffer)
// in
// {
//     assert(isValidCodePoint(c));
// }
// body
// {
//     EncoderInstance!(E).encode(c,buffer);
// }

/**
Encodes $(D c) in units of type $(D E) and writes the result to the
output range $(D R). Returns the number of $(D E)s written.
 */

alias void delegate(char c) encode_putchar;
alias void delegate(wchar c) encode_putwchar;

size_t encode_char(dchar  c, encode_putchar putc)
{
	if (c <= 0x7F)
	{
	    putc(cast(char) c);
	    return 1;
	}
	if (c <= 0x7FF)
	{
	    putc(cast(char)(0xC0 | (c >> 6)));
	    putc(cast(char)(0x80 | (c & 0x3F)));
	    return 2;
	}
	if (c <= 0xFFFF)
	{
	    putc(cast(char)(0xE0 | (c >> 12)));
	    putc(cast(char)(0x80 | ((c >> 6) & 0x3F)));
	    putc(cast(char)(0x80 | (c & 0x3F)));
	    return 3;
	}
	if (c <= 0x10FFFF)
	{
	    putc(cast(char)(0xF0 | (c >> 18)));
	    putc(cast(char)(0x80 | ((c >> 12) & 0x3F)));
	    putc(cast(char)(0x80 | ((c >> 6) & 0x3F)));
	    putc(cast(char)(0x80 | (c & 0x3F)));
	    return 4;
	}
	else
	{
	    assert(0);
	}
}
size_t encode_wchar(E, R)(dchar c, encode_putwchar putw)
{
        if (c <= 0xFFFF)
        {
            r.putw(cast(wchar) c);
            return 1;
        }
        r.putw(cast(wchar) ((((c - 0x10000) >> 10) & 0x3FF) + 0xD800));
        r.putw(cast(wchar) (((c - 0x10000) & 0x3FF) + 0xDC00));
        return 2;
}

/**
 Encodes a single code point to a delegate.

 This function encodes a single code point into one or more code units.
 The code units are passed one at a time to the supplied delegate.

 The input to this function MUST be a valid code point.
 This is enforced by the function's in-contract.

 The type of the output cannot be deduced. Therefore, it is necessary to
 explicitly specify the encoding as a template parameter.

 Supercedes:
 This function supercedes std.utf.encode(), however, note that the
 function codeUnits() supercedes it more conveniently.

 Standards: Unicode 5.0, ASCII, ISO-8859-1, WINDOWS-1252

 Params:
    c = the code point to be encoded
 */
void encode(E)(dchar c, void delegate(E) dg)
in
{
    assert(isValidCodePoint(c));
}
body
{
    EncoderInstance!(E).encode(c,dg);
}

/**
 Returns a foreachable struct which can bidirectionally iterate over all
 code points in a string.

 The input to this function MUST be validly encoded.
 This is enforced by the function's in-contract.

 You can foreach either
 with or without an index. If an index is specified, it will be initialized
 at each iteration with the offset into the string at which the code point
 begins.

 Supercedes:
 This function supercedes std.utf.decode().

 Standards: Unicode 5.0, ASCII, ISO-8859-1, WINDOWS-1252

 Params:
    s = the string to be decoded

 Examples:
 --------------------------------------------------------
 string s = "hello world";
 foreach(c;codePoints(s))
 {
     // do something with c (which will always be a dchar)
 }
 --------------------------------------------------------

 Note that, currently, foreach(c:codePoints(s)) is superior to foreach(c;s)
 in that the latter will fall over on encountering U+FFFF.
 */
CodePoints!(E) codePoints(E)(E[] s)
in
{
    assert(isValid(s));
}
body
{
    return CodePoints!(E)(s);
}

unittest
{
    string s = "hello";
    string t;
    foreach(c;codePoints(s))
    {
        t ~= cast(char)c;
    }
    assert(s == t);
}

/**
 Returns a foreachable struct which can bidirectionally iterate over all
 code units in a code point.

 The input to this function MUST be a valid code point.
 This is enforced by the function's in-contract.

 The type of the output cannot be deduced. Therefore, it is necessary to
 explicitly specify the encoding type in the template parameter.

 Supercedes:
 This function supercedes std.utf.encode().

 Standards: Unicode 5.0, ASCII, ISO-8859-1, WINDOWS-1252

 Params:
    d = the code point to be encoded

 Examples:
 --------------------------------------------------------
 dchar d = '\u20AC';
 foreach(c;codeUnits!(char)(d))
 {
     writefln("%X",c)
 }
 // will print
 // E2
 // 82
 // AC
 --------------------------------------------------------
 */
CodeUnits!(E) codeUnits(E)(dchar c)
in
{
    assert(isValidCodePoint(c));
}
body
{
    return CodeUnits!(E)(c);
}

unittest
{
    char[] a;
    foreach(c;codeUnits!(char)(cast(dchar)'\u20AC'))
    {
        a ~= c;
    }
    assert(a.length == 3);
    assert(a[0] == 0xE2);
    assert(a[1] == 0x82);
    assert(a[2] == 0xAC);
}

/**
Encodes $(D c) in units of type $(D E) and writes the result to the
output range $(D R). Returns the number of $(D E)s written.
 */

uint encode(Tgt, Src, R)(in Src[] s, R range)
{
    uint result;
    foreach (c; s)
    {
        result += encode!(Tgt)(c, range);
    }
    return result;
}

/**
 Convert a string from one encoding to another. (See also to!() below).

 The input to this function MUST be validly encoded.
 This is enforced by the function's in-contract.

 Supercedes:
 This function supercedes std.utf.toUTF8(), std.utf.toUTF16() and
 std.utf.toUTF32()
 (but note that to!() supercedes it more conveniently).

 Standards: Unicode 5.0, ASCII, ISO-8859-1, WINDOWS-1252

 Params:
    s = the source string
    r = the destination string

 Examples:
 --------------------------------------------------------
 wstring ws;
 transcode("hello world",ws);
     // transcode from UTF-8 to UTF-16

 Latin1String ls;
 transcode(ws, ls);
     // transcode from UTF-16 to ISO-8859-1
  --------------------------------------------------------
 */
void transcode(Src,Dst)(Src[] s,out Dst[] r)
in
{
    assert(isValid(s));
}
body
{
    static if(is(Src==Dst))
    {
        r = s;
    }
    else static if(is(Src==AsciiChar))
    {
        transcode!(char,Dst)(cast(string)s,r);
    }
    else
    {
        Src[] t = s;
        while (t.length != 0)
        {
            r ~= encode!(Dst)(decode(t));
        }
    }
}

/*
 Convert a string from one encoding to another. (See also transcode() above).

 The input to this function MUST be validly encoded.
 This is enforced by the function's in-contract.

 Supercedes:
 This function supercedes std.utf.toUTF8(), std.utf.toUTF16() and
 std.utf.toUTF32().

 Standards: Unicode 5.0, ASCII, ISO-8859-1, WINDOWS-1252

 Params:
    Dst = the destination encoding type
    s = the source string

 Examples:
 -----------------------------------------------------------------------------
 auto ws = to!(wchar)("hello world");  // transcode from UTF-8 to UTF-16
 auto ls = to!(Latin1Char)(ws);            // transcode from UTF-16 to ISO-8859-1
 -----------------------------------------------------------------------------
 */
// TODO: Commented out for no - to be moved to std.conv
// Dst to(Dst,Src)(immutable(Src)[] s)
// in
// {
//  assert(isValid(s));
// }
// body
// {
//  Dst r;
//  transcode(s,r);
//  return r;
// }

//=============================================================================

/** The base class for exceptions thrown by this module */
class EncodingException : Exception { this(string msg) { super(msg); } }

class UnrecognizedEncodingException : EncodingException
{
    private this(string msg) { super(msg); }
}

/** Abstract base class of all encoding schemes */
abstract class EncodingScheme
{
    /**
     * Registers a subclass of EncodingScheme.
     *
     * This function allows user-defined subclasses of EncodingScheme to
     * be declared in other modules.
     *
     * Examples:
     * ----------------------------------------------
     * class Amiga1251 : EncodingScheme
     * {
     *     static this()
     *     {
     *         EncodingScheme.register("path.to.Amiga1251");
     *     }
     * }
     * ----------------------------------------------
     */
    static void register(string className)
    {
        auto scheme = cast(EncodingScheme)ClassInfo.find(className).create();
        if (scheme is null)
            throw new EncodingException("Unable to create class "~className);
        foreach(encodingName;scheme.names())
        {
            supported[tolower(encodingName)] = className;
        }
    }

    /**
     * Obtains a subclass of EncodingScheme which is capable of encoding
     * and decoding the named encoding scheme.
     *
     * This function is only aware of EncodingSchemes which have been
     * registered with the register() function.
     *
     * Examples:
     * ---------------------------------------------------
     * auto scheme = EncodingScheme.create("Amiga-1251");
     * ---------------------------------------------------
     */
    static EncodingScheme create(string encodingName)
    {
        auto p = std.string.tolower(encodingName) in supported;
        if (p is null)
            throw new EncodingException("Unrecognized Encoding: "~encodingName);
        string className = *p;
        auto scheme = cast(EncodingScheme)ClassInfo.find(className).create();
        if (scheme is null) throw new EncodingException("Unable to create class "~className);
        return scheme;
    }

         /**
         * Returns the standard name of the encoding scheme
         */
        abstract override string toString();

        /**
         * Returns an array of all known names for this encoding scheme
         */
        abstract string[] names();

        /**
         * Returns true if the character c can be represented
         * in this encoding scheme.
         */
        abstract bool canEncode(dchar c);

        /**
         * Returns the number of ubytes required to encode this code point.
         *
         * The input to this function MUST be a valid code point.
         *
         * Params:
         *    c = the code point to be encoded
         *
         * Returns:
         *    the number of ubytes required.
         */
        abstract uint encodedLength(dchar c);

        /**
         * Encodes a single code point into a user-supplied, fixed-size buffer.
         *
         * This function encodes a single code point into one or more ubytes.
         * The supplied buffer must be code unit aligned.
         * (For example, UTF-16LE or UTF-16BE must be wchar-aligned,
         * UTF-32LE or UTF-32BE must be dchar-aligned, etc.)
         *
         * The input to this function MUST be a valid code point.
         *
         * Params:
         *    c = the code point to be encoded
         *
         * Returns:
         *    the number of ubytes written.
         */
        abstract uint encode(dchar c, ubyte[] buffer);

        /**
         * Decodes a single code point.
         *
         * This function removes one or more ubytes from the start of an array,
         * and returns the decoded code point which those ubytes represent.
         *
         * The input to this function MUST be validly encoded.
         *
         * Params:
         *    s = the array whose first code point is to be decoded
         */
        abstract dchar decode(ref ubyte[] s);

        /**
         * Decodes a single code point. The input does not have to be valid.
         *
         * This function removes one or more ubytes from the start of an array,
         * and returns the decoded code point which those ubytes represent.
         *
         * This function will accept an invalidly encoded array as input.
         * If an invalid sequence is found at the start of the string, this
         * function will remove it, and return the value INVALID_SEQUENCE.
         *
         * Params:
         *    s = the array whose first code point is to be decoded
         */
        abstract dchar safeDecode(ref ubyte[] s);

        /**
         * Returns the sequence of ubytes to be used to represent
         * any character which cannot be represented in the encoding scheme.
         *
         * Normally this will be a representation of some substitution
         * character, such as U+FFFD or '?'.
         */
        abstract ubyte[] replacementSequence();
   

    /**
     * Returns true if the array is encoded correctly
     *
     * Params:
     *    s = the array to be tested
     */
    bool isValid(ubyte[] s)
    {
        while (s.length != 0)
        {
            dchar d = safeDecode(s);
            if (d == INVALID_SEQUENCE)
                return false;
        }
        return true;
    }

    /**
     * Returns the length of the longest possible substring, starting from
     * the first element, which is validly encoded.
     *
     * Params:
     *    s = the array to be tested
     */
    uint validLength(ubyte[] s)
    {
        ubyte[] r = s;
        ubyte[] t = s;
        while (s.length != 0)
        {
            if (safeDecode(s) == INVALID_SEQUENCE) break;
            t = s;
        }
        return r.length - t.length;
    }

    /**
     * Sanitizes an array by replacing malformed ubyte sequences with valid
     * ubyte sequences. The result is guaranteed to be valid for this
     * encoding scheme.
     *
     * If the input array is already valid, this function returns the
     * original, otherwise it constructs a new array by replacing all illegal
     * sequences with the encoding scheme's replacement sequence.
     *
     * Params:
     *    s = the string to be sanitized
     */
     ubyte[] sanitize(ubyte[] s)
    {
		uint n = validLength(s);
		if (n == s.length) return s;

		auto repSeq = replacementSequence;

		// Count how long the string needs to be.
		// Overestimating is not a problem
		uint len = s.length;
		ubyte[] t = s[n..$];
		while (t.length != 0)
		{
			dchar c = safeDecode(t);
			assert(c == INVALID_SEQUENCE);
			len += repSeq.length;
			t = t[validLength(t)..$];
		}

		// Now do the write
		ubyte[] array = new ubyte[len];
		array[0..n] = s[0..n];
		uint offset = n;

		t = s[n..$];
		while (t.length != 0)
		{
			dchar c = safeDecode(t);
			assert(c == INVALID_SEQUENCE);
			array[offset .. offset+repSeq.length] = repSeq[];
			offset += repSeq.length;
			n = validLength(t);
			array[offset..offset+n] = t[0..n];
			offset += n;
			t = t[n..$];
		}
		return cast(ubyte[])array[0..offset];
    }

    /**
     * Returns the length of the first encoded sequence.
     *
     * The input to this function MUST be validly encoded.
     * This is enforced by the function's in-contract.
     *
     * Params:
     *    s = the array to be sliced
     */
    uint firstSequence(ubyte[] s)
    in
    {
        assert(s.length != 0);
        ubyte[] u = s;
        assert(safeDecode(u) != INVALID_SEQUENCE);
    }
    body
    {
        ubyte[] t = s;
        decode(s);
        return t.length - s.length;
    }

    /**
     * Returns the total number of code points encoded in a ubyte array.
     *
     * The input to this function MUST be validly encoded.
     * This is enforced by the function's in-contract.
     *
     * Params:
     *    s = the string to be counted
     */
    uint count(ubyte[] s)
    in
    {
        assert(isValid(s));
    }
    body
    {
        uint n = 0;
        while (s.length != 0)
        {
            decode(s);
            ++n;
        }
        return n;
    }

    /**
     * Returns the array index at which the (n+1)th code point begins.
     *
     * The input to this function MUST be validly encoded.
     * This is enforced by the function's in-contract.
     *
     * Params:
     *    s = the string to be counted
     */
    int index(ubyte[] s,int n)
    in
    {
        assert(isValid(s));
        assert(n >= 0);
    }
    body
    {
        ubyte[] t = s;
        for (uint i=0; i<n; ++i) decode(s);
        return t.length - s.length;
    }

    static string[string] supported;
}

/**
 EncodingScheme to handle ASCII

 This scheme recognises the following names:
                 "ANSI_X3.4-1968",
                 "ANSI_X3.4-1986",
                 "ASCII",
                 "IBM367",
                 "ISO646-US",
                 "ISO_646.irv:1991",
                 "US-ASCII",
                 "cp367",
                 "csASCII"
                 "iso-ir-6",
                 "us"
 */
class EncodingSchemeASCII : EncodingScheme
{
    static this()
    {
        EncodingScheme.register("std2.encoding.EncodingSchemeASCII");
    }


        override string[] names()
        {
            return
            [
                cast(string)
                "ANSI_X3.4-1968",
                "ANSI_X3.4-1986",
                "ASCII",
                "IBM367",
                "ISO646-US",
                "ISO_646.irv:1991",
                "US-ASCII",
                "cp367",
                "csASCII"
                "iso-ir-6",
                "us"
            ];
        }

        override string toString()
        {
            return "ASCII";
        }

        override bool canEncode(dchar c)
        {
            return std2.encoding.canEncode!(AsciiChar)(c);
        }
        
        override uint encodedLength(dchar c)
        {
        	return std2.encoding.encodedLength!(AsciiChar)(c);
        }

        override uint encode(dchar c, ubyte[] buffer)
        {
        	auto r = cast(AsciiChar[])buffer;
            return std2.encoding.encode(c,r);
        }

        override dchar decode(ref ubyte[] s)
        {
            auto t = cast(AsciiChar[]) s;
            dchar c = std2.encoding.decode(t);
            s = s[$-t.length..$];
            return c;
        }

        override dchar safeDecode(ref ubyte[] s)
        {
            auto t = cast(AsciiChar[]) s;
            dchar c = std2.encoding.safeDecode(t);
            s = s[$-t.length..$];
            return c;
        }

        override ubyte[] replacementSequence()
        {
            return cast(ubyte[])"?";
        }

}

/**
 EncodingScheme to handle Latin-1

 This scheme recognises the following names:
                 "CP819",
                 "IBM819",
                 "ISO-8859-1",
                 "ISO_8859-1",
                 "ISO_8859-1:1987",
                 "csISOLatin1",
                 "iso-ir-100",
                 "l1",
                 "latin1"
 */
class EncodingSchemeLatin1 : EncodingScheme
{
    static this()
    {
        EncodingScheme.register("std2.encoding.EncodingSchemeLatin1");
    }

        override string[] names()
        {
            return
            [
                cast(string)
                "CP819",
                "IBM819",
                "ISO-8859-1",
                "ISO_8859-1",
                "ISO_8859-1:1987",
                "csISOLatin1",
                "iso-ir-100",
                "l1",
                "latin1"
            ];
        }

        override string toString()
        {
            return "ISO-8859-1";
        }

        override bool canEncode(dchar c)
        {
            return std2.encoding.canEncode!(Latin1Char)(c);
        }

        override uint encodedLength(dchar c)
        {
        	return std2.encoding.encodedLength!(Latin1Char)(c);
        }

        override uint encode(dchar c, ubyte[] buffer)
        {
        	auto r = cast(Latin1Char[])buffer;
            return std2.encoding.encode(c,r);
        }

        override dchar decode(ref ubyte[] s)
        {
            auto t = cast(Latin1Char[]) s;
            dchar c = std2.encoding.decode(t);
            s = s[$-t.length..$];
            return c;
        }

        override dchar safeDecode(ref ubyte[] s)
        {
            auto t = cast(Latin1Char[]) s;
            dchar c = std2.encoding.safeDecode(t);
            s = s[$-t.length..$];
            return c;
        }

        override ubyte[] replacementSequence()
        {
            return cast(ubyte[])"?";
        }
}

/**
 EncodingScheme to handle Windows-1252

 This scheme recognises the following names:
                 "windows-1252"
 */
class EncodingSchemeWindows1252 : EncodingScheme
{
    static this()
    {
        EncodingScheme.register("std2.encoding.EncodingSchemeWindows1252");
    }

        override string[] names()
        {
            return
            [
                cast(string)
                "windows-1252"
            ];
        }

        override string toString()
        {
            return "windows-1252";
        }

        override bool canEncode(dchar c)
        {
            return std2.encoding.canEncode!(Windows1252Char)(c);
        }

        override uint encodedLength(dchar c)
        {
        	return std2.encoding.encodedLength!(Windows1252Char)(c);
        }

        override uint encode(dchar c, ubyte[] buffer)
        {
        	auto r = cast(Windows1252Char[])buffer;
            return std2.encoding.encode(c,r);
        }

        override dchar decode(ref ubyte[] s)
        {
            auto t = cast(Windows1252Char[]) s;
            dchar c = std2.encoding.decode(t);
            s = s[$-t.length..$];
            return c;
        }

        override dchar safeDecode(ref ubyte[] s)
        {
            auto t = cast(Windows1252Char[]) s;
            dchar c = std2.encoding.safeDecode(t);
            s = s[$-t.length..$];
            return c;
        }

        override ubyte[] replacementSequence()
        {
            return cast(ubyte[])"?";
        }
}

/**
 EncodingScheme to handle UTF-8

 This scheme recognises the following names:
                 "UTF-8"
 */
class EncodingSchemeUtf8 : EncodingScheme
{
    static this()
    {
        EncodingScheme.register("std2.encoding.EncodingSchemeUtf8");
    }

        override string[] names()
        {
            return
            [
                cast(string)
                "UTF-8"
            ];
        }

        override string toString()
        {
            return "UTF-8";
        }

        override bool canEncode(dchar c)
        {
            return std2.encoding.canEncode!(char)(c);
        }

        override uint encodedLength(dchar c)
        {
        	return std2.encoding.encodedLength!(char)(c);
        }

        override uint encode(dchar c, ubyte[] buffer)
        {
        	auto r = cast(char[])buffer;
            return std2.encoding.encode(c,r);
        }

        override dchar decode(ref ubyte[] s)
        {
            auto t = cast(char[]) s;
            dchar c = std2.encoding.decode(t);
            s = s[$-t.length..$];
            return c;
        }

        override dchar safeDecode(ref ubyte[] s)
        {
            auto t = cast(char[]) s;
            dchar c = std2.encoding.safeDecode(t);
            s = s[$-t.length..$];
            return c;
        }

        override ubyte[] replacementSequence()
        {
            return cast(ubyte[])"\uFFFD";
        }

}

/**
 EncodingScheme to handle UTF-16 in native byte order

 This scheme recognises the following names:
                 "UTF-16LE" (little-endian architecture only)
                 "UTF-16BE" (big-endian architecture only)
 */
class EncodingSchemeUtf16Native : EncodingScheme
{
    static this()
    {
        EncodingScheme.register("std2.encoding.EncodingSchemeUtf16Native");
    }

        version(LittleEndian) { string NAME = "UTF-16LE"; }
        version(BigEndian)    { string NAME = "UTF-16BE"; }

        override string[] names()
        {
            return [ NAME ];
        }

        override string toString()
        {
            return NAME;
        }

        override bool canEncode(dchar c)
        {
            return std2.encoding.canEncode!(wchar)(c);
        }

        override uint encodedLength(dchar c)
        {
        	return std2.encoding.encodedLength!(wchar)(c);
        }

        override uint encode(dchar c, ubyte[] buffer)
        {
        	auto r = cast(wchar[])buffer;
            return wchar.sizeof * std2.encoding.encode(c,r);
        }

        override dchar decode(ref ubyte[] s)
        in
        {
            assert((s.length & 1) == 0);
        }
        body
        {
            auto t = cast(wchar[]) s;
            dchar c = std2.encoding.decode(t);
            s = s[$-t.length..$];
            return c;
        }

        override dchar safeDecode(ref ubyte[] s)
        in
        {
            assert((s.length & 1) == 0);
        }
        body
        {
            auto t = cast(wchar[]) s;
            dchar c = std2.encoding.safeDecode(t);
            s = s[$-t.length..$];
            return c;
        }

        override ubyte[] replacementSequence()
        {
            return cast(ubyte[])"\uFFFD"w;
        }
}

/**
 EncodingScheme to handle UTF-32 in native byte order

 This scheme recognises the following names:
                 "UTF-32LE" (little-endian architecture only)
                 "UTF-32BE" (big-endian architecture only)
 */
class EncodingSchemeUtf32Native : EncodingScheme
{
    static this()
    {
        EncodingScheme.register("std2.encoding.EncodingSchemeUtf32Native");
    }


        version(LittleEndian) { string NAME = "UTF-32LE"; }
        version(BigEndian)    { string NAME = "UTF-32BE"; }

        override string[] names()
        {
            return [ NAME ];
        }

        override string toString()
        {
            return NAME;
        }

        override bool canEncode(dchar c)
        {
            return std2.encoding.canEncode!(dchar)(c);
        }

        override uint encodedLength(dchar c)
        {
        	return std2.encoding.encodedLength!(dchar)(c);
        }

        override uint encode(dchar c, ubyte[] buffer)
        {
        	auto r = cast(dchar[])buffer;
            return dchar.sizeof * std2.encoding.encode(c,r);
        }

        override dchar decode(ref ubyte[] s)
        in
        {
            assert((s.length & 3) == 0);
        }
        body
        {
            auto t = cast(dchar[]) s;
            dchar c = std2.encoding.decode(t);
            s = s[$-t.length..$];
            return c;
        }

        override dchar safeDecode(ref ubyte[] s)
        in
        {
            assert((s.length & 3) == 0);
        }
        body
        {
            auto t = cast(dchar[]) s;
            dchar c = std2.encoding.safeDecode(t);
            s = s[$-t.length..$];
            return c;
        }

        override ubyte[] replacementSequence()
        {
            return cast(ubyte[])"\uFFFD"d;
        }
}

void transcodeReverse(Src,Dst)(Src[] s, out Dst[] r)
{
    static if(is(Src==Dst))
    {
        return s;
    }
    else static if(is(Src==AsciiChar))
    {
        transcodeReverse!(char,Dst)(cast(string)s,r);
    }
    else
    {
        foreach_reverse(d;codePoints(s))
        {
            foreach_reverse(c;codeUnits!(Dst)(d))
            {
                r = c ~ r;
            }
        }
    }
}

string makeReadable(string s)
{
    string r = "\"";
    foreach(char c;s)
    {
        if (c >= 0x20 && c < 0x80)
        {
            r ~= c;
        }
        else
        {
            r ~= "\\x";
            r ~= toHexDigit(c >> 4);
            r ~= toHexDigit(c);
        }
    }
    r ~= "\"";
    return r;
}

string makeReadable(wstring s)
{
    string r = "\"";
    foreach(wchar c;s)
    {
        if (c >= 0x20 && c < 0x80)
        {
            r ~= cast(char) c;
        }
        else
        {
            r ~= "\\u";
            r ~= toHexDigit(c >> 12);
            r ~= toHexDigit(c >> 8);
            r ~= toHexDigit(c >> 4);
            r ~= toHexDigit(c);
        }
    }
    r ~= "\"w";
    return r;
}

string makeReadable(dstring s)
{
    string r = "\"";
    foreach(dchar c; s)
    {
        if (c >= 0x20 && c < 0x80)
        {
            r ~= cast(char) c;
        }
        else if (c < 0x10000)
        {
            r ~= "\\u";
            r ~= toHexDigit(c >> 12);
            r ~= toHexDigit(c >> 8);
            r ~= toHexDigit(c >> 4);
            r ~= toHexDigit(c);
        }
        else
        {
            r ~= "\\U00";
            r ~= toHexDigit(c >> 20);
            r ~= toHexDigit(c >> 16);
            r ~= toHexDigit(c >> 12);
            r ~= toHexDigit(c >> 8);
            r ~= toHexDigit(c >> 4);
            r ~= toHexDigit(c);
        }
    }
    r ~= "\"d";
    return r;
}

char toHexDigit(int n)
{
    return "0123456789ABCDEF"[n & 0xF];
}


unittest
{
	void TestEncoding()
	{
	    ubyte[][] validStrings =
	    [
		// Plain ASCII
		cast(ubyte[])"hello",

		// First possible sequence of a certain length
		[ 0x00 ],                       // U+00000000   one byte
		[ 0xC2, 0x80 ],                 // U+00000080   two bytes
		[ 0xE0, 0xA0, 0x80 ],           // U+00000800   three bytes
		[ 0xF0, 0x90, 0x80, 0x80 ],     // U+00010000   three bytes

		// Last possible sequence of a certain length
		[ 0x7F ],                       // U+0000007F   one byte
		[ 0xDF, 0xBF ],                 // U+000007FF   two bytes
		[ 0xEF, 0xBF, 0xBF ],           // U+0000FFFF   three bytes

		// Other boundary conditions
		[ 0xED, 0x9F, 0xBF ],
		// U+0000D7FF   Last character before surrogates
		[ 0xEE, 0x80, 0x80 ],
		// U+0000E000   First character after surrogates
		[ 0xEF, 0xBF, 0xBD ],
		// U+0000FFFD   Unicode replacement character
		[ 0xF4, 0x8F, 0xBF, 0xBF ],
		// U+0010FFFF   Very last character

		// Non-character code points
		/*  NOTE: These are legal in UTF, and may be converted from
		    one UTF to another, however they do not represent Unicode
		    characters. These code points have been reserved by
		    Unicode as non-character code points. They are permissible
		    for data exchange within an application, but they are are
		    not permitted to be used as characters. Since this module
		    deals with UTF, and not with Unicode per se, we choose to
		    accept them here. */
		[ 0xDF, 0xBE ],                 // U+0000FFFE
		[ 0xDF, 0xBF ],                 // U+0000FFFF
	    ];


	    ubyte[][] invalidStrings =
	    [
		// First possible sequence of a certain length, but greater
		// than U+10FFFF
		[ 0xF8, 0x88, 0x80, 0x80, 0x80 ],           // U+00200000   five bytes
		[ 0xFC, 0x84, 0x80, 0x80, 0x80, 0x80 ],     // U+04000000   six bytes

		// Last possible sequence of a certain length, but greater than U+10FFFF
		[ 0xF7, 0xBF, 0xBF, 0xBF ],                 // U+001FFFFF   four bytes
		[ 0xFB, 0xBF, 0xBF, 0xBF, 0xBF ],           // U+03FFFFFF   five bytes
		[ 0xFD, 0xBF, 0xBF, 0xBF, 0xBF, 0xBF ],     // U+7FFFFFFF   six bytes

		// Other boundary conditions
		[ 0xF4, 0x90, 0x80, 0x80 ],                 // U+00110000
			                                    // First code
			                                    // point after
			                                    // last character

		// Unexpected continuation bytes
		[ 0x80 ],
		[ 0xBF ],
		[ 0x20, 0x80, 0x20 ],
		[ 0x20, 0xBF, 0x20 ],
		[ 0x80, 0x9F, 0xA0 ],

		// Lonely start bytes
		[ 0xC0 ],
		[ 0xCF ],
		[ 0x20, 0xC0, 0x20 ],
		[ 0x20, 0xCF, 0x20 ],
		[ 0xD0 ],
		[ 0xDF ],
		[ 0x20, 0xD0, 0x20 ],
		[ 0x20, 0xDF, 0x20 ],
		[ 0xE0 ],
		[ 0xEF ],
		[ 0x20, 0xE0, 0x20 ],
		[ 0x20, 0xEF, 0x20 ],
		[ 0xF0 ],
		[ 0xF1 ],
		[ 0xF2 ],
		[ 0xF3 ],
		[ 0xF4 ],
		[ 0xF5 ],   // If this were legal it would start a character > U+10FFFF
		[ 0xF6 ],   // If this were legal it would start a character > U+10FFFF
		[ 0xF7 ],   // If this were legal it would start a character > U+10FFFF

		[ 0xEF, 0xBF ],             // Three byte sequence with third byte missing
		[ 0xF7, 0xBF, 0xBF ],       // Four byte sequence with fourth byte missing
		[ 0xEF, 0xBF, 0xF7, 0xBF, 0xBF ],   // Concatenation of the above

		// Impossible bytes
		[ 0xF8 ],
		[ 0xF9 ],
		[ 0xFA ],
		[ 0xFB ],
		[ 0xFC ],
		[ 0xFD ],
		[ 0xFE ],
		[ 0xFF ],
		[ 0x20, 0xF8, 0x20 ],
		[ 0x20, 0xF9, 0x20 ],
		[ 0x20, 0xFA, 0x20 ],
		[ 0x20, 0xFB, 0x20 ],
		[ 0x20, 0xFC, 0x20 ],
		[ 0x20, 0xFD, 0x20 ],
		[ 0x20, 0xFE, 0x20 ],
		[ 0x20, 0xFF, 0x20 ],

		// Overlong sequences, all representing U+002F
		/*  With a safe UTF-8 decoder, all of the following five overlong
		    representations of the ASCII character slash ("/") should be
		    rejected like a malformed UTF-8 sequence */
		[ 0xC0, 0xAF ],
		[ 0xE0, 0x80, 0xAF ],
		[ 0xF0, 0x80, 0x80, 0xAF ],
		[ 0xF8, 0x80, 0x80, 0x80, 0xAF ],
		[ 0xFC, 0x80, 0x80, 0x80, 0x80, 0xAF ],

		// Maximum overlong sequences
		/*  Below you see the highest Unicode value that is still resulting in
		    an overlong sequence if represented with the given number of bytes.
		    This is a boundary test for safe UTF-8 decoders. All five
		    characters should be rejected like malformed UTF-8 sequences. */
		[ 0xC1, 0xBF ],                             // U+0000007F
		[ 0xE0, 0x9F, 0xBF ],                       // U+000007FF
		[ 0xF0, 0x8F, 0xBF, 0xBF ],                 // U+0000FFFF
		[ 0xF8, 0x87, 0xBF, 0xBF, 0xBF ],           // U+001FFFFF
		[ 0xFC, 0x83, 0xBF, 0xBF, 0xBF, 0xBF ],     // U+03FFFFFF

		// Overlong representation of the NUL character
		/*  The following five sequences should also be rejected like malformed
		    UTF-8 sequences and should not be treated like the ASCII NUL
		    character. */
		[ 0xC0, 0x80 ],
		[ 0xE0, 0x80, 0x80 ],
		[ 0xF0, 0x80, 0x80, 0x80 ],
		[ 0xF8, 0x80, 0x80, 0x80, 0x80 ],
		[ 0xFC, 0x80, 0x80, 0x80, 0x80, 0x80 ],

		// Illegal code positions
		/*  The following UTF-8 sequences should be rejected like malformed
		    sequences, because they never represent valid ISO 10646 characters
		    and a UTF-8 decoder that accepts them might introduce security
		    problems comparable to overlong UTF-8 sequences. */
		[ 0xED, 0xA0, 0x80 ],       // U+D800
		[ 0xED, 0xAD, 0xBF ],       // U+DB7F
		[ 0xED, 0xAE, 0x80 ],       // U+DB80
		[ 0xED, 0xAF, 0xBF ],       // U+DBFF
		[ 0xED, 0xB0, 0x80 ],       // U+DC00
		[ 0xED, 0xBE, 0x80 ],       // U+DF80
		[ 0xED, 0xBF, 0xBF ],       // U+DFFF
	    ];

	    string[] sanitizedStrings =
	    [
		"\uFFFD","\uFFFD",
		"\uFFFD","\uFFFD","\uFFFD","\uFFFD","\uFFFD","\uFFFD"," \uFFFD ",
		" \uFFFD ","\uFFFD\uFFFD\uFFFD","\uFFFD","\uFFFD"," \uFFFD "," \uFFFD ",
		"\uFFFD","\uFFFD"," \uFFFD "," \uFFFD ","\uFFFD","\uFFFD"," \uFFFD ",
		" \uFFFD ","\uFFFD","\uFFFD","\uFFFD","\uFFFD","\uFFFD","\uFFFD",
		"\uFFFD","\uFFFD","\uFFFD","\uFFFD","\uFFFD\uFFFD","\uFFFD","\uFFFD",
		"\uFFFD","\uFFFD","\uFFFD","\uFFFD","\uFFFD","\uFFFD"," \uFFFD ",
		" \uFFFD "," \uFFFD "," \uFFFD "," \uFFFD "," \uFFFD "," \uFFFD ",
		" \uFFFD ","\uFFFD","\uFFFD","\uFFFD","\uFFFD","\uFFFD","\uFFFD",
		"\uFFFD","\uFFFD","\uFFFD","\uFFFD","\uFFFD","\uFFFD","\uFFFD","\uFFFD",
		"\uFFFD","\uFFFD","\uFFFD","\uFFFD","\uFFFD","\uFFFD","\uFFFD","\uFFFD",
	    ];

	    // Make sure everything that should be valid, is
	    foreach(a;validStrings)
	    {
		string s = cast(string)a;
		assert(isValid(s),"Failed to validate: "~makeReadable(s));
	    }

	    // Make sure everything that shouldn't be valid, isn't
	    foreach(a;invalidStrings)
	    {
		string s = cast(string)a;
		assert(!isValid(s),"Incorrectly validated: "~makeReadable(s));
	    }

	    // Make sure we can sanitize everything bad
	    assert(invalidStrings.length == sanitizedStrings.length);
	    for(int i=0; i<invalidStrings.length; ++i)
	    {
		string s = cast(string)invalidStrings[i];
		string t = sanitize(s);
		assert(isValid(t));
		assert(t == sanitizedStrings[i]);
		ubyte[] u = cast(ubyte[])t;
		validStrings ~= u;
	    }

	    // Make sure all transcodings work in both directions, using both forward
	    // and reverse iteration
	    foreach(i,a; validStrings)
	    {
		string s = cast(string)a;
		string s2;
		wstring ws, ws2;
		dstring ds, ds2;

		transcode(s,ws);
		assert(isValid(ws));
		transcode(ws,s2);
		assert(s == s2);

		transcode(s,ds);
		assert(isValid(ds));
		transcode(ds,s2);
		assert(s == s2);

		transcode(ws,s);
		assert(isValid(s));
		transcode(s,ws2);
		assert(ws == ws2);

		transcode(ws,ds);
		assert(isValid(ds));
		transcode(ds,ws2);
		assert(ws == ws2);

		transcode(ds,s);
		assert(isValid(s));
		transcode(s,ds2);
		assert(ds == ds2);

		transcode(ds,ws);
		assert(isValid(ws));
		transcode(ws,ds2);
		assert(ds == ds2);

		transcodeReverse(s,ws);
		assert(isValid(ws));
		transcodeReverse(ws,s2);
		assert(s == s2);

		transcodeReverse(s,ds);
		assert(isValid(ds));
		transcodeReverse(ds,s2);
		assert(s == s2);

		transcodeReverse(ws,s);
		assert(isValid(s));
		transcodeReverse(s,ws2);
		assert(ws == ws2);

		transcodeReverse(ws,ds);
		assert(isValid(ds));
		transcodeReverse(ds,ws2);
		assert(ws == ws2);

		transcodeReverse(ds,s);
		assert(isValid(s));
		transcodeReverse(s,ds2);
		assert(ds == ds2);

		transcodeReverse(ds,ws);
		assert(isValid(ws));
		transcodeReverse(ws,ds2);
		assert(ds == ds2);
	    }

	    // Make sure the non-UTF encodings work too
	    {
		auto s = "\u20AC100";
		Windows1252String t;
		transcode(s,t);
		assert(t == [cast(Windows1252Char)0x80, '1', '0', '0']);
		string u;
		transcode(s,u);
		assert(s == u);
		Latin1String v;
		transcode(s,v);
		assert(cast(string)v == "?100");
		AsciiString w;
		transcode(v,w);
		assert(cast(string)w == "?100");
	    }
	    
	    // Make sure we can count properly
	    {
	    	assert(encodedLength!(char)('A') == 1);
	    	assert(encodedLength!(char)('\u00E3') == 2);
	    	assert(encodedLength!(char)('\u2028') == 3);
	    	assert(encodedLength!(char)('\U0010FFF0') == 4);
	    	assert(encodedLength!(wchar)('A') == 1);
	    	assert(encodedLength!(wchar)('\U0010FFF0') == 2);
	    }
	    
	    // Make sure we can write into mutable arrays
	    {
		char[4] buffer;
		uint n = encode(cast(dchar)'\u00E3',buffer);
		assert(n == 2);
		assert(buffer[0] == 0xC3);
		assert(buffer[1] == 0xA3);
	    }
	}
	TestEncoding();

}
version (unittest_report)
{
    import std.io;
    unittest {
        writefln("unittest std2.encoding passed");
    }
}
//=============================================================================


version (build) {
    debug {
        pragma(link, "auxd");
    } else {
        pragma(link, "auxd");
    }
}
