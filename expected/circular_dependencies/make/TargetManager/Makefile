#----------------------------------------------------------------------------
#       Make Workspace
#
# $Id: MakeWorkspaceCreator.pm 2035 2011-10-06 15:05:21Z johnnyw $
#
# This file was generated by MPC.  Any changes made directly to
# this file will be lost the next time it is generated.
#
# MPC Command:
# /tmp/MPC/mwc.pl -include config -include /home/amitz/MPC_TEST/config -type make
#
#----------------------------------------------------------------------------


all: CIAO_TargetManager_stub CIAO_TargetManager_svnt CIAO_TargetManager_exec TMClient

depend: CIAO_TargetManager_stub-depend CIAO_TargetManager_svnt-depend CIAO_TargetManager_exec-depend TMClient-depend

clean generated realclean check-syntax $(CUSTOM_TARGETS):
	@$(MAKE) -f Makefile.CIAO_TargetManager_stub $(@)
	@$(MAKE) -f Makefile.CIAO_TargetManager_svnt $(@)
	@$(MAKE) -f Makefile.CIAO_TargetManager_exec $(@)
	@$(MAKE) -f Makefile.TMClient $(@)

.PHONY: CIAO_TargetManager_stub
CIAO_TargetManager_stub:
	@$(MAKE) -f Makefile.CIAO_TargetManager_stub all

.PHONY: CIAO_TargetManager_stub-depend
CIAO_TargetManager_stub-depend:
	@$(MAKE) -f Makefile.CIAO_TargetManager_stub depend

.PHONY: CIAO_TargetManager_svnt
CIAO_TargetManager_svnt: CIAO_TargetManager_stub
	@$(MAKE) -f Makefile.CIAO_TargetManager_svnt all

.PHONY: CIAO_TargetManager_svnt-depend
CIAO_TargetManager_svnt-depend:
	@$(MAKE) -f Makefile.CIAO_TargetManager_svnt depend

.PHONY: CIAO_TargetManager_exec
CIAO_TargetManager_exec: CIAO_TargetManager_svnt
	@$(MAKE) -f Makefile.CIAO_TargetManager_exec all

.PHONY: CIAO_TargetManager_exec-depend
CIAO_TargetManager_exec-depend:
	@$(MAKE) -f Makefile.CIAO_TargetManager_exec depend

.PHONY: TMClient
TMClient: CIAO_TargetManager_stub
	@$(MAKE) -f Makefile.TMClient all

.PHONY: TMClient-depend
TMClient-depend:
	@$(MAKE) -f Makefile.TMClient depend

project_name_list:
	@echo CIAO_TargetManager_exec
	@echo CIAO_TargetManager_stub
	@echo CIAO_TargetManager_svnt
	@echo TMClient
