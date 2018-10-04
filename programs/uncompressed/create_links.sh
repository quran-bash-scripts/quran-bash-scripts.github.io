#!/bin/bash

output_file="$HOME/links.txt"
cat /dev/null > "$output_file"

# find . -name '*.sh' | parallel --jobs=1 --line-buffer 'echo; echo {/} >> "$output_file"; echo [[file:`readlink --canonicalize-existing {}`][{/}]] >> "$output_file"; echo >> "$output_file"'


for file in *.sh
do
    echo  >> "$output_file"
    echo "[[file:`readlink --canonicalize-existing "$file"`][`basename "$file"`]]" >> "$output_file"
    echo >> "$output_file"
done

for folder in *
do
    if [[ -d "$folder" ]]
    then
	echo "$folder" >> "$output_file"
	cd "$folder"

	for file in *.sh
	do
	    echo  >> "$output_file"
	    echo "[[file:`readlink --canonicalize-existing "$file"`][`basename "$file"`]]" >> "$output_file"
	    echo >> "$output_file"
	done
	cd ..
    fi
done

exit $?
