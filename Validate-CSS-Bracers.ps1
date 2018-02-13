################# Configure script settings #################
# Full Path to css file
# E.g. For *nix:
#   $css_file_fullpath = "/path/to/file.css"
# E.g. For Windows:
#   $css_file_fullpath = "C:/path/to/file.css"
$css_file_fullpath = ""

# Alternatively, paste the css within this here-string (i.e. @' <here> '@)
# NOTE: This section is used if $css_file_fullpath is empty
$css_string = @'
* {
    box-sizing: border-box;
}
html {
    font-size: 10px;
}
'@

# Number of chars to spit out left and right of a found unmatching bracer
$near_length = 100

# Debug - Examples of bad css
# NOTE: do not use.
#$css_string = '*{box-sizing: border-box;}html}'
#$css_string = '*{box-sizing: border-box;}html{font-size: 10px;}@media all and (min-width: 400px) { body {}} }'
#############################################################


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


# Get the css as a string
if ($css_file_fullpath) {
    $css = Get-Content $css_file_fullpath -raw -ErrorAction Stop
    Write-Host "Got css from file: $css_file_fullpath" -ForegroundColor Cyan
}elseif($css_string) {
    $css =  $css_string
    Write-Host "Got css from declared string." -ForegroundColor Cyan
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