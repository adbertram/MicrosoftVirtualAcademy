function Restart-Cluster {
    param($ClusterName)

    ## Do whatever it takes to restart the cluster here
}
    
## Helper function to Start-ClusterTest
function Test-ClusterProblem {
    param($ClusterName)

    ## Check some stuff here. Return either $true if all checks passed
    ## or false if they did not. For now, we'll just return $true.
    $true
}

function Start-ClusterTest {
    param($ClusterName)

    Write-Host 'Starting cluster test...'
    $result = Test-ClusterProblem -ClusterName $ClusterName ## Run another function
    if ($result) {
        $true
    } else {
        Restart-Cluster -ClusterName $ClusterName
    }
}