#!/bin/bash
# Shawn Yat Sin
# School of Computer Science
# shawn.yatsin@mail.mcgill.ca

if [[ $# != 1 ]]    #if there is not exactly 1 argument
then
	echo 'Usage ./wparser.bash <weatherdatadir>'
	exit 1

elif [[ ! -d $1 ]] #if the argument is not a valid directory
then
	echo "Error! $1 is not a valid directory name" >&2
	exit 1
fi

function extractData {
	echo -e "\nProcessing Data From $1"
	echo ====================================	
	echo Year,Month,Day,Hour,TempS1,TempS2,TempS3,TempS4,TempS5,WindS1,WindS2,WindS3,WinDir
	grep 'observation line' $1 | sed -e 's/ observation line //' -e 's/-/ /' -e 's/-/ /' -e 's/:/ /' -e 's/MISSED SYNC STEP/REP/g' -e 's/NOINF/REP/g' -e 's/\[data log flushed] //g' -e 's/ /,/g' | 
	awk 'BEGIN {FS=",";OFS=",";p6=p7=p8=p9=p10=0} 
	{
	      	if ($NF == 0){ $NF="N" }            #translating the wind speeds
		else if ($NF == 1) { $NF="NE" }
		else if ($NF == 2) { $NF="E" }
		else if ($NF == 3) { $NF="SE" }
		else if ($NF == 4) { $NF="S" }
		else if ($NF == 5) { $NF="SW" }
		else if ($NF == 6) { $NF="W" }
		else if ($NF == 7) { $NF="NW" }
	
		for (i=6; i<=10; i++){                  #replacing any REP value with the previous reading
			if ($i == "REP"){
				if (i == 6) { $i=p6 }
				else if (i == 7) { $i=p7 }
				else if (i == 8) { $i=p8 }
				else if (i == 9) { $i=p9 }
				else if (i == 10) { $i=p10 }
			}
		}
	
	{p6=$6;p7=$7;p8=$8;p9=$9;p10=$10}                     #updating the variables to hold replacements
	{print $1,$2,$3,$4,$6,$7,$8,$9,$10,$11,$12,$13,$14}   #printing the line excluding the minutes and seconds	
	}
	'	
	echo ==================================== 	
	echo Observation Summary
	echo Year,Month,Day,Hour,MaxTemp,MinTemp,MaxWS,MinWS

	#pattern observation line; removing observation line, replacing first two - and : with spaces; replacing the errors with REP; removing [data log flushed];replacing space with ,
	grep 'observation line' $1 | sed -e 's/ observation line //' -e 's/-/ /' -e 's/-/ /' -e 's/:/ /' -e 's/MISSED SYNC STEP/REP/g' -e 's/NOINF/REP/g' -e 's/\[data log flushed] //g' -e 's/ /,/g' |
        awk 'BEGIN {FS=",";OFS=","}
        {
                MaxTemp=MinTemp=$6;MaxWS=MinWS=$11              
                for (i=6; i<=10; i++){
                        if (MaxTemp == "REP"){     #if variables initialize as REP, use the next temperature
                                MaxTemp=$(i+1)
                        }
                        if (MinTemp == "REP"){
                                MinTemp=$(i+1)
                        }       
                        if ($i == "REP") {       #if temperature to compare == REP, skip comparison
                                continue
                        }
                        if ($i > MaxTemp){     #if temperature greater than current MaxTemp, update MaxTemp
                                MaxTemp=$i
                        }
                        if ($i < MinTemp){   #if temperature less than current MinTemp, update MinTemp
                                MinTemp=$i
                        }
                }
                for (i=11; i<=13; i++){         #same for windspeeds without checking for errors
                        if ($i > MaxWS){
                                MaxWS=$i
                        }
                        if ($i < MinWS){
                                MinWS=$i
                        }
                }
        {print $1,$2,$3,$4,MaxTemp,MinTemp,MaxWS,MinWS}
        }
        '
}

for file in $(find $1 -name 'weather_info_*.data')        #extracting data from each weather info file in the directory argument given
do
       	extractData $file
done

echo '' > sensorstats.html                                #overriding sensorstats.html
for file in $(find $1 -name 'weather_info_*.data')
do
	#filtering error lines; replacing - with space for dates; initializing counters for each temp. sensor; OFS=" </TD> <TD> " for less writing later
	grep 'performing' $file | sed 's/-/ /g'| awk 'BEGIN {S1=S2=S3=S4=S5=0;OFS=" </TD> <TD> "}   
	{
		if ($10 == 1){      #checking 10th argument in line which corresponds to the temp. sensor affected
			S1++
		}
		else if ($10 == 2){
			S2++
		}
		else if ($10 == 3){
			S3++
		}
		else if ($10 == 4){
			S4++
		}
		else if ($10 == 5){
			S5++
		}
	}
	END {print "<TR> <TD> " $1,$2,$3,S1,S2,S3,S4,S5,S1+S2+S3+S4+S5" </TD> </TR>"}' >> sensorstats.html    #printing beginning and end tags; counters and total
done

sort -k27,27rn -k3,3n -k6,6n -k9,9n sensorstats.html -o sensorstats.html  #sorting total column in descending order, then year, month, day in regular; overriding sensorstats.html 
sed -i '1 i\<HTML>\n<BODY>\n<H2>Sensor error statistics</H2>\n<TABLE>\n<TR><TH>Year</TH><TH>Month</TH><TH>Day</TH><TH>TempS1</TH><TH>TempS2</TH><TH>TempS3</TH><TH>TempS4</TH><TH>TempS5</TH><TH>Total</TH><TR>' sensorstats.html  #adding first part of HTML to the beginning of sensorstats.html file
echo -e '</TABLE>\n</BODY>\n</HTML>' >> sensorstats.html
