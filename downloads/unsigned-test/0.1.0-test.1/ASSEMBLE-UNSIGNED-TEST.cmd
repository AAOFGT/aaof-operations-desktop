@echo off
setlocal EnableExtensions
cd /d "%~dp0"
set "OUTPUT=AAOF-Operations-Unsigned-Portable-0.1.0-test.1.exe"
set "EXPECTED=6eaef3416ef2cbf8ab7847b52687a49f36019d0434e16bb0396a6c53c4cd4554"
if exist "%OUTPUT%" del /f /q "%OUTPUT%"
copy /b "parts\AAOF-Operations-Unsigned-Portable-0.1.0-test.1.exe.part-00"+"parts\AAOF-Operations-Unsigned-Portable-0.1.0-test.1.exe.part-01"+"parts\AAOF-Operations-Unsigned-Portable-0.1.0-test.1.exe.part-02"+"parts\AAOF-Operations-Unsigned-Portable-0.1.0-test.1.exe.part-03"+"parts\AAOF-Operations-Unsigned-Portable-0.1.0-test.1.exe.part-04"+"parts\AAOF-Operations-Unsigned-Portable-0.1.0-test.1.exe.part-05" "%OUTPUT%" >nul
if errorlevel 1 goto :failed
for /f %%H in ('powershell -NoProfile -Command "(Get-FileHash -Algorithm SHA256 -LiteralPath '%OUTPUT%').Hash.ToLowerInvariant()"') do set "ACTUAL=%%H"
if /i not "%ACTUAL%"=="%EXPECTED%" goto :bad_hash
echo.
echo Verified successfully: %OUTPUT%
echo SHA-256: %ACTUAL%
echo.
echo This file is UNSIGNED and for staff testing only.
echo Windows may show Unknown publisher or SmartScreen warnings.
echo Do not bypass company endpoint-security policy if execution is blocked.
echo.
pause
exit /b 0
:bad_hash
echo ERROR: The reconstructed file failed SHA-256 verification.
echo Expected: %EXPECTED%
echo Actual:   %ACTUAL%
if exist "%OUTPUT%" del /f /q "%OUTPUT%"
pause
exit /b 2
:failed
echo ERROR: Could not reconstruct the portable test executable.
if exist "%OUTPUT%" del /f /q "%OUTPUT%"
pause
exit /b 1
