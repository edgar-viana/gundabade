# Define uma data para alteração: 1 mês atrás a partir de hoje
$semModified = (Get-Date).AddDays(-90)

# Lista TODAS as GPOs
$allGPOs = Get-GPO -All

# Lista GPOs com link em uso
$linkedGPOs = (Get-GPO -All | ForEach-Object {
    $report = Get-GPOReport -Guid $_.Id -ReportType XML
    [xml]$xml = $report
    if ($xml.GPO.LinksTo -ne $null) { $_.DisplayName }
})

# GPOs NÃO utilizadas
$unusedGPOs = $allGPOs | Where-Object { $linkedGPOs -notcontains $_.DisplayName -and $_.ModificationTime -lt $semModified}

# Exibir resultado


$EmailFrom = "svc_eng_workplace@americasmed.com.br"
$EmailTo   = @{ emailAddress = @{ address = "df3cd4d9.adhosp.onmicrosoft.com@amer.teams.ms" } },@{ emailAddress = @{ address = "l-engenharia-workplace@americasmed.com.br" }}
$Subject   = "Monitoracao de GPOs sem link em OU - No Use"
$Body      = $unusedGPOs | Select DisplayName, Id | ConvertTo-Html -Fragment
$total = $unusedGPOs.Count
$Bodyhmtl = @"
<!DOCTYPE html>
<html><head><meta charset='utf-8'></head><body>
Total de GPOs sem link em OU: <b style="color:red;">$total</b>
<br>
<br>
$Body
</body></html>
"@

#$credexc = Import-Clixml -Path "C:\scripts\monit_GPO_noLink\cred.xml"

#Verifica se a variavel tem conteudo para envio de alerta, caso contrário encerra o fluxo
if($unusedGPOs.id){

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

#$SMTPServer= "smtp.office365.com"
#$SMTPPort  = 587
#$credEmail = $credexc

<#Send-MailMessage `
  -From $EmailFrom `
  -To $EmailTo `
  -Subject $Subject `
  -body $Bodyhmtl `
  -BodyAsHtml `
  -SmtpServer $SMTPServer `
  -Port $SMTPPort `
  -UseSsl `
  -Credential $credEmail}#>