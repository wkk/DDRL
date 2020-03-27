FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

WORKDIR /ddrl

RUN apt update && apt install -y wget

RUN wget -q https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh -O anaconda.sh

RUN sh anaconda.sh -b -p /anaconda

ENV PATH /anaconda/bin:$PATH

RUN mkdir /notebooks

RUN conda update -y conda && \
    conda update -y anaconda && \
    conda update -y --all

RUN conda install -y -c pytorch pytorch

EXPOSE 8888

CMD ["jupyter", "notebook", "--port=8888", "--ip='*'", "--no-browser", "--allow-root", "--notebook-dir=/notebooks"]
