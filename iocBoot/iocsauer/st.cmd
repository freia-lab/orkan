#!../../bin/linux-arm/sauer

#- You may have to change sauer to something else
#- everywhere it appears in this file

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/sauer.dbd"
sauer_registerRecordDeviceDriver pdbbase

## Load record instances
#dbLoadRecords("db/sauer.db","user=pi")

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=pi"
