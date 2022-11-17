#!../../bin/linux-arm/sauer

#- You may have to change sauer to something else
#- everywhere it appears in this file

< envPaths

epicsEnvSet("ASYN_PORT_NAME","PORT1")
epicsEnvSet("SERIAL_PORT","/dev/ttyUSB0")
#epicsEnvSet("PREFIX","Cryo-Rec:LPx:")
epicsEnvSet("PREFIX","Cryo-Rec:LP:")
epicsEnvSet("DEV_NAME","C4:")
epicsEnvSet("IOCNAME","ioc01-orkan")



cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/sauer.dbd"
sauer_registerRecordDeviceDriver pdbbase

drvAsynSerialPortConfigure("$(ASYN_PORT_NAME)","$(SERIAL_PORT)",0,0,0)
asynSetOption("$(ASYN_PORT_NAME)",0,"baud", $(BAUD=9600))
asynSetOption("$(ASYN_PORT_NAME)",0,"bits", "8")
asynSetOption("$(ASYN_PORT_NAME)",0,"parity", "none")
asynSetOption("$(ASYN_PORT_NAME)",0,"stop", "1")
		
#modbusInterposeConfig(portName, 
#                      linkType,
#                      timeoutMsec,
#                      writeDelayMsec)

modbusInterposeConfig("$(ASYN_PORT_NAME)",1,500,100)

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

drvModbusAsynConfigure(RD_1R, "$(ASYN_PORT_NAME)", 2, 3, -1, 1, "UINT16", 4000, "orkan")
drvModbusAsynConfigure(RD_2R, "$(ASYN_PORT_NAME)", 2, 3, -1, 2, "UINT16", 4000, "orkan")

drvModbusAsynConfigure(WR_1R, "$(ASYN_PORT_NAME)", 2, 6, -1, 1, "UINT16", 1, "orkan")
drvModbusAsynConfigure(WR_2R, "$(ASYN_PORT_NAME)", 2, 6, -1, 2, "INT32_BE", 0, "orkan")

#drvModbusAsynConfigure(PRESSURE, "$(ASYN_PORT_NAME)", 2, 3, 0x1028, 104, "UINT16", 4000, "orkan")

#drvModbusAsynConfigure(TEMP1, "$(ASYN_PORT_NAME)", 2, 3, 0x1400, 123, "UINT16", 4000, "orkan")
#drvModbusAsynConfigure(TEMP2, "$(ASYN_PORT_NAME)", 2, 3, 0x14FA, 124, "UINT16", 4000, "orkan")
#drvModbusAsynConfigure(TEMP3, "$(ASYN_PORT_NAME)", 2, 3, 0x15F6, 26, "UINT16", 4000, "orkan")

#drvModbusAsynConfigure(MOTOR, "$(ASYN_PORT_NAME)", 2, 3, 0x1800, 24, "UINT16", 4000, "orkan")


## Load record instances
dbLoadRecords("db/orkan.db","PORT_RD_2R=RD_2R,PORT_RD_1R=RD_1R,PORT_WR_1R=WR_1R,PORT_WR_2R=WR_2R,P=$(PREFIX),D=$(DEV_NAME)")
dbLoadRecords("$(ASYN)/db/asynRecord.db","P=$(IOCNAME),R=:asynRec,PORT='$(ASYN_PORT_NAME)',ADDR='0',IMAX='1024',OMAX='256'")

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=pi"
