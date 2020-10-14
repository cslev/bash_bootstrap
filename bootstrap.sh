#!/bin/bash


mydir="$(dirname "$0")"
source $mydir/sources/extra.sh

function show_help
{
  c_print "Green" "This scripts bootstraps a new BASH project!"
  c_print "Bold" "Example: sudo ./bootstrap.sh -a start.sh -n 2 -t /home/user/killer_bash_script"
  c_print "Bold" "\t\t-a <SCRIPT_ALIAS>: Indicate the name of the script. Max no. is 10! (Default: Undefined)."
  c_print "Bold" "\t\t-n <NUMBER_OF_ARGUMENTS>: Indicate how many number of arguments your BASH script will use (Default: Undefined)."
  c_print "Bold" "\t\t-t <TARGET_DIR>: Indicate the target directory (Default: Undefined)."
  exit
}

NUM_ARGS=""
TARGET_DIR=""
NAME=""

while getopts "h?n:t:a:" opt
do
  case "$opt" in
  h|\?)
    show_help
    ;;
  n)
    NUM_ARGS=$OPTARG
    ;;
  t)
    TARGET_DIR=$OPTARG
    ;;
  a)
    NAME=$OPTARG
    ;;
  *)
    show_help
   ;;
  esac
done

if [ -z $NUM_ARGS ] || [ -z $TARGET_DIR ] || [ -z $NAME ]
then
  c_print "Red" "Undefined arguments!"
  show_help
fi

if [ $NUM_ARGS -gt 10 ]
then
  c_print "Red" "Required number of arguments is too high!"
  show_help
fi


c_print "Blue" "Bootstrapping ${NAME} in ${TARGET_DIR} with ${NUM_ARGS} arguments..."
mkdir -p $TARGET_DIR
mkdir -p tmp/
cp -r sources/ $TARGET_DIR

declare -A args
args=(
  [1]='a'
  [2]='b'
  [3]='c'
  [4]='d'
  [5]='e'
  [6]='f'
  [7]='g'
  [8]='h'
  [9]='i'
  [10]='j'
)
# ${args[2]}

FINAL_SCRIPT="
#!/bin/bash\n
\n
source sources/extra.sh\n
\n
"

vars=""

c_print "Blue" "Assembling funtion show_help ()..." 1
if [ $NUM_ARGS -ge 1 ]
then
  rm -rf tmp/tmp_function_help.tpl > /dev/null 2>&1
  for i in $(seq 1 $NUM_ARGS)
  do
    echo "\tc_print \"Bold\" \"\\\t\\\t-${args[${i}]} <ARG${i}>: set ARG1 here (Default: ???).\"\n" >> tmp/tmp_function_help.tpl
    vars="${vars}ARG${i}=\"\"\n"
  done
fi

cat templates/show_help.tpl | sed "s/<APPLICATION_NAME>/${NAME}/g" > tmp/show_help_1
head -n4 tmp/show_help_1 > tmp/show_help.final
cat tmp/tmp_function_help.tpl >> tmp/show_help.final
tail -n2 tmp/show_help_1 >> tmp/show_help.final
retval=$?
check_retval $retval

#add help function
help_function=$(cat tmp/show_help.final)
FINAL_SCRIPT="$FINAL_SCRIPT\n${help_function}"


#add vars
c_print "Blue" "Assembling arguments and getopts..." 1
FINAL_SCRIPT="${FINAL_SCRIPT}\n${vars}\n"
cycle="while getopts \"h?"
for i in $(seq 1 $NUM_ARGS)
do
  cycle="${cycle}${args[${i}]}:"
done
cycle=${cycle}"\" opt\n
do\n
\tcase \"\$opt\" in\n
\th|\?)\n
\t\tshow_help\n
\t\t;;\n
"
args="  "
for i in $(seq 1 $NUM_ARGS)
do
  args="${args}\t${args[${i}]})\n
  \t\tARG${i}=\$OPTARG\n
  \t\t;;\n
  "
done
args="${args}\n
\t*)\n
\t\tshow_help\n
\t\t;;\n
\tesac\n
done"

FINAL_SCRIPT="${FINAL_SCRIPT}\n${cycle}${args}\n"
c_print "BGreen" "[DONE]"


#add variable checking
c_print "Blue" "Assembling argument checking part..." 1
check="\nif "
for i in $(seq 1 $NUM_ARGS)
do
  if [ $i -lt $NUM_ARGS ]
  then
    check="${check}[ -z \$ARG${i} ] || "
  else
    check="${check}[ -z \$ARG${i} ]"
  fi
done
check="${check}\n
then\n
\tc_print \"Red\" \"Undefined arguments!\"\n
\tshow_help\n
fi\n"
FINAL_SCRIPT="${FINAL_SCRIPT}\n${check}\n"
c_print "BGreen" "[DONE]"

echo -e $FINAL_SCRIPT > $TARGET_DIR/$NAME
c_print "BGreen" "FINISHED!"
