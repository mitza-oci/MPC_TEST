# Microsoft Developer Studio Generated NMAKE File
!IF "$(CFG)" == ""
CFG=Win32 Debug
!MESSAGE No configuration specified. Defaulting to Win32 Debug.
!ENDIF

!IF "$(CFG)" == "Win32 Debug" || "$(CFG)" == "Win32 Release" || "$(CFG)" == "Win32 Static Debug" || "$(CFG)" == "Win32 Static Release"
!ELSE
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE
!MESSAGE NMAKE /f "Makefile.foo.mak" CFG="Win32 Debug"
!MESSAGE
!MESSAGE Possible choices for configuration are:
!MESSAGE
!MESSAGE "Win32 Debug" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "Win32 Release" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "Win32 Static Debug" (based on "Win32 (x86) Static Library")
!MESSAGE "Win32 Static Release" (based on "Win32 (x86) Static Library")
!MESSAGE
!ERROR An invalid configuration was specified.
!ENDIF

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE
NULL=nul
!ENDIF

!IF "$(DEPGEN)" == ""
!IF EXISTS("$(MPC_ROOT)/depgen.pl")
DEPGEN=perl $(MPC_ROOT)/depgen.pl -i -t nmake
!ELSEIF EXISTS("$(DEPGEN_ROOT)/depgen.pl")
DEPGEN=perl $(DEPGEN_ROOT)/depgen.pl -i -t nmake
!ELSEIF EXISTS("$(ACE_ROOT)/bin/depgen.pl")
DEPGEN=perl $(ACE_ROOT)/bin/depgen.pl -i -t nmake
!ENDIF
!ENDIF

GENERATED_DIRTY = "FooTypeSupportImpl.cpp" "FooTypeSupportImpl.h" "FooD.cpp" "FooD.h" "FooD.idl"

!IF  "$(CFG)" == "Win32 Debug"

OUTDIR=.
INTDIR=Debug\foo\I386

ALL : "$(INTDIR)" "$(OUTDIR)" DEPENDCHECK $(GENERATED_DIRTY) ".\food.dll"

DEPEND :
!IF "$(DEPGEN)" == ""
	@echo No suitable dependency generator could be found.
	@echo One comes with MPC, just set the MPC_ROOT environment variable
	@echo to the full path of MPC.  You can download MPC from
	@echo http://www.ociweb.com/products/mpc/down.html
!ELSE
	$(DEPGEN) -D_DEBUG -DWIN32 -D_WINDOWS -f "Makefile.foo.dep" "FooD.cpp" "FooTypeSupportImpl.cpp"
!ENDIF

REALCLEAN : CLEAN
	-@del /f/q "$(OUTDIR)\food.pdb"
	-@del /f/q ".\food.dll"
	-@del /f/q "$(OUTDIR)\food.lib"
	-@del /f/q "$(OUTDIR)\food.exp"
	-@del /f/q "$(OUTDIR)\food.ilk"
	-@del /f/q "FooTypeSupportImpl.cpp"
	-@del /f/q "FooTypeSupportImpl.h"
	-@del /f/q "FooD.cpp"
	-@del /f/q "FooD.h"
	-@del /f/q "FooD.idl"

"$(INTDIR)" :
	if not exist "Debug\$(NULL)" mkdir "Debug"
	if not exist "Debug\foo\$(NULL)" mkdir "Debug\foo"
	if not exist "$(INTDIR)\$(NULL)" mkdir "$(INTDIR)"

CPP=cl.exe
CPP_COMMON=/Zc:wchar_t /nologo /Ob0 /W3 /Gm /EHsc /Zi /MDd /GR /Gy /Fd"$(INTDIR)/" /D _DEBUG /D WIN32 /D _WINDOWS  /c

CPP_PROJ=$(CPP_COMMON) /Fo"$(INTDIR)\\"

RSC=rc.exe

LINK32=link.exe
LINK32_FLAGS=advapi32.lib user32.lib /INCREMENTAL:NO /libpath:"." /nologo /subsystem:windows /dll /debug /pdb:".\food.pdb" /machine:I386 /out:".\food.dll" /implib:"$(OUTDIR)\food.lib"
LINK32_OBJS= \
	"$(INTDIR)\FooD.obj" \
	"$(INTDIR)\FooTypeSupportImpl.obj"

