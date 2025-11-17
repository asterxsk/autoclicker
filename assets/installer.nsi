; --- AutoClicker OFFLINE Installer Script ---
; This script bundles the app. It does not download anything.

; --- 1. Basic Information ---
!define AppName "Autoclicker"
!define AppDisplayName "asterxsk's autoclicker"
!define CompanyName "asterxsk"
!define ExeName "AutoClicker.exe"
!define Version "1.0"

; Installer name
OutFile "autoclicker_setup.exe" ; Renamed to avoid confusion
Name "${AppDisplayName}"

; Set the installer's .exe icon
!define MUI_ICON "setup_icon.ico"
!define MUI_UNICON "setup_icon.ico"

; Default installation directory to user's local app data
InstallDir "$LOCALAPPDATA\${CompanyName}\${AppName}"

; Request user-level privileges, not admin
RequestExecutionLevel user

; --- 2. Included Libraries ---
!include "MUI2.nsh"
!include "LogicLib.nsh"

; --- 3. Interface Settings ---
!define MUI_ABORTWARNING
!define MUI_WELCOMEFINISHPAGE_BITMAP "wizard_image.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "wizard_image.bmp"

; --- 4. Installer Pages ---
!define MUI_WELCOMEPAGE_TEXT "Welcome to the ${AppDisplayName} Setup Wizard.$\r$\n$\r$\nThis wizard will guide you through the installation of ${AppDisplayName}."
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "license.txt"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!define MUI_FINISHPAGE_RUN "$INSTDIR\${ExeName}"
!define MUI_FINISHPAGE_RUN_TEXT "Run ${AppDisplayName}"
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; --- 5. Language ---
!insertmacro MUI_LANGUAGE "English"


; --- 6. Installation Section ---
Section "Install"
  
  SetOutPath $INSTDIR
  CreateDirectory $INSTDIR

  ; --- THIS IS THE FIX ---
  ; This command packs your .exe file *inside* the installer.
  ; Your "AutoClicker.exe" must be in the same folder as this .nsi script.
  File "${ExeName}"
  
  ; --- Post-Install Setup ---
  StrCpy $R0 "$SMPROGRAMS"  
  StrCpy $R0 "$R0\${CompanyName}"
  CreateDirectory $R0
  CreateShortCut "$R0\${AppName}.lnk" "$INSTDIR\${ExeName}"
  
  WriteUninstaller "$INSTDIR\uninstall.exe"
  
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${CompanyName} ${AppName}" "DisplayName" "${AppDisplayName}"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${CompanyName} ${AppName}" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${CompanyName} ${AppName}" "DisplayVersion" "${Version}"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${CompanyName} ${AppName}" "Publisher" "${CompanyName}"
  
SectionEnd

; --- 7. Uninstaller Section ---
Section "Uninstall"

  Delete "$INSTDIR\${ExeName}"
  Delete "$INSTDIR\uninstall.exe"
  
  StrCpy $R0 "$SMPROGRAMS"
  StrCpy $R0 "$R0\${CompanyName}"
  Delete "$R0\${AppName}.lnk"
  
  RMDir $R0
  RMDir "$INSTDIR"
  
  DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${CompanyName} ${AppName}"

SectionEnd