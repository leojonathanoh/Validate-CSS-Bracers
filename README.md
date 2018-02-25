# Validate-CSS-Bracers
This Powershell script helps locate any unmatching bracers in a .css file/string.

## Requirements:
- <a href="https://github.com/PowerShell/PowerShell#get-powershell" target="_blank">Powershell v3</a>
- Windows / *nix environment

## Features
- Works for both minified and non-minified css.

## How to use
`Validate-CSS-Bracers` can be used as a *script* or a *module*.

### As a Script
> This method can only check a single file at a time.

1. Open the <code>Validate-CSS-Bracers.ps1</code> in your favourite text editor and configure scripts settings:

  ```powershell
  # Full Path to css file
  # E.g. For *nix:
  #   $css_file_fullpath = "/path/to/file.css"
  # E.g. For Windows:
  #   $css_file_fullpath = "C:/path/to/file.css"
  $css_file_fullpath = ""

  # Alternatively, paste the css within this here-string (i.e. @' <here> '@)
  # NOTE: This section is used if $css_file_fullpath is empty
  $css_as_string = @'
  html {
      font-size: 10px;
  }
  '@
  ```

2. Run the script:
  - WinNT: Right click on the script in explorer and select <code>Run with Powershell</code>. (should be present on Windows 7 and up). Alternatively, open command prompt in the script directory, and run <code>Powershell .\Validate-CSS-Bracers.ps1</code>
  - *nix: Run <code>powershell ./Validate-CSS-Bracers.ps1</code> or <code>pwsh ./Validate-CSS-Bracers.ps1</code> depending on which version of powershell you're running.

### As a Module
> This method supports checking multiple css files by utilizing pipelining.

1. [Install](https://msdn.microsoft.com/en-us/library/dd878350(v=vs.85).aspx) the `Validate-CSS-Bracers.psm1` module into **any** of the following directories:

    *Windows*
    ```powershell
    %Windir%\System32\WindowsPowerShell\v1.0\Modules

    %UserProfile%\Documents\WindowsPowerShell\Modules

    %ProgramFiles%\WindowsPowerShell\Modules
    ```

    **nix*
    > Note: These may vary between *nix distros. Check `$Env:PSModulePath` inside `Powershell`.

    ```powershell
    ~/.local/share/powershell/Modules

    /usr/local/share/powershell/Modules

    /opt/microsoft/powershell/6.0.0-rc/Modules
    ```

2. Import the module, then pipe the `.css` files into the module:

    ```powershell
    Import-Module Validate-CSS-Bracers

    # You can either Pipe the file/files
    $files | Validate-CSS-Bracers

    # Or use the full Command (for single file)
    Validate-CSS-Bracers -File $css_file_fullpath

    # Or if you're using a CSS string
    Validate-CSS-Bracers -CssAsString $css_as_string
    ```

## Command Line

```powershell
Validate-CSS-Bracers [[-File] <String>] [[-CssAsString] <String>] [[-NearLength] <Int32>] [<CommonParameters>]

PARAMETERS
    -File <String>
        Full Path to css file, accepting input from the pipeline.

        Required?                    false
        Position?                    1
        Default value
        Accept pipeline input?       true (ByValue)
        Accept wildcard characters?  false

    -CssAsString <String>
        CSS as a string.

        Required?                    false
        Position?                    2
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -NearLength <Int32>
        Number of chars to spit out left and right of a found unmatching bracer

        Required?                    false
        Position?                    3
        Default value                0
        Accept pipeline input?       false
        Accept wildcard characters?  false

    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).
```

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