$clientId = "d473231a-9a65-4bc5-8236-66674eb85c01"                  ##[AppID]
$clientSecret = "kxJ8Q~k3KdN1q52chG2JuDx6FOYmpzOgYV_tjcjR"  | ConvertTo-SecureString -AsPlainText -Force ##[Secret Token]
$tenantId = "5ccab9a7-0c4d-47d7-acc0-ab532b6047d9"              ##[Tenat]

# Conectar ao Microsoft Graph
  $cred = New-Object System.Management.Automation.PSCredential ($clientId, $clientSecret)  ##[Conversão da Credencial]
    Connect-MgGraph -ClientSecretCredential $cred -TenantId $tenantId

$testeAccount = Get-ADUser -filter * -Properties name,samaccountname,division | ?{$_.division -ne $null -and $_.enabled -eq $true} | Select-Object name,samaccountname,division

$result = foreach($tA in $testeAccount){
$testDisable = Get-ADUser $tA.division

   if($testDisable.enabled -eq $false){ 

     [PSCustomObject]@{
                        Name = $tA.name
                        AccountAdmin = $tA.samaccountname
                        AccountNominal = $tA.division
                        StatusUserNominal = $testDisable.enabled}
   
   Get-ADUser $tA.samaccountname | Disable-ADAccount -Confirm:$false
   
   }

}


$EmailFrom = "svc_eng_workplace@americasmed.com.br"
$EmailTo   = @{ emailAddress = @{ address = "72e02360.adhosp.onmicrosoft.com@amer.teams.ms" } },@{ emailAddress = @{ address = "l-engenharia-workplace@americasmed.com.br" }}
$Subject   = "Desativação de Contas Administrativas"
$Body      =  $result | Select-Object Name, AccountAdmin, AccountNominal, StatusUserNominal | ConvertTo-Html -Fragment
$total = $result.Count
$Bodyhmtl = @"
<!DOCTYPE html>
<html><head><meta charset='utf-8'></head><body>
Total de contas administrativas desativadas: <b style="color:red;">$total</b>
<br>
<br>
$Body
</body></html>
"@

#Verifica se a variavel tem conteudo para envio de alerta, caso contrário encerra o fluxo

if($result.AccountAdmin){

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
