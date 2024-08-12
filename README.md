# Info

- Based on [rocker-project](https://rocker-project.org/use/singularity.html) and [rstudio-server-conda](https://github.com/grst/rstudio-server-conda)


# Setup


## Clone Repo
- `git clone https://github.com/lutrarutra/rstudio-server-cemm rstudio-server`

## Conda Environment

### 0. (Optional) Install Mamba if you don't have Conda/Mamba
- Download installer script
    - `wget https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh`
- Install somewhere on nobackup (it will ask after you have agreed for terms and conditions),
e.g. `/nobackup/<lab-name>/users/<user-name>/mambaforge`
- Execute installer script
    - `bash Mambaforge-$(uname)-$(uname -m).sh`
- Init mamba (if you haven't yet)
    - `mamba init`
    - `source ~/.bashrc` to finalize mamba -> you should see `(base)` in front of your prompt

### 1. Create conda environment
- Create conda/mamba environment
    - `conda env create -f rstudio-server/environment.yml`
    or
    - `mamba env create -f rstudio-server/environment.yml`

### 2. Create Slurm submission script
- Copy  `rstudio-server/submit.template.sh` to `rstudio-server/submit.sh`
- Modify `rstudio-server/submit.sh`:
    1. set `repository path`, wherever you cloned the repo in to
    2. set `PASSWORD` to your preferred password (this is asked by rstudio when connecting)
    3. set container path, e.g. somewhere on nobackup `/nobackup/<your lab dir>/users/$(whoami)/containers/rstudio_latest.sif`

# Start RStudio Server
- `sbatch rstudio-server/submit.sh`
- Open the link from log-file `rsutdio-server.log` (should be in repo folder) in your browser, e.g. `http://dYYY.int.cemm.at:XXXX`






