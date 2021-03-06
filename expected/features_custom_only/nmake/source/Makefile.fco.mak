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
!MESSAGE NMAKE /f "Makefile.fco.mak" CFG="Win32 Debug"
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

GENERATED_DIRTY = "zar_thatA.cpp" "zar_thatA.h" "zar_thatA.inl" "zar_thatB.cpp" "zar_thatB.h" "zar_thatB.inl" "zar_thatC.cpp" "zar_thatC.h" "zar_thisA.cpp" "zar_thisA.h" "zar_thisA.inl" "zar_thisB.cpp" "zar_thisB.h" "zar_thisB.inl" "zar_thisB_T.cpp" "zar_thisB_T.h" "zar_thisB_T.inl" "zar_thisC.cpp" "zar_thisC.h"

!IF  "$(CFG)" == "Win32 Debug"

OUTDIR=.
INTDIR=Debug\fco\I386

ALL : "$(INTDIR)" "$(OUTDIR)" DEPENDCHECK $(GENERATED_DIRTY)

DEPEND :
!IF "$(DEPGEN)" == ""
	@echo No suitable dependency generator could be found.
	@echo One comes with MPC, just set the MPC_ROOT environment variable
	@echo to the full path of MPC.  You can download MPC from
	@echo http://www.ociweb.com/products/mpc/down.html
!ELSE
	-@rem
!ENDIF

REALCLEAN : CLEAN
	-@del /f/q "$(OUTDIR)\d.lib"
	-@del /f/q "$(OUTDIR)\d.exp"
	-@del /f/q "$(OUTDIR)\d.ilk"
	-@del /f/q "zar_thatA.cpp"
	-@del /f/q "zar_thatA.h"
	-@del /f/q "zar_thatA.inl"
	-@del /f/q "zar_thatB.cpp"
	-@del /f/q "zar_thatB.h"
	-@del /f/q "zar_thatB.inl"
	-@del /f/q "zar_thatC.cpp"
	-@del /f/q "zar_thatC.h"
	-@del /f/q "zar_thisA.cpp"
	-@del /f/q "zar_thisA.h"
	-@del /f/q "zar_thisA.inl"
	-@del /f/q "zar_thisB.cpp"
	-@del /f/q "zar_thisB.h"
	-@del /f/q "zar_thisB.inl"
	-@del /f/q "zar_thisB_T.cpp"
	-@del /f/q "zar_thisB_T.h"
	-@del /f/q "zar_thisB_T.inl"
	-@del /f/q "zar_thisC.cpp"
	-@del /f/q "zar_thisC.h"

"$(INTDIR)" :
	if not exist "Debug\$(NULL)" mkdir "Debug"
	if not exist "Debug\fco\$(NULL)" mkdir "Debug\fco"
	if not exist "$(INTDIR)\$(NULL)" mkdir "$(INTDIR)"

CPP=cl.exe
CPP_COMMON=/Zc:wchar_t /nologo /Ob0 /W3 /Gm /EHsc /Zi /MDd /GR /Gy /Fd"$(INTDIR)/" /D _DEBUG /D WIN32 /D _WINDOWS  /c

CPP_PROJ=$(CPP_COMMON) /Fo"$(INTDIR)\\"

RSC=rc.exe


!ELSEIF  "$(CFG)" == "Win32 Release"

OUTDIR=.
INTDIR=Release\fco\I386

ALL : "$(INTDIR)" "$(OUTDIR)" DEPENDCHECK $(GENERATED_DIRTY)

DEPEND :
!IF "$(DEPGEN)" == ""
	@echo No suitable dependency generator could be found.
	@echo One comes with MPC, just set the MPC_ROOT environment variable
	@echo to the full path of MPC.  You can download MPC from
	@echo http://www.ociweb.com/products/mpc/down.html
!ELSE
	-@rem
!ENDIF

