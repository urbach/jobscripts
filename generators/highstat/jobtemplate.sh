#!/bin/sh
#
#(otherwise the default shell would be used)
#$ -S /bin/sh
#
#(the running time for this job)
#$ -l h_rt=H_RT
#$ -l s_rt=S_RT
#
#(stderr and stdout are merged together to stdout) 
#$ -j y
#
# redirect stdout and stderr to /dev/null
#$ -o /dev/null
#
#(send mail on job's end and abort)
#$ -m bae
# queue name and number of cores
#$ -pe QUEUE NCORES

# number of mpi processes
NPROCS=NP
# basename, e.g. hmc0
BASENAME=BN
# e.g. openmp_noreduct
ADDON=AN
# e.g. highstatX
SUBDIR=SD
# "s" for start, "c" for continue
STATE=ST
# numerical counter for number of continue script
# if STATE=c
NCONT=NC

OUTPUT=/lustre/fs4/group/nic/kostrzew/output/${SUBDIR}/${BASENAME}_${ADDON}
EDIR=${HOME}/tmLQCD/execs/hmc_tm
IDIR=${HOME}/tmLQCD/inputfiles/${ADDON}
IFILE=${IDIR}/${STATE}${NCONT}_${BASENAME}.input

# write stdout and stderr into tmp dir, will be copied to output at the end
exec > ${TMPDIR}/stdout.txt.${JOB_ID} 2> ${TMPDIR}/stderr.txt.${JOB_ID}

if [[ ${STATE} == "s" ]]; then
  if [[ ! -d ${OUTPUT} ]]; then
    mkdir ${OUTPUT}
  fi
fi

if [[ ! -d ${OUTPUT} ]]
then
  echo "output directory ${OUTPUT} could not be found! Aborting!"
  exit 111
fi

cd ${OUTPUT}

MPIRUN="/usr/lib64/openmpi/1.4-icc/bin/mpirun -wd ${OUTPUT} -np ${NPROCS}"
case ${ADDON} in
  *mpi*): MPIPREFIX=${MPIRUN};;
  *hybrid*): MPIPREFIX=${MPIRUN};;
esac

${MPIPREFIX} ${EDIR}/${ADDON} -f ${IDIR}/${IFILE}

cp ${TMPDIR}/std* ${OUTPUT}

