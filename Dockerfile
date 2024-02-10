FROM continuumio/anaconda3

RUN apt update \
 && apt install -y liblttng-ust0 \
                   libcurl4 \
                   libcurl4-openssl-dev \
                   gcc g++ \
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

RUN conda create -n py38 python=3.8 pip
RUN echo "source activate py38" >> ~/.bashrc \
 && echo "source ~/.docker-prompt" >> ~/.bashrc

ENV PATH /opt/conda/envs/env/bin:$PATH

COPY requirements.txt .
RUN ~/.conda/envs/py38/bin/pip install -r requirements.txt
RUN ~/.conda/envs/py38/bin/pip install -r ~/.conda/envs/py38/lib/python3.8/site-packages/azureml/automl/core/validated_linux_requirements.txt

COPY src /src
ENV PYTHONPATH "/src:$PYTHONPATH"
