# -------------------------------------------------------------
# Script: Remoção de sites SharePoint inativos (e seus grupos)
# Descrição: identifica sites inativos por critérios de uso e data,
#            solicita remoção do Microsoft 365 Group associado e
#            remove o site (move para Deleted Sites).
# Observação: verificar credenciais e executar em ambiente seguro.
# -------------------------------------------------------------

# URL do SharePoint Admin do tenant
$AdminUrl = "https://adhosp-admin.sharepoint.com/"

# Credenciais: carrega objeto PSCredential previamente exportado via 
# Export-Clixml (arquivo seguro, protegido por chave do usuário que exportou)
$cred = Import-Clixml -Path "C:\scripts\monit_SharepointInativos\cred_message.xml"

Connect-PnPOnline -Url $AdminUrl -Credentials $cred

# Conecta ao SharePoint Online com PnP (usando credenciais importadas)
# -WarningAction Ignore para suprimir warnings que não impedem execução
Connect-PnPOnline -Url $AdminUrl -Credentials $cred -WarningAction Ignore

# Conecta ao Azure AD (precisa das mesmas credenciais ou permissões)
Connect-AzureAD -Credential $cred

# Define limites de inatividade: 3 meses e 12 meses (para regras diferentes)
$semModified = (Get-Date).AddMonths(-3)       # sites com pouca atividade nos últimos 3 meses
$semModifiedAnual = (Get-Date).AddMonths(-12) # sites sem atividade nos últimos 12 meses

# Timestamp para nomear o log/transcript
$hoje = (Get-Date).ToString('dd-MM-yyyy-HH-mm-ss')

# Mensagem inicial
Write-Host "Buscando site collections..." -ForegroundColor Cyan

# 1) sites pequenos (StorageUsage -eq 1) e sem atividade nos últimos 3 meses
#    seleciona propriedades úteis: Title, Url, GroupId, StorageUsage, LastContentModifiedDate
$sites1 = Get-PnPTenantSite -IncludeOneDrive:$false -Detailed |`
    ?{ $_.StorageUsage -eq 1 -and $_.LastContentModifiedDate -lt $semModified } |`
    Select-Object Title, Url, GroupId, StorageUsage, LastContentModifiedDate

# 2) sites maiores (StorageUsage -gt 1) e sem atividade nos últimos 12 meses
$sites2 = Get-PnPTenantSite -IncludeOneDrive:$false -Detailed |`
    ?{ $_.StorageUsage -gt 1 -and $_.LastContentModifiedDate -lt $semModifiedAnual} |`
    Select-Object Title, Url, GroupId, StorageUsage, LastContentModifiedDate

# Combina as duas listas em $sites (candidatos à revisão/remoção)
$sites = @()

$sites += $sites1
$sites += $sites2

#____________________________________________________________________________________________________________

# Exibir resultado

$EmailFrom = "svc_eng_workplace@americasmed.com.br"
$EmailTo   = @{ emailAddress = @{ address = "ca1aadf8.adhosp.onmicrosoft.com@amer.teams.ms" } },@{ emailAddress = @{ address = "l-engenharia-workplace@americasmed.com.br" }}
$Subject   = "Monitoracao de Sites Sharepoint sem Utilizacao"
$Body = $sites | Select Url, StorageUsage, LastContentModifiedDate | ConvertTo-Html -Fragment
$total1 = $sites1.Count
$total2 = $sites2.Count
$Bodyhmtl = @"
<!DOCTYPE html>
<html><head><meta charset='utf-8'></head><body>
Sites com menos de 1 MB sem modificacao +3 meses: <b style="color:red;">$total1</b>
<br>
Sites com mais de 1 MB sem modificacao +12 meses: <b style="color:red;">$total2</b>
<br>
<br>
$Body
</body></html>
"@

#Verifica se a variavel tem conteudo para envio de alerta, caso contrário encerra o fluxo
if($sites.URL){

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
