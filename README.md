# Bootstrapping a nice skeleton for your next BASH script
This BASH script helps you to bootstrap or create a nice skeleton for your next BASH script without the need of defining and typing all the boring things every needs. This includes argument checking, coloring, return value checking functions, etc.
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
  c_print "Bold" "\t-a <ARG1>: set ARG1 here (Default: ???)."
  c_print "Bold" "\t-b <ARG2>: set ARG1 here (Default: ???)."
  exit
}

ARG1=""
ARG2=""


while getopts "h?a:b:" opt
 do
    case "$opt" in	
    h|\?)
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

# Some nice functions
## colorized printing in BASH
There almost all possible bash colors and prettifying things provided in the helper functions. The easiest way to print out (i.e., `echo`) something
with a nice looking output is:
```
c_print "Green" "All dependencies installed"
```
This will print the second argument of `c_print` in green color. 
If you want it to be Bold, put a `B` in front of `Green`. 
```
c_print "BGreen" "All dependencies installed"
```
For underline, use `U` instead of `B`.

## Colorized output for progress/checking status
The function `c_print` has a third optional argument, which can be literally anything. If it exists, no carry return will happen **and** the line will be padded until the end of the line, where you can use 6-character status messages, like `[DONE]`, `[FAIL]`, etc.
Let's say you want a status update after a function call (which does not print anything to the standard output):
```
c_print "White" "Running quick calculations..." 1
your_quick_calc()
c_print "BGreen" "[DONE]"
```
### Test return value of a call
There is a function called `check_retval` that checks the return value of function call. If the value equals to `0` (i.e., the function worked as expected), it prints **`[DONE]`** in bold green colors. On the other hand, it prints **`[FAIL]`** in red.

For example, let's check a dependency in you script
```
c_print "White" "Testing JSON parsting dependency 'jq'..." 1
which(jq) #this will return 0, if 'jq' is installed
retval=$(echo $?) #get the return value of the prev. command
check_retval $retval #let the 'check_retval' function to do the rest
```
If the return value is not 0, then the script will quit. Modify the `check_retval()` function if you want to avoid this.

## Get random number
The other thing I usually need when scripting in BASH is to get a *random number*.
So, there is a handy helper function to do this without the need to go to Stackoverflow to check again how it should be done.
```
c_print "White" "A random number between 1 and 1200:" 1 
rnd=get_random 1 1200
c_print "BWhite" "${rnd}"
```
