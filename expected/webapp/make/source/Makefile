#----------------------------------------------------------------------------
#       Make Workspace
#
# $Id$
#
# This file was generated by MPC.  Any changes made directly to
# this file will be lost the next time it is generated.
#
# MPC Command:
# /tmp/MPC/mwc.pl -include config -include /home/amitz/MPC_TEST/config -type make -language csharp
#
#----------------------------------------------------------------------------


all: cras aly

depend: cras-depend aly-depend

bundle clean generated realclean check-syntax $(CUSTOM_TARGETS):
	@$(MAKE) -f Makefile.cras $(@)
	@$(MAKE) -f Makefile.aly $(@)

.PHONY: cras
cras:
	@$(MAKE) -f Makefile.cras all

.PHONY: cras-depend
cras-depend:
	@$(MAKE) -f Makefile.cras depend

.PHONY: aly
aly: cras
	@$(MAKE) -f Makefile.aly all

.PHONY: aly-depend
aly-depend:
	@$(MAKE) -f Makefile.aly depend

project_name_list:
	@echo aly
	@echo cras
