# Get-Strings
  A PowerShell version of the 'strings' command

## NAME
  Get-Strings
    
## SYNOPSIS
  Searches the contents of a file object and displays discovered strings of printable characters.
  Non-printable characters are stripped from the output by default.
  
## SYNTAX
  `Get-Strings [-FilePath] <String[]> [-Encoding <String>] [-MinimumLength <UInt32>] [-StripNonPrintable <Boolean>] [-PlaceHolder <String>] [<CommonParameters>]`
 
## DESCRIPTION
  "Strings" is a well-known, common command for *NIX systems. Since Windows does not include a version of this command, this function aims to recreate some of that functionality.
  The function takes a `FilePath` as a mandatory argument and a `MinimumLength` (default 4) as an optional argument.
  By default, it will search for both ASCII and Unicode strings. An optional argument, `Encoding`, can be used to only search for one or the other.
  
  Check `Get-Help` for other arguments.
    
## PARAMETERS
```
-FilePath <String[]>
    Absolute or relative path to the object to be searched.

    Required?                    true
    Position?                    2
    Default value
    Accept pipeline input?       true (ByPropertyName)
    Accept wildcard characters?  false

-Encoding <String>
    Instructs the function to search for Ascii or Unicode strings of characters.
    Default is 'Both'.

    Required?                    false
    Position?                    named
    Default value                Default
    Accept pipeline input?       false
    Accept wildcard characters?  false

-MinimumLength <UInt32>
    The shortest sequence of characters to be included in the search results.

    Required?                    false
    Position?                    named
    Default value                4
    Accept pipeline input?       false
    Accept wildcard characters?  false

-StripNonPrintable <Boolean>
    By default, the function strips non-printable characters from the output. By enabling this, those characters will be included.
    Not recommended when displaying output as STDOUT.

    Required?                    false
    Position?                    named
    Default value                True
    Accept pipeline input?       false
    Accept wildcard characters?  false

-PlaceHolder <String>
    This value lets you substitute any other character for non-printable characters in the output.
    If any value is specified, StripNonPrintable is automatically set to false.

    Required?                    false
    Position?                    named
    Default value
    Accept pipeline input?       false
    Accept wildcard characters?  false

<CommonParameters>
    This cmdlet supports the common parameters: Verbose, Debug, ErrorAction, ErrorVariable, WarningAction, WarningVariable, OutBuffer, PipelineVariable, and OutVariable. For more information, see about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216).
```
    
## NOTES
  Written by Word Eater (WordEaterNG@gmail.com)
  
  I wrote this because PowerSploit's Get-Strings is no longer being actively maintained.
  Also, every time I tried to download that `Get-Strings.ps1` code, or cut and paste it into Notepad++ my anti-malware software would immediately delete it.
        
  I rolled my own which, in places, resembles the other one.
        
  I made use of OpenAI's ChatGPT to tune this script.
  ChatGPT can't (reliably) write a valid script for you from scratch, but it can sure help you figure out bits and pieces.
  It also takes being called out when it makes an error much better than some real people.
        
  It has been tested on Windows 10, Windows Server 2019, and Kali Linux 2022.4
  
  ## EXAMPLES
  ```
  -------------------------- EXAMPLE 1 --------------------------
PS > Get-Strings C:\WINDOWS\System32\notepad.exe

-------------------------- EXAMPLE 2 --------------------------
PS > Get-Strings -FilePath C:\WINDOWS\System32\notepad.exe -MinimumLength 8 -Encoding Unicode

-------------------------- EXAMPLE 3 --------------------------
PS > Get-Strings C:\WINDOWS\System32\notepad.exe -StripNonPrintable 0

-------------------------- EXAMPLE 4 --------------------------
PS > Get-Strings C:\WINDOWS\System32\notepad.exe -PlaceHolder '.'

-------------------------- EXAMPLE 5 --------------------------
PS > Get-ChildItem C:\WINDOWS\*.dll -Recurse | ForEach-Object { Get-Strings $_ -MinimumLength 12 }

-------------------------- EXAMPLE 6 --------------------------
PS > Get-Strings /usr/bin/mousepad -MinimumLength 8 -PlaceHolder '.' 
```
