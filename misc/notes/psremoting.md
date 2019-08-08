# PS Remoting

## Linux

Install powershell:

```shell
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
sudo gdebi packages-microsoft-prod.deb
sudo apt update
sudo apt install powershell gss-ntlmssp libntlm0
rehash
pwsh
```

## Windows

Make sure that fw is disable and network connections profiles are set to private.

```shell
PS C:\> Enable-PSRemoting -force
PS C:\> Set-Service WinRM -StartMode Automatic
PS C:\> Set-Item WSMan:\localhost\Client\TrustedHosts -value 192.168.56.1
PS C:\> Get-Item WSMan:\localhost\Client\TrustedHosts


   WSManConfig: Microsoft.WSMan.Management\WSMan::localhost\Client

Type            Name                           SourceOfValue   Value              
----            ----                           -------------   -----              
System.String   TrustedHosts                                   192.168.56.1

PS C:\> Restart-Service -Force WinRM
```

## Back to linux

```shell
PS C:\> $creds = Get-Credential
PS C:\> Enter-PSSession -ComputerName 192.168.56.111 -Credential $creds -Authentication Negotiate
[192.168.56.111]: PS C:\> ls


    Directory: C:\


Mode                LastWriteTime         Length Name                             
----                -------------         ------ ----                             
d-----       2019-03-18   9:52 PM                PerfLogs                         
d-r---       2019-04-23   3:46 PM                Program Files                    
d-r---       2019-03-18  11:22 PM                Program Files (x86)              
d-r---       2019-04-29   2:25 PM                Users                            
d-----       2019-04-29   2:25 PM                Windows                          


[192.168.56.111]: PS C:\>
```