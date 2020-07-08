FROM jupyter/scipy-notebook:76402a27fd13

RUN pip install jupyter-book && \
    jupyter lab build