REALCLEAN : CLEAN
	-@del /f/q "$(OUTDIR)\.lib"
	-@del /f/q "$(OUTDIR)\.exp"
	-@del /f/q "$(OUTDIR)\.ilk"
	-@del /f/q "zar_thatA.cpp"
	-@del /f/q "zar_thatA.h"
	-@del /f/q "zar_thatA.inl"
	-@del /f/q "zar_thatB.cpp"
	-@del /f/q "zar_thatB.h"
	-@del /f/q "zar_thatB.inl"
	-@del /f/q "zar_thatC.cpp"
	-@del /f/q "zar_thatC.h"
	-@del /f/q "zar_thisA.cpp"
	-@del /f/q "zar_thisA.h"
	-@del /f/q "zar_thisA.inl"
	-@del /f/q "zar_thisB.cpp"
	-@del /f/q "zar_thisB.h"
	-@del /f/q "zar_thisB.inl"
	-@del /f/q "zar_thisB_T.cpp"
	-@del /f/q "zar_thisB_T.h"
	-@del /f/q "zar_thisB_T.inl"
	-@del /f/q "zar_thisC.cpp"
	-@del /f/q "zar_thisC.h"

"$(INTDIR)" :
	if not exist "Release\$(NULL)" mkdir "Release"
	if not exist "Release\fco\$(NULL)" mkdir "Release\fco"
	if not exist "$(INTDIR)\$(NULL)" mkdir "$(INTDIR)"

CPP=cl.exe
CPP_COMMON=/Zc:wchar_t /nologo /O2 /W3 /EHsc /MD /GR /D NDEBUG /D WIN32 /D _WINDOWS  /c

CPP_PROJ=$(CPP_COMMON) /Fo"$(INTDIR)\\"

RSC=rc.exe


!ELSEIF  "$(CFG)" == "Win32 Static Debug"

OUTDIR=.
INTDIR=Static_Debug\fco\I386

ALL : "$(INTDIR)" "$(OUTDIR)" DEPENDCHECK $(GENERATED_DIRTY)

DEPEND :
!IF "$(DEPGEN)" == ""
	@echo No suitable dependency generator could be found.
	@echo One comes with MPC, just set the MPC_ROOT environment variable
	@echo to the full path of MPC.  You can download MPC from
	@echo http://www.ociweb.com/products/mpc/down.html
!ELSE
	-@rem
!ENDIF

REALCLEAN : CLEAN
	-@del /f/q ".\sd.pdb"
	-@del /f/q "zar_thatA.cpp"
	-@del /f/q "zar_thatA.h"
	-@del /f/q "zar_thatA.inl"
	-@del /f/q "zar_thatB.cpp"
	-@del /f/q "zar_thatB.h"
	-@del /f/q "zar_thatB.inl"
	-@del /f/q "zar_thatC.cpp"
	-@del /f/q "zar_thatC.h"
	-@del /f/q "zar_thisA.cpp"
	-@del /f/q "zar_thisA.h"
	-@del /f/q "zar_thisA.inl"
	-@del /f/q "zar_thisB.cpp"
	-@del /f/q "zar_thisB.h"
	-@del /f/q "zar_thisB.inl"
	-@del /f/q "zar_thisB_T.cpp"
	-@del /f/q "zar_thisB_T.h"
	-@del /f/q "zar_thisB_T.inl"
	-@del /f/q "zar_thisC.cpp"
	-@del /f/q "zar_thisC.h"

"$(INTDIR)" :
	if not exist "Static_Debug\$(NULL)" mkdir "Static_Debug"
	if not exist "Static_Debug\fco\$(NULL)" mkdir "Static_Debug\fco"
	if not exist "$(INTDIR)\$(NULL)" mkdir "$(INTDIR)"

CPP=cl.exe
CPP_COMMON=/Zc:wchar_t /nologo /Ob0 /W3 /Gm /EHsc /Zi /GR /Gy /MDd /Fd".\sd.pdb" /D _DEBUG /D WIN32 /D _WINDOWS  /c

