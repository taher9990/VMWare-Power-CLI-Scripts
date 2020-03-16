# Connect to vCenter using passthrough credentials
connect-viserver "hcivc01.hci.local";

# Get a list of hosts in a specific cluster (omit the get-cluster to get all hosts, and just use get-vmhost)
$hosts = get-cluster "STC-HCI-CLUSTER" | get-vmhost;

# Define an empty table
$table = @();

# Loop through each host found
foreach ($vmhost in $hosts) {

    # Create an empty row
    $row = "" | select Hostname, LogicalCPUs, CPUsAssigned, Overcommited;

    # Get the number of vCPUs assigned
    $cpumeasure = $vmhost | get-vm | where {$_.powerstate -eq "poweredon"} | measure-object numcpu -sum;

    # Add the hostname to the row
    $row.Hostname = (($vmhost.name).split("."))[0];

    # Add the number of logical CPUs to the row 
    $row.logicalcpus = $vmhost.numcpu * 2;

    # Add the number of allocated vCPUs to the row
    $row.cpusassigned = [int]$cpumeasure.sum;

    # Get the overcommitment level as a percentage
    $perc = [int](($cpumeasure.sum / $row.logicalcpus)*100);

    # Warn if overcommitted
    if ($perc -gt 100) {
        $row.Overcommited = "YES - " + $perc + "%";
    }
    else {
        $row.Overcommited = "No";
    }

# Add the current row to the table
$table = $table + $row;

}

# Display the table
$table | out-gridview;