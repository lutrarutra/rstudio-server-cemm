#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=64G
#SBATCH --cpus-per-task=12
#SBATCH --partition=interactiveq
#SBATCH --qos=interactiveq
#SBATCH --time 12:00:00
#SBATCH --job-name rstudio-server
#SBATCH --chdir <repository path>
#SBATCH --output rstudio-server.log

# Change Parameters
PASSWORD=password
CONTAINER="/nobackup/<your lab dir>/users/<your user name>/containers/rstudio_latest.sif"

mkdir -p $(dirname $CONTAINER)

module purge
module load singularity

source ~/.bashrc
conda activate rstudio-server  # or any other conda env with R language installed

export OMP_NUM_THREADS=${SLURM_JOB_CPUS_PER_NODE}

PORT=$(shuf -i8000-9999 -n1)
USER=$(whoami)
TMPDIR=${TMPDIR:-tmp}

RSTUDIO_TMP="${TMPDIR}/$(echo -n $CONDA_PREFIX | md5sum | awk '{print $1}')"
mkdir -p $RSTUDIO_TMP/{run,var-lib-rstudio-server,local-share-rstudio}
mkdir -p $HOME/.config/rstudio
mkdir -p ~/rstudio-data

R_BIN=$CONDA_PREFIX/bin/R
PY_BIN=$CONDA_PREFIX/bin/python

if [ ! -f $CONTAINER ]; then
	singularity build --fakeroot $CONTAINER Singularity
fi

if [ -z "$CONDA_PREFIX" ]; then
  echo "Activate a conda env or specify \$CONDA_PREFIX"
  exit 1
fi

echo "Starting rstudio-server"
echo "http://$(hostname).int.cemm.at:$PORT"

singularity exec \
	--bind $RSTUDIO_TMP/run:/run \
	--bind $RSTUDIO_TMP/var-lib-rstudio-server:/var/lib/rstudio-server \
	--bind /sys/fs/cgroup/:/sys/fs/cgroup/:ro \
	--bind database.conf:/etc/rstudio/database.conf \
	--bind rsession.conf:/etc/rstudio/rsession.conf \
	--bind $RSTUDIO_TMP/local-share-rstudio:/home/rstudio/.local/share/rstudio \
	--bind ${CONDA_PREFIX}:${CONDA_PREFIX} \
	--bind $HOME/.config/rstudio:/home/rstudio/.config/rstudio \
    --bind /research:/research \
    --bind /nobackup:/nobackup \
	--bind ~/rstudio-data:/data \
	--env CONDA_PREFIX=$CONDA_PREFIX \
    --env OMP_NUM_THREADS=$OMP_NUM_THREADS \
	--env RSTUDIO_WHICH_R=$R_BIN \
	--env RETICULATE_PYTHON=$PY_BIN \
	--env PASSWORD=$PASSWORD \
	--env PORT=$PORT \
	--env USER=$USER \
	$CONTAINER \
	/init.sh


