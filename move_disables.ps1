Import-Module ActiveDirectory

# Define uma data para alteração: 7 dias atrás a partir de hoje
$semModified = (Get-Date).AddDays(-7)

$hoje = (Get-Date).ToString('dd-MM-yyyy')

# Export de todas as contas do AD desabilitas e sem modificação a mais de 1 mês
$user1 = Get-ADUser -Filter * -SearchBase "OU=DASA.NET,dc=adhosp,dc=com,dc=br" -Properties * | Where-Object{$_.enabled -match "false" -and $_.whenChanged -lt $semModified}
$user2 = Get-ADUser -Filter * -SearchBase "OU=EUC,dc=adhosp,dc=com,dc=br" -Properties * | Where-Object{$_.enabled -match "false" -and $_.whenChanged -lt $semModified}

$estado = @("BA","DF", "MA", "PR", "RJ", "SP","AMIL","FORNECEDORES_TERCEIROS", "Bind")
foreach($e in $estado){

$user3 += Get-ADUser -Filter * -SearchBase "OU=$e,dc=adhosp,dc=com,dc=br" -Properties * | Where-Object{$_.enabled -match "false" -and $_.whenChanged -lt $semModified}
}

$usermove = @()

$usermove += $user1
$usermove += $user2
$usermove += $user3

#Gera script de log

Start-Transcript -Path ("C:\scripts\move_accountdisable\logs\" + "$hoje" + ".txt")

#Movimentas as contas para as OUs de Desabilitados definidas

Write-Host "Quantidade de contas encontradas para movimentacao: " $usermove.count

foreach($um in $usermove){

if($um.SamAccountName -like "F*" -or $um.SamAccountName -like "J*"){
 $groups = $um.memberof
       
       foreach($g in $groups){
       
       Remove-ADGroupMember -Identity $g -Members $um -Confirm:$false
       }
 Write-Host "OU Original"
 $um.distinguishedName
 get-aduser $um.SamAccountName | Move-ADObject -TargetPath "OU=Usuarios Desligados,OU=Disable Users,DC=adhosp,DC=com,DC=br"}

 if($um.SamAccountName -like "T*"){
  $groups = $um.memberof
       
       foreach($g in $groups){
       Remove-ADGroupMember -Identity $g -Members $um -Confirm:$false
       }
       Write-Host "OU Original"
 $um.distinguishedName
 get-aduser $um.SamAccountName | Move-ADObject -TargetPath "OU=Terceiros Desligados,OU=Disable Users,DC=adhosp,DC=com,DC=br"}

 if($um.SamAccountName -like "O*"){
  $groups = $um.memberof
       
       foreach($g in $groups){
       Remove-ADGroupMember -Identity $g -Members $um -Confirm:$false
       }
       Write-Host "OU Original"
 $um.distinguishedName
 get-aduser $um.SamAccountName | Move-ADObject -TargetPath "OU=Conta O Disable,OU=Disable Users,DC=adhosp,DC=com,DC=br"}

 if($um.SamAccountName -like "S*"){
   $groups = $um.memberof
       
       foreach($g in $groups){
       Remove-ADGroupMember -Identity $g -Members $um -Confirm:$false
       }
       Write-Host "OU Original"
 $um.distinguishedName
 get-aduser $um.SamAccountName | Move-ADObject -TargetPath "OU=Conta S Disable,OU=Disable Users,DC=adhosp,DC=com,DC=br"}

 else{
  $groups = $um.memberof
       
       foreach($g in $groups){
       Remove-ADGroupMember -Identity $g -Members $um -Confirm:$false
       }
       Write-Host "OU Original"
 $um.distinguishedName
 Get-ADUser $um.SamAccountName | Move-ADObject -TargetPath "OU=Outros Desligados,OU=Disable Users,DC=adhosp,DC=com,DC=br"
 }

}

 Stop-Transcript