# Written By: Meghan Augusta
# Last Updated - 10/18/2023

# BASIC DESCRIPTION:
#
# A script to randomly generate passwords using a 3 words, a number and a special character.


# ==========================================================================================================
# Declared Variables, Initial directory change, Verify CSV Dictonary is present.
#
# $PWLENGTH defines the required password length before a number is added to the password
# $NUMRANGE defines the range of numbers that can be selected from to generate a random number for the password
# $EXCLUDEDNUMS defines any numbers you may not want to use in passwords for any reason.
# $PATH gets the location the script is saved because the words.csv file should be saved in the same dirctory.
# SPECCHAR is a predefined list of acceptable special characters to be added to the password.

$PWLENGTH = 12
$NUMRANGE = 10..99
$EXCLUDEDNUMS = 66,69
$SPECCHAR=’!’,’@’,’#’,’+’,’-’,’=’,’?’,"_"
$DISCLAIMER = Get-Content .\GPLDisclaimer.txt

$PATH = split-path -parent $MyInvocation.MyCommand.Definition
CD $PATH

CLS

Write-Host "=========================================================================================="
Write-Host ""
Write-Host "This script is releaseed under the The GNU General Public License Version 3." -ForegroundColor Yellow
Write-Host "You can find the licnese at: https://www.gnu.org/licenses/gpl-3.0.en.html" -ForegroundColor Yellow
Write-Host ""
Write-Host "IMPORTANT:" -ForegroundColor Red -BackgroundColor Black
Write-Host ""
Write-Host $DISCLAIMER -BackgroundColor Black
Write-Host ""
Write-Host ""
Write-Host "=========================================================================================="
Write-Host ""
Write-Host "If you accept the warranty disclaimer press any key and a password will be generated." -ForegroundColor Yellow
Read-Host

CLS

# ==========================================================================================================
 
 
# The first do loop repeats until it gets three random words from the words.csv that when concatenated 
# together without spaces equals $PWLENGTH which is defined at the begining of the script.
# If you don't want to limit the randomly generated password length to exactly $PWLENGTH 
# you can change -eq to -ge.

# ==========================================================================================================

Do{

$RANDOM = Import-Csv Dictonary.csv | Get-Random -Count 3 | Select-Object -ExpandProperty WORD
$RANDOM = (Get-Culture).TextInfo.ToTitleCase($RANDOM)


$PASSWORD = ""

Foreach($WORD in $RANDOM)
{
$PASSWORD = $PASSWORD + $WORD.ToString()
}

$PASSWORD = $PASSWORD -replace " "

}Until ($PASSWORD.Length -eq $PWLENGTH)


#==========================================================================================================

# The next potion of the script generates a random number to append to the end of the password using 
# constraints defined by $NUMRANGE and $EXCLUDEDNUMS to allow easy expansion/change to the requirements.

#==========================================================================================================


$RANDOMRANGE = $NUMRANGE | Where-Object { $EXCLUDEDNUMS -notcontains $_ }

$NUMBER = Get-Random -InputObject $RANDOMRANGE
$NUMBER = $NUMBER.ToString()

$PASSWORD = $PASSWORD + $NUMBER

#==========================================================================================================

# The next potion of the script selects a special character and adds it to begining or end based on get-random

#==========================================================================================================
$CHAR = ""
$CHAR = Get-Random -InputObject $SPECCHAR

$WHERE = Get-Random -Minimum 1 -Maximum 2

if($WHERE -eq 1) {
$PASSWORD = $CHAR + $PASSWORD
}else {
$PASSWORD = $PASSWORD + $CHAR
}



Write-Host "=============================="
Write-Host "GENERATED PASSWORD IS BELOW:" -ForegroundColor Yellow
Write-Host
Write-Host $PASSWORD -BackgroundColor Black -ForegroundColor White
Write-Host
Write-Host "=============================="
Write-Host
