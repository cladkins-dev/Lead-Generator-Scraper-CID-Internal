#!/bin/bash


#Simple Lead Generation Script based on searching Google.
#09DEC2018

query=""
for term in "$@"
do
        query=$query"+"$term
done



start=10
end=50
size=10

_log="_result_log"
_log_clean="_result_log"
_log_clean_all="_result_log"
_log_clean_string=""

for _index in $(seq $start $size $end);do

_log="logs/_result_log_$_index"
_log_clean="logs/_result_log_${_index}_clean"
_log_clean_all="logs/_result_log__clean_all"
_log_clean_string=$(printf "%s %s" "$_log_clean_string" "$_log_clean")

#echo "Scraping $_index Page Results...."

url=$(printf 'https://www.google.com/search?q=site:YouTube.com+%s+"@gmail.com"&start=' "$query")

url=$(printf "%s%s" "$url" "$_index")

#echo "$url"

#_SITE_DUMP=$(lynx  --dump -accept_all_cookies $url| grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*" | sort | uniq)
_SITE_DUMP=$(lynx  --dump -accept_all_cookies $url|sed 's,https://www.google.com/url?q=,,g'| sort | uniq)
#echo "$_SITE_DUMP"

EMAILS=()
for _url in $(echo "$_SITE_DUMP");do


_url=$(echo "$_url" |sed -e's/%\([0-9A-F][0-9A-F]\)/\\\\\x\1/g' | xargs echo -e 2>/dev/null)
_url=$(echo "$_url" | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*")



_email=$(curl -s "$_url" |grep -E -o "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b")

echo "$_email">>"$_log"

done
cat "$_log"|sort -u>"$_log_clean"

done
cat $_log_clean_string > $_log_clean_all
cat "$_log_clean_all"
