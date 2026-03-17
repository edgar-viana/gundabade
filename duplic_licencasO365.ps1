<# Office 365 E3; Valor =6fd2c87f-b296-42f0-b197-1e91e994b900
Office 365 E1 Plus; Valor =12a0b0ef-3d7c-4456-8f61-aa3817576c8d
Microsoft 365 F1; Valor =50f60901-3181-4b75-8a2c-4c8e4c1d5a72
Microsoft 365 E3; Valor =05e9a617-0261-4cee-bb44-138d3ef5d965
Microsoft 365 F3; Valor =66b55226-6b4f-492c-910c-a3b7a3c9d993
Office 365 E1; Valor =18181a46-0d4e-45cd-891e-60aabd171b4e #>

$clientId = "d473231a-9a65-4bc5-8236-66674eb85c01"                  ##[AppID]
$clientSecret = "kxJ8Q~k3KdN1q52chG2JuDx6FOYmpzOgYV_tjcjR"  | ConvertTo-SecureString -AsPlainText -Force ##[Secret Token]
$tenantId = "5ccab9a7-0c4d-47d7-acc0-ab532b6047d9"              ##[Tenat]

# Conectar ao Microsoft Graph
  $cred = New-Object System.Management.Automation.PSCredential ($clientId, $clientSecret)  ##[Conversão da Credencial]
    Connect-MgGraph -ClientSecretCredential $cred -TenantId $tenantId


$credexc = Import-Clixml -Path "C:\scripts\monit_duplicidade_licencaO365\cred.xml"

Connect-ExchangeOnline -Credential $credexc

$aa = @()

$result = @()

$aa = Get-User -Filter * -ResultSize unlimited | Select-Object userprincipalname

foreach($a in $aa){
$count = $null
$UserLicenses = Get-MgUserLicenseDetail -UserId $a.UserPrincipalName | Select-Object id, skuid, skupartnumber

$var = $UserLicenses.skuid
$procurar = @("6fd2c87f-b296-42f0-b197-1e91e994b900", "12a0b0ef-3d7c-4456-8f61-aa3817576c8d","50f60901-3181-4b75-8a2c-4c8e4c1d5a72",`
"05e9a617-0261-4cee-bb44-138d3ef5d965", "66b55226-6b4f-492c-910c-a3b7a3c9d993","18181a46-0d4e-45cd-891e-60aabd171b4e")

foreach($v in $var){

foreach($p in $procurar){

if($v -eq $p){
     $count++
    if($count -gt 1){
          $result += [PSCustomObject]@{
                        UserPrincipalName = $a.UserPrincipalName
                        MatchCount        = $count}
             }
          }
       }
    }
}

$EmailFrom = "svc_eng_workplace@americasmed.com.br"
$EmailTo   = @{ emailAddress = @{ address = "6fcaf0dc.adhosp.onmicrosoft.com@amer.teams.ms" } },@{ emailAddress = @{ address = "l-engenharia-workplace@americasmed.com.br" }}
$Subject   = "Alerta Duplicidade - Licencas O365"
$Body      =  $result | Select-Object UserPrincipalName, MatchCount | ConvertTo-Html -Fragment
$total = $result.Count
$Bodyhmtl = @"
<!DOCTYPE html>
<html><head><meta charset='utf-8'></head><body>
Total de contas duplicadas: <b style="color:red;">$total</b>
<br>
<br>
$Body
</body></html>
"@

#Verifica se a variavel tem conteudo para envio de alerta, caso contrário encerra o fluxo

if($result.UserPrincipalName){

$params = @{
    message = @{
        subject = $Subject
        body = @{
            contentType = "HTML"
            content = $Bodyhmtl
        }
        toRecipients = @(
            $EmailTo 
        )
    }
}

Send-MgUserMail -UserId $EmailFrom -BodyParameter $params}
