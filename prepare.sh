#!/bin/bash 

path=$(cd "$(dirname "$0")"; pwd)
echo "$path"
cd $path

#cd openssl

#make 2>&1 | tee makelog

#cd $path

filesToProcess() {
  local listFile=$path/casestudy/openssl_files
  cat $listFile
# cat $listFile | sed -n "${1}~8p" 
}
echo "Generating interface"
../Morpheus/morpheus.sh $path/openssl/ssl/t1_meth.c --study openssl --writeProjectInterface

flags=" --bdd \
  	--study openssl --reuseAST --refPrep --refLink $path/CLinking.interface \
        -I $path/openssl \
	-I $path/openssl/include
	-I $path/openssl/include/openssl
	--platfromHeader $path/openssl/platform.h \
        --featureModelDimacs $path/openssl/OpenSSL.dimacs \
	--include $path/openssl/partial_configuration.h \
	--recordTiming --parserstatistics --lexNoStdout"

filesToProcess $1|while read i; do
         echo "Analysing $path/openssl/$i.c"
         echo "With settings: $flags"
         ../Morpheus/morpheus.sh $path/openssl/$i.c $flags
         done

exit
