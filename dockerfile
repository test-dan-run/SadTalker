FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-runtime

ENV TZ=Asia/Singapore
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install libsndfile1 (linux soundfile package)
RUN apt-get update && apt-get install -y gcc libsndfile1 ffmpeg wget \
    && rm -rf /var/lib/apt/lists/*

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE 1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED 1

RUN conda install ffmpeg dlib --channel conda-forge && conda clean -ayq
RUN pip install --upgrade --no-cache-dir pip wheel setuptools
RUN pip install --no-cache-dir torchaudio==0.11.0 --extra-index-url https://download.pytorch.org/whl/cu113
RUN pip install --no-cache-dir ffmpeg Cmake boost

ADD requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt  

WORKDIR /workspace
RUN ["bash"]
