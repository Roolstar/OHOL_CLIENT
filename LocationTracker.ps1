       
# Settings
    # Set File Location
    $LogLocation = "stdout.txt"

    # Set Loop Delay
	$loopDelayMilliseconds = 500

    #Print with Timestamp
    $timestamp = $true


	while($true){

    #we will be parsing the lines which are similar to: "Sending message to server: MOVE 56611 109507 -1 0 -2 0 -3 0 -4 1#"
    try{ 

    $lastLine = Get-Content -Path $LogLocation | Where-Object {$_ -like "*Sending message to server: MOVE*"} | Select-Object -Last 1
    
    #if the last line has not been processed
    if ($lastLine -ne $lastLineNew ){
        
        #get the coordinates directly after the "Move" text in the last line we retrieved


        $pos = $lastLine.IndexOf("MOVE")
        $coordinates = $lastLine.Substring($pos+5)
        $pos = $coordinates.IndexOf(" ")
        $x = $coordinates.Substring(0, $pos)
        $y = $coordinates.Substring($pos+1)
        $pos = $coordinates.IndexOf(" ")
        $pos = $y.IndexOf(" ")
        $y = $y.Substring(0,$pos+0)
        $coordinates = "X: $x`t Y: $y"

        #check if settings have timestamp enabled
        if ($timestamp = $true){
        
        #get the time
        $time= Get-Date -Format g 

        #add the time to the coordinates
        $coordinates =  "$time `t $coordinates"

        }
       
       #print out the coordinate line to the console
       Write-Host $coordinates 
   

    #update lastline in memory
    $lastLineNew = $lastLine 
    }
    }Catch{
    $lastLineNew = ""

    }Finally{

    #loop through log file
	Start-Sleep -Milliseconds $loopDelayMilliseconds 
    }
}