function Get-Strings {
	<#	
	.SYNOPSIS
	Searches the contents of a file object and displays discovered strings of printable characters.
	Non-printable characters are stripped from the output by default.
	
	.DESCRIPTION
	"Strings" is a well-known, common command for *NIX systems. Since Windows does not include a version of this command, this function aims to recreate some of that functionality.
	The function takes a FilePath as a mandatory argument and a MinimumLength (default 4) as an optional argument.
	By default, it will search for both ASCII and Unicode strings. An optional argument, Encoding, can be used to only search for one or the other.
	
	Check `Get-Help` for other arguments.
	
	.PARAMETER FilePath
	Absolute or relative path to the object to be searched.
	
	.PARAMETER Encoding
	Instructs the function to search for Ascii or Unicode strings of characters.
	Default is 'Both'.
	
	.PARAMETER MinimumLength
	The shortest sequence of characters to be included in the search results.
	
	.PARAMETER ShowNonPrintable
	By default, the function strips non-printable characters from the output. By enabling this, those characters will be included.
	Not recommended when displaying output as STDOUT uhles combined with NonPrintablePlaceHolder.
		
	.PARAMETER NonPrintablePlaceHolder
	This value lets you substitute any other character for non-printable characters in the output.
	If any value is specified, ShowNonPrintable is implicitly set to true.
	
	.EXAMPLE	
	Get-Strings C:\WINDOWS\System32\notepad.exe
	
	.EXAMPLE
	Get-Strings -FilePath C:\WINDOWS\System32\notepad.exe -MinimumLength -Encoding Unicode
	
	.EXAMPLE
	Get-Strings /usr/bin/attr -NonPrintablePlaceHolder '.' -Encoding Ascii -Verbose
	
	.EXAMPLE
	Get-Strings C:\WINDOWS\System32\notepad.exe -PlaceHolder '.'
	
	.EXAMPLE
	Get-Strings /usr/bin/mousepad -MinimumLength 8 -ShowNonPrintable | Out-File .\mousepad-strings.txt
	
	.NOTES
	Written by Word Eater (WordEaterNG@gmail.com)
	
	I wrote this because PowerSploit's Get-Strings is no longer being actively maintained.
	Also, every time I tried to download that Get-Strings.ps1 code, or cut and paste it into Notepad my anti-malware software would immediately delete it.
	
	I rolled my own which, in places, resembles the other one.
	
	I made use of OpenAI's ChatGPT to tune this script.
	ChatGPT can't (reliably) write a valid script for you from scratch, but it can sure help you figure out bits and pieces.
	It also takes being called out when it makes an error much better than some real people.
	
	It has been tested on Windows 10, Windows Server 2019, and Kali Linux 2022.4
	#>
	
	[CmdletBinding()]
	Param
	(
        	[Parameter(Position = 0, Mandatory = $True, ValueFromPipelineByPropertyName = $True)]
	        [ValidateNotNullOrEmpty()]
        	[ValidateScript({Test-Path $_ -PathType 'Leaf'})]
        	[String[]]
        	[Alias('PSPath')]
        	$FilePath,

        	[ValidateSet('Default','Ascii','Unicode')]
        	[String]
        	$Encoding = 'Default',

        	[UInt32][ValidateRange(0, [Int32]::MaxValue)]
        	$MinimumLength = 4,
		
		[Switch]
		$ShowNonPrintable,
		
		[String]
		$NonPrintablePlaceHolder=''
	)
	
	Begin {	
		# creating helper function
		function Get-TimeStamp {
			$TimeStamp = "[{0:yyyy-MM-dd} {0:HH:mm:ss}]" -f (Get-Date)
			return $TimeStamp
		}
		$StartDateTime = Get-Date
		
		# Don't strip non-printable characters if a placeholder value is specified
		if ( $NonPrintablePlaceHolder -ne '' ) { $ShowNonPrintable = $true; }
		
		$(Get-Timestamp) + "`tFile to check: " + (Get-ChildItem $FilePath).FullName | Write-Verbose
		$(Get-Timestamp) + "`tMininum string length: " + $MinimumLength | Write-Verbose
		$(Get-Timestamp) + "`tEncoding: " + $Encoding | Write-Verbose
		$(Get-Timestamp) + "`tShow non-printable characters: " + $ShowNonPrintable | Write-Verbose
		$(Get-Timestamp) + "`tNon-printable placeholder character: " + $NonPrintablePlaceHolder | Write-Verbose
	}

	Process {	
		# Search for strings of printable characters of MinimumLength or longer, default 4
		if ($Encoding -eq 'Ascii' -or $Encoding -eq 'Default') {
			$strings = Select-String $FilePath -Pattern "[\x20-\x7E]{$MinimumLength,}"
			if ( $NonPrintablePlaceHolder -ne '' ) { $strings = $strings | % { $_ -replace "[^\x20-\x7E]+",$NonPrintablePlaceHolder } }
			if ( $ShowNonPrintable -eq $false ) { $strings = $strings | % { $_ -replace "[^\x20-\x7E]+" } }
			$(Get-Timestamp) + "`t" + '---------- BEGIN ASCII STRINGS ----------' | Write-Verbose
			$strings
			$(Get-Timestamp) + "`t" + '---------- END ASCII STRINGS ----------' | Write-Verbose
		}
		if ($Encoding -eq 'Unicode' -or $Encoding -eq 'Default') {		
			$strings = Select-String $FilePath -Pattern "[\u0020-\u007E]{$MinimumLength,}"
			#$strings = Select-String $FilePath -Pattern "\p{L}{$MinimumLength,}"
			if ( $NonPrintablePlaceHolder -ne '' ) { $strings = $strings | % { $_ -replace "[^\x20-\x7E]+",$NonPrintablePlaceHolder } }
			if ( $ShowNonPrintable -eq $false  ) { $strings = $strings | % { $_ -replace "[^\x20-\x7E]+" } }
			$(Get-Timestamp) + "`t" + '---------- BEGIN UNICODE STRINGS ----------' | Write-Verbose
			$strings
			$(Get-Timestamp) + "`t" + '---------- END UNICODE STRINGS ----------' | Write-Verbose
		}		
	}
	
	End {
		$EndDateTime = Get-Date
		$Duration = New-TimeSpan -Start $StartDateTime -End $EndDateTime
		$(Get-Timestamp) + "`t" + "Execution took $Duration" | Write-Verbose
	}
}
