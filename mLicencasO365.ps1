# Lista de nomenclaturas por ID

$list = @(
    [PSCustomObject]@{Nome ="Visio Plano 2"; Valor ="c5928f49-12ba-48f7-ada3-0d743a3601d5"}
    [PSCustomObject]@{Nome ="Power BI Pro"; Valor ='f8a1db68-be16-40ed-86d5-cb42ce701560'}
    [PSCustomObject]@{Nome ='Copilot para Microsoft 365'; Valor ='639dec6b-bb19-468b-871c-c5c441c4b0cb'}
    [PSCustomObject]@{Nome ='App Connect IW'; Valor ='8f0c5670-4e56-4892-b06d-91c085d7004f'}
    [PSCustomObject]@{Nome ='Windows Store para Empresas'; Valor ='6470687e-a428-4b7a-bef2-8a291ad947c9'}
    [PSCustomObject]@{Nome ='Office 365 E3'; Valor ='6fd2c87f-b296-42f0-b197-1e91e994b900'}
    [PSCustomObject]@{Nome ='Microsoft Power Automate Gratuito'; Valor ='f30db892-07e9-47e9-837c-80727f46fd3d'}
    [PSCustomObject]@{Nome ='Telefonia do Microsoft Teams Standard'; Valor ='e43b5b99-8dfb-405f-9987-dc307f34bcbd'}
    [PSCustomObject]@{Nome ='Project do Plan 1'; Valor ='beb6439c-caad-48d3-bf46-0c82871e12be'}
   [PSCustomObject]@{Nome ='Project Plan 5'; Valor ='09015f9f-377f-4538-bbb5-f75ceb09358a'}
    [PSCustomObject]@{Nome ='Proteção de Informações do Azure Plano 1'; Valor ='c52ea49f-fe5d-4e95-93ba-1de91d380f89'}
    [PSCustomObject]@{Nome ='Avaliação viral do Microsoft Copilot Studio'; Valor ='606b54a9-78d8-4298-ad8b-df6ef4481c80'}
    [PSCustomObject]@{Nome ='Avaliação do Dynamics 365 Customer Voice'; Valor ='bc946dac-7877-4271-b2f7-99d2db13cd2c'}
    [PSCustomObject]@{Nome ='Avaliação do Microsoft Power Apps Plano 2'; Valor ='dcb1a3ae-b33f-4487-846a-a640262fadf4'}
    [PSCustomObject]@{Nome ='Departamento Exploratório do Microsoft Teams'; Valor ='e0dfc8b9-9531-4ec8-94b4-9fec23b05fc8'}
    [PSCustomObject]@{Nome ='Clipchamp Standard'; Valor ='481f3bc2-5756-4b28-9375-5c8c86b99e6b'}
    [PSCustomObject]@{Nome ='Microsoft Fabric (Gratuito)'; Valor ='a403ebcc-fae0-4ca2-8c8c-7a907fd6c235'}
    [PSCustomObject]@{Nome ='Microsoft 365 Apps para Grandes Empresas'; Valor ='c2273bd0-dff7-4215-9ef5-2c7bcfb06425'}
    [PSCustomObject]@{Nome ='Visio Plano 2'; Valor ='38b434d2-a15e-4cde-9a98-e737c75623e1'}
    [PSCustomObject]@{Nome ='Salas do Microsoft Teams Básico'; Valor ='6af4b3d6-14bb-4a2a-960c-6c902aad34f3'}
    [PSCustomObject]@{Nome ='Office 365 E1 Plus'; Valor ='12a0b0ef-3d7c-4456-8f61-aa3817576c8d'}
   [PSCustomObject]@{Nome ='Enterprise Mobility + Security E3'; Valor ='efccb6f7-5641-4e0e-bd10-b4976e1bf68e'}
    [PSCustomObject]@{Nome ='Microsoft 365 F1'; Valor ='50f60901-3181-4b75-8a2c-4c8e4c1d5a72'}
    [PSCustomObject]@{Nome ='Microsoft 365 E3'; Valor ='05e9a617-0261-4cee-bb44-138d3ef5d965'}
    [PSCustomObject]@{Nome ='Planejador e Plano de Projeto 3'; Valor ='53818b1b-4a27-454b-8896-0dba576410e6'}
    [PSCustomObject]@{Nome ='Arquivamento do Exchange Online para Exchange Online'; Valor ='ee02fd1b-340e-4a4b-b355-4a514e4c8943'}
    [PSCustomObject]@{Nome ='Microsoft 365 F3'; Valor ='66b55226-6b4f-492c-910c-a3b7a3c9d993'}
    [PSCustomObject]@{Nome ='Teams Premium (para Departamentos)'; Valor ='52ea0e27-ae73-4983-a08f-13561ebdb823'}
    [PSCustomObject]@{Nome ='Salas Microsoft Teams Pro'; Valor ='4cde982a-ede4-4409-9ae6-b003453c8ea6'}
    [PSCustomObject]@{Nome ='Rights Management Adhoc'; Valor ='8c4ce438-32a7-4ac5-91a6-e22ae08d9c8b'}
    [PSCustomObject]@{Nome ='Microsoft PowerApps para Desenvolvedor'; Valor ='5b631642-bd26-49fe-bd20-1daaa972ef80'}
    [PSCustomObject]@{Nome ='Project Plano 3 (para Departamento)'; Valor ='46102f44-d912-47e7-b0ca-1bd7b70ada3b'}
    [PSCustomObject]@{Nome ='Office 365 E1'; Valor ='18181a46-0d4e-45cd-891e-60aabd171b4e'}
)
#_________________________________________________________________________________________________________________________

