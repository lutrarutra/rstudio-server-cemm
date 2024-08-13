# Info

- Based on [rocker-project](https://rocker-project.org/use/singularity.html) and [rstudio-server-conda](https://github.com/grst/rstudio-server-conda)


# Setup


## Clone Repo
- *On the cluster,* clone the repository to, e.g. your home directory `/home/<user-name>/`:
    -  `git clone https://github.com/lutrarutra/rstudio-server-cemm rstudio-server`

## Conda Environment

### 0. (Optional) Install Mamba if you don't have Conda/Mamba installed.
- Download installer script
    - `wget https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh`
- Install somewhere on nobackup (it will ask after you have agreed for terms and conditions),
e.g. `/nobackup/<lab-name>/users/<user-name>/mambaforge`
- Execute installer script
    - `bash Mambaforge-$(uname)-$(uname -m).sh`
- Init mamba (if you haven't yet)
    - `mamba init`
    - `source ~/.bashrc` to finalize mamba -> you should see `(base)` in front of your prompt

### 1. You can use your existing conda environment with R:
- change line `conda activate rstudio-server` in `rstudio-server/submit.sh` to `conda activate <your env name>`
### or Create a new Conda environment
- Create conda/mamba environment
    - `conda env create -f rstudio-server/environment.yml`
    or
    - `mamba env create -f rstudio-server/environment.yml`

### 2. Create Slurm submission script
- Copy  `rstudio-server/submit.template.sh` to `rstudio-server/submit.sh`
- Modify `rstudio-server/submit.sh`:
    1. set `repository path`, path of the repo wherever you cloned it, e.g. `/home/<user-name>/rstudio-server`
    2. set `PASSWORD` to your preferred password (this is asked by rstudio when connecting)
    3. set container path, e.g. somewhere on nobackup `/nobackup/<your lab dir>/users/$(whoami)/containers/rstudio_latest.sif`

# Start RStudio Server
- `sbatch rstudio-server/submit.sh`
- Open the link from log-file `rstudio-server.log` (should be in repo folder) in your browser, e.g. `http://dYYY.int.cemm.at:XXXX`
- When you run for the first time, it will take couple minutes to download and setup the container.





