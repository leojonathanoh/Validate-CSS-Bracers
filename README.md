# Validate-CSS-Bracers
This Powershell script helps locate any unmatching bracers in a .css file/string.

## Requirements:
- <a href="https://github.com/PowerShell/PowerShell#get-powershell" target="_blank">Powershell v3</a>
- Windows / *nix environment

## Features
- Works for both minified and non-minified css.

## Installation/usage:
- Open the <code>Validate-CSS-Bracers.ps1</code> in your favourite text editor and configure scripts settings
- WinNT:
  - Right click on the script in explorer and select <code>Run with Powershell</code>. (should be present on Windows 7 and up)
  - Alternatively, open command prompt in the script directory, and run <code>Powershell .\Validate-CSS-Bracers.ps1</code>
- *nix:
  - Run <code>powershell ./Validate-CSS-Bracers.ps1</code> or <code>pwsh ./Validate-CSS-Bracers.ps1</code> depending on which version of powershell you're running.
  
## FAQ

### WinNT
Q: Help! I am getting an error <code>'File C:\...Validate-CSS-Bracers.ps1 cannot be loaded because the execution of scripts is disabled on this system. Please see "get-help about_signing" for more details.'</code>
- You need to allow the execution of unverified scripts. Open Powershell as administrator, type <code>Set-ExecutionPolicy Unrestricted -Force</code> and press ENTER. Try running the script again. You can easily restore the security setting back by using <code>Set-ExecutionPolicy Undefined -Force</code>.

Q: Help! Upon running the script I am getting an error <code>File C:\...Validate-CSS-Bracers.ps1 cannot be loaded. The file 
C:\...\Validate-CSS-Bracers.ps1 is not digitally signed. You cannot run 
this script on the current system. For more information about running scripts and setting 
execution policy, see about_Execution_Policies at http://go.microsoft.com/fwlink/?LinkID=135170.</code>
- You need to allow the execution of unverified scripts. Open Powershell as administrator, type <code>Set-ExecutionPolicy Unrestricted -Force</code> and press ENTER. Try running the script again. You can easily restore the security setting back by using <code>Set-ExecutionPolicy Undefined -Force</code>.

Q: Help! Upon running the script I am getting a warning <code>'Execution Policy change. The execution policy helps protect you from scripts that you do not trust. Changing the execution policy might expose you to the security risks described in the about_Execution_Policies help topic at http://go.microsoft.com/?LinkID=135170. Do you want to change the execution policy?</code>
- You need to allow the execution of unverified scripts. Type <code>Y</code> for yes and press enter. You can easily restore the security setting back opening Powershell as administrator, and using the code <code>Set-ExecutionPolicy Undefined -Force</code>.

### *nix
Nil

## Known issues
Nil

## Background:
- Every web developer knows that when a page is suddenly broken, it's a css unmatching bracer. The cause of the problem becomes more obscure for minified css files. The script can help developers find those unmatching bracers and fix their css. It works for both minified and non-minified css.