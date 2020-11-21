while read line
do
src=`echo $line | awk -F'|' '{print $1}'`
dst=`echo $line | awk -F'|' '{print $2}'`
echo sed -i \"\" \"s/$src/$dst/g\" */*.md
done  < words.md