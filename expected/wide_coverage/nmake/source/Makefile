#----------------------------------------------------------------------------
#       NMAKE Workspace
#
# $Id$
#
# This file was generated by MPC.  Any changes made directly to
# this file will be lost the next time it is generated.
#
# MPC Command:
# /tmp/MPC/mwc.pl -include config -include /home/amitz/MPC_TEST/config -type nmake -features rtti=1 wide_coverage.mwc
#
#----------------------------------------------------------------------------

!IF "$(CFG)" == ""
CFG=Win32 Debug
!MESSAGE No configuration specified. Defaulting to Win32 Debug.
!ENDIF

!IF "$(CUSTOM_TARGETS)" == ""
CUSTOM_TARGETS=_EMPTY_TARGET_
!ENDIF

all: source_lib source fake-target

depend: source_lib-depend source-depend fake-target-depend

clean generated realclean $(CUSTOM_TARGETS):
	@echo Project: Makefile.source_lib.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.source_lib.mak CFG="$(CFG)" $(@)
	@echo Project: Makefile.source.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.source.mak CFG="$(CFG)" $(@)
	@cd fake
	@echo Directory: fake
	@echo Project: Makefile.fake.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.fake.mak CFG="$(CFG)" $(@)
	@cd $(MAKEDIR)

source_lib:
	@echo Project: Makefile.source_lib.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.source_lib.mak CFG="$(CFG)" all

source_lib-depend:
	@echo Project: Makefile.source_lib.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.source_lib.mak CFG="$(CFG)" depend

source: source_lib
	@echo Project: Makefile.source.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.source.mak CFG="$(CFG)" all

source-depend:
	@echo Project: Makefile.source.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.source.mak CFG="$(CFG)" depend

fake-target:
	@cd fake
	@echo Directory: fake
	@echo Project: Makefile.fake.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.fake.mak CFG="$(CFG)" all
	@cd $(MAKEDIR)

fake-target-depend:
	@cd fake
	@echo Directory: fake
	@echo Project: Makefile.fake.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.fake.mak CFG="$(CFG)" depend
	@cd $(MAKEDIR)

project_name_list:
	@echo source
	@echo source_lib
	@echo fake-target
