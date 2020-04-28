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
