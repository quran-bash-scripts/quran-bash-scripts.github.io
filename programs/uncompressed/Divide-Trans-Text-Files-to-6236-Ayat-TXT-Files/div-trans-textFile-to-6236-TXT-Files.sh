#!/bin/bash
#
# In the Name of Allah The entirely Mercifyl, the especially Merciful
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses/>
# or write to the Free Software Foundation, Inc., 51 Franklin St,
# Fifth Floor, Boston, MA 02110-1301 USA
#
# Copyright (C) Hijri 1436, 1437, 1438, 1439, 1440
#
# Copyright (C) Gregorian 2015, 2016, 2017, 2018 Abu-Djuwairiyyah
# Karim ibn Muḥammad as-Salafî
#
echo; echo "Please make sure your translation files"
echo "are correctly named. This program only"
echo "recognizes files that have the following"
echo "extension: *.trans.zekr. For instance:"
echo "en-hilali.trans.zekr | en-sahih.trans.zekr"; echo

# This script, if given a zekr/tanzil
# translation file with the "*.zekr"
# extension, will create a folder with its
# basename and change into it in order to
# generate 6236 text files, according to
# the 6236 lines of the file and those
# lines correspond to the 6236 verses of
# the Quran. Next, it will rename them
# from 0001--6236 to a Quran/Surah/Verse
# naming scheme that we have derived from
# the "VerseByVerse" project Quran
# recitation audio files. For instance:
# 001005 (5th verse of surah al-Fatiḥah),
# 058010 -> 10th verse of the 58th surah
# of the Quran...

for file in *.trans.zekr
do
    # make a folder with the basename of the file and copy it in it
    mkdir -p "${file%.trans.zekr}" && cp -rvf "$file" "${file%.trans.zekr}" && cd "${file%.trans.zekr}"

    # we also need to copy the following two files:
    # 01-Quran-Verses-Line-Numbers.txt
    # and
    # 02-VerseByVerse-Quran-Ayat-List.txt
    # otherwise the operation will fail
    cp -rfv ../01-Quran-Verses-Line-Numbers.txt ../02-VerseByVerse-Quran-Ayat-List.txt .
    
    # We'll use this to pad job sequence with leading zeros to get equal width
    # --rpl '{0#} $f=1+int("".(log(total_jobs())/log(10))); $_=sprintf("%0${f}d",seq())'

    parallel --bar --linebuffer --jobs=32 --rpl '{0#} $f=1+int("".(log(total_jobs())/log(10))); $_=sprintf("%0${f}d",seq())' 'echo {} > {0#}' :::: "$file"

    # we need the following two files:
    # 01-Quran-Verses-Line-Numbers.txt
    # and
    # 02-VerseByVerse-Quran-Ayat-List.txt
    # remember, for the time being, the files
    # that we have generated are named according
    # to their line numbers in the original
    # translation file and they are 0001 through
    # 6236, which corresponds to the total verses
    # of the Qur'an. What we would like to have is
    # the files named according to their surah and
    # verse numbers, i.e., 001007 (seventh verse
    # of surah al-Fatiḥa). To do that, we have two
    # files that will help.
    # "01-Quran-Verses-Line-Numbers.txt" contains
    # the filenames according to their original line
    # numbers and "02-VerseByVerse-Quran-Ayat-List.txt"
    # the filenames according to their surah and ayah
    # numbers. We'll use the following code to carry
    # out the renaming process.

    parallel --bar --jobs=32 'mv {1} {2}' :::: 01-Quran-Verses-Line-Numbers.txt ::::+ 02-VerseByVerse-Quran-Ayat-List.txt

    # Clean-up
    rm -rfv ./01-Quran-Verses-Line-Numbers.txt ./02-VerseByVerse-Quran-Ayat-List.txt ./"$file"
    
    # append the translation id and the
    # "*.txt" extension to the files
    parallel --bar --linebuffer --jobs=32 "mv {} {}.${file%.trans.zekr}.txt" ::: *

    # to parent folder in order to process the
    # remaining translation files, if any.
    cd ..
    
done
