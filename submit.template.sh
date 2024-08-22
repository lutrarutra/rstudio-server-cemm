#!/bin/bash
#SBATCH --nodes=1
#SBATCH --cpus-per-task=${NUM_CPUS}
#SBATCH --mem=${MEM_GB}G
#SBATCH --partition=${QUEUE}
#SBATCH --qos=${QUEUE}
#SBATCH --time=${TIME_LIMIT}
#SBATCH --job-name=rstudio-server
#SBATCH --output=rstudio-server.log

REBUILD=false
for arg in "$@"; do
    if [ "$arg" == "--rebuild" ]; then
        REBUILD=true
        break
    fi
done

source ${REPO_PATH}/.env

module purge
module load singularity

source ~/.bashrc
conda activate ${CONDA_ENV}

if [ -z "${CONDA_PREFIX}" ]; then
  echo "Activate a conda env or specify \$CONDA_PREFIX"
  exit 1
fi

PORT=$(shuf -i8000-9999 -n1)
USER=$(whoami)
PASSWORD=${PASSWORD:-password}
TMPDIR=${TMPDIR:-tmp}

RSTUDIO_TMP="${TMPDIR}/$(echo -n ${CONDA_PREFIX} | md5sum | awk '{print $1}')"
mkdir -p ${RSTUDIO_TMP}/{run,var-lib-rstudio-server,local-share-rstudio}
mkdir -p ${HOME}/.config/rstudio

# Check if the container should be rebuilt
if [ "$REBUILD" == true ] && [ -f "$CONTAINER_PATH" ]; then
    echo "Rebuild flag detected, deleting old container: $CONTAINER_PATH"
    rm -f "$CONTAINER_PATH"
fi

if [ ! -f $CONTAINER_PATH ]; then
    mkdir -p $(dirname $CONTAINER_PATH)
	singularity build --fakeroot $CONTAINER_PATH docker://rocker/rstudio
fi

echo "Starting rstudio-server"
echo "http://$(hostname).int.cemm.at:${PORT}"

singularity exec --cleanenv \
	--bind ${RSTUDIO_TMP}/run:/run \
	--bind ${RSTUDIO_TMP}/var-lib-rstudio-server:/var/lib/rstudio-server \
	--bind /sys/fs/cgroup/:/sys/fs/cgroup/:ro \
	--bind ${REPO_PATH}/database.conf:/etc/rstudio/database.conf \
	--bind ${REPO_PATH}/rsession.conf:/etc/rstudio/rsession.conf \
    --bind ${CONDA_PREFIX}/bin/R:/usr/local/bin/R \
    --bind ${CONDA_PREFIX}/lib:/usr/local/lib \
	--bind ${RSTUDIO_TMP}/local-share-rstudio:/home/rstudio/.local/share/rstudio \
	--bind ${HOME}/.config/rstudio:/home/rstudio/.config/rstudio \
    --bind /research:/research \
    --bind /nobackup:/nobackup \
	--env RETICULATE_PYTHON=${CONDA_PREFIX}/bin/python \
	--env PASSWORD=${PASSWORD} \
    --env USER=${USER} \
    --env OMP_NUM_THREADS=${NUM_CPUS} \
	${CONTAINER_PATH} \
    rserver \
        --www-address=$(hostname).int.cemm.at \
        --www-port=${PORT} \
        --rsession-which-r=/usr/local/bin/R \
        --rsession-ld-library-path=/usr/local/lib \
        --auth-timeout-minutes=0 \
        --auth-stay-signed-in-days=30  \
        --auth-none=0 \
        --auth-pam-helper-path=pam-helper \
        --server-user $USER


