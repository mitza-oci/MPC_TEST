#----------------------------------------------------------------------------
#       Macros
#----------------------------------------------------------------------------
CXX           = gcj
LD            = $(CXX) $(CCFLAGS) $(CPPFLAGS)
AR            = ar
PICFLAGS      = -fPIC
CPPFLAGS      = $(PICFLAGS) $(GENFLAGS)
OBJEXT        = .o
OUTPUT_OPTION = -o "$@"
COMPILE.cc    = $(CXX) $(CCFLAGS) $(CPPFLAGS) -c
LDFLAGS       = -L"."
CCC           = $(CXX)
MAKEFILE      = Makefile.j
DEPENDENCIES  = .depend.$(MAKEFILE)
BTARGETDIR    = ./
BIN           = $(BTARGETDIR)simple$(EXESUFFIX)$(EXEEXT)
CAT           = cat
MV            = mv -f
RM            = rm -rf
CP            = cp -p
NUL           = /dev/null
MKDIR         = mkdir -p
TESTDIRSTART  = test -d
TESTDIREND    = ||
EXEEXT        = 
LIBPREFIX     = lib
LIBSUFFIX     = 
GENFLAGS      = -O
LDLIBS        = -ldl $(subst lib,-l,$(sort $(basename $(notdir $(wildcard /usr/lib/librt.so /lib/librt.so))))) -lpthread
OBJS          = simple$(OBJEXT)
SRC           = simple.java
LINK.cc       = $(LD) $(LDFLAGS)

#----------------------------------------------------------------------------
#       Local targets
#----------------------------------------------------------------------------

all: $(BIN)

$(BIN): $(OBJS)
	@$(TESTDIRSTART) "$(BTARGETDIR)" $(TESTDIREND) $(MKDIR) "$(BTARGETDIR)"
	$(LINK.cc) $(OBJS) $(LDLIBS) --main=simple $(OUTPUT_OPTION)

generated: $(GENERATED_DIRTY)
	@-:

simple$(OBJEXT): simple.java
	$(COMPILE.cc) $(EXPORTFLAGS) $(OUTPUT_OPTION) simple.java

clean:
	-$(RM) $(OBJS)

realclean: clean
	-$(RM) $(BIN)

#----------------------------------------------------------------------------
#       Dependencies
#----------------------------------------------------------------------------

$(DEPENDENCIES):
	@touch $(DEPENDENCIES)

depend:
	-/home/elliottc/current/MPC/depgen.pl  $(CFLAGS) $(CCFLAGS) $(CPPFLAGS) -f $(DEPENDENCIES) $(SRC) 2> $(NUL)

include $(DEPENDENCIES)