$clientId = "d473231a-9a65-4bc5-8236-66674eb85c01"                  ##[AppID]
$clientSecret = "kxJ8Q~k3KdN1q52chG2JuDx6FOYmpzOgYV_tjcjR"  | ConvertTo-SecureString -AsPlainText -Force ##[Secret Token]
$tenantId = "5ccab9a7-0c4d-47d7-acc0-ab532b6047d9"              ##[Tenat]

# Conectar ao Microsoft Graph
  $cred = New-Object System.Management.Automation.PSCredential ($clientId, $clientSecret)  ##[Conversão da Credencial]
    Connect-MgGraph -ClientSecretCredential $cred -TenantId $tenantId

$licencas = Get-MgSubscribedSku | Select-Object SkuPartNumber, SkuId, @{Name="TotalLicencas";Expression={$_.PrepaidUnits.Enabled}}, `
@{Name="LicencasConsumidas";Expression={$_.ConsumedUnits}}, `
@{Name="LicencasDisponiveis";Expression={$_.PrepaidUnits.Enabled - $_.ConsumedUnits}}

#______________________________________________________________________________
## Tabela customizada para reporte de quantidade de licencas

$report = foreach($l in $list){
  foreach($lic in $licencas){

if($l.Valor -eq $lic.SkuId){
    [PSCustomObject]@{
  Nome =  $l.Nome
  SkuId = $lic.SkuId
   TotalLicencas = $lic.TotalLicencas
   LicencasConsumidas = $lic.LicencasConsumidas
   LicencasDisponiveis = $lic.LicencasDisponiveis}}
   }


}

#_________________________________________________________________________________________

 #Write-Host "`n📊 Licenças disponíveis no tenant:`n" -ForegroundColor Cyan
#$report | Format-Table -AutoSize
$send = $report | ?{$_.LicencasDisponiveis -like "-*"} #| Format-Table -AutoSize
$timePBI = $report | ?{$_.Nome -eq "Power BI Pro"}

#_________________________________________________________________________________________

$EmailFrom = "svc_eng_workplace@americasmed.com.br"
$EmailTo   = @{ emailAddress = @{ address = "d82cc50d.adhosp.onmicrosoft.com@amer.teams.ms" } },@{ emailAddress = @{ address = "l-engenharia-workplace@americasmed.com.br" }}
$Subject   = "Monitoracao de Licencas O365 - Negativas"
$Body      = $send | Select-Object Nome, Skuid, TotalLicencas, LicencasConsumidas, LicencasDisponiveis | ConvertTo-Html -Fragment
$Bodyhmtl = @"
<!DOCTYPE html>
<html><head><meta charset='utf-8'></head><body>
$Body
</body></html>
"@

#$SMTPServer= "smtp.office365.com"
#$SMTPPort  = 587
#$credEmail = Import-Clixml -Path "C:\scripts\monit_licencasO365\cred.xml"

if($send.Skuid){

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

  #________________________________________________________________________________
  ##Relatorio de licenças de power bi

  $groupbi = Get-ADGroupMember GG_BR_APL_OF_LS_BI | Select-Object name | ConvertTo-Html -Fragment

$EmailFrompbi = "svc_eng_workplace@americasmed.com.br"
$EmailTopbi   = @{ emailAddress = @{ address = "tiago.barbosa@americasmed.com.br" } },@{ emailAddress = @{ address = "dvlopes@americasmed.com.br" }},@{ emailAddress = @{ address = "l-engenharia-workplace@americasmed.com.br" }}
$Subjectpbi   = "Monitoracao de Licencas PBI"
$BodyPbi     = $timePBI | Select-Object Nome, Skuid, TotalLicencas, LicencasConsumidas, LicencasDisponiveis | ConvertTo-Html -Fragment
$BodyhmtlPbi = @"
<!DOCTYPE html>
<html><head><meta charset='utf-8'></head><body>
$BodyPbi
<br>
<br>
$groupbi
</body></html>
"@

$paramsbi = @{
    message = @{
        subject = $Subjectpbi
        body = @{
            contentType = "HTML"
            content = $BodyhmtlPbi
        }
        toRecipients = @(
            $EmailTopbi 
        )
    }
}

Send-MgUserMail -UserId $EmailFrompbi -BodyParameter $paramsbi
