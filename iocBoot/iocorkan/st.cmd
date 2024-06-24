#!../../bin/linux-arm/orkan

#- You may have to change orkan to something else
#- everywhere it appears in this file

< envPaths

epicsEnvSet("ASYN_PORT_NAME","PORT1")
epicsEnvSet("SERIAL_PORT","/dev/ttyUSB0")
#epicsEnvSet("PREFIX","Cryo-Rec:LPx:")
epicsEnvSet("PREFIX","Cryo-Rec:LP:")
epicsEnvSet("DEV_NAME","C4:")
epicsEnvSet("IOCNAME","ioc01-orkan")
epicsEnvSet("LOCATION","Sauer Compressor Container")
epicsEnvSet("STARTUP","/home/pi/epics/ioc/orkan/iocBoot/iocorkan")
epicsEnvSet("ST_CMD","st.cmd")
epicsEnvSet("ENGINEER","pi")

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/orkan.dbd"
orkan_registerRecordDeviceDriver pdbbase

drvAsynSerialPortConfigure("$(ASYN_PORT_NAME)","$(SERIAL_PORT)",0,0,0)
asynSetOption("$(ASYN_PORT_NAME)",0,"baud", $(BAUD=9600))
asynSetOption("$(ASYN_PORT_NAME)",0,"bits", "8")
asynSetOption("$(ASYN_PORT_NAME)",0,"parity", "none")
asynSetOption("$(ASYN_PORT_NAME)",0,"stop", "1")
		
#modbusInterposeConfig(portName, 
#                      linkType,
#                      timeoutMsec,
#                      writeDelayMsec)

modbusInterposeConfig("$(ASYN_PORT_NAME)",1,5000,10)

#drvModbusAsynConfigure	 'Port name'
#			 'Octet port name' 
#			 'Modbus slave address' 
#			 'Modbus function code' 
#			 'Modbus start address' 
#			 'Modbus length' 
#			 'Data type' 
#			 'Poll time (msec)' 
#			 'PLC type'
#drvModbusAsynConfigure($(ASYN_PORT_NAME)_STATUS, "$(ASYN_PORT_NAME)", 2, 3, 0x247A, 16, "UINT16", 4000, "orkan")

drvModbusAsynConfigure(WR_1R, "$(ASYN_PORT_NAME)", 2, 6, -1, 1, "UINT16", 0, "orkan")

drvModbusAsynConfigure(RD_STAT_BITS, "$(ASYN_PORT_NAME)", 2, 3, 0x0000, 0x30, "UINT16", 2000, "orkan")
drvModbusAsynConfigure(RD_1000, "$(ASYN_PORT_NAME)", 2, 3, 0x1000, 22, "UINT16", 2000, "orkan")
drvModbusAsynConfigure(RD_2000, "$(ASYN_PORT_NAME)", 2, 3, 0x2000, 34, "UINT16", 4000, "orkan")
drvModbusAsynConfigure(RD_3000, "$(ASYN_PORT_NAME)", 2, 3, 0x3000, 39, "UINT16", 4000, "orkan")
drvModbusAsynConfigure(RD_4000, "$(ASYN_PORT_NAME)", 2, 3, 0x4000, 13, "UINT16", 4000, "orkan")

var(reccastTimeout, 5.0)
var(reccastMaxHoldoff, 5.0)

## Load record instances
dbLoadRecords("db/orkan.db","PORT_RD_1000=RD_1000,PORT_RD_2000=RD_2000,PORT_RD_3000=RD_3000,PORT_RD_4000=RD_4000,PORT_RD_STAT_BITS=RD_STAT_BITS,PORT_RD_1R=RD_1R,PORT_WR_1R=WR_1R,P=$(PREFIX),D=$(DEV_NAME)")
dbLoadRecords("$(ASYN)/db/asynRecord.db","P=$(IOCNAME),R=:asynRec,PORT='$(ASYN_PORT_NAME)',ADDR='0',IMAX='1024',OMAX='256'")
dbLoadRecords("$(RECSYNC)/db/reccaster.db","P=$(IOCNAME):RecSync-")
dbLoadRecords("db/iocAdminSoft-ess.db","IOC=$(IOCNAME)")

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=pi"
