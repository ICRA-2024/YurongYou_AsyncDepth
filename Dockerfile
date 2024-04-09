FROM nvidia/cuda:11.3.1-devel-ubuntu20.04

RUN apt-get update && apt-get install wget -yq
RUN apt-get install build-essential g++ gcc -y
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install libgl1-mesa-glx libglib2.0-0 -y
RUN apt-get install openmpi-bin openmpi-common libopenmpi-dev libgtk2.0-dev git -y

# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
     /bin/bash ~/miniconda.sh -b -p /opt/conda
# Put conda in path so we can use conda activate
ENV PATH=$CONDA_DIR/bin:$PATH
RUN conda install python=3.8
RUN conda install pytorch==1.10.1 torchvision==0.11.2 torchaudio==0.10.1 cudatoolkit=11.3 -c pytorch -y
RUN pip install Pillow==8.4.0
RUN pip install tqdm
RUN pip install torchpack
ENV CUDA_HOME="/usr/local/cuda-11.3"
RUN MMCV_WITH_OPS=1 FORCE_CUDA=1 pip install mmcv-full==1.4.0 -f https://download.openmmlab.com/mmcv/dist/cu113/torch1.10/index.html
RUN pip install mmcv==1.4.0 mmcv-full==1.4.0 mmdet==2.20.0
RUN pip install nuscenes-devkit
RUN pip install mpi4py==3.0.3
RUN pip install numba==0.48.0
RUN pip install numpy==1.20.3 yapf==0.40.1 setuptools==59.5.0 trimesh==4.1 wandb
RUN pip install -U git+https://github.com/lyft/nuscenes-devkit
RUN pip install git+https://github.com/cdiazruiz/ithaca365-devkit.git
RUN conda install pytorch-scatter -c pyg -y
RUN apt-get install libopenblas-dev ninja-build -y
RUN git clone https://github.com/NVIDIA/MinkowskiEngine.git \
    && cd MinkowskiEngine \
    && git checkout c854f0c \
    && python setup.py install --force_cuda
