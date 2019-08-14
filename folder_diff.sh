TMP_FILE="diff__file.info"
OUT_FOLDER="diff__folder"
MATCH_OUT_FOLDER="match__folder"

if [ $# -ge 2 ] && [ -d $1 ] && [ -d $2 ] 
then  

diff -rq $1 $2 |& sort > $TMP_FILE


rm -rf $OUT_FOLDER
mkdir  $OUT_FOLDER
chmod -R 777 $OUT_FOLDER

echo "# Parsing diff files..." 
awk -F"[ ]" '{    if($1 == "Files") { 
                      cmd = "cp --parents -rf " $2 " ./'"$OUT_FOLDER"'"; 
                      system(cmd);
                      cmd = "cp --parents -rf " $4 " ./'"$OUT_FOLDER"'";
                      system(cmd);
                  }  
                  else if ($1 == "Only") { 
                      split($3,a,":");
                      cmd = "cp --parents -rf " a[1] "/"$4" ./'"$OUT_FOLDER"'";
                      system(cmd);
                         
                  } 
             } ' $TMP_FILE

echo "# Completed OUT_FOLDER is ./$OUT_FOLDER ." 


rm -rf  $TMP_FILE

for i in $*  
do
    case $i in
    -m) echo "# Found -m options try to filter only \"ALTICAST\" patch files."
        cd $OUT_FOLDER;
        rm -rf  $MATCH_OUT_FOLDER;
        mkdir $MATCH_OUT_FOLDER;
        grep -rsl "ALTICAST" * | cut -d "/" -f2- |  awk  '{     
                          cmd = "cp --parents -rf '"$1"'/" $1 " ./'"$MATCH_OUT_FOLDER"'"; 
                          system(cmd);
                          cmd = "cp --parents -rf '"$2"'/" $1 " ./'"$MATCH_OUT_FOLDER"'"; 
                          system(cmd);
                   }'
        echo "# Completed MATCH_OUT_FOLDER is ./$OUT_FOLDER/$MATCH_OUT_FOLDER .";; 
    esac
done



else
    echo "Usage   : folder_diff.sh [Folder1] [Folder2] [Options..]"
    echo "Options : "
    echo "   -m     only match ALTICAST patch"
    exit -1
fi

