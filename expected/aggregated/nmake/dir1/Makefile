#----------------------------------------------------------------------------
#       NMAKE Workspace
#
# $Id$
#
# This file was generated by MPC.  Any changes made directly to
# this file will be lost the next time it is generated.
#
# MPC Command:
# /tmp/MPC/mwc.pl -include config -include /home/amitz/MPC_TEST/config -type nmake aggregated.mwc
#
#----------------------------------------------------------------------------

!IF "$(CFG)" == ""
CFG=Win32 Debug
!MESSAGE No configuration specified. Defaulting to Win32 Debug.
!ENDIF

!IF "$(CUSTOM_TARGETS)" == ""
CUSTOM_TARGETS=_EMPTY_TARGET_
!ENDIF

all: foo dir4-target dir5-target

depend: foo-depend dir4-target-depend dir5-target-depend

clean generated realclean $(CUSTOM_TARGETS):
	@cd dir2
	@echo Directory: dir2
	@echo Project: Makefile.foo.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.foo.mak CFG="$(CFG)" $(@)
	@cd $(MAKEDIR)
	@cd dir4
	@echo Directory: dir4
	@echo Project: Makefile.dir4.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.dir4.mak CFG="$(CFG)" $(@)
	@cd $(MAKEDIR)
	@cd dir5
	@echo Directory: dir5
	@echo Project: Makefile.dir5.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.dir5.mak CFG="$(CFG)" $(@)
	@cd $(MAKEDIR)

foo:
	@cd dir2
	@echo Directory: dir2
	@echo Project: Makefile.foo.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.foo.mak CFG="$(CFG)" all
	@cd $(MAKEDIR)

foo-depend:
	@cd dir2
	@echo Directory: dir2
	@echo Project: Makefile.foo.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.foo.mak CFG="$(CFG)" depend
	@cd $(MAKEDIR)

dir4-target:
	@cd dir4
	@echo Directory: dir4
	@echo Project: Makefile.dir4.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.dir4.mak CFG="$(CFG)" all
	@cd $(MAKEDIR)

dir4-target-depend:
	@cd dir4
	@echo Directory: dir4
	@echo Project: Makefile.dir4.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.dir4.mak CFG="$(CFG)" depend
	@cd $(MAKEDIR)

dir5-target:
	@cd dir5
	@echo Directory: dir5
	@echo Project: Makefile.dir5.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.dir5.mak CFG="$(CFG)" all
	@cd $(MAKEDIR)

dir5-target-depend:
	@cd dir5
	@echo Directory: dir5
	@echo Project: Makefile.dir5.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.dir5.mak CFG="$(CFG)" depend
	@cd $(MAKEDIR)

project_name_list:
	@echo foo
	@echo dir4-target
	@echo dir5-target