CPP_PROJ=$(CPP_COMMON) /Fo"$(INTDIR)\\"



!ELSEIF  "$(CFG)" == "Win32 Static Release"

OUTDIR=.
INTDIR=Static_Release\fco\I386

ALL : "$(INTDIR)" "$(OUTDIR)" DEPENDCHECK $(GENERATED_DIRTY)

DEPEND :
!IF "$(DEPGEN)" == ""
	@echo No suitable dependency generator could be found.
	@echo One comes with MPC, just set the MPC_ROOT environment variable
	@echo to the full path of MPC.  You can download MPC from
	@echo http://www.ociweb.com/products/mpc/down.html
!ELSE
	-@rem
!ENDIF

REALCLEAN : CLEAN
	-@del /f/q "zar_thatA.cpp"
	-@del /f/q "zar_thatA.h"
	-@del /f/q "zar_thatA.inl"
	-@del /f/q "zar_thatB.cpp"
	-@del /f/q "zar_thatB.h"
	-@del /f/q "zar_thatB.inl"
	-@del /f/q "zar_thatC.cpp"
	-@del /f/q "zar_thatC.h"
	-@del /f/q "zar_thisA.cpp"
	-@del /f/q "zar_thisA.h"
	-@del /f/q "zar_thisA.inl"
	-@del /f/q "zar_thisB.cpp"
	-@del /f/q "zar_thisB.h"
	-@del /f/q "zar_thisB.inl"
	-@del /f/q "zar_thisB_T.cpp"
	-@del /f/q "zar_thisB_T.h"
	-@del /f/q "zar_thisB_T.inl"
	-@del /f/q "zar_thisC.cpp"
	-@del /f/q "zar_thisC.h"

"$(INTDIR)" :
	if not exist "Static_Release\$(NULL)" mkdir "Static_Release"
	if not exist "Static_Release\fco\$(NULL)" mkdir "Static_Release\fco"
	if not exist "$(INTDIR)\$(NULL)" mkdir "$(INTDIR)"

CPP=cl.exe
CPP_COMMON=/Zc:wchar_t /nologo /O2 /W3 /EHsc /MD /GR /D NDEBUG /D WIN32 /D _WINDOWS  /c

CPP_PROJ=$(CPP_COMMON) /Fo"$(INTDIR)\\"



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
!IF EXISTS("Makefile.fco.dep")
!INCLUDE "Makefile.fco.dep"
!ENDIF
!ENDIF

!IF "$(CFG)" == "Win32 Debug" || "$(CFG)" == "Win32 Release" || "$(CFG)" == "Win32 Static Debug" || "$(CFG)" == "Win32 Static Release" 
!IF  "$(CFG)" == "Win32 Debug"
SOURCE="that.zar"

InputPath=that.zar

"zar_thatA.cpp" "zar_thatA.h" "zar_thatA.inl" "zar_thatB.cpp" "zar_thatB.h" "zar_thatB.inl" "zar_thatC.cpp" "zar_thatC.h" : $(SOURCE) 
	<<tempfile-Win32-Debug-zar_files-that_zar.bat
	@echo off
	perl ..\bin\exercise.pl $(CLO_ZARFLAGS) -GA -Sc "$(InputPath)"
<<

SOURCE="this.zar"

InputPath=this.zar

"zar_thisA.cpp" "zar_thisA.h" "zar_thisA.inl" "zar_thisB.cpp" "zar_thisB.h" "zar_thisB.inl" "zar_thisB_T.cpp" "zar_thisB_T.h" "zar_thisB_T.inl" "zar_thisC.cpp" "zar_thisC.h" : $(SOURCE) 
	<<tempfile-Win32-Debug-zar_files-this_zar.bat
	@echo off
	perl ..\bin\exercise.pl $(CLO_ZARFLAGS) -GA "$(InputPath)"
<<

