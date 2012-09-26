@echo off
SET BASE_SCRIPT_DIR=%cd%\base
SET PROJECT_DIR=%cd%\..
SET MODULE_TEMPLATE_HOME=%PROJECT_DIR%\src\com\funcom\project\module
SET VISUAL_TEMPLATE_HOME=%PROJECT_DIR%\asset\fla\module
SET MODULE_DEFINITION_HOME=%PROJECT_DIR%\src\com\funcom\project\manager\implementation\module\enum
SET TEMPLATE_DIR=%MODULE_TEMPLATE_HOME%\template

SET /p MODULE_NAME=Enter your module's name (ex: "WorlMap"):
SET /p AUTHOR_NAME=Enter your name (ex: "Keven Poulin"):

::--------------------------------------CREATE CONCRETE CLASS
ECHO>%MODULE_NAME%
DIR /b/l %MODULE_NAME%>lower.tmp
SET /p PACKAGE_NAME=<lower.tmp
DEL %PACKAGE_NAME%
DEL lower.tmp

MKDIR %MODULE_TEMPLATE_HOME%\%PACKAGE_NAME%
XCOPY %TEMPLATE_DIR% %MODULE_TEMPLATE_HOME%\%PACKAGE_NAME% /Y /S /E /I>nul
REN %MODULE_TEMPLATE_HOME%\%PACKAGE_NAME%\TemplateModule.as %MODULE_NAME%Module.as

::Package renaming
%BASE_SCRIPT_DIR%\search-replace.exe "#PackageName#" "com.funcom.project.module."%PACKAGE_NAME% %MODULE_TEMPLATE_HOME%\%PACKAGE_NAME%\%MODULE_NAME%Module.as
::Name renaming
%BASE_SCRIPT_DIR%\search-replace.exe "#ModuleName#" %MODULE_NAME%Module %MODULE_TEMPLATE_HOME%\%PACKAGE_NAME%\%MODULE_NAME%Module.as
::Author renaming
%BASE_SCRIPT_DIR%\search-replace.exe "#AuthorName#" %AUTHOR_NAME% %MODULE_TEMPLATE_HOME%\%PACKAGE_NAME%\%MODULE_NAME%Module.as

::--------------------------------------CREATE CONCRETE VISUAL LIB
COPY %VISUAL_TEMPLATE_HOME%\TemplateModule.fla %VISUAL_TEMPLATE_HOME%\%MODULE_NAME%Module.fla

::--------------------------------------CREATE MODULE DEFINITION
%BASE_SCRIPT_DIR%\search-replace.exe "//[SCRIPT_HOOK::MODULE_IMPORT]" "//[SCRIPT_HOOK::MODULE_IMPORT]import com.funcom.project.module."%PACKAGE_NAME%"."%MODULE_NAME% %MODULE_DEFINITION_HOME%\EModuleDefinition.as

::CLS
ECHO Module created!

PAUSE