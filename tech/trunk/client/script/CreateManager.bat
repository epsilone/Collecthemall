@echo off
SET BASE_SCRIPT_DIR=%cd%\base
SET PROJECT_DIR=%cd%\..
SET TEMPLATE_HOME=%PROJECT_DIR%\src\com\funcom\project\manager\implementation
SET TEMPLATE_DIR=%TEMPLATE_HOME%\template

SET /p MANAGER_NAME=Enter your manager's name (ex: "Tooltip"):
SET /p AUTHOR_NAME=Enter your name (ex: "Keven Poulin"):

ECHO>%MANAGER_NAME%
DIR /b/l %MANAGER_NAME%>lower.tmp
SET /p PACKAGE_NAME=<lower.tmp
DEL %PACKAGE_NAME%
DEL lower.tmp

MKDIR %TEMPLATE_HOME%\%PACKAGE_NAME%
XCOPY %TEMPLATE_DIR% %TEMPLATE_HOME%\%PACKAGE_NAME% /Y /S /E /I>nul
REN %TEMPLATE_HOME%\%PACKAGE_NAME%\TemplateManager.as %MANAGER_NAME%Manager.as
REN %TEMPLATE_HOME%\%PACKAGE_NAME%\ITemplateManager.as I%MANAGER_NAME%Manager.as

::Package
%BASE_SCRIPT_DIR%\search-replace.exe "#PackageName#" %PACKAGE_NAME% %TEMPLATE_HOME%\%PACKAGE_NAME%\%MANAGER_NAME%Manager.as
%BASE_SCRIPT_DIR%\search-replace.exe "#PackageName#" %PACKAGE_NAME% %TEMPLATE_HOME%\%PACKAGE_NAME%\I%MANAGER_NAME%Manager.as

::Name
%BASE_SCRIPT_DIR%\search-replace.exe "#ManagerName#" %MANAGER_NAME%Manager %TEMPLATE_HOME%\%PACKAGE_NAME%\%MANAGER_NAME%Manager.as
%BASE_SCRIPT_DIR%\search-replace.exe "#ManagerName#" %MANAGER_NAME%Manager %TEMPLATE_HOME%\%PACKAGE_NAME%\I%MANAGER_NAME%Manager.as

::Author
%BASE_SCRIPT_DIR%\search-replace.exe "#AuthorName#" %AUTHOR_NAME% %TEMPLATE_HOME%\%PACKAGE_NAME%\%MANAGER_NAME%Manager.as
%BASE_SCRIPT_DIR%\search-replace.exe "#AuthorName#" %AUTHOR_NAME% %TEMPLATE_HOME%\%PACKAGE_NAME%\I%MANAGER_NAME%Manager.as

CLS
ECHO Manager created!

PAUSE