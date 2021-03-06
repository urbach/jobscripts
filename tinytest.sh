#!/bin/sh
#
#(otherwise the default shell would be used)
#$ -S /bin/sh
#
#(the running time for this job)
#$ -l h_cpu=00:10:00
#
#(stderr and stdout are merged together to stdout) 
#$ -j y
#
#(send mail on job's end and abort)
#$ -m bae
#$ -pe multicore-mpi 2

BASENAME=hmc0
ADDON=_hybrid_tinytest

OUTPUT=/afs/ifh.de/group/nic/scratch/pool4/kostrzew/output/${BASENAME}${ADDON}

if [[ ! -d ${OUTPUT} ]]
then
  mkdir ${OUTPUT}
fi

if [[ ! -d ${OUTPUT} ]]
then
  echo "ouput directory ${OUTPUT} could not be created!"
  exit 1
fi

cd $TMPDIR
/usr/lib64/openmpi/1.4-icc/bin/mpirun -wd $TMPDIR -np 1 /afs/ifh.de/user/k/kostrzew/code/tmLQCD.kost/build_hybrid/hmc_tm -f /afs/ifh.de/user/k/kostrzew/code/tmLQCD.kost/build_hybrid/sample-${BASENAME}_tinytest.input
cp ${TMPDIR}/* ${OUTPUT}

