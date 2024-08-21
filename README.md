# Info

- Based on [rocker-project](https://rocker-project.org/use/singularity.html) and [rstudio-server-conda](https://github.com/grst/rstudio-server-conda)


# Setup


## 0. Clone Repo
- *On the cluster,* clone the repository to, e.g. your home directory `/home/<user-name>/`:
    -  `git clone https://github.com/lutrarutra/rstudio-server-cemm rstudio-server`

## 0.1 (Optional) Install Mamba if you don't have Conda/Mamba installed.
- Download installer script
    - `wget https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh`
- Install somewhere on nobackup (it will ask after you have agreed for terms and conditions),
e.g. `/nobackup/<lab-name>/users/<user-name>/mambaforge`
- Execute installer script
    - `bash Mambaforge-$(uname)-$(uname -m).sh`
- Init mamba (if you haven't yet)
    - `mamba init`
    - `source ~/.bashrc` to finalize mamba -> you should see `(base)` in front of your prompt

## 1. Define parameters
- Copy  `rstudio-server/.env.template` to `rstudio-server/.env`
- Change parameters `rstudio-server/.env` as you wish.
- Give execute permission to `rstudio-server/run.sh`
    - `chmod u+x rstudio-server/run.sh`

# Start RStudio Server
- Run the script
    - `rstudio-server/run.sh`
- Open the link from log-file `rstudio-server.log` in your browser, e.g. `http://dYYY.int.cemm.at:XXXX`
- When you run for the first time, it will take couple minutes to download and setup the container.


# Github Co-Pilot
You can enable Github Co-Pilot in RStudio by following the instructions by:
- Tools &#8594; Global Options &#8594; Copilot &#8594; Enable Github Copilot & Sign In with Github


# Issues:
### 'R is taking longer to start than usual'
- Happens when you have saved a large workspace on the previous session and RStudio tries to load it.
- Solution: wait or delete the `.RData` file in your home directory: `rm ~/.RData`, then cancel the job and re-run the script.
- You can also disable auto loading the workspace on startup by unchecking the box in the RStudio settings.




