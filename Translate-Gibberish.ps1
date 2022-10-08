<#
    .PARAMETER Dictionary
    The absolute location of the dictionary or it's relative path to the script

    .DESCRIPTION
    This PowerShell script translates english into gibberish using a populated dictionary. 

    .SYNOPSIS
    This script was written in collaboration with my daughter for fun and training. This PowerShell script translates english into gibberish using a populated dictionary. The script will prompt the user for the inag tralation if the word(s) is/are not in the dictionary. The translated pair get updated in an XML file dictionary.

    .PARAMETER Message
    The message to translate into gibberish

    .PARAMETER UpdateWord
    The word to update

    .EXAMPLE
    ./Translate-Gibberish.ps1 -Message 'Hello World!'

    .EXAMPLE
    ./Translate-Gibberish.ps1 -UdpateWord hello:hinagellinago
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateSet("Gibberish","PigLatin",'MadeUp')]
    $Language,

    $Message = "This is a test message using the Gibberish translator!",
    
    $UpdateWord,
    
    [switch]$DebugMode
)
if ($DebugMode) {
    $DebugPreference = "Continue"
}
else {
    $DebugPreference = "SilentlyContinue"
}

if (($Language -eq 'Gibberish') -and (Test-Path "./Gibberish_Dictionary.xml")) {
    $Dictionary =  Import-Clixml "./Gibberish_Dictionary.xml"
}
elseif (($Language -eq 'PigLatin') -and (Test-Path "./PigLatin_Dictionary.xml")) {
    $Dictionary =  Import-Clixml "./PigLatin_Dictionary.xml"
}
elseif (($Language -eq 'MadeUp') -and (Test-Path "./MadeUp_Dictionary.xml")) {
    $Dictionary =  Import-Clixml "./MadeUp_Dictionary.xml"
}
else {
    $Dictionary = @{}
}

if ($UpdateWord) {
    #Update word
    $UpdateKey   = ($UpdateWord -split ':')[0]
    $UpdateValue = ($UpdateWord -split ':')[1]
    $Dictionary[$UpdateKey] = $UpdateValue
    Write-Host ""
    Write-Host "[!] " -NoNewline -ForegroundColor Red
    Write-Host "The word " -NoNewline -ForegroundColor Cyan
    Write-Host "$UpdateKey " -NoNewline -ForegroundColor Yellow
    Write-Host "[" -NoNewline -ForegroundColor Cyan
    Write-Host "$UpdateValue" -NoNewline -ForegroundColor Green
    Write-Host "] was updated within the gibberish dictionary!" -NoNewline -ForegroundColor Cyan
}

$DirtyWords = $Message -split ' '

$PunctuationList = ".,;:!?<>()[]{}\/|_+-='`"".ToCharArray()

$GibberishMessage = @()
$NotInDictionary = @()
$DitionaryPrepEntry = ''

Write-Host ""
Foreach ($Word in $DirtyWords) {
    $WordArray = $Word.ToCharArray()

    #Strips out Beginning Punctuation
    $PunctuationFoundAtStartArray = @()
    if ($WordArray[0] -in $PunctuationList) {    
        Foreach ($char in $WordArray) {
            if ($char -in $PunctuationList){
                $PunctuationFoundAtStartArray += $char
            }
            else {
                break
            }
        }
    }
    $PunctuationFoundAtStart = -join($PunctuationFoundAtStartArray)

    #Strips out Ending Punctuation
    $PunctuationFoundAtEndArray = @()
    [array]::Reverse($WordArray)
    if ($WordArray[0] -in $PunctuationList) {    
        Foreach ($char in $WordArray) {
            if ($char -in $PunctuationList){
                $PunctuationFoundAtEndArray += $char
            }
            else {
                break
            }
        }
    }
    [array]::Reverse($PunctuationFoundAtEndArray)
    $PunctuationFoundAtEnd = -join($PunctuationFoundAtEndArray)


    $CleanWord = $Word.trim(".,;:!?<>()[]{}\/|_+-='`"")

    if ($Dictionary.ContainsKey($CleanWord)) {
        $GibberishMessage += "$PunctuationFoundAtStart$($Dictionary[$CleanWord])$PunctuationFoundAtEnd"
        # $GibberishMessage += $Dictionary[$CleanWord]
        Write-Debug "[ ] In the dictionary: $CleanWord"
    }
    else {
        if ($CleanWord -notin $NotInDictionary) {
            $NotInDictionary += $CleanWord
            Write-Debug "[-] Not in dictionary: $CleanWord"

            Write-Host "[!] " -NoNewline -ForegroundColor Red
            Write-Host "$CleanWord " -NoNewline -ForegroundColor Yellow
            Write-Host "was not in the " -NoNewline -ForegroundColor Cyan  
            Write-Host "$Language " -NoNewline -ForegroundColor Yellow
            Write-Host "language dictionary. Please provide the desired translation" -NoNewline -ForegroundColor Cyan    

            $GibberishTranslation = Read-Host " "
            $Dictionary[$CleanWord] = $GibberishTranslation
        }
    }
}

if ($Language -eq 'Gibberish') {
    $Dictionary | Export-Clixml "./Gibberish_Dictionary.xml"
}
elseif ($Language -eq 'PigLatin') {
    $Dictionary | Export-Clixml "./PigLatin_Dictionary.xml"
}
elseif ($Language -eq 'MadeUp') {
    $Dictionary | Export-Clixml "./MadeUp_Dictionary.xml"
}


# Clear-Host
Write-Host ""
Write-Host "Gibberish... blah blah blah..." -ForegroundColor Green
Write-Host $GibberishMessage

Write-Host ""
Write-Host "The following words are not in the dictionary:" -ForegroundColor Red
Write-Host "Therea are a total of $($NotInDictionary.Count) Words to translate with inag..."
$DitionaryPrepEntry
"`$Dictionary | Export-Clixml ./Gibberish_Dictionary.xml"

#$Translate = Read-Host -Prompt "`r`nTranslating Gibberish back into English...`r`n"
#Write-Host "`r`nTranslating Gibberish back into English...`r`n"
#$GibberishMessage.replace('inag','') -join ' '

