# -*- makefile -*-
#----------------------------------------------------------------------------
#       GNU ACE Workspace
#
# $Id: GNUACEWorkspaceCreator.pm 14 2007-02-01 15:49:12Z mitza $
#
# This file was generated by MPC.  Any changes made directly to
# this file will be lost the next time it is generated.
#
# MPC Command:
# /tao_builds/chad/ocitao/ACE_wrappers/build/linux/bin/mwc.pl -include config -type gnuace
#
#----------------------------------------------------------------------------

MAKEFILE = GNUmakefile

ifeq ($(findstring k,$(MAKEFLAGS)),k)
  KEEP_GOING = -
endif

include $(ACE_ROOT)/include/makeinclude/macros.GNU

all: bfs_exe bfs_lib

REMAINING_TARGETS := $(subst all, , $(TARGETS_NESTED:.nested=)) $(CUSTOM_TARGETS)

$(REMAINING_TARGETS):
	@cd source && $(MAKE) -f GNUmakefile.bfs_exe $(@)
	@cd source && $(MAKE) -f GNUmakefile.bfs_lib $(@)

.PHONY: bfs_exe
bfs_exe:
	@cd source && $(MAKE) -f GNUmakefile.bfs_exe all

.PHONY: bfs_lib
bfs_lib:
	@cd source && $(MAKE) -f GNUmakefile.bfs_lib all

project_name_list:
	@echo bfs_exe
	@echo bfs_lib
