#AUTHOR: RIYADH ALMAUILI
#DATE: 24-08-2017

#POWERSHELL SCRIPT
#The survey fucntion returns the following:
#Computername, Date/Time, OS Version,
#List of all processes,separated by session, List of all open sockets

#===================================================================================================#

                
                echo " "
                echo "========================WELCOME TO MY SCRIP==========================="
                echo "======================================================================"
                echo "======================================================================"
                echo "======================================================================"
                echo "======================================================================"
                echo "MEANU:"
                echo "TYPE 'survey' TO GET survey ABOUT THIS MACHINE"
                echo "TYPE 'hash' TO HASH THE FILES IN A DIROCTORY YOU SPECIFIED"
                echo "TYPE 'schedualedTasks' TO LOAD THE SCHEDULAED TASKS INTO A .TXT FILE"
                echo "TYPE 'processes_range' TO LOAD PROCESSES THAT FALLS UNDER THE RANGE YOU SPECIFY "
                echo " "
                echo " "

#===================================================================================================#



function survey {

param ([parameter(parametersetname='filename',mandatory=$true)]$filename)
#COMPUTER NAME
echo " " >>$filename
echo "Computer Name: $env:COMPUTERNAME" >>$filename


#DATE/TIME
echo " " >>$filename
$dateTime=Get-Date
echo "Date and Time: $dateTime" >>$filename


#OS VERSION
echo " ">>$filename
echo "OS Version is:">>$filename
[environment]::osversion.version >>$filename


#LIST OF ALL PROCESS,SEPARATED BY SESSION
echo " ">>$filename
echo "List of processes and session">>$filename
Get-Process | Group-Object SessionId >>$filename


#LIST INFORMATION ABOUT SOCKETS
echo " ">>$filename
netstat -ano >>$filename



}



function hash {

param ([parameter(parametersetname='filedir',mandatory=$true)]$filedir,
       [parameter(mandatory=$true)]$outputFile
)

#will recursively open all file and hash them and forward the result to a file  
Get-ChildItem $filedir -Recurse  | Get-FileHash >>$outputFile 



}





function schedualedTasks {


param ([parameter(parametersetname='filename',mandatory=$true)]$filename)

#show the schedualed tasks
echo " "
schtasks -query >>$filename



}

#range of process id's specified by user
function processes_range {

param ([parameter(mandatory=$true)][int32]$start_range0,
       [parameter(mandatory=$true)][int32]$end_range1,
       [parameter(mandatory=$true)]$outputfile
)

   $x=$start_range0
   $y=$end_range1
  
    while ($x -lt $y) { 
       Get-Process | Where-Object{$_.id -match ($x -as [int32])} >> $outputfile
       $x = $x + 1
    
        }

}











