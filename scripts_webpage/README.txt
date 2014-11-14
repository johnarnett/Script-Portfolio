This is the file structure of a LAMP stack hosting a web utility that can run bash and powershell scripts. These have the ability to retrieve / update information at remote locations in the US and Canada.

The scripts are located in the 'scripts' directory. Each script has a corresponding
http and php file associated with it to gather input from the web UI and pass the
arguments to the script for execution.

Control Flow is as follows:
index.html > scripts/script_name.html > scripts/script_name.php > scripts/script_name.sh
