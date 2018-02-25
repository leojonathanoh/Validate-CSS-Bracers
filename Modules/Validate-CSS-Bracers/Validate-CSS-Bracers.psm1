# Given a css string, returns the line number and position of the found unmatching bracer
# NOTE for @media nested queries:
#     Assumes that when two closing bracers occur consecutively in a @media query, it's the end of the nested css.
#     Hence, if the function finds a unmatching closing bracer after a media query, there is likely to be an extra closing bracer in the nearest preceding media query.'
# Param1: [string]$css
# Param2: [int]$near_length
function Find-Unmatching-bracer($str = '', $near_length = 100) {
    $line = 1
    $error_pos = 0
    $query = ''
    $in_nested = 0
    $bracer_to_find = ''
    $bracer_not_to_find = ''
    for($i=0; $i -lt $str.length; $i++) {
        if ($str[$i] -match "`n") {
            $line++
        }
        if ($bracer_not_to_find) {
            if ($str[$i] -eq $bracer_not_to_find) {
                if ($in_nested) {
                    $in_nested = 0
                    Write-Host "End of nested css." -ForegroundColor Cyan
                    continue
                }
                Write-Host "Found unmatching bracer @line $line and position $i. bracer_to_find: '$bracer_to_find', bracer_not_to_find: '$bracer_not_to_find'`n`tNear:`n " -ForegroundColor Yellow
                Write-Host "$( $($str[($i-$near_length)..($i-1)]) -join '' )" -NoNewline
                Write-Host "$( $($str[$i]) -join '' )" -ForegroundColor Red -NoNewline
                Write-Host "$( $($str[($i+1)..($i+$near_length)]) -join '' )"
                $error_pos = $i
                break
            }else {
                #Write-Host "Looking. At pos: $i"
            }
        }
        if ($str[$i] -eq '{') {
            if ($query -match '@media') {
                Write-Host "In nested css @line $line,  Query:`n" -ForegroundColor Cyan
                Write-Host "$($query.trim())" -ForegroundColor White
                $in_nested = 1
                $query = ''
                continue
            }
            $bracer_to_find = '}'
            $bracer_not_to_find = '{'
        }
        if ($str[$i] -eq '}') {
            $query = ''
            $bracer_to_find = '{'
            $bracer_not_to_find = '}'
        }

        if ($str[$i] -eq '{' -or $str[$i] -eq '}') {
            if ($str[$i] -eq '{') {
                #Write-Host "query: $($query.trim())"
                $query = ''
            }
        }else {
            $query += $str[$i]
        }
    }

    if (!$error_pos) {
         if ($in_nested) {
            Write-Host "End of nested css. Line $line"
        }
    }
    $line, $error_pos
}


#  Validate-CSS-Bracers Cmdlet
function Validate-CSS-Bracers {
    <#
    .SYNOPSIS
    This Powershell script helps locate any unmatching bracers in a .css file/string.

    .PARAMETER File
    Full Path to css file, accepting input from the pipeline.

    .PARAMETER CssAsString
    CSS as a string.

    .PARAMETER NearLength
    Number of chars to spit out left and right of a found unmatching bracer

    .EXAMPLE
    Validate-CSS-Bracers $css_file_fullpath

    .EXAMPLE
    Validate-CSS-Bracers -File $css_file_fullpath -NearLength 100

    .EXAMPLE
    Validate-CSS-Bracers -CssAsString $css_as_string -NearLength 100
    #>
    
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [string]$File
    ,
        [alias("s")]
        [string]$CssAsString
    ,
        [alias("n")]
        [int]$NearLength
    )

    begin {
        # Use Caller Error action if specified
        $CallerEA = $ErrorActionPreference
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            # Get the css as a string
            if ($File) {
                $css = Get-Content $File -raw -ErrorAction Stop
                Write-Host "Got css from file: $File" -ForegroundColor Cyan
            }elseif($CssAsString) {
                $css =  $CssAsString
                Write-Host "Got css from declared string." -ForegroundColor Cyan
            }else {
                Write-Error "No file or css string specified." -ErrorAction Stop
            }

            # Warn if there's already a unmatch number of bracers
            $bracer_open_cnt = $css.split('{').count
            $bracer_close_cnt = $css.split('}').count
            Write-Host "`n[Css Information] `n Length: $($css.length) `n '{' count: $bracer_open_cnt `n '}' count: $bracer_close_cnt" -ForegroundColor Cyan
            if ($bracer_open_cnt -ne $bracer_close_cnt) {
                Write-Host "Warning: Curly bracer counts do not match." -ForegroundColor Yellow
            }

            # Check the css for unmatching bracers
            Write-Host "`n[Checking css]" -ForegroundColor Cyan
            $line, $error_pos = Find-Unmatching-bracer $css $near_length
            if ($error_pos -gt 0) {
                Write-Host "`nDone with errors." -ForegroundColor Yellow
            }else {
                Write-Host "`nDone. No errors." -ForegroundColor Green
            }
        }catch {
            Write-Error -ErrorRecord $_ -ErrorAction $callerEA
        }
    }
}


Export-ModuleMember -Function Validate-CSS-Bracers