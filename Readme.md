# Search-PwndPassword

## Description

This Script checks if the given string is in the password database of https://haveibeenpwned.com/Passwords

It uses K-Anonymity and works like this: 
 -  The script hashes the password
 -  the hash is memorized and then shorten to the first 5 characters
 -  the 5 characters is send to the api (https://api.pwnedpasswords.com/range/)
 -  the api gives back a list with complete hashes that start with the 5 characters
 -  we check if the list contains the memorized full hash.


## Example

```
PS C:\Temp\source\Powershell\Search-PwndPassword> Import-Module .\Search-PwndPassword.ps1
PS C:\Temp\source\Powershell\Search-PwndPassword> Pony1 | Search-PwndPassword
PS C:\Temp\source\Powershell\Search-PwndPassword> "Pony1" | Search-PwndPassword
WARNUNG: Password Found: 19


 Times
PS C:\Temp\source\Powershell\Search-PwndPassword> "LOLPower" | Search-PwndPassword
Password not found.
PS C:\Temp\source\Powershell\Search-PwndPassword>
```