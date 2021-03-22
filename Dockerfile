FROM ubuntu:18.04
MAINTAINER "Shannon Quinn magsol@gmail.com" 

# Set up ubuntu a bit.
RUN apt-get update && apt-get install -y wget build-essential cmake unzip vim \
    protobuf-compiler
RUN apt update && apt install -y git

# Download Python.
ENV MINICONDA Miniconda3-latest-Linux-x86_64.sh
RUN echo 'export PATH=/opt/conda/bin:$PATH' > conda.sh && mv conda.sh /etc/profile.d/
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    chmod +x ${MINICONDA} && /bin/bash ${MINICONDA} -b -p /opt/conda && \
    rm ${MINICONDA}
ENV PATH /opt/conda/bin:$PATH
RUN conda update -y --all && conda install -y -c conda-forge \
    ipython joblib jupyter matplotlib numpy scipy pandas pillow \
    pip scikit-image scikit-learn

# Get the SC2 ladder environment set up.
RUN git clone --recursive https://github.com/Cryptyc/Sc2LadderServer.git
RUN cd Sc2LadderServer && mkdir build && cd build && cmake ../ && make -j 8 && \
    cd ../..
RUN wget http://blzdistsc2-a.akamaihd.net/Linux/SC2.4.10.zip && \
    unzip -P iagreetotheeula -oq SC2.4.10.zip -d / && \
    wget https://github.com/deepmind/pysc2/releases/download/v1.0/mini_games.zip && \
    unzip -P iagreetotheeula -oq mini_games.zip -d /StarCraftII/Maps/ && \
    rm SC2.4.10.zip && rm mini_games.zip
RUN pip install pysc2
RUN wget http://blzdistsc2-a.akamaihd.net/MapPacks/Ladder2019Season3.zip && \
    unzip -P iagreetotheeula -oq Ladder2019Season3.zip -d /StarCraftII/Maps/ && \
    rm Ladder2019Season3.zip

# Not really sure what to do at this point...
# - How to set up pysc2 mini-games?
# - How to configure pysc2 bots?
# - What is the role of Sc2LadderServer?
# - Where can bot v bot play be specified?

RUN git clone https://github.com/Archiatrus/pysc2-ladderbot
