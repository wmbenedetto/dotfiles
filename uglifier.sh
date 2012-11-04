echo "Uglifying $1"
uglifyjs  -o $2 --define MINIFIED=true $1