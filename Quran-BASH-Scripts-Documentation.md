
# Table of Contents

1.  [IMPORTANT INFORMATION:](#org59bcf59)
2.  [IMPORTANT NOTES:](#orgedb5d3d)
    1.  [Important Note N°1](#org302b72a)
    2.  [Important Note N°2](#org015fca1)
3.  [tafsir.sh](#orgb695d5c)
    1.  [SYNOPSIS](#org98b597b)
    2.  [DESCRIPTION](#org7e2f926)
    3.  [EXAMPLES:](#orgedc4819)
    4.  [DEPENDENCIES](#org0bb140e)
        1.  [App dependencies](#orge3e2623)
        2.  [Supported Format of Tafsir Files](#org47c5b8b)
        3.  [How to Prepare the Tafsir Files](#org7b78fdc)
4.  [qap-audio-player.sh](#org38ab610)
    1.  [SYNOPSIS](#org6c99b18)
    2.  [DESCRIPTION](#org2718817)
    3.  [EXAMPLES](#orgea3a5b4)
    4.  [AS FOR THE REST OF THE OPTIONS:](#org4e6a34b)
    5.  [DEPENDENCIES](#org9703263)
    6.  [CREATING THE PLAYLIST FILES](#orgf3c7d99)
5.  [rq-ayat-3x-each-then-1.sh](#orgc7f5870)
    1.  [SYNOPSYS](#org78d448b)
    2.  [DESCRIPTION](#orgb9da801)
    3.  [COMMAND LINE OPTIONS](#org9e058a9)
    4.  [EXAMPLES](#org849827c)
    5.  [DEPENDENCIES](#org80baec0)
6.  [Divide Quran 6236 Audio Files to Various Units](#org9be4f29)
    1.  [divide-quran-per-suwar.sh](#org60df7da)
    2.  [divide-quran-per-juz.sh](#org94edce0)
    3.  [divide-quran-per-hizb-1-safe.sh](#org3e34bc2)
    4.  [divide-quran-per-hizb-2-unsafe.sh](#orgcc34d44)
    5.  [divide-quran-per-hizb-roub-1-safe.sh](#org96fccc7)
    6.  [divide-quran-per-hizb-roub-2-unsafe.sh](#orgd4064d6)
    7.  [divide-quran-per-page-1-safe.sh](#org61fcfb5)
    8.  [divide-quran-per-page-2-unsafe.sh](#org77a6e56)
    9.  [Bonus: move-21-ayat-in-subdirs.sh](#org5362d74)
7.  [div-trans-textFile-to-6236-TXT-Files](#orgcc000b3)
    1.  [Dependencies:](#org9f4587e)
        1.  [01-Quran-Verses-Line-Numbers.txt](#orgea21ffd)
        2.  [02-VerseByVerse-Quran-Ayat-List.txt](#org2a969c7)
        3.  [Zekr/Tanzil Translation files](#orgee07735)
8.  [Show Sûrah or Âyah Metadata](#orgc4a69de)
    1.  [List of Verses of Surah-Juz-Hizb-RubUlHizb-PageNumber](#org7919744)
        1.  [show-list-of-verses-that-belong-to-this-surah.sh](#org4801716)
        2.  [show-list-of-verses-that-belong-to-this-juz.sh](#org02f44ef)
        3.  [show-list-of-verses-that-belong-to-this-hizb.sh](#org492ab0f)
        4.  [show-list-of-verses-that-belong-to-this-rub-al-hizb.sh](#orgd4f30cb)
        5.  [show-list-of-verses-that-belong-to-this-page-number.sh](#orgad64daa)
    2.  [Number of Verses of Surah-Juz-Hizb-RubUlHizb-PageNumber](#orgb903b87)
        1.  [give-the-number-of-verses-of-surah.sh](#org5742f86)
        2.  [show-number-of-verses-that-belong-to-this-juz.sh](#orga212b70)
        3.  [show-number-of-verses-that-belong-to-this-hizb.sh](#org36f25d7)
        4.  [show-number-of-verses-that-belong-to-this-rub-al-hizb.sh](#org6c95111)
        5.  [show-number-of-verses-that-belong-to-this-page-number.sh](#org241cc61)
    3.  [Show ID of the Greater Unit to Which a Verse Belongs](#orgd7173f7)
        1.  [show-juz-to-which-this-ayah-belongs.sh](#org7a57f97)
        2.  [show-hizb-to-which-this-ayah-belongs.sh](#orgf377d46)
        3.  [show-rub-al-hizb-to-which-this-ayah-belongs.sh](#org25b7b2d)
        4.  [show-page-number-to-which-this-ayah-belongs.sh](#org226ab29)
    4.  [Show Some More Info for a Surah](#orgd026d94)
        1.  [show-surah-meccan-or-medinan.sh](#org00c2379)
        2.  [show-surah-name-arabic.sh](#org1caccda)
        3.  [show-surah-name-english.sh](#org831b068)
        4.  [show-surah-number.sh](#orgea38b7d)
        5.  [show-surah-number-without-leading-zeros.sh](#org91a3668)
    5.  [Show Number of Elements Contained in the Unit to Which a Verse Belongs](#org6ce53d6)
        1.  [get-number-of-ayaat-of-the-surah-to-which-this-ayah-belongs.sh](#org3e31888)
    6.  [Other Ayah Related BASH Functions](#orgc6b94d5)
        1.  [ayah-necessitates-sadjdah-or-not.sh](#org30a69e3)
        2.  [play-basmala-for-the-113-suwar.sh](#orgb55ac3c)
9.  [Download Section](#org933ec47)
    1.  [tafsir.sh](#org600e6ee)
    2.  [qap-audio-player.sh](#org530cef8)
    3.  [rq-ayat-3x-each-then-1-5.0-ALPHA.sh](#orgfb87aa1)
    4.  [Tafsir Files](#org2e8d5cb)
    5.  [Playlist Files + Audios](#org040b9c4)
    6.  [Translation Files Divided into 6236 TXT Files](#org8f54955)
    7.  [Scripts that Divide the Quran 6236 Audio Files into Various Units](#orgbab79eb)
    8.  [Scripts that Divide Translation Text-Files into 6236 TXT Files](#org112be50)
    9.  [Scripts that Show Various Sûrah or Âyah Metadata](#org00a7a23)
    10. [Custom Tanzil/Zekr Translation/Tafsir Files](#org364bac4)
    11. [Other Scripts](#orgea22206)



<a id="org59bcf59"></a>

# IMPORTANT INFORMATION:

Please note that this site and the programs it provides are a work in progress. We are still in beta.


<a id="orgedb5d3d"></a>

# IMPORTANT NOTES:


<a id="org302b72a"></a>

## Important Note N°1

The first lines of the scripts contain:

-variable declations

-a function that gets the root directory of the script (and uses that to search for the relevent files needed by the script)

-`getopt` related stuff to check command line arguments

Just after that, appear huge functions of thousands of lines which get for us various information related to verses, suwar, juz, hizb, rub-\`ul-hizb or page numbers. Since the Quran has 6236 verses, 114 suwar, 30 juz, 60 hizb, 240 rub-\`ul-hizb and 604 pages, it is only natural that these functions would need thousands of lines. It is important to make this known because anyone who looks to the code would get frustrated as he/she scrolls down endless lines. To edit the code go to the last line of the scripts and then scroll up to the last metadata-related functions: that's from were the real code of the scripts start. If you want to edit the scripts, that's where you want to do it.


<a id="org015fca1"></a>

## Important Note N°2

The Quran has 6236 verses. This is the number of verses you should find in any Tanzil/Zekr Tafsir/Translation files. This is also the number of verses you should normally get in any Zekr Quran Audio Recitation file. However, this number could change. This number could vary if each Sûrah has the Basmala as its first verse. For example 002000.mp3 (or 002000.oga) would be the Basmala for Sûratul-Baqarah.

If each Sûrah has its own Basmala the number of files would increase with 114 more verses. This situation as pointed out above, could only arise in the case of the Quran Audio Recitation Files, not of Tanzil/Zekr Translation/Tafsir files. It is very very important, in fact it is compulsory, very vital that all the \*OOO.mp3 (or \*000.oga) files get deleted before, for example, creating the Playlist files that will be used by the `qap-audio-player` below. If there is an addition of one single file to the 6236 Quran verses, the resulting Playlist file will have an additional 1 line somewhere between the 6236 lines. If this happens, the app will never work properly.

The app heavily relies on the playlist file having 6236 lines, each line corresponding to a verse of the Quran as it appears in any valid Tanzil/Zekr Tafsir/Translation file. As pointed out, the Tanzil/Zekr Translation/Tafsir files could tolerate additional lines, however, they have to appear after the 6236 lines designating the verses of the Quran. This is also the case for the Playlist files. They would tolerate additional lines if they appear after the 6236 lines pointing to the 6236 Quran audio files. The additional lines could give some licence information or any other type of information. These additional lines will never be used by the program.


<a id="orgb695d5c"></a>

# tafsir.sh


<a id="org98b597b"></a>

## SYNOPSIS

tafsir.sh -a|&#x2013;ayaat verse(s) -s|&#x2013;suwar sûrah(s) -f|&#x2013;tafsir-format format of the tafsir files to generate: txt || htm -h|&#x2013;help -J|&#x2013;juz -H|&#x2013;hizb -R|&#x2013;rub-ul-hizb -P|&#x2013;page-number -t|&#x2013;txt-tafasir -x|&#x2013;htm-tafasir -o|&#x2013;output-file-root


<a id="org7e2f926"></a>

## DESCRIPTION

This script, if given zekr/tanzil translation/tafsir files with the "\*trans.zekr" extension, or the  "\*trans.zekr.7z" extension will generate/or show the tafsir one or more ayat, one or more suwar passed through the command line as follows:

-a|&#x2013;ayaat takes 3-digits designating the Sûrah number followed by 3 other digits for the given verse. For example: 005012  means:
Sûrah 5, verse 12. Here one can provide verses in this format - one or more, quoted  for instance: '002102 005075 009105'.
One can also provide ayah numbers  in range. For instance:
'001001\\<sub>001007</sub>'  in such case, the separating character between the two ayaat numbers has to be the underscore character: '\\\_'

-f|&#x2013;tafsir-format takes either htm or txt. Quoiting is not needed. This is the format in which the file should be generated.

-s|&#x2013;suwar takes  SûrahNumber  (without leading zeros). Here you can input many Sûrah names at the same time. For instance:  '1 9 107 50' ==> this is four Sûrah numbers. The list of Sûrah  has to be quoted also. You can also provide Sûrah numbers in range. For instance:
'100\\<sub>105</sub>', '1\\<sub>13</sub>' &#x2026; In such case, the separating character between the two Sûrah numbers has to also be the underscore character: '\\\_'

-J|&#x2013;juz generate tafsir for a given Juz, set of or range of Juz.
-H|&#x2013;hizb generate for Hizb, set of Hizb or range of Hizb.
-R|&#x2013;rub-ul-hizb generate for Rub-ul-Hizb, set of or range of Rub-ul-Hizb
-P|&#x2013;page-number generate for page, set of or range of pages
-t|&#x2013;txt-tafasir txt tafasir files folder
-x|&#x2013;htm-tafasir html tafasir files folder
-o|&#x2013;output-file-root output folder root folder
-h|&#x2013;help display this help message.


<a id="orgedc4819"></a>

## EXAMPLES:

**\*** ONE AYAH OR ONE SÛRAH:
E.g.1 (v1): tafsir.sh -f htm -s 15
E.g.1 (v2): tafsir.sh &#x2013;tafsir-format txt &#x2013;suwar 16

E.g.2 (v1): tafsir.sh -f txt -a 002102
E.g.2 (v2): tafsir.sh &#x2013;tafsir-format htm &#x2013;ayaat 002282

**\*** SEPARATE ÂYÂT OR SUWAR:
E.g.1 (v1): tafsir.sh -f htm -s '1 18 111'
E.g.1 (v2): tafsir.sh &#x2013;tafsir-format txt &#x2013;suwar '16 17 15'

E.g.2 (v1): tafsir.sh -f txt -a '002102 002023 006100' 
E.g.2 (v2): tafsir.sh &#x2013;tafsir-format htm &#x2013;ayaat '002282 003156 110005'

**\*** RANGE OF SUWAR OR ÂYÂT:
E.g.1 (v1): tafsir.sh -f htm -s '90\\<sub>100</sub>'
E.g.1 (v2): tafsir.sh &#x2013;tafsir-format txt &#x2013;suwar '107\\<sub>114</sub>'

E.g.2 (v1): tafsir.sh -f txt -a '002102\\<sub>002110</sub>' 
E.g.2 (v2): tafsir.sh &#x2013;tafsir-format htm &#x2013;ayaat '002280\\<sub>003010</sub>'

in E.g.1 we generate a tafsir for the whole Sûrah 15 of the Quran, thus the option -s in E.g.2 we generate a tafsir for verse number 102 of Sûratul-Baqarah, thus the  -a option and the 002102 value entered.


<a id="org0bb140e"></a>

## DEPENDENCIES


<a id="orge3e2623"></a>

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


<a id="org47c5b8b"></a>

### Supported Format of Tafsir Files

The tafsir files that the program uses are in the format of Tanzil/Zekr translation/tafsir files. You can grab some files from the above-mentioned projects web-sites or (if the tafsir/translation file you would like to work on has not already been setup for zekr/tanzil) create your own. The Tanzil/Zekr file format is a simple text file which has 6236 lines. Each line corresponds to a verse of the Quran. The lines are arranged in the order of the appearance of the verses in the Qur'an from Sûratul-Fatiha to Sûratun-Nâss. Note that after the 6236 lines, you can add some other lines of information or licence, provided that all the 6236 lines of verses appear properly.


<a id="org7b78fdc"></a>

### How to Prepare the Tafsir Files

Let's say we have a set of Zekr tafsir files (this is recommended, though Tanzil files also work fine) as follows:

\#+BEGIN\\<sub>QUOTE</sub>

en.hilali.trans.zip
en.jallalayn.trans.zip
en.sahih.trans.zip
en.al-quran-info-transliteration.trans.zip

\#+END\\<sub>QUOTE</sub>

To prepare them for this tafsir look-up Bash script, do the following:

\#+BEGIN\\<sub>SRC</sub> bash

mkdir ./work
mv -fv en.hilali.trans.zip en.jallalayn.trans.zip \\
   en.sahih.trans.zip \\
   en.al-quran-info-transliteration.trans.zip work

cd work

for file in \*.zip
do
    7z -aoa x "$file"

done

for file in \*.txt
do
    mv -fv "\(file" "\){file%%.txt}.trans.zekr"
done

for file in \*.trans.zekr
do
    7za a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on "\({file}.7z" "\){file}"
done

for file in \*.trans.zekr
do
    rm -rfv "${file}"
done

for file in \*.zip
do
    rm -rfv "$file"
done

rm -rfv translation.properties

\#+END\\<sub>SRC</sub>

If everything goes fine, we should end up with:

`en.sahih.trans.zekr.7z`
`en.hilali.trans.zekr.7z`
`en.jallalayn.trans.zekr.7z`
`en.al-quran-info-transliteration.trans.zekr.7z`

These are the types of files the script handles! Now, you are ready to copy or move them to the appropriate directories.

For the files containing HTML tags, move them to either:

`"SCRIPT\_ROOT\_DIR/html-tafasir-files"`

or

`"$HOME/.tafsir/html-tafasir-files"`

or provide your own directory with the CLI swith:

`-x|--htm-tafasir FULL\_PATH\_TO\_TAFSIR\_FILES`

For plain text files containing no HTML tags move them to either:

`"SCRIPT\_ROOT\_DIR/txt-tafasir-files"`

or

`"$HOME/.tafsir/txt-tafasir-files"`

or provide your own directory with the CLI swith:

`-t|--txt-tafasir FULL\_PATH\_TO\_TAFSIR\_FILES`


<a id="org38ab610"></a>

# qap-audio-player.sh

Please, if you have not already read the **Important Note N°2**, go up and do so. This is vital.


<a id="org6c99b18"></a>

## SYNOPSIS

qap-audio-player.sh -a|&#x2013;ayaat verse(s) -s|&#x2013;suwar sûrah(s) -m|&#x2013;mpv-speed PlaybackSpeed -l|&#x2013;mpv-loop LoopNumber -f|&#x2013;file-loop LoopNumber -g|&#x2013;groupLoop LoopNumber -p|&#x2013;play-trans TranslationID &#x2013;r|&#x2013;reset-eta (takes no option) -J|&#x2013;juz JuzNumber -H|&#x2013;hizb HizbNumber -R|&#x2013;rub-ul-hizb RubUlHizbNumber-P|&#x2013;page-number PageNumber -o|&#x2013;output-quran-html-root WhereToCreateQuran.html -q|&#x2013;hifz-ul-quran ActivateHifzMode -L|&#x2013;playlist-file-root WhereToSearchForPlaylist -e|&#x2013;extension-of-audios QuranAudioFilesExtension -G|&#x2013;generate-playlist QuranFilesRoot &#x2013;ara-font-size size &#x2013;lat-font-size size &#x2013;metadata-font-size size &#x2013;table-font-size size &#x2013;system-font-name FontName &#x2013;user-font-file FullPathToFontFile -h|&#x2013;help (takes no option). All the following take no option also: -k|&#x2013;compact-table &#x2013;eng-audio &#x2013;fra-audio &#x2013;no-ara-txt &#x2013;translit &#x2013;eng-txt-sahih &#x2013;eng-txt-hilali-khan &#x2013;fra-txt-hamid


<a id="org2718817"></a>

## DESCRIPTION

This script, if given playlist files in zekr/tanzil format with the "\*plst.6236.lines.7z" extension, or "\*plst.6236.lines" extension will read the audio files of ayât, set of ayât, range of ayât; suwar, set of suwar, range of suwar; juz, set of juz, range of juz; ḥizb, set of ḥizb, range of ḥizb; rub-\`ul-ḥizb, set of rub-\`ul-ḥizb, range of rub-\`ul-ḥizb; page, set of pages or range of pages passed to it through the command line in the the following format:

FOR AYÂT: 3-digits designating the Sûrah number followed by 3 other digits for the given verse. For example: 005012.
Henceforth this is what we will name ayah\\<sub>id</sub>. The example above means: Sûrah 5, verse 12.

FOR SUWAR: a simple number ranging from 1 to 114 without
any leading zeros. For example '1' for Sûrah al-Fâtiḥa.

FOR JUZ: a simple number also. Ranging from 1 to 30.

FOR ḤIZB: a number ranging from 1 to 60.

FOR RUB-\`UL-ḤIZB: a number ranging from 1 to 240.

FOR PAGES: a number ranging from 1 to 604.

-s|&#x2013;suwar is followed by SûrahNumber (without leading 0s). Here you can input many Sûrah numbers at the same time.
For instance: '1 9 107 50' - Here we have entered four Sûrah numbers. The list of Sûrah has to be quoted either in single quotes (which is preferred) or double quotes.

You can also provide Sûrah numbers in range. For instance:
'100\\<sub>105</sub>' in such case, the separating char between the two Sûrah numbers has to be the underscore character: '\\\_' 

-a|&#x2013;ayaat has to be followed by Sûrah+Ayah e.g.: 007018 - one or more, quoted. I.e., '002102 005075 009105'

Here also you can provide ayah numbers in range. For instance: '001001\\<sub>001007</sub>' in such case, the separating character between the two ayaat numbers has to be the underscore character also: '\\\_'

-J|&#x2013;juz read Quran audio of a given Juz, set of or range of Juz.
-H|&#x2013;hizb read a Hizb, set of Hizb or range of Hizb.
-R|&#x2013;rub-ul-hizb read a Rub-ul-Hizb, set of or range of Rub-ul-Hizb
-P|&#x2013;page-number read a page, set of or range of pages

Note also that -J, -H, -R, and -P will also take single, many or range of units to be played. A unit may refer to a Juz, a Ḥizb, a Rub-\`ul-Ḥizb or a page. It might also refer to a Sûrah. If you would like to provide any unit in range just separate the two numbers with an underscore character just like above.

Also, do not input any leading zeros. And take into account the maximum  number any unit would accept. For instance there are a total of 30  Juz in the Quran, so you cannot request a playback for Juz number 31 which does not exist.


<a id="orgea3a5b4"></a>

## EXAMPLES

**\*** E.g.1 (v1):
qap-audio-player.sh -s 15 -m 1.8 -l 6 -f 2 -g 3 -p eng -r

**\*** E.g.1 (v2):
qap-audio-player.sh &#x2013;suwar 15 &#x2013;mpv-speed 1.8 &#x2013;mpv-loop 6 &#x2013;file-loop 2 &#x2013;group-loop 3 &#x2013;play-trans eng &#x2013;reset-eta

**\*** E.g.2 (v1):
qap-audio-player.sh -a 001005 -m 1.8 -l 6 -f 2 -g 3 -p eng -r

**\*** E.g.2 (v2):
qap-audio-player.sh &#x2013;ayaat 001005 &#x2013;mpv-speed 1.8 &#x2013;mpv-loop 6 &#x2013;file-loop 2 &#x2013;group-loop 3 &#x2013;play-trans eng &#x2013;reset-eta

In the first example we play the audio for the whole Sûrah 15 of the Quran, thus the option -s|&#x2013;suwar

in the second example we play the audio file for verse number 102 of Sûratul-Baqarah, thus the -a|&#x2013;ayaat option and the 002102 value entered.


<a id="org4e6a34b"></a>

## AS FOR THE REST OF THE OPTIONS:

-m|&#x2013;mpv-speed is the playback speed for the MPV-Player. The default value it 1.00.

-l|&#x2013;mpv-loop is the number of times MPV plays the audio file internally.

-f|&#x2013;file-loop is the file loop number. This is the number of times this programs feeds the file to MPV for it to play it.

If for instance we hand the file twice to MPV and its own loop number is set to 6, then we will end up with 6x2=12. This is the total number of times the file gets played. This is so, if the group-loop option is set to 1. It if is set to 2 for instance then the total number of times the file gets played is:
((6x2) x 2)=24.

-g|&#x2013;group-loop is the group loop number. This loop number refeeds the whole group of files to MPV, and lets it play them all and then rehands them to it.

-p|&#x2013;play-trans will activate translation audio files playback. It takes an argument also which is the translation id.

&#x2013;r|&#x2013;reset-eta will reset the saved playback duration of the previous session.

-o|&#x2013;output-quran-html-root where to generate the quran.html file
-q|&#x2013;hifz-ul-quran activate the 'quran rq\\<sub>ayat</sub>\\<sub>3x</sub>\\<sub>each</sub>\\<sub>then</sub>\\<sub>1</sub>' memorisation mode
-L|&#x2013;playlist-file-root where to look for playlist files. This will override the default values.

-e|&#x2013;extension-of-audios extension of the audio files that are in the directory for which you would like to have the playlist file generated. For this to work -e has to come before -G
-G|&#x2013;generate-playlist quran files folder for which to generate the playlist file

&#x2013;ara-font-size provide a size for use with the arabic verses/tafsirs
&#x2013;lat-font-size font size for the latin text (translations, tafsirs)
&#x2013;metadata-font-size a size to be used when displaying metadata information (elapsed time, number of verses of Sûrah&#x2026;)
&#x2013;table-font-size a size to be used with the table that displays some additional Sûwar, âyât metadata
&#x2013;system-font-name here the user has the possibility to provide the name of a font that is already installed on the system. This is not the full path, it is only the official name of the font as registered on the system.
&#x2013;user-font-file here, one ca provide the full path to a font file whether it is installed on the system or not.

-k|&#x2013;compact-table this toggles the display of the compact set of tables (Sûrah and Âyah metadata tables) specifically designed for Android devices and any other small screen device which is able to run GNU/Linux whether natively, through chroot and whatnot!

&#x2013;eng-audio play english verse interpretation audio
&#x2013;fra-audio play french verse interpretation audio

&#x2013;no-ara-txt do not Quran arabic text of current ayah to output html file

&#x2013;translit show transliteration text of current ayah to the command line and also write it to output html file

&#x2013;eng-txt-sahih show Sahih Int. verse interpretation text of current ayah on the command line and also write it to output html file

&#x2013;eng-txt-hilali-khan show Taqi-ud-Deen al-Hilali & Mushin Khan english verse interpretation on the command line and write it also to output html file

&#x2013;fra-txt-hamid show Muhammad Hamidullah french verse interpretation on the command line and write it also to output html file

-h|&#x2013;help will display this help message.

Most of the above options have default values.


<a id="org9703263"></a>

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


<a id="orgf3c7d99"></a>

## CREATING THE PLAYLIST FILES

To generate the playlist files, you need 6236 Quran audio files in a directory. It if recommended that you seperate the 6236 verses into the units that you like. We call unit any of the following: Sûrah, Juz, Ḥizb, Rub-\`ul-Ḥizb and Page-Number.

You could use one of the Bash scripts below to divide your 6236 files into the unit you like.
Please bear in mind that is it very vital that you do not have more that 6236 files before generating the Playlist file. If you get 1 more file then everything will be messed-up completely. If you have additional files designating the Basmalas for each or some Sûrah, then you will have to delete them. To do so, see the code below.

Change to the directory where your audio verses are located. If they are already divided into Suwar, i.e., each Sûrah has its own folder containing its verses, then just deleted the Basmalas. Otherwise it is recommended to divide the verses into units.

We recognize the Basmala files by the fact that they bear the number of the suwar+000. e.g.: 003000.mp3 or 110000.mp3. To remove them we simple search for and remove all the files ending in 000.mp3 in case we are dealing with mp3 files. You replace the 'mp3' with the extension of the audio files you are using.

\#+BEGIN\\<sub>SRC</sub> bash

find . -name '\*000.mp3' | parallel &#x2013;line-buffer &#x2013;jobs=32 'rm -rfv {}'

find . -name '\*000.mp3' -exec bash -c 'rm -rfv "$0"' {} \\;

\#+END\\<sub>SRC</sub>

If everthing is fine, call the script as follows:

`qap-audio-player.sh -G QuranFilesRoot AudioFilesExtension`

or

`qap-audio-player.sh --generate-playlist QuranFilesRoot AudioFilesExtension`

For \\<sub>example</sub>:\\\_

`qap-audio-player.sh -G /home/abu-dju/Verse-By-Verse-Quran-Audio-File/Hudhaify-20k-Hafs oga`

The Playlist file will be generated in the following directory:

$SCRIPT-ROOT-DIR/Playlist/ &#x2013; This is the root directory from where the script is being called by the user. By default this is where the script looks for Playlist files each time it starts up. If the Playlist sub-directory does not exist it will look for Playlist files in $HOME/.qap/Playlists

The extension of the Playlist files is: `plst.6236.lines.7z` &#x2013; It needs to be compressed so that it be well-preserved.


<a id="orgc7f5870"></a>

# rq-ayat-3x-each-then-1.sh


<a id="org78d448b"></a>

## SYNOPSYS

\`basename $0\` -m|&#x2013;mpv-speed playback-speed -l&#x2013;mpv-loop mpv-loop-number -f|&#x2013;file-loop each-file-loop-number -e|&#x2013;extension-of-audios QuranAudioFilesExtension -G|&#x2013;generate-playlist QuranFilesRoot -C|&#x2013;create-fake-audios NumberOfFakeAudiosPerFolder &#x2013;ara-font-size size &#x2013;lat-font-size size &#x2013;metadata-font-size size &#x2013;table-font-size size &#x2013;system-font-name FontName &#x2013;user-font-file FullPathToFontFile. All the following take no option also: -k|&#x2013;compact-table &#x2013;eng-audio &#x2013;fra-audio &#x2013;no-ara-txt &#x2013;translit &#x2013;eng-txt-sahih &#x2013;eng-txt-hilali-khan &#x2013;fra-txt-hamid -h|&#x2013;help


<a id="orgb9da801"></a>

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


<a id="org9e058a9"></a>

## COMMAND LINE OPTIONS

-m|&#x2013;mpv-speed MPV-Player playback speed (default: 1.00)
-l&#x2013;mpv-loop number of time MPV will play each file, internally
-f|&#x2013;file-loop number of times each file gets handed to MPV so that it plays it while also performing its internal loop. The number of times the file gets played is mpv-loop\*file-loop. For example 2\*6=12

-e|&#x2013;extension-of-audios extension of the audio files that are in the directory for which you would like to have the playlist file generated. For this to work -e has to come before -G
-G|&#x2013;generate-playlist quran files folder for which to generate the playlist file

-C|&#x2013;create-fake-audios generate the fake audio files directory for all the 6236 Quran verses. Takes as argument, the number of files per directory

-R|&#x2013;generate-rortrl-files with this option, you request the creation of the following files:
\*RECITE\\<sub>ONCE</sub>\\<sub>LIST</sub>
\*RECITE\\<sub>THRICE</sub>\\<sub>LIST</sub>
\*RECITE\\<sub>LAST</sub>\\<sub>LIST</sub>
You need to create these files in case an error happened that prevents the audios to be played in the correct order. i.e., the program skips some verses - or any other reason that makes you want to do this.
This parameter takes as the sole option, either the number '1', or any other number. '1' makes the program generate the first stage files: RECITE\\<sub>ONCE</sub>\\<sub>LIST</sub> and RECITE\\<sub>THRICE</sub>\\<sub>LIST</sub> files. Any other number, other than '1', will make the program generate RECITE\\<sub>LAST</sub>\\<sub>LIST</sub> file.
h
&#x2013;ara-font-size provide a size for use with the arabic verses/tafsirs
&#x2013;lat-font-size font size for the latin text (translations, tafsirs)
&#x2013;metadata-font-size a size to be used when displaying metadata information (elapsed time, number of verses of Sûrah&#x2026;)
&#x2013;table-font-size a size to be used with the table that displays some additional Sûwar, âyât metadata
&#x2013;system-font-name here the user has the possibility to provide the name of a font that is already installed on the system. This is not the full path, it is only the official name of the font as registered on the system.
&#x2013;user-font-file here, one ca provide the full path to a font file whether it is installed on the system or not.

-k|&#x2013;compact-table this toggles the display of the compact set of tables (Sûrah and Âyah metadata tables) specifically designed for Android devices and any other small screen device which is able to run GNU/Linux whether natively, through chroot and whatnot!

&#x2013;eng-audio play english verse interpretation audio
&#x2013;fra-audio play french verse interpretation audio

&#x2013;no-ara-txt do not write Quran arabic text of current ayah to output html file

&#x2013;translit show transliteration text of current ayah to the command line and also write it to output html file

&#x2013;eng-txt-sahih show Sahih Int. verse interpretation text of current ayah on the command line and also write it to output html file

&#x2013;eng-txt-hilali-khan show Taqi-ud-Deen al-Hilali & Mushin Khan english verse interpretation on the command line and write it also to output html file

&#x2013;fra-txt-hamid show Muhammad Hamidullah french verse interpretation on the command line and write it also to output html file


<a id="org849827c"></a>

## EXAMPLES

rq-ayat-3x-each-then-1.sh -m|&#x2013;mpv-speed 1.8 -l|&#x2013;mpv-loop 6 -f|&#x2013;file-loop 2

Playback speed 180%. Make mpv play each file 6 time. Pass each file 2 times to mpv so that it plays it 6 times as indicated above thus playing it 12 times for all."


<a id="org80baec0"></a>

## DEPENDENCIES

See the "DEPENDENCIES" section of the qap-audio-player.sh script above.


<a id="org9be4f29"></a>

# Divide Quran 6236 Audio Files to Various Units

Scripts that divide a set of Zekr Quran audio files into 114 Suwar, 30-Juz, 60-Ḥizb, 240-Rub-ul-Ḥizb or 604-Pages


<a id="org60df7da"></a>

## divide-quran-per-suwar.sh

This divides the 6236 Quran audio files into 114 folders, each corresponding to a Sûrah of the Quran.


<a id="org94edce0"></a>

## divide-quran-per-juz.sh

This divides the 6236 Quran files into 30 folders, each corresponding to a Juz of the Noble Quran.


<a id="org3e34bc2"></a>

## divide-quran-per-hizb-1-safe.sh

This divides the 6236 Quran audio files into 60 folders, each corresponding to a Ḥizb of the Quran. It has the tag `safe` because it is fast and uses only Bash specific features. This holds true for all the remaining scripts of the list that have that tag.


<a id="orgcc34d44"></a>

## divide-quran-per-hizb-2-unsafe.sh

The `safe` version of the above script.

**\\<sub>Question</sub>:\\\_** Why have the `unsafe` versions since we have the `safe` ones ?

**\\<sub>Answer</sub>:\\\_** The `unsafe` version was created first. Then it was used to divide the Quran files on a test-folder. With the result of the run of that script, we were able to use some hacks through the CLI to list the folders and their contents. With these data we created the `safe` version. Since the `safe` version exists thanks to the `unsafe` version, we thought it would not be wise to delete the `unsafe` version.

The `unsafe` version uses Bash to extrapolate the elements between a range. For instance this excerpt `mv -f {002253..003014} 05` tries to move the elements of the Ḥizb N°5 to a folder named `05`. If you look at the range you will realize that Bash will try to move in fact all the files from 002253 to 003014. We know that Sûratul-Baqarah has a total of 282 verses. Bash will try to move, namely, files 002287, 002288, 002289, 002290, and all the way through 0022999 which do not exit. In fact, here only, it will try to move 713 files that do not exist. This is why this version of the script is tagged `unsafe`. This explanation, holds true for all the remaining scripts tagged `unsafe`.


<a id="org96fccc7"></a>

## divide-quran-per-hizb-roub-1-safe.sh

Divides the Quran verses into 240 Rub-\`ul-Ḥizb. The `safe` version.


<a id="orgd4064d6"></a>

## divide-quran-per-hizb-roub-2-unsafe.sh

The `unsafe` version of the above script.


<a id="org61fcfb5"></a>

## divide-quran-per-page-1-safe.sh

Will divide the Quran version into 604 folders, each corresponding to a page of the Quran in the \`Uthmanic Musḥaff.


<a id="org77a6e56"></a>

## divide-quran-per-page-2-unsafe.sh

The `unsafe` version of the above script.


<a id="org5362d74"></a>

## Bonus: move-21-ayat-in-subdirs.sh


<a id="orgcc000b3"></a>

# div-trans-textFile-to-6236-TXT-Files

This script, if given a zekr/tanzil translation file with the "\*.trans.zekr" extension, will create a folder with the basename of the current input file and then moves to it in order to generate 6236 text files, according to the 6236 lines of the file. Those lines correspond to the 6236 verses of the Quran.

Next, it will rename them from 0001&#x2013;6236 to a SûrahNumber+AyahNumber naming scheme that we have derived from the `VerseByVerse` Quran project recitation audio files.

For instance: 001005 is the 5th verse of surah al-Fatiḥah

058010 is the 10th verse of the 58th surah of the Quran. And so on. This is what we call the `ayah\_id`.

Please make sure your translation files are correctly named. This program only recognizes files that have the extension: `*.trans.zekr`

For instance: `en-hilali.trans.zekr` or `en-sahih.trans.zekr` &#x2013; Note that the file is not zipped.


<a id="org9f4587e"></a>

## Dependencies:

we need the following two files:


<a id="orgea21ffd"></a>

### 01-Quran-Verses-Line-Numbers.txt

This is a simple list of line numbers from 0001 to 6236. This will be used in conjunction with `02-VerseByVerse-Quran-Ayat-List.txt` to rename the generated verses from their original line numbers to their ayah\\<sub>id</sub>.


<a id="org2a969c7"></a>

### 02-VerseByVerse-Quran-Ayat-List.txt

This is also a simple list, but it consists of ayah\\<sub>ids</sub>, from 001001 (the first verse of Sûratu-Fatiḥa) to 114006 (the last verse of Sûratun-Nâss).


<a id="orgee07735"></a>

### Zekr/Tanzil Translation files

This may be any Tanzil/Zekr Translation/Tafsir file either downloaded from their respective web-sites or prepared by a third party, provided that the file is well-prepared and is valid. If you would not want to end up with HTML tags in the generated 6236 text files, you would have to remove all HTML tags using some text editor or some regex engine. Google is your best friend here ;-).


<a id="orgc4a69de"></a>

# Show Sûrah or Âyah Metadata

These display various metadata related to either verses or Sûwar of the Quran.


<a id="org7919744"></a>

## List of Verses of Surah-Juz-Hizb-RubUlHizb-PageNumber

These will give the **list** of verses of various units.


<a id="org4801716"></a>

### show-list-of-verses-that-belong-to-this-surah.sh

Shows the **list** of verses that belong to a particular Sûrah.


<a id="org02f44ef"></a>

### show-list-of-verses-that-belong-to-this-juz.sh

Shows the **list** of verses that belong to a particular Juz.


<a id="org492ab0f"></a>

### show-list-of-verses-that-belong-to-this-hizb.sh

Shows the **list** of verses that belong to a particular Ḥizb.


<a id="orgd4f30cb"></a>

### show-list-of-verses-that-belong-to-this-rub-al-hizb.sh

Shows the **list** of verses that belong to a particular Rub-\`ul-Ḥizb.


<a id="orgad64daa"></a>

### show-list-of-verses-that-belong-to-this-page-number.sh

Shows the **list** of verses that belong to a particular page.


<a id="orgb903b87"></a>

## Number of Verses of Surah-Juz-Hizb-RubUlHizb-PageNumber

These will give, not the **list** of verses, but the **number** of verses of various units.


<a id="org5742f86"></a>

### give-the-number-of-verses-of-surah.sh

Shows the **number** of verses that belong to a particular Sûrah.


<a id="orga212b70"></a>

### show-number-of-verses-that-belong-to-this-juz.sh

Shows the **number** of verses that belong to a particular Juz.


<a id="org36f25d7"></a>

### show-number-of-verses-that-belong-to-this-hizb.sh

Shows the **number** of verses that belong to a particular Ḥizb.


<a id="org6c95111"></a>

### show-number-of-verses-that-belong-to-this-rub-al-hizb.sh

Shows the **number** of verses that belong to a particular Rub-\`ul-Ḥizb.


<a id="org241cc61"></a>

### show-number-of-verses-that-belong-to-this-page-number.sh

Shows the **number** of verses that belong to a particular page.


<a id="orgd7173f7"></a>

## Show ID of the Greater Unit to Which a Verse Belongs

This will show the **number** (name) of the upper unit to which a verse belongs.


<a id="org7a57f97"></a>

### show-juz-to-which-this-ayah-belongs.sh

It takes one ayah and returns the **number** of the Juz to which it belongs. For instance if given the value `002159`, it returns: `02`, which means: the ayah belongs to Juz N°02 of the Quran.


<a id="orgf377d46"></a>

### show-hizb-to-which-this-ayah-belongs.sh

It takes one ayah and returns the **number** of the Ḥizb to which it belongs. For instance if given the value `001007`, it returns: `01`, which means: the ayah belongs to Ḥizb N°01 of the Quran.


<a id="org25b7b2d"></a>

### show-rub-al-hizb-to-which-this-ayah-belongs.sh

It takes one ayah and returns the **number** of the Rub-\`ul-Ḥizb to which it belongs. For instance if given the value `114006`, returns: `240`, which means: the ayah belongs to Rub-\`ul-Ḥizb N°240 of the Quran.


<a id="org226ab29"></a>

### show-page-number-to-which-this-ayah-belongs.sh

It takes one ayah and returns the **number** of the Page to which it belongs. For instance if given the value `002285`, returns: `049`, which means: the ayah belongs to Page N°049 of the Quran.


<a id="orgd026d94"></a>

## Show Some More Info for a Surah

The following functions take one ayah\\<sub>id</sub> and return some information about the Sûrah to which it belongs.


<a id="org00c2379"></a>

### show-surah-meccan-or-medinan.sh

Shows whether the Sûrah to which this ayah belongs is Meccan or Medinan.


<a id="org1caccda"></a>

### show-surah-name-arabic.sh

Shows the Arabic Name of the Sûrah to which this ayah belongs.


<a id="org831b068"></a>

### show-surah-name-english.sh

Shows the English Name of the Sûrah to which this ayah belongs.


<a id="orgea38b7d"></a>

### show-surah-number.sh

Shows the 3-digit Number of the Sûrah to which this ayah belongs.


<a id="org91a3668"></a>

### show-surah-number-without-leading-zeros.sh

Shows the 3-digit Number of the Sûrah to which this ayah belongs, without leading zeros. This means, for instance, that where the above script would return `006`, this one returns `6`. This is sometimes useful for some particular purposes.


<a id="org6ce53d6"></a>

## Show Number of Elements Contained in the Unit to Which a Verse Belongs

This take a single ayah\\<sub>id</sub> and returns the number of elements contained the greater unit to which it belongs.


<a id="org3e31888"></a>

### get-number-of-ayaat-of-the-surah-to-which-this-ayah-belongs.sh

Returns the number of verses of the Sûrah to which a given ayah belongs.


<a id="orgc6b94d5"></a>

## Other Ayah Related BASH Functions


<a id="org30a69e3"></a>

### ayah-necessitates-sadjdah-or-not.sh

This tells us wether a given verse necessitates prosternation after recitation or not.


<a id="orgb55ac3c"></a>

### play-basmala-for-the-113-suwar.sh

This program is able to know when the user is playing the first verses of the 113 chapters of the Quran for which it is mandatory to read the Basmalah and it consequently plays it.


<a id="org933ec47"></a>

# Download Section

If you clone this `github` repository, you will get all the files at once!


<a id="org600e6ee"></a>

## tafsir.sh

Download Link:
[tafsir.sh.gz](programs/tafsir.sh.gz)

[tafsir.sh](programs/uncompressed/tafsir.sh)


<a id="org530cef8"></a>

## qap-audio-player.sh

Download Links:
[qap-audio-player.sh.gz](programs/qap-audio-player.sh.gz)

[qap-audio-player.sh](programs/uncompressed/qap-audio-player.sh)


<a id="orgfb87aa1"></a>

## rq-ayat-3x-each-then-1-5.0-ALPHA.sh

Download Link:
[rq-ayat-3x-each-then-1-5.0-ALPHA.sh.gz](programs/rq-ayat-3x-each-then-1-5.0-ALPHA.sh.gz)

[rq-ayat-3x-each-then-1-5.0-ALPHA.sh](programs/uncompressed/rq-ayat-3x-each-then-1-5.0-ALPHA.sh)


<a id="org2e8d5cb"></a>

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


<a id="org040b9c4"></a>

## Playlist Files + Audios

Coming soon in Sha Allah.


<a id="org8f54955"></a>

## Translation Files Divided into 6236 TXT Files

Coming soon in Sha Allah.


<a id="orgbab79eb"></a>

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


<a id="org112be50"></a>

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


<a id="org00a7a23"></a>

## Scripts that Show Various Sûrah or Âyah Metadata

Below, you can download the whole set of functions that display all sorts of information related to Quranic Chapers (Suwar) and verses (âyât)

Download Link - 7z archive containing all the scrips: 
[Show-Surah-Metadata.7z](programs/Show\_Surah\_Metadata.7z)

Download Links - Separate scripts - \*.sh

Scripts that Show List of Verses of Surah/Juz/Ḥizb/Rub-ul-Ḥizb/PageNumber:

[show-list-of-verses-that-belong-to-this-hizb.sh](programs/uncompressed/Show\_Surah\_Metadata/List\_of\_Verses\_of\_Surah-Juz-Hizb-RubUlHizb-PageNumber/show-list-of-verses-that-belong-to-this-hizb.sh)

[show-list-of-verses-that-belong-to-this-juz.sh](programs/uncompressed/Show\_Surah\_Metadata/List\_of\_Verses\_of\_Surah-Juz-Hizb-RubUlHizb-PageNumber/show-list-of-verses-that-belong-to-this-juz.sh)

[show-list-of-verses-that-belong-to-this-page-number.sh](programs/uncompressed/Show\_Surah\_Metadata/List\_of\_Verses\_of\_Surah-Juz-Hizb-RubUlHizb-PageNumber/show-list-of-verses-that-belong-to-this-page-number.sh)

[show-list-of-verses-that-belong-to-this-rub-al-hizb.sh](programs/uncompressed/Show\_Surah\_Metadata/List\_of\_Verses\_of\_Surah-Juz-Hizb-RubUlHizb-PageNumber/show-list-of-verses-that-belong-to-this-rub-al-hizb.sh)

[show-list-of-verses-that-belong-to-this-surah.sh](programs/uncompressed/Show\_Surah\_Metadata/List\_of\_Verses\_of\_Surah-Juz-Hizb-RubUlHizb-PageNumber/show-list-of-verses-that-belong-to-this-surah.sh)

Scripts that Show Number of Verses of Surah/Juz/Ḥizb/Rub-ul-Ḥizb/PageNumber:

[give-the-number-of-verses-of-surah.sh](programs/uncompressed/Show\_Surah\_Metadata/Number\_of\_Verses\_of\_Surah-Juz-Hizb-RubUlHizb-PageNumber/give-the-number-of-verses-of-surah.sh)

[show-number-of-verses-that-belong-to-this-hizb.sh](programs/uncompressed/Show\_Surah\_Metadata/Number\_of\_Verses\_of\_Surah-Juz-Hizb-RubUlHizb-PageNumber/show-number-of-verses-that-belong-to-this-hizb.sh)

[show-number-of-verses-that-belong-to-this-juz.sh](programs/uncompressed/Show\_Surah\_Metadata/Number\_of\_Verses\_of\_Surah-Juz-Hizb-RubUlHizb-PageNumber/show-number-of-verses-that-belong-to-this-juz.sh)

[show-number-of-verses-that-belong-to-this-page-number.sh](programs/uncompressed/Show\_Surah\_Metadata/Number\_of\_Verses\_of\_Surah-Juz-Hizb-RubUlHizb-PageNumber/show-number-of-verses-that-belong-to-this-page-number.sh)

[show-number-of-verses-that-belong-to-this-rub-al-hizb.sh](programs/uncompressed/Show\_Surah\_Metadata/Number\_of\_Verses\_of\_Surah-Juz-Hizb-RubUlHizb-PageNumber/show-number-of-verses-that-belong-to-this-rub-al-hizb.sh)

Other Ayah Related Scripts:

[ayah-necessitates-sadjdah-or-not.sh](programs/uncompressed/Show\_Surah\_Metadata/Other\_Ayah\_Related\_BASH\_Functions/ayah-necessitates-sadjdah-or-not.sh)

[play-basmala-for-the-113-suwar.sh](programs/uncompressed/Show\_Surah\_Metadata/Other\_Ayah\_Related\_BASH\_Functions/play-basmala-for-the-113-suwar.sh)

Scripts that Show the Id of Surah/Juz/Ḥizb/Rub-ul-Ḥizb/PageNumber to which a Verse Belongs:

[show-hizb-to-which-this-ayah-belongs.sh](programs/uncompressed/Show\_Surah\_Metadata/Show\_ID\_of\_the\_Greater\_Unit\_to\_Which\_a\_Verse\_Belongs/show-hizb-to-which-this-ayah-belongs.sh)

[show-juz-to-which-this-ayah-belongs.sh](programs/uncompressed/Show\_Surah\_Metadata/Show\_ID\_of\_the\_Greater\_Unit\_to\_Which\_a\_Verse\_Belongs/show-juz-to-which-this-ayah-belongs.sh)

[show-page-number-to-which-this-ayah-belongs.sh](programs/uncompressed/Show\_Surah\_Metadata/Show\_ID\_of\_the\_Greater\_Unit\_to\_Which\_a\_Verse\_Belongs/show-page-number-to-which-this-ayah-belongs.sh)

[show-rub-al-hizb-to-which-this-ayah-belongs.sh](programs/uncompressed/Show\_Surah\_Metadata/Show\_ID\_of\_the\_Greater\_Unit\_to\_Which\_a\_Verse\_Belongs/show-rub-al-hizb-to-which-this-ayah-belongs.sh)

Scripts that Show the Number of Verses of the Surah/Juz/Ḥizb/Rub-ul-Ḥizb/PageNumber to a Verse Belongs:

[get-number-of-ayaat-of-the-HIZB-to-which-this-ayah-belongs.sh](programs/uncompressed/Show\_Surah\_Metadata/Show\_Number\_of\_Elements\_Contained\_in\_the\_Unit\_to\_Which\_a\_Verse\_Belongs/get-number-of-ayaat-of-the-HIZB-to-which-this-ayah-belongs.sh)

[get-number-of-ayaat-of-the-JUZ-to-which-this-ayah-belongs.sh](programs/uncompressed/Show\_Surah\_Metadata/Show\_Number\_of\_Elements\_Contained\_in\_the\_Unit\_to\_Which\_a\_Verse\_Belongs/get-number-of-ayaat-of-the-JUZ-to-which-this-ayah-belongs.sh)

[get-number-of-ayaat-of-the-PAGE-to-which-this-ayah-belongs.sh](programs/uncompressed/Show\_Surah\_Metadata/Show\_Number\_of\_Elements\_Contained\_in\_the\_Unit\_to\_Which\_a\_Verse\_Belongs/get-number-of-ayaat-of-the-PAGE-to-which-this-ayah-belongs.sh)

[get-number-of-ayaat-of-the-RUB-UL-HIZB-to-which-this-ayah-belongs.sh](programs/uncompressed/Show\_Surah\_Metadata/Show\_Number\_of\_Elements\_Contained\_in\_the\_Unit\_to\_Which\_a\_Verse\_Belongs/get-number-of-ayaat-of-the-RUB-UL-HIZB-to-which-this-ayah-belongs.sh)

[get-number-of-ayaat-of-the-surah-to-which-this-ayah-belongs.sh](programs/uncompressed/Show\_Surah\_Metadata/Show\_Number\_of\_Elements\_Contained\_in\_the\_Unit\_to\_Which\_a\_Verse\_Belongs/get-number-of-ayaat-of-the-surah-to-which-this-ayah-belongs.sh)

Scripts that Show Some Extras Information for a Surah:

[show-surah-meccan-or-medinan.sh](programs/uncompressed/Show\_Surah\_Metadata/Show\_Some\_Info\_for\_a\_Surah/show-surah-meccan-or-medinan.sh)

[show-surah-name-arabic.sh](programs/uncompressed/Show\_Surah\_Metadata/Show\_Some\_Info\_for\_a\_Surah/show-surah-name-arabic.sh)

[show-surah-name-english.sh](programs/uncompressed/Show\_Surah\_Metadata/Show\_Some\_Info\_for\_a\_Surah/show-surah-name-english.sh)

[show-surah-number.sh](programs/uncompressed/Show\_Surah\_Metadata/Show\_Some\_Info\_for\_a\_Surah/show-surah-number.sh)

[show-surah-number-without-leading-zeros.sh](programs/uncompressed/Show\_Surah\_Metadata/Show\_Some\_Info\_for\_a\_Surah/show-surah-number-without-leading-zeros.sh)

A Single Script that Shows all the Informations of a Given Ayah - It is the combination of most of the other scripts:
[00-show-all-verse-metadata.sh](programs/uncompressed/Show\_Surah\_Metadata/00-show-all-verse-metadata.sh)

A Single Script that Shows all the Verses Belonging to A Surah/Juz/Ḥizb/Rub-ul-Ḥizb or PageNumber:
[show-list-of-verses-of-various-units.sh](programs/uncompressed/Show\_Surah\_Metadata/show-list-of-verses-of-various-units.sh)


<a id="org364bac4"></a>

## Custom Tanzil/Zekr Translation/Tafsir Files

These are a set of Tanzil/Zekr translation or Tafsir files that I prepared for my personal use over the years. In the past years I did my best to get in touch with the Tanzil project in order to send them these files for the benefit of other people but they wouldn't answer my emails. In the end I got frustrated and stopped sending them emails. Here I am today, after many years, publishing them on the internet myself. All praise is due to Allah, The Lord of the Worlds.

Coming soon in Sha Allah.


<a id="orgea22206"></a>

## Other Scripts

Coming soon in Sha Allah.

