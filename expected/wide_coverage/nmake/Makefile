#----------------------------------------------------------------------------
#       NMAKE Workspace
#
# $Id: NMakeWorkspaceCreator.pm 2035 2011-10-06 15:05:21Z johnnyw $
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

all: generator_be generator-target source_lib source-target fake

depend: generator_be-depend generator-target-depend source_lib-depend source-target-depend fake-depend

clean generated realclean $(CUSTOM_TARGETS):
	@cd generator
	@echo Directory: generator
	@echo Project: Makefile.generator_be.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.generator_be.mak CFG="$(CFG)" $(@)
	@cd $(MAKEDIR)
	@cd generator
	@echo Directory: generator
	@echo Project: Makefile.generator.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.generator.mak CFG="$(CFG)" $(@)
	@cd $(MAKEDIR)
	@cd source
	@echo Directory: source
	@echo Project: Makefile.source_lib.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.source_lib.mak CFG="$(CFG)" $(@)
	@cd $(MAKEDIR)
	@cd source
	@echo Directory: source
	@echo Project: Makefile.source.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.source.mak CFG="$(CFG)" $(@)
	@cd $(MAKEDIR)
	@cd source/fake
	@echo Directory: source/fake
	@echo Project: Makefile.fake.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.fake.mak CFG="$(CFG)" $(@)
	@cd $(MAKEDIR)

generator_be:
	@cd generator
	@echo Directory: generator
	@echo Project: Makefile.generator_be.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.generator_be.mak CFG="$(CFG)" all
	@cd $(MAKEDIR)

generator_be-depend:
	@cd generator
	@echo Directory: generator
	@echo Project: Makefile.generator_be.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.generator_be.mak CFG="$(CFG)" depend
	@cd $(MAKEDIR)

generator-target: generator_be
	@cd generator
	@echo Directory: generator
	@echo Project: Makefile.generator.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.generator.mak CFG="$(CFG)" all
	@cd $(MAKEDIR)

generator-target-depend:
	@cd generator
	@echo Directory: generator
	@echo Project: Makefile.generator.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.generator.mak CFG="$(CFG)" depend
	@cd $(MAKEDIR)

source_lib: generator-target
	@cd source
	@echo Directory: source
	@echo Project: Makefile.source_lib.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.source_lib.mak CFG="$(CFG)" all
	@cd $(MAKEDIR)

source_lib-depend:
	@cd source
	@echo Directory: source
	@echo Project: Makefile.source_lib.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.source_lib.mak CFG="$(CFG)" depend
	@cd $(MAKEDIR)

source-target: source_lib
	@cd source
	@echo Directory: source
	@echo Project: Makefile.source.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.source.mak CFG="$(CFG)" all
	@cd $(MAKEDIR)

source-target-depend:
	@cd source
	@echo Directory: source
	@echo Project: Makefile.source.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.source.mak CFG="$(CFG)" depend
	@cd $(MAKEDIR)

fake:
	@cd source/fake
	@echo Directory: source/fake
	@echo Project: Makefile.fake.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.fake.mak CFG="$(CFG)" all
	@cd $(MAKEDIR)

fake-depend:
	@cd source/fake
	@echo Directory: source/fake
	@echo Project: Makefile.fake.mak
	$(MAKE) /$(MAKEFLAGS) /f Makefile.fake.mak CFG="$(CFG)" depend
	@cd $(MAKEDIR)

project_name_list:
	@echo generator-target
	@echo generator_be
	@echo source-target
	@echo source_lib
	@echo fake
