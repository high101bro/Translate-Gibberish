<#
    .PARAMETER Dictionary
    The absolute location of the dictionary or it's relative path to the script

    .PARAMETER Message
    The message to translate into gibberish

    .PARAMETER UpdateWord
    The word to update

    .EXAMPLE
    ./Translate-Gibberish.ps1 -UdpateWord hello:hinagellinago

#>
[CmdletBinding()]
param(
    $Dictionary = "./Gibberish_Dictionary.xml",
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

$Dictionary =  Import-Clixml $Dictionary

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
            Write-Host "was not in the gibberish dictionary. Please provide the [" -NoNewline -ForegroundColor Cyan
            Write-Host "inag" -NoNewline -ForegroundColor Yellow
            Write-Host "] translation" -NoNewline -ForegroundColor Cyan
            $GibberishTranslation = Read-Host " "
            $Dictionary[$CleanWord] = $GibberishTranslation
        }
    }
}

$Dictionary | Export-Clixml ./Gibberish_Dictionary.xml

# Clear-Host
Write-Host ""
Write-Host "Gibberish... blah blah blah..." -ForegroundColor Green
Write-Host $GibberishMessage

Write-Host ""
Write-Host "The following words are not in the dictionary:" -ForegroundColor Red
Write-Host "Therea are a total of $($NotInDictionary.Count) Words to translate with inag..."
$DitionaryPrepEntry
"`$Dictionary | Export-Clixml ./Gibberish_Dictionary.xml"
<#
$Dictionary["Mom"] = "Minagom"
$Dictionary["need"] = "ninageed"
$Dictionary["sentence"] = "sinagentinagence"
$Dictionary["here"] = "hinagere"
$Dictionary["Pretty"] = "Prinagettinagy"
$Dictionary["please"] = "plinagease"
$Dictionary["sugar"] = "sinaguginagar"
$Dictionary["top"] = "tinagop"

$Dictionary | Export-Clixml ./Gibberish_Dictionary.xml
#>
$Dictionary | Export-Clixml ./Gibberish_Dictionary.xml

#$Translate = Read-Host -Prompt "`r`nTranslating Gibberish back into English...`r`n"
Write-Host "`r`nTranslating Gibberish back into English...`r`n"
$GibberishMessage.replace('inag','') -join ' '




<#

$a = @"
rock - et __________ __________
dinn - er __________ __________
lum - ber __________ __________
hamm - er __________ __________
catt - le __________ __________
pan - ther __________ __________
ratt - le __________ __________
chick - en __________ __________
robb - er __________ __________
mar - ble __________ __________
han - dle __________ __________
jack - et __________ __________
can - dy __________ __________
litt - le __________ __________
pupp - et __________ __________
tem - per __________ __________
num - ber __________ __________
free - zer __________ __________
vall - ey __________ __________
Thurs - day __________ __________
mon - ster __________ __________
tar - get __________ __________
far - mer __________ __________
can - dle __________ __________
musk - rat __________ __________
con - tact __________ __________
co - met __________ __________
ha - bit __________ __________
ba - sket __________ __________
trum - pet __________ __________
fi - nish __________ __________
sham - poo __________ __________
aw - ful __________ __________
cam - per __________ __________
chap - ter __________ __________
fol - der __________ __________
li - ver __________ __________
scoo - ter __________ __________
show - er __________ __________
hur - dle __________ __________
con - vince __________ __________
holl - ow __________ __________
coff - ee __________ __________
li - zard __________ __________
sur - prise __________ __________
quar - ter __________ __________
sher - iff __________ __________
hun - ger __________ __________
fa - sten __________ __________
badg - er __________ __________
mu - stard __________ __________
whi - stle __________ __________
ho - ney __________ __________
crow - ded __________ __________
blizz - ard __________ __________
ex - plain __________ __________
mi - stake __________ __________
wai - tress __________ __________
bubb - ly __________ __________
chill - y __________ __________
com - plete __________ __________
con - crete __________ __________
co - py __________ __________
dizz - y __________ __________
high - est __________ __________
in - vite __________ __________
supp - er __________ __________
ex - plode __________ __________
hope - less __________ __________
re - pair __________ __________
en - joy __________ __________
laun - dry __________ __________
dir - ect __________ __________
clo - ver __________ __________
ligh - ter __________ __________
thir - sty __________ __________
trai - ler __________ __________
part - ly __________ __________
cherr - y __________ __________
rai - ling __________ __________
stock - ing __________ __________
ma - gic __________ __________
ex - cept __________ __________
la - zy __________ __________
pre - pare
"@

$b=$a.split("`r`n").trim('_ ').replace(' ','')

$SyllableWords = $b | where {$_ -ne ''}

$AlphabetConsonants = 'bcdfghjklmnpqrstvwxyz'.ToCharArray()
$AlphabetVowels     = 'aeiou'.ToCharArray()

Foreach ($Word in $SyllableWords) {
    # Splits words into individual Syllables
    $Syllables = $Word.split('-')
    #$Syllables -join ''

    # Placeholder for the Gibberish word as its being tranlated
    $GibberishWord = ''

    # Rules for Gibberish
    Foreach ($Syllable in $Syllables) {
        if ($Syllable[0] -in $AlphabetConsonants) {
            $FirstLetter    = $Syllable[0]
            $SecondThruLast = $Syllable[1..$($Syllable.length -1)] -join ''

#            if (){}
#            elseif (){}
#            elseif (){}
#            elseif (){}
#            elseif (){}
            $GibberishWord += "$($FirstLetter)inag$($SecondThruLast)"
        }
        elseif ($Syllable[0] -in $AlphabetVowels) {
            $GibberishWord += "inag$($Syllable)"
        }
    }
    $GibberishWord
    "======================"

#    if (-not ($Dictionary.ContainsKey($word))) {
#    }
}


$ProgressPreference = 'SilentlyContinue'
$word = 'technology'
#$InternetLookup = Invoke-WebRequest "https://www.howmanysyllables.com/words/technology/technology"
$response = Invoke-WebRequest -Uri 'https://www.howmanysyllables.com/' -SessionVariable rb
$form = $response.Forms[0]
$form.Fields["SearchQueryForm"] = "technology"
$response = Invoke-WebRequest -Uri $form.Action -WebSession $rb -Method POST

#>
#<input type="text" id="SearchQuery_TextBox" name="SearchQuery_FromUser" value="Search Dictionary" onfocus="inputFocus(this)" onblur="inputBlur(this)">
