TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#=============================
# Build the IOC application

PROD_IOC = orkan
# orkan.dbd will be created and installed
DBD += orkan.dbd

# orkan.dbd will be made up from these files:
orkan_DBD += base.dbd

# Include dbd files from all support applications:
#orkan_DBD += xxx.dbd
orkan_DBD += asyn.dbd
orkan_DBD += modbusApp.dbd
orkan_DBD += modbusSupport.dbd

# Add all the support libraries needed by this IOC
#orkan_LIBS += xxx
orkan_LIBS += modbus
orkan_LIBS += asyn

# orkan_registerRecordDeviceDriver.cpp derives from orkan.dbd
orkan_SRCS += orkan_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
orkan_SRCS_DEFAULT += orkanMain.cpp
orkan_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#orkan_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Finally link to the EPICS Base libraries
orkan_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

