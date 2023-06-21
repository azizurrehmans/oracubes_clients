expdp system/one@orcl schemas=addos directory=data_pump_dir dumpfile=addos_%date:~7,2%%date:~4,2%.dmp log=addos_addos_%date:~7,2%%date:~4,2%.log
pause