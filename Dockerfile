
# Original source: Miniconda install copy-pasted from Miniconda's own Dockerfile reachable
# at: https://github.com/ContinuumIO/docker-images/blob/master/miniconda3/debian/Dockerfile

FROM debian:buster-slim
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Toronto
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && \
    apt-get install -y \
       wget \
       bzip2 \
       ca-certificates \
       libglib2.0-0 \
       libxext6 \
       libsm6 \
       libxrender1 \
       git \
       mercurial \
       subversion \
       cron && \
    rm -rf /var/lib/apt/lists/*

# Copy in Run and Cron scripts
COPY run.sh /usr/local/bin/run.sh
COPY cron.sh /usr/local/bin/cron.sh
COPY cron.py /usr/local/bin/cron.py
RUN chmod +x /usr/local/bin/run.sh /usr/local/bin/cron.sh

# Install Miniconda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy

# Install Miniconda Packages
RUN /opt/conda/bin/conda install pandas -y && \
    /opt/conda/bin/conda install pymongo -y && \
    /opt/conda/bin/conda install requests -y && \
    /opt/conda/bin/conda install python-dateutil -y && \
    /opt/conda/bin/python3 -m pip install exchangelib

# Entrypoint is requried to run cron
ENTRYPOINT ["run.sh"]

# Any ports required

# Bind Mount Volumes
