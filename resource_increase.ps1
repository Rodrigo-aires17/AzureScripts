# Defina suas credenciais do Azure
$subscriptionId = ""
$resourceGroupName = ""
$serverName = ""
$databaseName = ""

# Defina o tamanho da instância do SQL Azure
$targetEdition = "Standard"
$targetServiceObjectiveName = "S4"

# Defina o horário de início e término do redimensionamento
$startTime = "10:01:00" # 3 hours of diference to Brazil 07:01
$endTime = "20:59:00" # 3 hours of diference to Brazil 17:59

# Obtém a hora atual
$currentTime = Get-Date
Write-Output ($currentTime)

# Verifica se é hora de redimensionar
if ($currentTime.TimeOfDay -ge [TimeSpan]::Parse($startTime) -and $currentTime.TimeOfDay -lt [TimeSpan]::Parse($endTime)) {

    try
    {
        "Logging in to Azure..."
        Connect-AzAccount -Identity -SubscriptionId $subscriptionId
    }
    catch {
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
  
    # Obtém informações sobre o banco de dados atual
    $database = Get-AzSqlDatabase -ResourceGroupName $resourceGroupName -ServerName $serverName -DatabaseName $databaseName

    # Verifica se já mudou ou não o tamanho, e muda de tudo para baixo
    if ($database.CurrentServiceObjectiveName -ne $targetServiceObjectiveName) {
        # Redimensiona a instância do SQL Azure
        Set-AzSqlDatabase -ResourceGroupName $resourceGroupName -ServerName $serverName -DatabaseName $databaseName -Edition $targetEdition -RequestedServiceObjectiveName $targetServiceObjectiveName
      
        $serverName = ""
        $databaseName = ""
        $targetServiceObjectiveName = ""
        
        # Redimensiona a instância do SQL Azure
        Set-AzSqlDatabase -ResourceGroupName $resourceGroupName -ServerName $serverName -DatabaseName $databaseName -Edition $targetEdition -RequestedServiceObjectiveName $targetServiceObjectiveName

        Write-Output ("Workday time, increase")
    } 
    else 
    {
        
         Write-Output ("Workday time, already changed.")

    }

    
}