FROM continuumio/anaconda3

RUN apt update \
 && apt install -y liblttng-ust0 \
                   libcurl4 \
                   libcurl4-openssl-dev \
 && rm -rf /var/lib/apt/lists/*

# Set user and group
ARG uid=1000
ARG gid=1000
RUN groupadd -g ${gid} automl
RUN useradd -u ${uid} -g automl -s /bin/sh -m automl
USER automl

WORKDIR /home/automl

# Add nicer looking prompt
# from https://gist.github.com/scmx/242caa249b0ea343e2588adea14479e6
COPY .docker-prompt .

RUN conda create -n py37 python=3.7 pip
RUN echo "source activate py37" >> ~/.bashrc \
 && echo "source ~/.docker-prompt" >> ~/.bashrc

ENV PATH /opt/conda/envs/env/bin:$PATH

RUN ~/.conda/envs/py37/bin/pip install azure-ai-ml \
                                       azureml-core \
                                       sklearn \
                                       azureml-train-automl-client \
                                       azureml-dataprep[pandas]

COPY src /src
ENV PYTHONPATH "/src:$PYTHONPATH"
