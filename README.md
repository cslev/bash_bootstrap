# Bootstrapping a BASH script
This BASH script helps you to bootstrap another BASH script without the need of defining and typing all the boring things every needs. This includes argument checking, coloring, return value checking functions, etc.
Now, you do not have to do that anymore! Check out the script!

# Usage
```
Example: sudo ./bootstrap.sh -a start.sh -n 2 -t /home/user/killer_bash_script
		-a <SCRIPT_ALIAS>: Indicate the name of the script. Max no. is 10! (Default: Undefined).
		-n <NUMBER_OF_ARGUMENTS>: Indicate how many number of arguments your BASH script will use (Default: Undefined).
		-t <TARGET_DIR>: Indicate the target directory (Default: Undefined).

```
This will create the following scripts and data structure:
```
/home/user/killer_bash_script/
 |-- sources/
    |-- sources/extra.sh
 |-- start.sh
```

And your final script will look like this:
```
#!/bin/bash
 
 source sources/extra.sh
 
 
function show_help 
 { 
 	c_print "Green" "This script does ...!"
 	c_print "Bold" "Example: sudo ./asd.sh "
 	c_print "Bold" "\t\t-a <ARG1>: set ARG1 here (Default: ???)."
 	c_print "Bold" "\t\t-b <ARG2>: set ARG1 here (Default: ???)."
 	exit
 }

ARG1=""
ARG2=""


while getopts "h?a:b:" opt
 do
 	case "$opt" in	h|\?)
 		show_help
 		;;
 	a)
 		ARG1=$OPTARG
 		;;
 	b)
 		ARG2=$OPTARG
 		;;
 
 	*)
 		show_help
 		;;
 	esac
 done


if [ -z $ARG1 ] || [ -z $ARG2 ]
 then
 	c_print "Red" "Undefined arguments!"
 	show_help
 fi

```
