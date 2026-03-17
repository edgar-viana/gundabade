$clientId = "d473231a-9a65-4bc5-8236-66674eb85c01"                  ##[AppID]
$clientSecret = "kxJ8Q~k3KdN1q52chG2JuDx6FOYmpzOgYV_tjcjR"  | ConvertTo-SecureString -AsPlainText -Force ##[Secret Token]
$tenantId = "5ccab9a7-0c4d-47d7-acc0-ab532b6047d9"              ##[Tenat]

# Conectar ao Microsoft Graph
  $credGraph = New-Object System.Management.Automation.PSCredential ($clientId, $clientSecret)  ##[Conversão da Credencial]
    Connect-MgGraph -ClientSecretCredential $credGraph -TenantId $tenantId -NoWelcome
    

$allDevices = Get-MgDeviceManagementManagedDevice -All | Select-Object DeviceName, userprincipalname

foreach($import in $allDevices){

$testeUser = $import.userprincipalname
$testeDevice = $import.DeviceName

#Get-MgDeviceManagementManagedDevice -All -Filter "deviceName eq 'BRAMND896107541'" | fl

$getUser = (Get-MgDeviceManagementManagedDevice -All -Filter "userprincipalname eq '$testeUser'").userprincipalname
$consultaTitle = (Get-MgUser -Filter "userPrincipalName eq '$getUser'" -Property JobTitle).JobTitle

      
      if($consultaTitle -match "VP|DIRETOR|DIR|PRESIDENTE"){
      # Obter o ID do dispositivo no Intune
      $device = Get-MgDevice -Filter "displayName eq '$testeDevice'"
      
       # Atualizar o atributo "category" personalizado com VIP
      $IDVip =  Get-MgDevice -Filter "id eq '$($device.Id)'"
      $groupVIP = Get-MgGroup -Filter "DisplayName eq 'Devices_VIP_Americas'"
      New-MgGroupMember -GroupId $groupVIP.Id -DirectoryObjectId $IDVip.Id

        }

      if($consultaTitle -match "Analista TI|COORDENADOR OPERACOES TI|ANALISTA OPERACOES TI|Analista Seguranca Informacao|GERENTE TI|Consultor Operacoes TI"){
      # Obter o ID do dispositivo no Intune
      $device = Get-MgDevice -Filter "displayName eq '$testeDevice'"

       # Atualizar o atributo "category" personalizado com VIP
      $IDVip =  Get-MgDevice -Filter "id eq '$($device.Id)'"
      $groupVIP = Get-MgGroup -Filter "DisplayName eq 'Devices_TI_Teams_Americas'"
      New-MgGroupMember -GroupId $groupVIP.Id -DirectoryObjectId $IDVip.Id

        }

      $users = @(
    "edgar.viana@americasmed.com.br",
    "jean.parga@americasmed.com.br",
    "douglas.calixto@americasmed.com.br",
    "carlos.zuchini@AMERICASMED.COM.BR",
    "gabriel.sabino@americasmed.com.br",
    "gustavo.tavares@AMERICASMED.COM.BR",
    "l.duque@americasmed.com.br",
    "marcos.vieira@americasmed.com.br",
    "larissa.s.santos.ext@americasmed.com.br",
    "michel.jardim@americasmed.com.br",
    "jaine.lauersdorf@americasmed.com.br")

if ($getUser -in $users) {
    # código aqui
      # Obter o ID do dispositivo no Intune
      $device = Get-MgDevice -Filter "displayName eq '$testeDevice'"
      
       # Atualizar o atributo "category" personalizado com VIP
      $IDVip =  Get-MgDevice -Filter "id eq '$($device.Id)'"
      $groupVIP = Get-MgGroup -Filter "DisplayName eq 'Devices_Teste_Engenharia_Workplace'"
      New-MgGroupMember -GroupId $groupVIP.Id -DirectoryObjectId $IDVip.Id }

      else{
      # Obter o ID do dispositivo no Intune
      $devicenot = Get-MgDevice -Filter "displayName eq '$testeDevice'"

      # Atualizar o atributo "category" personalizado com VIP
      $IDNot =  Get-MgDevice -Filter "id eq '$($device.Id)'"
      $groupNOTVIP = Get-MgGroup -Filter "DisplayName eq 'Devices_NOTVIP_Americas'"
      New-MgGroupMember -GroupId $groupVIP.Id -DirectoryObjectId $IDVip.Id
        }
      
}