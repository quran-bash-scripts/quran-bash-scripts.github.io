
# Table of Contents

1.  [IMPORTANT INFORMATION:](#org5fc03eb)
2.  [IMPORTANT NOTES:](#orga1390f6)
    1.  [Important Note N°1](#org03529ad)
    2.  [Important Note N°2](#org9c9cc29)
3.  [tafsir.sh](#org2b3c20e)
    1.  [SYNOPSIS](#org6bc98ea)
    2.  [DESCRIPTION](#org59c93dc)
    3.  [EXAMPLES:](#orgd7ea7c8)
    4.  [DEPENDENCIES](#org4484715)
        1.  [App dependencies](#org1984db9)
        2.  [Supported Format of Tafsir Files](#orgd6c3b74)
        3.  [How to Prepare the Tafsir Files](#org3c2cfc1)
4.  [qap-audio-player.sh](#org833d554)
    1.  [SYNOPSIS](#org49d617d)
    2.  [DESCRIPTION](#org1c6c55c)
    3.  [EXAMPLES](#org9dfbe6f)
    4.  [AS FOR THE REST OF THE OPTIONS:](#org157c290)
    5.  [DEPENDENCIES](#org4925571)
    6.  [CREATING THE PLAYLIST FILES](#org5e0dce8)
5.  [rq-ayat-3x-each-then-1.sh](#orgc24d5f5)
    1.  [SYNOPSYS](#orgcb1a354)
    2.  [DESCRIPTION](#orgabe0acf)
    3.  [COMMAND LINE OPTIONS](#org433ae4e)
    4.  [EXAMPLES](#orgcab4ddc)
    5.  [DEPENDENCIES](#org237f934)
6.  [Divide Quran 6236 Audio Files to Various Units](#org261c568)
    1.  [divide-quran-per-suwar.sh](#org9d90e4a)
    2.  [divide-quran-per-juz.sh](#org2ac223a)
    3.  [divide-quran-per-hizb-1-safe.sh](#orgbc73d5b)
    4.  [divide-quran-per-hizb-2-unsafe.sh](#org2208a91)
    5.  [divide-quran-per-hizb-roub-1-safe.sh](#org8a15fbf)
    6.  [divide-quran-per-hizb-roub-2-unsafe.sh](#orgfc5d2cd)
    7.  [divide-quran-per-page-1-safe.sh](#org313bc22)
    8.  [divide-quran-per-page-2-unsafe.sh](#orgf10af36)
    9.  [Bonus: move-21-ayat-in-subdirs.sh](#orgeb0b406)
7.  [div-trans-textFile-to-6236-TXT-Files](#orgafd665b)
    1.  [Dependencies:](#org55fca83)
        1.  [01-Quran-Verses-Line-Numbers.txt](#orgfafd260)
        2.  [02-VerseByVerse-Quran-Ayat-List.txt](#orge1f7946)
        3.  [Zekr/Tanzil Translation files](#org519cca8)
8.  [Show Sûrah or Âyah Metadata](#orgc1d58db)
    1.  [List of Verses of Surah-Juz-Hizb-RubUlHizb-PageNumber](#org274d25f)
        1.  [show-list-of-verses-that-belong-to-this-surah.sh](#org2a02680)
        2.  [show-list-of-verses-that-belong-to-this-juz.sh](#org2c3fed6)
        3.  [show-list-of-verses-that-belong-to-this-hizb.sh](#org46975de)
        4.  [show-list-of-verses-that-belong-to-this-rub-al-hizb.sh](#org84fc722)
        5.  [show-list-of-verses-that-belong-to-this-page-number.sh](#orge8b3952)
    2.  [Number of Verses of Surah-Juz-Hizb-RubUlHizb-PageNumber](#org632b19f)
        1.  [give-the-number-of-verses-of-surah.sh](#org8b51048)
        2.  [show-number-of-verses-that-belong-to-this-juz.sh](#org6f40f7f)
        3.  [show-number-of-verses-that-belong-to-this-hizb.sh](#org1b64722)
        4.  [show-number-of-verses-that-belong-to-this-rub-al-hizb.sh](#orgea78f20)
        5.  [show-number-of-verses-that-belong-to-this-page-number.sh](#orgeae93e9)
    3.  [Show ID of the Greater Unit to Which a Verse Belongs](#org907bd7d)
        1.  [show-juz-to-which-this-ayah-belongs.sh](#org4e4459b)
        2.  [show-hizb-to-which-this-ayah-belongs.sh](#org5313f26)
        3.  [show-rub-al-hizb-to-which-this-ayah-belongs.sh](#org29911e9)
        4.  [show-page-number-to-which-this-ayah-belongs.sh](#orgb6a7b5e)
    4.  [Show Some More Info for a Surah](#org03a5fd9)
        1.  [show-surah-meccan-or-medinan.sh](#orgfcfe676)
        2.  [show-surah-name-arabic.sh](#orgdfab0ce)
        3.  [show-surah-name-english.sh](#org1b45f28)
        4.  [show-surah-number.sh](#orgda4e52d)
        5.  [show-surah-number-without-leading-zeros.sh](#org0631073)
    5.  [Show Number of Elements Contained in the Unit to Which a Verse Belongs](#orgb9d8e6b)
        1.  [get-number-of-ayaat-of-the-surah-to-which-this-ayah-belongs.sh](#orgb2b664f)
    6.  [Other Ayah Related BASH Functions](#orgeb31b8f)
        1.  [`show_number_of_pages_of_a_surah.sh`](#org537b4c2)
        2.  [ayah-necessitates-sadjdah-or-not.sh](#org08a1aa4)
        3.  [play-basmala-for-the-113-suwar.sh](#org2de95fe)
9.  [Download Section](#org426831f)
    1.  [tafsir.sh](#org5ab802f)
    2.  [qap-audio-player.sh](#org95cd6b7)
    3.  [rq-ayat-3x-each-then-1-5.0-ALPHA.sh](#org9ef00bf)
    4.  [Tafsir Files](#org142dbed)
    5.  [Playlist Files + Audios](#org882687b)
    6.  [Translation Files Divided into 6236 TXT Files](#org3110bb4)
    7.  [Scripts that Divide the Quran 6236 Audio Files into Various Units](#org74cfb5e)
    8.  [Scripts that Divide Translation Text-Files into 6236 TXT Files](#org9af021d)
    9.  [Scripts that Show Various Sûrah or Âyah Metadata](#org5576dc8)
    10. [Custom Tanzil/Zekr Translation/Tafsir Files](#org0628b4f)
    11. [Other Scripts](#org54f3375)



<a id="org5fc03eb"></a>

# IMPORTANT INFORMATION:

**In the Name of Allah The entirely Mercifyl, the especially Merciful**

Please note that this site and the programs it provides are a work in progress. We are still in beta.


<a id="orga1390f6"></a>

# IMPORTANT NOTES:


<a id="org03529ad"></a>

## Important Note N°1

The first lines of the scripts contain:

-variable declations

-a function that gets the root directory of the script (and uses that to search for the relevent files needed by the script)

-`getopt` related stuff to check command line arguments

Just after that, appear huge functions of thousands of lines which get for us various information related to verses, suwar, juz, hizb, rub-\`ul-hizb or page numbers. Since the Quran has 6236 verses, 114 suwar, 30 juz, 60 hizb, 240 rub-\`ul-hizb and 604 pages, it is only natural that these functions would need thousands of lines. It is important to make this known because anyone who looks to the code would get frustrated as he/she scrolls down endless lines. To edit the code go to the last line of the scripts and then scroll up to the last metadata-related functions: that's from were the real code of the scripts start. If you want to edit the scripts, that's where you want to do it.


<a id="org9c9cc29"></a>

## Important Note N°2

The Quran has 6236 verses. This is the number of verses you should find in any Tanzil/Zekr Tafsir/Translation files. This is also the number of verses you should normally get in any Zekr Quran Audio Recitation file. However, this number could change. This number could vary if each Sûrah has the Basmala as its first verse. For example 002000.mp3 (or 002000.oga) would be the Basmala for Sûratul-Baqarah.

If each Sûrah has its own Basmala the number of files would increase with 114 more verses. This situation as pointed out above, could only arise in the case of the Quran Audio Recitation Files, not of Tanzil/Zekr Translation/Tafsir files. It is very very important, in fact it is compulsory, very vital that all the \*OOO.mp3 (or \*000.oga) files get deleted before, for example, creating the Playlist files that will be used by the `qap-audio-player` below. If there is an addition of one single file to the 6236 Quran verses, the resulting Playlist file will have an additional 1 line somewhere between the 6236 lines. If this happens, the app will never work properly.

The app heavily relies on the playlist file having 6236 lines, each line corresponding to a verse of the Quran as it appears in any valid Tanzil/Zekr Tafsir/Translation file. As pointed out, the Tanzil/Zekr Translation/Tafsir files could tolerate additional lines, however, they have to appear after the 6236 lines designating the verses of the Quran. This is also the case for the Playlist files. They would tolerate additional lines if they appear after the 6236 lines pointing to the 6236 Quran audio files. The additional lines could give some licence information or any other type of information. These additional lines will never be used by the program.


<a id="org2b3c20e"></a>

# tafsir.sh


<a id="org6bc98ea"></a>

## SYNOPSIS

tafsir.sh -a|--ayaat verse(s) -s|--suwar sûrah(s) -f|--tafsir-format format of the tafsir files to generate: txt || htm -h|--help -J|--juz -H|--hizb -R|--rub-ul-hizb -P|--page-number -t|--txt-tafasir -x|--htm-tafasir -o|--output-file-root


<a id="org59c93dc"></a>

## DESCRIPTION

This script, if given zekr/tanzil translation/tafsir files with the "\*trans.zekr" extension, or the  "\*trans.zekr.7z" extension will generate/or show the tafsir one or more ayat, one or more suwar passed through the command line as follows:

-a|--ayaat takes 3-digits designating the Sûrah number followed by 3 other digits for the given verse. For example: 005012  means:
Sûrah 5, verse 12. Here one can provide verses in this format - one or more, quoted  for instance: '002102 005075 009105'.
One can also provide ayah numbers  in range. For instance:
'001001\_001007'  in such case, the separating character between the two ayaat numbers has to be the underscore character: '\_'

-f|--tafsir-format takes either htm or txt. Quoiting is not needed. This is the format in which the file should be generated.

-s|--suwar takes  SûrahNumber  (without leading zeros). Here you can input many Sûrah names at the same time. For instance:  '1 9 107 50' ==> this is four Sûrah numbers. The list of Sûrah  has to be quoted also. You can also provide Sûrah numbers in range. For instance:
'100\_105', '1\_13' ... In such case, the separating character between the two Sûrah numbers has to also be the underscore character: '\_'

-J|--juz generate tafsir for a given Juz, set of or range of Juz.
-H|--hizb generate for Hizb, set of Hizb or range of Hizb.
-R|--rub-ul-hizb generate for Rub-ul-Hizb, set of or range of Rub-ul-Hizb
-P|--page-number generate for page, set of or range of pages
-t|--txt-tafasir txt tafasir files folder
-x|--htm-tafasir html tafasir files folder
-o|--output-file-root output folder root folder
-h|--help display this help message.


<a id="orgd7ea7c8"></a>

## EXAMPLES:

**\*** ONE AYAH OR ONE SÛRAH:
E.g.1 (v1): tafsir.sh -f htm -s 15
E.g.1 (v2): tafsir.sh --tafsir-format txt --suwar 16

E.g.2 (v1): tafsir.sh -f txt -a 002102
E.g.2 (v2): tafsir.sh --tafsir-format htm --ayaat 002282

**\*** SEPARATE ÂYÂT OR SUWAR:
E.g.1 (v1): tafsir.sh -f htm -s '1 18 111'
E.g.1 (v2): tafsir.sh --tafsir-format txt --suwar '16 17 15'

E.g.2 (v1): tafsir.sh -f txt -a '002102 002023 006100' 
E.g.2 (v2): tafsir.sh --tafsir-format htm --ayaat '002282 003156 110005'

**\*** RANGE OF SUWAR OR ÂYÂT:
E.g.1 (v1): tafsir.sh -f htm -s '90\_100'
E.g.1 (v2): tafsir.sh --tafsir-format txt --suwar '107\_114'

E.g.2 (v1): tafsir.sh -f txt -a '002102\_002110' 
E.g.2 (v2): tafsir.sh --tafsir-format htm --ayaat '002280\_003010'

in E.g.1 we generate a tafsir for the whole Sûrah 15 of the Quran, thus the option -s in E.g.2 we generate a tafsir for verse number 102 of Sûratul-Baqarah, thus the  -a option and the 002102 value entered.


<a id="org4484715"></a>

## DEPENDENCIES


<a id="org1984db9"></a>

### App dependencies

sed coreutils p7zip-full.

Under Debian-based GNU/Linux systems run the following to install them:

`sudo apt install sed coreutils p7zip-full`

or

`sudo apt-get install sed coreutils p7zip-full`

On Termux on Android, run:

`pkg install sed coreutils p7zip-full`

or

`apt install sed coreutils p7zip-full`

or

`apt-get install sed coreutils p7zip-full`


<a id="orgd6c3b74"></a>

### Supported Format of Tafsir Files

The tafsir files that the program uses are in the format of Tanzil/Zekr translation/tafsir files. You can grab some files from the above-mentioned projects web-sites or (if the tafsir/translation file you would like to work on has not already been setup for zekr/tanzil) create your own. The Tanzil/Zekr file format is a simple text file which has 6236 lines. Each line corresponds to a verse of the Quran. The lines are arranged in the order of the appearance of the verses in the Qur'an from Sûratul-Fatiha to Sûratun-Nâss. Note that after the 6236 lines, you can add some other lines of information or licence, provided that all the 6236 lines of verses appear properly.


<a id="org3c2cfc1"></a>

### How to Prepare the Tafsir Files

Let's say we have a set of Zekr tafsir files (this is recommended, though Tanzil files also work fine) as follows:

> 
> 
> en.hilali.trans.zip
> en.jallalayn.trans.zip
> en.sahih.trans.zip
> en.al-quran-info-transliteration.trans.zip

To prepare them for this tafsir look-up Bash script, do the following:

    
    # Move them in a working folder
    mkdir ./work
    mv -fv en.hilali.trans.zip en.jallalayn.trans.zip \
       en.sahih.trans.zip \
       en.al-quran-info-transliteration.trans.zip work
    
    # Change to the working folder
    cd work
    
    # Extract them
    for file in *.zip
    do
        7z -aoa x "$file"
        # -aoa will make 7z overwrite the file
        # 'translation.properties' which has
        # the same name in all zekr files
    done
    
    # Rename them to *trans.zekr | *trans.zekr.7z
    for file in *.txt
    do
        mv -fv "$file" "${file%%.txt}.trans.zekr"
    done
    
    # Compress them with 7z. This is particularly
    # important since these files should never be
    # modified inadvertantly. This is serious stuff!
    for file in *.trans.zekr
    do
        7za a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on "${file}.7z" "${file}"
    done
    
    # Clean-up: OPTIONAL
    # clean-up *.trans.zekr files
    for file in *.trans.zekr
    do
        rm -rfv "${file}"
    done
    
    # clean-up the original zekr zip files
    for file in *.zip
    do
        rm -rfv "$file"
    done
    
    # The properties file
    rm -rfv translation.properties

If everything goes fine, we should end up with:

`en.sahih.trans.zekr.7z`
`en.hilali.trans.zekr.7z`
`en.jallalayn.trans.zekr.7z`
`en.al-quran-info-transliteration.trans.zekr.7z`

These are the types of files the script handles! Now, you are ready to copy or move them to the appropriate directories.

For the files containing HTML tags, move them to either:

`"SCRIPT_ROOT_DIR/html-tafasir-files"`

or

`"$HOME/.tafsir/html-tafasir-files"`

or provide your own directory with the CLI swith:

`-x|--htm-tafasir FULL_PATH_TO_TAFSIR_FILES`

For plain text files containing no HTML tags move them to either:

`"SCRIPT_ROOT_DIR/txt-tafasir-files"`

or

`"$HOME/.tafsir/txt-tafasir-files"`

or provide your own directory with the CLI swith:

`-t|--txt-tafasir FULL_PATH_TO_TAFSIR_FILES`


<a id="org833d554"></a>

# qap-audio-player.sh

Please, if you have not already read the **Important Note N°2**, go up and do so. This is vital.


<a id="org49d617d"></a>

## SYNOPSIS

qap-audio-player.sh -a|--ayaat verse(s) -s|--suwar sûrah(s) -m|--mpv-speed PlaybackSpeed -l|--mpv-loop LoopNumber -f|--file-loop LoopNumber -g|--groupLoop LoopNumber -p|--play-trans TranslationID --r|--reset-eta (takes no option) -J|--juz JuzNumber -H|--hizb HizbNumber -R|--rub-ul-hizb RubUlHizbNumber-P|--page-number PageNumber -o|--output-quran-html-root WhereToCreateQuran.html -q|--hifz-ul-quran ActivateHifzMode -L|--playlist-file-root WhereToSearchForPlaylist -e|--extension-of-audios QuranAudioFilesExtension -G|--generate-playlist QuranFilesRoot --ara-font-size size --lat-font-size size --metadata-font-size size --table-font-size size --system-font-name FontName --user-font-file FullPathToFontFile -h|--help (takes no option). All the following take no option also: -k|--compact-table --eng-audio --fra-audio --no-ara-txt --translit --eng-txt-sahih --eng-txt-hilali-khan --fra-txt-hamid


<a id="org1c6c55c"></a>

## DESCRIPTION

This script, if given playlist files in zekr/tanzil format with the "\*plst.6236.lines.7z" extension, or "\*plst.6236.lines" extension will read the audio files of ayât, set of ayât, range of ayât; suwar, set of suwar, range of suwar; juz, set of juz, range of juz; ḥizb, set of ḥizb, range of ḥizb; rub-\`ul-ḥizb, set of rub-\`ul-ḥizb, range of rub-\`ul-ḥizb; page, set of pages or range of pages passed to it through the command line in the the following format:

FOR AYÂT: 3-digits designating the Sûrah number followed by 3 other digits for the given verse. For example: 005012.
Henceforth this is what we will name ayah\_id. The example above means: Sûrah 5, verse 12.

FOR SUWAR: a simple number ranging from 1 to 114 without
any leading zeros. For example '1' for Sûrah al-Fâtiḥa.

FOR JUZ: a simple number also. Ranging from 1 to 30.

FOR ḤIZB: a number ranging from 1 to 60.

FOR RUB-\`UL-ḤIZB: a number ranging from 1 to 240.

FOR PAGES: a number ranging from 1 to 604.

-s|--suwar is followed by SûrahNumber (without leading 0s). Here you can input many Sûrah numbers at the same time.
For instance: '1 9 107 50' - Here we have entered four Sûrah numbers. The list of Sûrah has to be quoted either in single quotes (which is preferred) or double quotes.

You can also provide Sûrah numbers in range. For instance:
'100\_105' in such case, the separating char between the two Sûrah numbers has to be the underscore character: '\_' 

-a|--ayaat has to be followed by Sûrah+Ayah e.g.: 007018 - one or more, quoted. I.e., '002102 005075 009105'

Here also you can provide ayah numbers in range. For instance: '001001\_001007' in such case, the separating character between the two ayaat numbers has to be the underscore character also: '\_'

-J|--juz read Quran audio of a given Juz, set of or range of Juz.
-H|--hizb read a Hizb, set of Hizb or range of Hizb.
-R|--rub-ul-hizb read a Rub-ul-Hizb, set of or range of Rub-ul-Hizb
-P|--page-number read a page, set of or range of pages

Note also that -J, -H, -R, and -P will also take single, many or range of units to be played. A unit may refer to a Juz, a Ḥizb, a Rub-\`ul-Ḥizb or a page. It might also refer to a Sûrah. If you would like to provide any unit in range just separate the two numbers with an underscore character just like above.

Also, do not input any leading zeros. And take into account the maximum  number any unit would accept. For instance there are a total of 30  Juz in the Quran, so you cannot request a playback for Juz number 31 which does not exist.


<a id="org9dfbe6f"></a>

## EXAMPLES

**\*** E.g.1 (v1):
qap-audio-player.sh -s 15 -m 1.8 -l 6 -f 2 -g 3 -p eng -r

**\*** E.g.1 (v2):
qap-audio-player.sh --suwar 15 --mpv-speed 1.8 --mpv-loop 6 --file-loop 2 --group-loop 3 --play-trans eng --reset-eta

**\*** E.g.2 (v1):
qap-audio-player.sh -a 001005 -m 1.8 -l 6 -f 2 -g 3 -p eng -r

**\*** E.g.2 (v2):
qap-audio-player.sh --ayaat 001005 --mpv-speed 1.8 --mpv-loop 6 --file-loop 2 --group-loop 3 --play-trans eng --reset-eta

In the first example we play the audio for the whole Sûrah 15 of the Quran, thus the option -s|--suwar

in the second example we play the audio file for verse number 102 of Sûratul-Baqarah, thus the -a|--ayaat option and the 002102 value entered.


<a id="org157c290"></a>

## AS FOR THE REST OF THE OPTIONS:

-m|--mpv-speed is the playback speed for the MPV-Player. The default value it 1.00.

-l|--mpv-loop is the number of times MPV plays the audio file internally.

-f|--file-loop is the file loop number. This is the number of times this programs feeds the file to MPV for it to play it.

If for instance we hand the file twice to MPV and its own loop number is set to 6, then we will end up with 6x2=12. This is the total number of times the file gets played. This is so, if the group-loop option is set to 1. It if is set to 2 for instance then the total number of times the file gets played is:
((6x2) x 2)=24.

-g|--group-loop is the group loop number. This loop number refeeds the whole group of files to MPV, and lets it play them all and then rehands them to it.

-p|--play-trans will activate translation audio files playback. It takes an argument also which is the translation id.

--r|--reset-eta will reset the saved playback duration of the previous session.

-o|--output-quran-html-root where to generate the quran.html file
-q|--hifz-ul-quran activate the 'quran rq\_ayat\_3x\_each\_then\_1' memorisation mode
-L|--playlist-file-root where to look for playlist files. This will override the default values.

-e|--extension-of-audios extension of the audio files that are in the directory for which you would like to have the playlist file generated. For this to work -e has to come before -G
-G|--generate-playlist quran files folder for which to generate the playlist file

--ara-font-size provide a size for use with the arabic verses/tafsirs
--lat-font-size font size for the latin text (translations, tafsirs)
--metadata-font-size a size to be used when displaying metadata information (elapsed time, number of verses of Sûrah...)
--table-font-size a size to be used with the table that displays some additional Sûwar, âyât metadata
--system-font-name here the user has the possibility to provide the name of a font that is already installed on the system. This is not the full path, it is only the official name of the font as registered on the system.
--user-font-file here, one ca provide the full path to a font file whether it is installed on the system or not.

-k|--compact-table this toggles the display of the compact set of tables (Sûrah and Âyah metadata tables) specifically designed for Android devices and any other small screen device which is able to run GNU/Linux whether natively, through chroot and whatnot!

--eng-audio play english verse interpretation audio
--fra-audio play french verse interpretation audio

--no-ara-txt do not Quran arabic text of current ayah to output html file

--translit show transliteration text of current ayah to the command line and also write it to output html file

--eng-txt-sahih show Sahih Int. verse interpretation text of current ayah on the command line and also write it to output html file

--eng-txt-hilali-khan show Taqi-ud-Deen al-Hilali & Mushin Khan english verse interpretation on the command line and write it also to output html file

--fra-txt-hamid show Muhammad Hamidullah french verse interpretation on the command line and write it also to output html file

-h|--help will display this help message.

Most of the above options have default values.


<a id="org4925571"></a>

## DEPENDENCIES

Under Debian-based GNU/Linux systems run the following to install them:

`sudo apt install sed gawk coreutils perl parallel mpv p7zip-full`

or

`sudo apt-get install sed gawk coreutils perl parallel mpv p7zip-full`

On Termux on Android, run:

`pkg install sed gawk coreutils termux-apis perl parallel mpv p7zip-full`

or

`apt install sed gawk coreutils termux-apis perl parallel mpv p7zip-full`

or

`apt-get install sed gawk coreutils termux-apis perl parallel mpv p7zip-full`

Note that the `termux-apis` package is specific to Android and is not available for GNU/Linux. This package is used to display some information on the Android notification bar.


<a id="org5e0dce8"></a>

## CREATING THE PLAYLIST FILES

To generate the playlist files, you need 6236 Quran audio files in a directory. It if recommended that you seperate the 6236 verses into the units that you like. We call unit any of the following: Sûrah, Juz, Ḥizb, Rub-\`ul-Ḥizb and Page-Number.

You could use one of the Bash scripts below to divide your 6236 files into the unit you like.
Please bear in mind that is it very vital that you do not have more that 6236 files before generating the Playlist file. If you get 1 more file then everything will be messed-up completely. If you have additional files designating the Basmalas for each or some Sûrah, then you will have to delete them. To do so, see the code below.

Change to the directory where your audio verses are located. If they are already divided into Suwar, i.e., each Sûrah has its own folder containing its verses, then just deleted the Basmalas. Otherwise it is recommended to divide the verses into units.

We recognize the Basmala files by the fact that they bear the number of the suwar+000. e.g.: 003000.mp3 or 110000.mp3. To remove them we simple search for and remove all the files ending in 000.mp3 in case we are dealing with mp3 files. You replace the 'mp3' with the extension of the audio files you are using.

    
    find . -name '*000.mp3' | parallel --line-buffer --jobs=32 'rm -rfv {}'
    # I love GNU-Parallel. If you don't have it installed, use this:
    
    find . -name '*000.mp3' -exec bash -c 'rm -rfv "$0"' {} \;
    # This should work if you are on any decent GNU/Linux distro
    
    # If you are dealing with *.oga files,
    # replace the '*000.mp3' with '*000.oga'

If everthing is fine, call the script as follows:

`qap-audio-player.sh -G QuranFilesRoot AudioFilesExtension`

or

`qap-audio-player.sh --generate-playlist QuranFilesRoot AudioFilesExtension`

For <span class="underline">example:</span>

`qap-audio-player.sh -G /home/abu-dju/Verse-By-Verse-Quran-Audio-File/Hudhaify-20k-Hafs oga`

The Playlist file will be generated in the following directory:

$SCRIPT-ROOT-DIR/Playlist/ -- This is the root directory from where the script is being called by the user. By default this is where the script looks for Playlist files each time it starts up. If the Playlist sub-directory does not exist it will look for Playlist files in $HOME/.qap/Playlists

The extension of the Playlist files is: `plst.6236.lines.7z` -- It needs to be compressed so that it be well-preserved.


<a id="orgc24d5f5"></a>

# rq-ayat-3x-each-then-1.sh


<a id="orgcb1a354"></a>

## SYNOPSYS

\`basename $0\` -m|--mpv-speed playback-speed -l--mpv-loop mpv-loop-number -f|--file-loop each-file-loop-number -e|--extension-of-audios QuranAudioFilesExtension -G|--generate-playlist QuranFilesRoot -C|--create-fake-audios NumberOfFakeAudiosPerFolder --ara-font-size size --lat-font-size size --metadata-font-size size --table-font-size size --system-font-name FontName --user-font-file FullPathToFontFile. All the following take no option also: -k|--compact-table --eng-audio --fra-audio --no-ara-txt --translit --eng-txt-sahih --eng-txt-hilali-khan --fra-txt-hamid -h|--help


<a id="orgabe0acf"></a>

## DESCRIPTION

This script tries to implement an algorithm to let the Quranic reader who wishes to memorize a set of verses to do it in a consistent manner. The program gets a list of ayat and then does the following:

Consider we have a set of five files to play:

1-reads the first ayah 3 times (the user can change this number);

2-goes back and reads it 1 time;

3-moves to the second ayah and reads it 3 times;

4-goes back and reads the first and second ayaat 1 time each;

5-moves to the third ayah to play it 3 times;

6-goes back to the first, second and third ayaat and reads them 1 time each;

7-moves to the fourth ayah and plays it 3 times;

8-goes back to the first, second, third and fourth ayaat and plays them 1 time each;

9-moves to the fifth which is our last ayah and plays it 3 times.

From the 9th step, since there are no remaining ayaat to be played:

10-it plays the whole group once;

11-removes the 1st ayah from the list, and thus plays all but the 1st ayah;

12-removes the 1st and 2nd ayaat from the list and plays all but the 1st and 2nd ayaat;

13-removes the 1st 2nd and 3rd ayaat from the list and plays all but the 1st 2nd and 3rd ayaat;

14-removes the 1st 2nd 3rd and 4th ayaat from the list and plays all but the 1st 2nd 3rd and 4th ayaat

=> This means, since we only have 5 files to be played, that here we play the 5th and last verse and then exit.

In total, we would play each verse 3x + 5x (which is the number of total files to play) thus adding up to 8 times.


<a id="org433ae4e"></a>

## COMMAND LINE OPTIONS

-m|--mpv-speed MPV-Player playback speed (default: 1.00)
-l--mpv-loop number of time MPV will play each file, internally
-f|--file-loop number of times each file gets handed to MPV so that it plays it while also performing its internal loop. The number of times the file gets played is mpv-loop\*file-loop. For example 2\*6=12

-e|--extension-of-audios extension of the audio files that are in the directory for which you would like to have the playlist file generated. For this to work -e has to come before -G
-G|--generate-playlist quran files folder for which to generate the playlist file

-C|--create-fake-audios generate the fake audio files directory for all the 6236 Quran verses. Takes as argument, the number of files per directory

-R|--generate-rortrl-files with this option, you request the creation of the following files:
\*RECITE\_ONCE\_LIST
\*RECITE\_THRICE\_LIST
\*RECITE\_LAST\_LIST
You need to create these files in case an error happened that prevents the audios to be played in the correct order. i.e., the program skips some verses - or any other reason that makes you want to do this.
This parameter takes as the sole option, either the number '1', or any other number. '1' makes the program generate the first stage files: RECITE\_ONCE\_LIST and RECITE\_THRICE\_LIST files. Any other number, other than '1', will make the program generate RECITE\_LAST\_LIST file.
h
--ara-font-size provide a size for use with the arabic verses/tafsirs
--lat-font-size font size for the latin text (translations, tafsirs)
--metadata-font-size a size to be used when displaying metadata information (elapsed time, number of verses of Sûrah...)
--table-font-size a size to be used with the table that displays some additional Sûwar, âyât metadata
--system-font-name here the user has the possibility to provide the name of a font that is already installed on the system. This is not the full path, it is only the official name of the font as registered on the system.
--user-font-file here, one ca provide the full path to a font file whether it is installed on the system or not.

-k|--compact-table this toggles the display of the compact set of tables (Sûrah and Âyah metadata tables) specifically designed for Android devices and any other small screen device which is able to run GNU/Linux whether natively, through chroot and whatnot!

--eng-audio play english verse interpretation audio
--fra-audio play french verse interpretation audio

--no-ara-txt do not write Quran arabic text of current ayah to output html file

--translit show transliteration text of current ayah to the command line and also write it to output html file

--eng-txt-sahih show Sahih Int. verse interpretation text of current ayah on the command line and also write it to output html file

--eng-txt-hilali-khan show Taqi-ud-Deen al-Hilali & Mushin Khan english verse interpretation on the command line and write it also to output html file

--fra-txt-hamid show Muhammad Hamidullah french verse interpretation on the command line and write it also to output html file


<a id="orgcab4ddc"></a>

## EXAMPLES

rq-ayat-3x-each-then-1.sh -m|--mpv-speed 1.8 -l|--mpv-loop 6 -f|--file-loop 2

Playback speed 180%. Make mpv play each file 6 time. Pass each file 2 times to mpv so that it plays it 6 times as indicated above thus playing it 12 times for all."


<a id="org237f934"></a>

## DEPENDENCIES

See the "DEPENDENCIES" section of the qap-audio-player.sh script above.


<a id="org261c568"></a>

# Divide Quran 6236 Audio Files to Various Units

Scripts that divide a set of Zekr Quran audio files into 114 Suwar, 30-Juz, 60-Ḥizb, 240-Rub-ul-Ḥizb or 604-Pages


<a id="org9d90e4a"></a>

## divide-quran-per-suwar.sh

This divides the 6236 Quran audio files into 114 folders, each corresponding to a Sûrah of the Quran.


<a id="org2ac223a"></a>

## divide-quran-per-juz.sh

This divides the 6236 Quran files into 30 folders, each corresponding to a Juz of the Noble Quran.


<a id="orgbc73d5b"></a>

## divide-quran-per-hizb-1-safe.sh

This divides the 6236 Quran audio files into 60 folders, each corresponding to a Ḥizb of the Quran. It has the tag `safe` because it is fast and uses only Bash specific features. This holds true for all the remaining scripts of the list that have that tag.


<a id="org2208a91"></a>

## divide-quran-per-hizb-2-unsafe.sh

The `safe` version of the above script.

**<span class="underline">Question:</span>** Why have the `unsafe` versions since we have the `safe` ones ?

**<span class="underline">Answer:</span>** The `unsafe` version was created first. Then it was used to divide the Quran files on a test-folder. With the result of the run of that script, we were able to use some hacks through the CLI to list the folders and their contents. With these data we created the `safe` version. Since the `safe` version exists thanks to the `unsafe` version, we thought it would not be wise to delete the `unsafe` version.

The `unsafe` version uses Bash to extrapolate the elements between a range. For instance this excerpt `mv -f {002253..003014} 05` tries to move the elements of the Ḥizb N°5 to a folder named `05`. If you look at the range you will realize that Bash will try to move in fact all the files from 002253 to 003014. We know that Sûratul-Baqarah has a total of 282 verses. Bash will try to move, namely, files 002287, 002288, 002289, 002290, and all the way through 0022999 which do not exit. In fact, here only, it will try to move 713 files that do not exist. This is why this version of the script is tagged `unsafe`. This explanation, holds true for all the remaining scripts tagged `unsafe`.


<a id="org8a15fbf"></a>

## divide-quran-per-hizb-roub-1-safe.sh

Divides the Quran verses into 240 Rub-\`ul-Ḥizb. The `safe` version.


<a id="orgfc5d2cd"></a>

## divide-quran-per-hizb-roub-2-unsafe.sh

The `unsafe` version of the above script.


<a id="org313bc22"></a>

## divide-quran-per-page-1-safe.sh

Will divide the Quran version into 604 folders, each corresponding to a page of the Quran in the \`Uthmanic Musḥaff.


<a id="orgf10af36"></a>

## divide-quran-per-page-2-unsafe.sh

The `unsafe` version of the above script.


<a id="orgeb0b406"></a>

## Bonus: move-21-ayat-in-subdirs.sh


<a id="orgafd665b"></a>

# div-trans-textFile-to-6236-TXT-Files

This script, if given a zekr/tanzil translation file with the "\*.trans.zekr" extension, will create a folder with the basename of the current input file and then moves to it in order to generate 6236 text files, according to the 6236 lines of the file. Those lines correspond to the 6236 verses of the Quran.

Next, it will rename them from 0001--6236 to a SûrahNumber+AyahNumber naming scheme that we have derived from the `VerseByVerse` Quran project recitation audio files.

For instance: 001005 is the 5th verse of surah al-Fatiḥah

058010 is the 10th verse of the 58th surah of the Quran. And so on. This is what we call the `ayah_id`.

Please make sure your translation files are correctly named. This program only recognizes files that have the extension: `*.trans.zekr`

For instance: `en-hilali.trans.zekr` or `en-sahih.trans.zekr` -- Note that the file is not zipped.


<a id="org55fca83"></a>

## Dependencies:

we need the following two files:


<a id="orgfafd260"></a>

### 01-Quran-Verses-Line-Numbers.txt

This is a simple list of line numbers from 0001 to 6236. This will be used in conjunction with `02-VerseByVerse-Quran-Ayat-List.txt` to rename the generated verses from their original line numbers to their ayah\_id.


<a id="orge1f7946"></a>

### 02-VerseByVerse-Quran-Ayat-List.txt

This is also a simple list, but it consists of ayah\_ids, from 001001 (the first verse of Sûratu-Fatiḥa) to 114006 (the last verse of Sûratun-Nâss).


<a id="org519cca8"></a>

### Zekr/Tanzil Translation files

This may be any Tanzil/Zekr Translation/Tafsir file either downloaded from their respective web-sites or prepared by a third party, provided that the file is well-prepared and is valid. If you would not want to end up with HTML tags in the generated 6236 text files, you would have to remove all HTML tags using some text editor or some regex engine. Google is your best friend here ;-).


<a id="orgc1d58db"></a>

# Show Sûrah or Âyah Metadata

These display various metadata related to either verses or Sûwar of the Quran.


<a id="org274d25f"></a>

## List of Verses of Surah-Juz-Hizb-RubUlHizb-PageNumber

These will give the **list** of verses of various units.


<a id="org2a02680"></a>

### show-list-of-verses-that-belong-to-this-surah.sh

Shows the **list** of verses that belong to a particular Sûrah.


<a id="org2c3fed6"></a>

### show-list-of-verses-that-belong-to-this-juz.sh

Shows the **list** of verses that belong to a particular Juz.


<a id="org46975de"></a>

### show-list-of-verses-that-belong-to-this-hizb.sh

Shows the **list** of verses that belong to a particular Ḥizb.


<a id="org84fc722"></a>

### show-list-of-verses-that-belong-to-this-rub-al-hizb.sh

Shows the **list** of verses that belong to a particular Rub-\`ul-Ḥizb.


<a id="orge8b3952"></a>

### show-list-of-verses-that-belong-to-this-page-number.sh

Shows the **list** of verses that belong to a particular page.


<a id="org632b19f"></a>

## Number of Verses of Surah-Juz-Hizb-RubUlHizb-PageNumber

These will give, not the **list** of verses, but the **number** of verses of various units.


<a id="org8b51048"></a>

### give-the-number-of-verses-of-surah.sh

Shows the **number** of verses that belong to a particular Sûrah.


<a id="org6f40f7f"></a>

### show-number-of-verses-that-belong-to-this-juz.sh

Shows the **number** of verses that belong to a particular Juz.


<a id="org1b64722"></a>

### show-number-of-verses-that-belong-to-this-hizb.sh

Shows the **number** of verses that belong to a particular Ḥizb.


<a id="orgea78f20"></a>

### show-number-of-verses-that-belong-to-this-rub-al-hizb.sh

Shows the **number** of verses that belong to a particular Rub-\`ul-Ḥizb.


<a id="orgeae93e9"></a>

### show-number-of-verses-that-belong-to-this-page-number.sh

Shows the **number** of verses that belong to a particular page.


<a id="org907bd7d"></a>

## Show ID of the Greater Unit to Which a Verse Belongs

This will show the **number** (name) of the upper unit to which a verse belongs.


<a id="org4e4459b"></a>

### show-juz-to-which-this-ayah-belongs.sh

It takes one ayah and returns the **number** of the Juz to which it belongs. For instance if given the value `002159`, it returns: `02`, which means: the ayah belongs to Juz N°02 of the Quran.


<a id="org5313f26"></a>

### show-hizb-to-which-this-ayah-belongs.sh

It takes one ayah and returns the **number** of the Ḥizb to which it belongs. For instance if given the value `001007`, it returns: `01`, which means: the ayah belongs to Ḥizb N°01 of the Quran.


<a id="org29911e9"></a>

### show-rub-al-hizb-to-which-this-ayah-belongs.sh

It takes one ayah and returns the **number** of the Rub-\`ul-Ḥizb to which it belongs. For instance if given the value `114006`, returns: `240`, which means: the ayah belongs to Rub-\`ul-Ḥizb N°240 of the Quran.


<a id="orgb6a7b5e"></a>

### show-page-number-to-which-this-ayah-belongs.sh

It takes one ayah and returns the **number** of the Page to which it belongs. For instance if given the value `002285`, returns: `049`, which means: the ayah belongs to Page N°049 of the Quran.


<a id="org03a5fd9"></a>

## Show Some More Info for a Surah

The following functions take one ayah\_id and return some information about the Sûrah to which it belongs.


<a id="orgfcfe676"></a>

### show-surah-meccan-or-medinan.sh

Shows whether the Sûrah to which this ayah belongs is Meccan or Medinan.


<a id="orgdfab0ce"></a>

### show-surah-name-arabic.sh

Shows the Arabic Name of the Sûrah to which this ayah belongs.


<a id="org1b45f28"></a>

### show-surah-name-english.sh

Shows the English Name of the Sûrah to which this ayah belongs.


<a id="orgda4e52d"></a>

### show-surah-number.sh

Shows the 3-digit Number of the Sûrah to which this ayah belongs.


<a id="org0631073"></a>

### show-surah-number-without-leading-zeros.sh

Shows the 3-digit Number of the Sûrah to which this ayah belongs, without leading zeros. This means, for instance, that where the above script would return `006`, this one returns `6`. This is sometimes useful for some particular purposes.


<a id="orgb9d8e6b"></a>

## Show Number of Elements Contained in the Unit to Which a Verse Belongs

This take a single ayah\_id and returns the number of elements contained the greater unit to which it belongs.


<a id="orgb2b664f"></a>

### get-number-of-ayaat-of-the-surah-to-which-this-ayah-belongs.sh

Returns the number of verses of the Sûrah to which a given ayah belongs.


<a id="orgeb31b8f"></a>

## Other Ayah Related BASH Functions


<a id="org537b4c2"></a>

### `show_number_of_pages_of_a_surah.sh`

This program take one verse id (i.e., 002008) and returns the following:

-   The Total Pages of the Sûrah
-   The Page on which is located the entered verse id
-   The the pages that come before the entered verse id
-   And the number of the Remaining pages in the Sūrah


<a id="org08a1aa4"></a>

### ayah-necessitates-sadjdah-or-not.sh

This tells us wether a given verse necessitates prosternation after recitation or not.


<a id="org2de95fe"></a>

### play-basmala-for-the-113-suwar.sh

This program is able to know when the user is playing the first verses of the 113 chapters of the Quran for which it is mandatory to read the Basmalah and it consequently plays it.


<a id="org426831f"></a>

# Download Section

If you clone this `github` repository, you will get all the files at once!


<a id="org5ab802f"></a>

## tafsir.sh

Download Link:
[tafsir.sh.gz](programs/tafsir.sh.gz)

[tafsir.sh](programs/uncompressed/tafsir.sh)


<a id="org95cd6b7"></a>

## qap-audio-player.sh

Download Links:
[qap-audio-player.sh.gz](programs/qap-audio-player.sh.gz)

[qap-audio-player.sh](programs/uncompressed/qap-audio-player.sh)


<a id="org9ef00bf"></a>

## rq-ayat-3x-each-then-1-5.0-ALPHA.sh

Download Link:
[rq-ayat-3x-each-then-1-5.0-ALPHA.sh.gz](programs/rq-ayat-3x-each-then-1-5.0-ALPHA.sh.gz)

[rq-ayat-3x-each-then-1-5.0-ALPHA.sh](programs/uncompressed/rq-ayat-3x-each-then-1-5.0-ALPHA.sh)


<a id="org142dbed"></a>

## Tafsir Files

Download Links:
[HTML Tafsir Files](downloads/html-tafasir-files.7z)
Contains the following files in HTML format:

-   00 - Arabic Text.trans.zekr.7z
-   01 - English - Taqi-ud-Deen al-Hilali and Muhsin Khan.trans.zekr.7z
-   02 - English - Tanweer al-Miqbas.trans.zekr.7z
-   03 - English Jallalayn.trans.zekr.7z
-   04 - English - Tafhimul-Quran - Maududi.trans.zekr.7z
-   05 - English Tafsir ibn Kathir.trans.zekr.7z

[TXT Tafsir Files](downloads/txt-tafasir-files.7z)
Contains the following files in plain text format:

-   00 - Arabic Text.trans.zekr.7z
-   01 - English - Taqi-ud-Deen al-Hilali and Muhsin Khan.trans.zekr.7z
-   02 - English - Tanweer al-Miqbas.trans.zekr.7z
-   03 - English Jallalayn.trans.zekr.7z
-   04 - English - Tafhimul-Quran - Maududi.trans.zekr.7z
-   05 - English Tafsir ibn Kathir.trans.zekr.7z


<a id="org882687b"></a>

## Playlist Files + Audios

Coming soon in Sha Allah.


<a id="org3110bb4"></a>

## Translation Files Divided into 6236 TXT Files

Coming soon in Sha Allah.


<a id="org74cfb5e"></a>

## Scripts that Divide the Quran 6236 Audio Files into Various Units

Please download the following archive and extract it with `7zip` and you will get the whole set of scripts that divide your Quran 6236 audio files into folders representing various units of the Quran, i.e., Sûrah, Juz, Hizb etc.

Download Link - 7z archive containing all the scrips: 
[divide-quran-per-PARTS.7z](programs/divide-quran-per-PARTS.7z)

Download Links - Separate scripts - \*.sh

[divide-quran-per-hizb-1-safe.sh](programs/uncompressed/divide-quran-per-PARTS/divide-quran-per-hizb-1-safe.sh)

[divide-quran-per-hizb-2-unsafe.sh](programs/uncompressed/divide-quran-per-PARTS/divide-quran-per-hizb-2-unsafe.sh)

[divide-quran-per-hizb-roub-1-safe.sh](programs/uncompressed/divide-quran-per-PARTS/divide-quran-per-hizb-roub-1-safe.sh)

[divide-quran-per-hizb-roub-2-unsafe.sh](programs/uncompressed/divide-quran-per-PARTS/divide-quran-per-hizb-roub-2-unsafe.sh)

[divide-quran-per-juz.sh](programs/uncompressed/divide-quran-per-PARTS/divide-quran-per-juz.sh)

[divide-quran-per-page-1-safe.sh](programs/uncompressed/divide-quran-per-PARTS/divide-quran-per-page-1-safe.sh)

[divide-quran-per-page-2-unsafe.sh](programs/uncompressed/divide-quran-per-PARTS/divide-quran-per-page-2-unsafe.sh)

[divide-quran-per-suwar.sh](programs/uncompressed/divide-quran-per-PARTS/divide-quran-per-suwar.sh)


<a id="org9af021d"></a>

## Scripts that Divide Translation Text-Files into 6236 TXT Files

Download link - one 7z archive containing the script and its dependencies: 
[Divide-Trans-Text-Files-to-6236-Ayat-TXT-Files.7z](programs/Divide-Trans-Text-Files-to-6236-Ayat-TXT-Files.7z)

Download Links - \*.sh script and \*.txt dependencies: 
[div-trans-textFile-to-6236-TXT-Files.sh](programs/uncompressed/Divide-Trans-Text-Files-to-6236-Ayat-TXT-Files/div-trans-textFile-to-6236-TXT-Files.sh)

Its Dependencies:

[01-Quran-Verses-Line-Numbers.txt](programs/uncompressed/Divide-Trans-Text-Files-to-6236-Ayat-TXT-Files/01-Quran-Verses-Line-Numbers.txt)

[02-VerseByVerse-Quran-Ayat-List.txt](programs/uncompressed/Divide-Trans-Text-Files-to-6236-Ayat-TXT-Files/02-VerseByVerse-Quran-Ayat-List.txt)

Download Some tranlation files especially prepared for use with the Quran Text or Translation division script above. Note that the files are in the format of the Tanzil/Zekr projects Quran text and translation/tafsir files. Note also the the Quran text division program can also divide the HTLM/TXT tafsir files that the `tafsir.sh` program uses to generate the tafsir of ayaat or suwar.

Please note that these have not been divided into 6236 files yet. Divide them with the script provided above. If you would like to download alread divides files, go to `Translation Files Divided into 6236 TXT Files`

[Translations-Without-HTML-Tags.7z](downloads/Translations-Without-HTML-Tags.7z)

The file contains the following:

1.  en.asad.trans.zekr
2.  en.hilali.trans.zekr
3.  en.jallalayn.trans.zekr
4.  en.sahih.trans.zekr
5.  en.tafheem.trans.zekr
6.  en.tafsir-ibn-kathir.trans.zekr
7.  en.tanweer.trans.zekr
8.  fr.hamidullah.trans.zekr
9.  ha.gumi.trans.zekr
10. transliteration.trans.zekr


<a id="org5576dc8"></a>

## Scripts that Show Various Sûrah or Âyah Metadata

Below, you can download the whole set of functions that display all sorts of information related to Quranic Chapers (Suwar) and verses (âyât)

Download Link - 7z archive containing all the scrips: 
[Show-Surah-Metadata.7z](programs/Show_Surah_Metadata.7z)

Download Links - Separate scripts - \*.sh

Scripts that Show List of Verses of Surah/Juz/Ḥizb/Rub-ul-Ḥizb/PageNumber:

[show-list-of-verses-that-belong-to-this-hizb.sh](programs/uncompressed/Show_Surah_Metadata/List_of_Verses_of_Surah-Juz-Hizb-RubUlHizb-PageNumber/show-list-of-verses-that-belong-to-this-hizb.sh)

[show-list-of-verses-that-belong-to-this-juz.sh](programs/uncompressed/Show_Surah_Metadata/List_of_Verses_of_Surah-Juz-Hizb-RubUlHizb-PageNumber/show-list-of-verses-that-belong-to-this-juz.sh)

[show-list-of-verses-that-belong-to-this-page-number.sh](programs/uncompressed/Show_Surah_Metadata/List_of_Verses_of_Surah-Juz-Hizb-RubUlHizb-PageNumber/show-list-of-verses-that-belong-to-this-page-number.sh)

[show-list-of-verses-that-belong-to-this-rub-al-hizb.sh](programs/uncompressed/Show_Surah_Metadata/List_of_Verses_of_Surah-Juz-Hizb-RubUlHizb-PageNumber/show-list-of-verses-that-belong-to-this-rub-al-hizb.sh)

[show-list-of-verses-that-belong-to-this-surah.sh](programs/uncompressed/Show_Surah_Metadata/List_of_Verses_of_Surah-Juz-Hizb-RubUlHizb-PageNumber/show-list-of-verses-that-belong-to-this-surah.sh)

Scripts that Show Number of Verses of Surah/Juz/Ḥizb/Rub-ul-Ḥizb/PageNumber:

[give-the-number-of-verses-of-surah.sh](programs/uncompressed/Show_Surah_Metadata/Number_of_Verses_of_Surah-Juz-Hizb-RubUlHizb-PageNumber/give-the-number-of-verses-of-surah.sh)

[show-number-of-verses-that-belong-to-this-hizb.sh](programs/uncompressed/Show_Surah_Metadata/Number_of_Verses_of_Surah-Juz-Hizb-RubUlHizb-PageNumber/show-number-of-verses-that-belong-to-this-hizb.sh)

[show-number-of-verses-that-belong-to-this-juz.sh](programs/uncompressed/Show_Surah_Metadata/Number_of_Verses_of_Surah-Juz-Hizb-RubUlHizb-PageNumber/show-number-of-verses-that-belong-to-this-juz.sh)

[show-number-of-verses-that-belong-to-this-page-number.sh](programs/uncompressed/Show_Surah_Metadata/Number_of_Verses_of_Surah-Juz-Hizb-RubUlHizb-PageNumber/show-number-of-verses-that-belong-to-this-page-number.sh)

[show-number-of-verses-that-belong-to-this-rub-al-hizb.sh](programs/uncompressed/Show_Surah_Metadata/Number_of_Verses_of_Surah-Juz-Hizb-RubUlHizb-PageNumber/show-number-of-verses-that-belong-to-this-rub-al-hizb.sh)

Other Ayah Related Scripts:

[ayah-necessitates-sadjdah-or-not.sh](programs/uncompressed/Show_Surah_Metadata/Other_Ayah_Related_BASH_Functions/ayah-necessitates-sadjdah-or-not.sh)

[play-basmala-for-the-113-suwar.sh](programs/uncompressed/Show_Surah_Metadata/Other_Ayah_Related_BASH_Functions/play-basmala-for-the-113-suwar.sh)

Scripts that Show the Id of Surah/Juz/Ḥizb/Rub-ul-Ḥizb/PageNumber to which a Verse Belongs:

[show-hizb-to-which-this-ayah-belongs.sh](programs/uncompressed/Show_Surah_Metadata/Show_ID_of_the_Greater_Unit_to_Which_a_Verse_Belongs/show-hizb-to-which-this-ayah-belongs.sh)

[show-juz-to-which-this-ayah-belongs.sh](programs/uncompressed/Show_Surah_Metadata/Show_ID_of_the_Greater_Unit_to_Which_a_Verse_Belongs/show-juz-to-which-this-ayah-belongs.sh)

[show-page-number-to-which-this-ayah-belongs.sh](programs/uncompressed/Show_Surah_Metadata/Show_ID_of_the_Greater_Unit_to_Which_a_Verse_Belongs/show-page-number-to-which-this-ayah-belongs.sh)

[show-rub-al-hizb-to-which-this-ayah-belongs.sh](programs/uncompressed/Show_Surah_Metadata/Show_ID_of_the_Greater_Unit_to_Which_a_Verse_Belongs/show-rub-al-hizb-to-which-this-ayah-belongs.sh)

Scripts that Show the Number of Verses of the Surah/Juz/Ḥizb/Rub-ul-Ḥizb/PageNumber to a Verse Belongs:

[get-number-of-ayaat-of-the-HIZB-to-which-this-ayah-belongs.sh](programs/uncompressed/Show_Surah_Metadata/Show_Number_of_Elements_Contained_in_the_Unit_to_Which_a_Verse_Belongs/get-number-of-ayaat-of-the-HIZB-to-which-this-ayah-belongs.sh)

[get-number-of-ayaat-of-the-JUZ-to-which-this-ayah-belongs.sh](programs/uncompressed/Show_Surah_Metadata/Show_Number_of_Elements_Contained_in_the_Unit_to_Which_a_Verse_Belongs/get-number-of-ayaat-of-the-JUZ-to-which-this-ayah-belongs.sh)

[get-number-of-ayaat-of-the-PAGE-to-which-this-ayah-belongs.sh](programs/uncompressed/Show_Surah_Metadata/Show_Number_of_Elements_Contained_in_the_Unit_to_Which_a_Verse_Belongs/get-number-of-ayaat-of-the-PAGE-to-which-this-ayah-belongs.sh)

[get-number-of-ayaat-of-the-RUB-UL-HIZB-to-which-this-ayah-belongs.sh](programs/uncompressed/Show_Surah_Metadata/Show_Number_of_Elements_Contained_in_the_Unit_to_Which_a_Verse_Belongs/get-number-of-ayaat-of-the-RUB-UL-HIZB-to-which-this-ayah-belongs.sh)

[get-number-of-ayaat-of-the-surah-to-which-this-ayah-belongs.sh](programs/uncompressed/Show_Surah_Metadata/Show_Number_of_Elements_Contained_in_the_Unit_to_Which_a_Verse_Belongs/get-number-of-ayaat-of-the-surah-to-which-this-ayah-belongs.sh)

Scripts that Show Some Extras Information for a Surah:

[show-surah-meccan-or-medinan.sh](programs/uncompressed/Show_Surah_Metadata/Show_Some_Info_for_a_Surah/show-surah-meccan-or-medinan.sh)

[show-surah-name-arabic.sh](programs/uncompressed/Show_Surah_Metadata/Show_Some_Info_for_a_Surah/show-surah-name-arabic.sh)

[show-surah-name-english.sh](programs/uncompressed/Show_Surah_Metadata/Show_Some_Info_for_a_Surah/show-surah-name-english.sh)

[show-surah-number.sh](programs/uncompressed/Show_Surah_Metadata/Show_Some_Info_for_a_Surah/show-surah-number.sh)

[show-surah-number-without-leading-zeros.sh](programs/uncompressed/Show_Surah_Metadata/Show_Some_Info_for_a_Surah/show-surah-number-without-leading-zeros.sh)

[show\_number\_of\_pages\_of\_a\_surah.sh](programs/uncompressed/Show_Surah_Metadata/show_number_of_pages_of_a_surah.sh)

  

A Single Script that Shows all the Informations of a Given Ayah - It is the combination of most of the other scripts:
[00-show-all-verse-metadata.sh](programs/uncompressed/Show_Surah_Metadata/00-show-all-verse-metadata.sh)

A Single Script that Shows all the Verses Belonging to A Surah/Juz/Ḥizb/Rub-ul-Ḥizb or PageNumber:
[show-list-of-verses-of-various-units.sh](programs/uncompressed/Show_Surah_Metadata/show-list-of-verses-of-various-units.sh)


<a id="org0628b4f"></a>

## Custom Tanzil/Zekr Translation/Tafsir Files

These are a set of Tanzil/Zekr translation or Tafsir files that I prepared for my personal use over the years. In the past years I did my best to get in touch with the Tanzil project in order to send them these files for the benefit of other people but they wouldn't answer my emails. In the end I got frustrated and stopped sending them emails. Here I am today, after many years, publishing them on the internet myself. All praise is due to Allah, The Lord of the Worlds.   

**Arabic Tafasir of the Quran**:

1.  [ar.baghawy.trans.zip](downloads/zekr-extras-tafasir/ar.baghawy.trans.zip)     **Tafsir Al-Baghawiy**

2.  [ar.e3rab.trans.zip](downloads/zekr-extras-tafasir/ar.e3rab.trans.zip)       **I'raab-ul-Quran**

3.  [ar.jalalayn.trans.zip](downloads/zekr-extras-tafasir/ar.jalalayn.trans.zip)    **Tafsir Jallalayn**

4.  [ar.katheer.trans.zip](downloads/zekr-extras-tafasir/ar.katheer.trans.zip)     **Tafsir Ibn Katheer**

5.  [ar.muyassar.trans.zip](downloads/zekr-extras-tafasir/ar.muyassar.trans.zip)    **Tafsir al-Muyassar**

6.  [ar.qortoby.trans.zip](downloads/zekr-extras-tafasir/ar.qortoby.trans.zip)     **Tafsir al-Qurṭubi**

7.  [ar.sa3dy.trans.zip](downloads/zekr-extras-tafasir/ar.sa3dy.trans.zip)       **Tafsir as-Sa\`adi**

8.  [ar.tabary.trans.zip](downloads/zekr-extras-tafasir/ar.tabary.trans.zip)      **Tafsir aṭ-Ṭabari**

9.  [ar.tanweer.trans.zip](downloads/zekr-extras-tafasir/ar.tanweer.trans.zip)     **Tanwir al-Miqbas Tafsir**

10. [ar.waseet.trans.zip](downloads/zekr-extras-tafasir/ar.waseet.trans.zip)     **Tafsir Waseet**

**English Tafasir/Translations/Romanizations:**

1.  [en.jallalayn.trans.zip](downloads/zekr-extras-tafasir/en.jallalayn.trans.zip)          **Tafsir Jallalayn English**

2.  [en.tafheem.trans.zip](downloads/zekr-extras-tafasir/en.tafheem.trans.zip)            **Tafsir Maududi - Tafheem-ul-Quran**

3.  [en.tafsir-ibn-kathir.trans.zip](downloads/zekr-extras-tafasir/en.tafsir-ibn-kathir.trans.zip)  **Tafsir Ibn Katheer English**

4.  [en.tanweer.trans.zip](downloads/zekr-extras-tafasir/en.tanweer.trans.zip)            **Tanwir al-Miqbas Tafsir - English**

5.  [en.transliteration.trans.zip](downloads/zekr-extras-tafasir/en.transliteration.trans.zip)    **Romanization Type-1**

6.  [en.romanization.trans.zip](downloads/zekr-extras-tafasir/en.romanization.trans.zip)       **Romanization Type-2**

**French Tafasir/Translations/Romanizations:**

1.  [fr.al-quran-info-transliteration.trans.zip](downloads/zekr-extras-tafasir/fr.al-quran-info-transliteration.trans.zip) **Romanization Type-1 - French**

2.  [fr.romanization.trans.zip](downloads/zekr-extras-tafasir/fr.romanization.trans.zip)                  **Romanization Type-2 - French**


<a id="org54f3375"></a>

## Other Scripts

Coming soon in Sha Allah.

