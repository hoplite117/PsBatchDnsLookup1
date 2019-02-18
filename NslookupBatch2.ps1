$lookupfilepath = "C:\yourfolder"
$dnsresults = @()
Get-Content -Path $lookupfilepath | ForEach-Object {
$cnameresults = Resolve-DnsName -Name $_ -DnsOnly -Type CNAME
$aresults = Resolve-DnsName -Name $_ -DnsOnly -Type A
$reusltstype = $cnameresults | select-object -expandproperty Type
$reusltstypea = $aresults | select-object -expandproperty Type
if ($reusltstype -eq "SOA"){
	if ($reusltstypea -eq "A"){
		$avalue = $aresults | select-object -expandproperty IPAddress
		$dnstemparray = "$_","None","$avalue"
		$dnsresults += ,$dnstemparray
	}
	else {
		$dnstemparray = "$_","None"
		$dnsresults += ,$dnstemparray
	}
}
elseif ($reusltstype -eq "CNAME"){
	$cnamevalue = $cnameresults | select-object -expandproperty NameHost
	$dnstemparray = "$_","CNAME",$cnamevalue
	$dnsresults += ,$dnstemparray
}
}
foreach ($dnsresult in $dnsresults) {
	foreach ($subdnsresult in $dnsresult){		
		$subdnsresult
	}
	write-host "-----------------------------------"
}