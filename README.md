# APIFuzzing

This is a plugin written in lua for cuberite. As the plugin name already indicates it's used for fuzzing and it can check the cuberite lua api.

There are two commands
* fuzzing
* checkapi

# Fuzzing
The runme file has to be copied to the root folder of Cuberite, before running it.

### Windows
Run the file runme.bat and it will startup Cuberite.

### Linux
Run the file runme.sh and it will startup Cuberite.

### Running
The server will be started and runs the console command `fuzzing`.
If an crash occurs:
* Under linux the script will automatically restart cuberite and run the command again
* Under windows, you need to close the debugger message box that will appear, then cuberite will start and run the command again

The message `Fuzzing completed!` will be printed in the console, if the plugin is finished.
If an crash has occured, in the home directory of the plugin will be a file named `crashed_table.txt`.
It contains the `class name`, `function name` and the `function call` of all crashes.

# CheckAPI
Start the server and run the console command `checkapi`. The plugin will be finished if the message `CheckAPI completed!` appears. The results, if any, are in the console output and in cuberite log files.

### Features
* It can catch:
* - Syntax errors, indicates a problem in code generation of plugin
* - Runtime errors, function doesn't exists, is not exported or flag IsStatic is missing in APIDoc
* It checks the return types of the function call with the APIDoc
