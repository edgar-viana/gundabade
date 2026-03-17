Import-Module ActiveDirectory

# Define a data limite para inatividade: 3 meses atrás a partir de hoje
$dataLimite = (Get-Date).AddMonths(-3)

# Define uma data para alteração: 7 dias atrás a partir de hoje
$semModified = (Get-Date).AddDays(-7)
$semModifiedNull = (Get-Date).AddDays(-30)

#Gera log do dia
$hoje = (Get-Date).ToString('dd-MM-yyyy-HH-mm-ss')

# Busca todos os usuários na OU "Disable Users" que:
# - Estão desabilitados
# - Não foram modificados nos últimos 7 dias
# - Não fizeram login nos últimos 3 meses
# - Não alteraram a senha nos últimos 3 meses
# O resultado é uma lista de objetos com propriedades selecionadas
$RemoveUsers = @()

$RemoveUsers = Get-ADUser -Filter "Enabled -eq 'False'" `
    -SearchBase "OU=Disable Users,DC=adhosp,DC=com,DC=br" `
    -Properties * |
    Where-Object {
        $_.whenChanged -lt $semModified -and
        $_.lastlogondate -lt $dataLimite -and
        $_.PasswordLastSet -lt $dataLimite} | Select-Object name, userprincipalname, samaccountname, enabled, lastlogondate, PasswordLastSet, whenChanged

$RemoveUsers += Get-ADUser -Filter "Enabled -eq 'False'" `
    -SearchBase "OU=Disable Users,DC=adhosp,DC=com,DC=br" `
    -Properties * |
    Where-Object {$_.whenChanged -lt $semModifiedNull
        } | Select-Object name, userprincipalname, samaccountname, enabled, lastlogondate, PasswordLastSet, whenChanged

Start-Transcript -Path ("C:\scripts\exclude_accountdisable\logs\" + "$hoje" + ".txt")

# Loop para processar até 20000 usuários OU o total disponível na lista, o que for menor
# Aqui, apenas exibe os dados do usuário. Para excluir, descomente o Remove-ADUser
#for ($i = 0; $i -lt 19999 -and $i -lt $RemoveUsers.Count; $i++) 
   foreach($r in $RemoveUsers){
    Get-ADUser $r.samaccountname
    # Para remover os usuários automaticamente, descomente a linha abaixo:
    Remove-ADUser $r.samaccountname -Confirm:$false}


 Stop-Transcript