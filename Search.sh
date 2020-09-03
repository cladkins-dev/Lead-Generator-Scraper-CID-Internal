#!/bin/bash
# Opens a lynx browser searching any terms that follow the name of this script

url="https://www.google.com/search?q="

for term in "$@"
do
	url=$url"+"$term
done


echo "$url"

lynx  --dump -accept_all_cookies $url| grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*" | sort | uniq 