!ELSEIF  "$(CFG)" == "Win32 Release"
SOURCE="that.zar"

InputPath=that.zar

"zar_thatA.cpp" "zar_thatA.h" "zar_thatA.inl" "zar_thatB.cpp" "zar_thatB.h" "zar_thatB.inl" "zar_thatC.cpp" "zar_thatC.h" : $(SOURCE) 
	<<tempfile-Win32-Release-zar_files-that_zar.bat
	@echo off
	perl ..\bin\exercise.pl $(CLO_ZARFLAGS) -GA -Sc "$(InputPath)"
<<

SOURCE="this.zar"

InputPath=this.zar

"zar_thisA.cpp" "zar_thisA.h" "zar_thisA.inl" "zar_thisB.cpp" "zar_thisB.h" "zar_thisB.inl" "zar_thisB_T.cpp" "zar_thisB_T.h" "zar_thisB_T.inl" "zar_thisC.cpp" "zar_thisC.h" : $(SOURCE) 
	<<tempfile-Win32-Release-zar_files-this_zar.bat
	@echo off
	perl ..\bin\exercise.pl $(CLO_ZARFLAGS) -GA "$(InputPath)"
<<

!ELSEIF  "$(CFG)" == "Win32 Static Debug"
SOURCE="that.zar"

InputPath=that.zar

"zar_thatA.cpp" "zar_thatA.h" "zar_thatA.inl" "zar_thatB.cpp" "zar_thatB.h" "zar_thatB.inl" "zar_thatC.cpp" "zar_thatC.h" : $(SOURCE) 
	<<tempfile-Win32-Static_Debug-zar_files-that_zar.bat
	@echo off
	perl ..\bin\exercise.pl $(CLO_ZARFLAGS) -GA -Sc "$(InputPath)"
<<

SOURCE="this.zar"

InputPath=this.zar

"zar_thisA.cpp" "zar_thisA.h" "zar_thisA.inl" "zar_thisB.cpp" "zar_thisB.h" "zar_thisB.inl" "zar_thisB_T.cpp" "zar_thisB_T.h" "zar_thisB_T.inl" "zar_thisC.cpp" "zar_thisC.h" : $(SOURCE) 
	<<tempfile-Win32-Static_Debug-zar_files-this_zar.bat
	@echo off
	perl ..\bin\exercise.pl $(CLO_ZARFLAGS) -GA "$(InputPath)"
<<

!ELSEIF  "$(CFG)" == "Win32 Static Release"
SOURCE="that.zar"

InputPath=that.zar

"zar_thatA.cpp" "zar_thatA.h" "zar_thatA.inl" "zar_thatB.cpp" "zar_thatB.h" "zar_thatB.inl" "zar_thatC.cpp" "zar_thatC.h" : $(SOURCE) 
	<<tempfile-Win32-Static_Release-zar_files-that_zar.bat
	@echo off
	perl ..\bin\exercise.pl $(CLO_ZARFLAGS) -GA -Sc "$(InputPath)"
<<

SOURCE="this.zar"

InputPath=this.zar

"zar_thisA.cpp" "zar_thisA.h" "zar_thisA.inl" "zar_thisB.cpp" "zar_thisB.h" "zar_thisB.inl" "zar_thisB_T.cpp" "zar_thisB_T.h" "zar_thisB_T.inl" "zar_thisC.cpp" "zar_thisC.h" : $(SOURCE) 
	<<tempfile-Win32-Static_Release-zar_files-this_zar.bat
	@echo off
	perl ..\bin\exercise.pl $(CLO_ZARFLAGS) -GA "$(InputPath)"
<<

!ENDIF


!ENDIF

GENERATED : "$(INTDIR)" "$(OUTDIR)" $(GENERATED_DIRTY)
	-@rem

DEPENDCHECK :
!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("Makefile.fco.dep")
	@echo Using "Makefile.fco.dep"
!ENDIF
!ENDIF

