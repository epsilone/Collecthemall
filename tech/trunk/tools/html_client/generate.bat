@echo off
..\thrift.exe -v -r -out client\js --gen js ..\..\common\all.thrift
..\thrift.exe -v -r -out client --gen html:ajax_calls ..\..\common\all.thrift