".\food.dll" : $(DEF_FILE) $(LINK32_OBJS)
	$(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<
	if exist ".\food.dll.manifest" mt.exe -manifest ".\food.dll.manifest" -outputresource:$@;2

!ELSEIF  "$(CFG)" == "Win32 Release"

OUTDIR=.
INTDIR=Release\foo\I386

ALL : "$(INTDIR)" "$(OUTDIR)" DEPENDCHECK $(GENERATED_DIRTY) ".\foo.dll"

DEPEND :
!IF "$(DEPGEN)" == ""
	@echo No suitable dependency generator could be found.
	@echo One comes with MPC, just set the MPC_ROOT environment variable
	@echo to the full path of MPC.  You can download MPC from
	@echo http://www.ociweb.com/products/mpc/down.html
!ELSE
	$(DEPGEN) -DNDEBUG -DWIN32 -D_WINDOWS -f "Makefile.foo.dep" "FooD.cpp" "FooTypeSupportImpl.cpp"
!ENDIF

REALCLEAN : CLEAN
	-@del /f/q ".\foo.dll"
	-@del /f/q "$(OUTDIR)\foo.lib"
	-@del /f/q "$(OUTDIR)\foo.exp"
	-@del /f/q "$(OUTDIR)\foo.ilk"
	-@del /f/q "FooTypeSupportImpl.cpp"
	-@del /f/q "FooTypeSupportImpl.h"
	-@del /f/q "FooD.cpp"
	-@del /f/q "FooD.h"
	-@del /f/q "FooD.idl"

"$(INTDIR)" :
	if not exist "Release\$(NULL)" mkdir "Release"
	if not exist "Release\foo\$(NULL)" mkdir "Release\foo"
	if not exist "$(INTDIR)\$(NULL)" mkdir "$(INTDIR)"

CPP=cl.exe
CPP_COMMON=/Zc:wchar_t /nologo /O2 /W3 /EHsc /MD /GR /D NDEBUG /D WIN32 /D _WINDOWS  /c

CPP_PROJ=$(CPP_COMMON) /Fo"$(INTDIR)\\"

RSC=rc.exe

LINK32=link.exe
LINK32_FLAGS=advapi32.lib user32.lib /INCREMENTAL:NO /libpath:"." /nologo /subsystem:windows /dll  /machine:I386 /out:".\foo.dll" /implib:"$(OUTDIR)\foo.lib"
LINK32_OBJS= \
	"$(INTDIR)\FooD.obj" \
	"$(INTDIR)\FooTypeSupportImpl.obj"

".\foo.dll" : $(DEF_FILE) $(LINK32_OBJS)
	$(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<
	if exist ".\foo.dll.manifest" mt.exe -manifest ".\foo.dll.manifest" -outputresource:$@;2

!ELSEIF  "$(CFG)" == "Win32 Static Debug"

OUTDIR=.
INTDIR=Static_Debug\foo\I386

ALL : "$(INTDIR)" "$(OUTDIR)" DEPENDCHECK $(GENERATED_DIRTY) "$(OUTDIR)\foosd.lib"

DEPEND :
!IF "$(DEPGEN)" == ""
	@echo No suitable dependency generator could be found.
	@echo One comes with MPC, just set the MPC_ROOT environment variable
	@echo to the full path of MPC.  You can download MPC from
	@echo http://www.ociweb.com/products/mpc/down.html
!ELSE
	$(DEPGEN) -D_DEBUG -DWIN32 -D_WINDOWS -f "Makefile.foo.dep" "FooD.cpp" "FooTypeSupportImpl.cpp"
!ENDIF

REALCLEAN : CLEAN
	-@del /f/q "$(OUTDIR)\foosd.lib"
	-@del /f/q "$(OUTDIR)\foosd.exp"
	-@del /f/q "$(OUTDIR)\foosd.ilk"
	-@del /f/q ".\foosd.pdb"
	-@del /f/q "FooTypeSupportImpl.cpp"
	-@del /f/q "FooTypeSupportImpl.h"
	-@del /f/q "FooD.cpp"
	-@del /f/q "FooD.h"
	-@del /f/q "FooD.idl"

"$(INTDIR)" :
	if not exist "Static_Debug\$(NULL)" mkdir "Static_Debug"
	if not exist "Static_Debug\foo\$(NULL)" mkdir "Static_Debug\foo"
	if not exist "$(INTDIR)\$(NULL)" mkdir "$(INTDIR)"

CPP=cl.exe
CPP_COMMON=/Zc:wchar_t /nologo /Ob0 /W3 /Gm /EHsc /Zi /GR /Gy /MDd /Fd".\foosd.pdb" /D _DEBUG /D WIN32 /D _WINDOWS  /c

CPP_PROJ=$(CPP_COMMON) /Fo"$(INTDIR)\\"


LINK32=link.exe -lib
LINK32_FLAGS=/nologo /machine:I386 /out:".\foosd.lib"
LINK32_OBJS= \
	"$(INTDIR)\FooD.obj" \
	"$(INTDIR)\FooTypeSupportImpl.obj"

"$(OUTDIR)\foosd.lib" : $(DEF_FILE) $(LINK32_OBJS)
	$(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<
	if exist "$(OUTDIR)\foosd.lib.manifest" mt.exe -manifest "$(OUTDIR)\foosd.lib.manifest" -outputresource:$@;2

!ELSEIF  "$(CFG)" == "Win32 Static Release"

OUTDIR=.
INTDIR=Static_Release\foo\I386

ALL : "$(INTDIR)" "$(OUTDIR)" DEPENDCHECK $(GENERATED_DIRTY) "$(OUTDIR)\foos.lib"

DEPEND :
!IF "$(DEPGEN)" == ""
	@echo No suitable dependency generator could be found.
	@echo One comes with MPC, just set the MPC_ROOT environment variable
	@echo to the full path of MPC.  You can download MPC from
	@echo http://www.ociweb.com/products/mpc/down.html
!ELSE
	$(DEPGEN) -DNDEBUG -DWIN32 -D_WINDOWS -f "Makefile.foo.dep" "FooD.cpp" "FooTypeSupportImpl.cpp"
!ENDIF

REALCLEAN : CLEAN
	-@del /f/q "$(OUTDIR)\foos.lib"
	-@del /f/q "$(OUTDIR)\foos.exp"
	-@del /f/q "$(OUTDIR)\foos.ilk"
	-@del /f/q "FooTypeSupportImpl.cpp"
	-@del /f/q "FooTypeSupportImpl.h"
	-@del /f/q "FooD.cpp"
	-@del /f/q "FooD.h"
	-@del /f/q "FooD.idl"

"$(INTDIR)" :
	if not exist "Static_Release\$(NULL)" mkdir "Static_Release"
	if not exist "Static_Release\foo\$(NULL)" mkdir "Static_Release\foo"
	if not exist "$(INTDIR)\$(NULL)" mkdir "$(INTDIR)"

CPP=cl.exe
CPP_COMMON=/Zc:wchar_t /nologo /O2 /W3 /EHsc /MD /GR /D NDEBUG /D WIN32 /D _WINDOWS  /c

CPP_PROJ=$(CPP_COMMON) /Fo"$(INTDIR)\\"


LINK32=link.exe -lib
LINK32_FLAGS=/nologo /machine:I386 /out:".\foos.lib"
LINK32_OBJS= \
	"$(INTDIR)\FooD.obj" \
	"$(INTDIR)\FooTypeSupportImpl.obj"

"$(OUTDIR)\foos.lib" : $(DEF_FILE) $(LINK32_OBJS)
	$(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<
	if exist "$(OUTDIR)\foos.lib.manifest" mt.exe -manifest "$(OUTDIR)\foos.lib.manifest" -outputresource:$@;2

!ENDIF

CLEAN :
	-@del /f/s/q "$(INTDIR)"

"$(OUTDIR)" :
	if not exist "$(OUTDIR)\$(NULL)" mkdir "$(OUTDIR)"

.c{$(INTDIR)}.obj::
	$(CPP) @<<
   $(CPP_PROJ) $<
<<

.cpp{$(INTDIR)}.obj::
	$(CPP) @<<
   $(CPP_PROJ) $<
<<

.cxx{$(INTDIR)}.obj::
	$(CPP) @<<
   $(CPP_PROJ) $<
<<

.c{$(INTDIR)}.sbr::
	$(CPP) @<<
   $(CPP_PROJ) $<
<<

.cpp{$(INTDIR)}.sbr::
	$(CPP) @<<
   $(CPP_PROJ) $<
<<

.cxx{$(INTDIR)}.sbr::
	$(CPP) @<<
   $(CPP_PROJ) $<
<<

!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("Makefile.foo.dep")
!INCLUDE "Makefile.foo.dep"
!ENDIF
!ENDIF

!IF "$(CFG)" == "Win32 Debug" || "$(CFG)" == "Win32 Release" || "$(CFG)" == "Win32 Static Debug" || "$(CFG)" == "Win32 Static Release" 
SOURCE="FooD.cpp"

"$(INTDIR)\FooD.obj" : $(SOURCE)
	$(CPP) $(CPP_COMMON) /Fo"$(INTDIR)\FooD.obj" $(SOURCE)

SOURCE="FooTypeSupportImpl.cpp"

"$(INTDIR)\FooTypeSupportImpl.obj" : $(SOURCE)
	$(CPP) $(CPP_COMMON) /Fo"$(INTDIR)\FooTypeSupportImpl.obj" $(SOURCE)

!IF  "$(CFG)" == "Win32 Debug"
SOURCE="Foo.idl"

InputPath=Foo.idl

"FooTypeSupportImpl.cpp" "FooTypeSupportImpl.h" : $(SOURCE)  "dep1"
	<<tempfile-Win32-Debug-typesupport_files-Foo_idl.bat
	@echo off
	perl foo.pl  "$(InputPath)"
<<

SOURCE="Foo.idl"

InputPath=Foo.idl

"FooD.cpp" "FooD.h" "FooD.idl" : $(SOURCE)  "dep2"
	<<tempfile-Win32-Debug-ddsidl_files-Foo_idl.bat
	@echo off
	perl zzz.pl  "$(InputPath)"
<<

!ELSEIF  "$(CFG)" == "Win32 Release"
SOURCE="Foo.idl"

InputPath=Foo.idl

"FooTypeSupportImpl.cpp" "FooTypeSupportImpl.h" : $(SOURCE)  "dep1"
	<<tempfile-Win32-Release-typesupport_files-Foo_idl.bat
	@echo off
	perl foo.pl  "$(InputPath)"
<<

SOURCE="Foo.idl"

InputPath=Foo.idl

"FooD.cpp" "FooD.h" "FooD.idl" : $(SOURCE)  "dep2"
	<<tempfile-Win32-Release-ddsidl_files-Foo_idl.bat
	@echo off
	perl zzz.pl  "$(InputPath)"
<<

!ELSEIF  "$(CFG)" == "Win32 Static Debug"
SOURCE="Foo.idl"

InputPath=Foo.idl

"FooTypeSupportImpl.cpp" "FooTypeSupportImpl.h" : $(SOURCE)  "dep1"
	<<tempfile-Win32-Static_Debug-typesupport_files-Foo_idl.bat
	@echo off
	perl foo.pl  "$(InputPath)"
<<

SOURCE="Foo.idl"

InputPath=Foo.idl

"FooD.cpp" "FooD.h" "FooD.idl" : $(SOURCE)  "dep2"
	<<tempfile-Win32-Static_Debug-ddsidl_files-Foo_idl.bat
	@echo off
	perl zzz.pl  "$(InputPath)"
<<

!ELSEIF  "$(CFG)" == "Win32 Static Release"
SOURCE="Foo.idl"

InputPath=Foo.idl

"FooTypeSupportImpl.cpp" "FooTypeSupportImpl.h" : $(SOURCE)  "dep1"
	<<tempfile-Win32-Static_Release-typesupport_files-Foo_idl.bat
	@echo off
	perl foo.pl  "$(InputPath)"
<<

SOURCE="Foo.idl"

InputPath=Foo.idl

"FooD.cpp" "FooD.h" "FooD.idl" : $(SOURCE)  "dep2"
	<<tempfile-Win32-Static_Release-ddsidl_files-Foo_idl.bat
	@echo off
	perl zzz.pl  "$(InputPath)"
<<

!ENDIF


!ENDIF

GENERATED : "$(INTDIR)" "$(OUTDIR)" $(GENERATED_DIRTY)
	-@rem

DEPENDCHECK :
!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("Makefile.foo.dep")
	@echo Using "Makefile.foo.dep"
!ELSE
	@echo Warning: cannot find "Makefile.foo.dep"
!ENDIF
!ENDIF

