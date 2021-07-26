#Requires -Version 3

Function Search-PwndPassword{
<#
.SYNOPSIS
    Searches a password database
.DESCRIPTION
    This Function Checks the Given Password with HaveIBeenPwnd Database using K-Anonymity

.PARAMETER Password
    Cleartext Password. Value can be piped. If Parameter is not Set a windows Credential box will appear

.NOTES

  Version:        1.0

  Author:         Alexander Kiko

  Creation Date:  26.04.2019

  Purpose/Change: Initial script devpelopment
  

.EXAMPLE

  Search-PwndPassword

  "Pony1" | Search-PwndPassword

  Search-PwndPassword "Pony1"

#>

[cmdletbinding()]

Param (

[parameter(ValueFromPipeline)]
[string]
$Password
)


    Begin{
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $baseUrlOfService = "https://api.pwnedpasswords.com/range/"
    
        Function Get-StringHash([String] $String,$HashName = "SHA1") 
        {    
            $StringBuilder = New-Object System.Text.StringBuilder 
            [System.Security.Cryptography.HashAlgorithm]::Create($HashName).ComputeHash([System.Text.Encoding]::UTF8.GetBytes($String)) | ForEach-Object{ 
                [Void]$StringBuilder.Append($_.ToString("x2")) 
            } 
            $StringBuilder.ToString() 
        }
    }
    
    Process{
    
        if($Password){
            $hashWord = Get-StringHash $Password
        }
        else{
            $hashWord = Get-StringHash (Get-Credential -UserName "NOT IMPORTANT" -Message "not important").GetNetworkCredential().Password
        }
    
        $shortHash = $hashWord.SubString(0,5)
    
        $hashSuffix = $hashWord.SubString(5,35) + ":"
    
        
        $resultList = Invoke-WebRequest -Uri ($baseUrlOfService + $shortHash) -UseBasicParsing | Select-Object Content -ExpandProperty Content
    
        $result = $resultList.Split('') | Select-String $hashSuffix | Out-String
    
        if($result){
            $count = $result.Split(":")[1]
            Write-Warning "Password Found: $count Times"
        }
        else{
            Write-Output  'Password not found.'
        }
        
    }
}
