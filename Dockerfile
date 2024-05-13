# base image
FROM tensorflow/tensorflow:latest
LABEL org.opencontainers.image.source https://github.com/mpolinowski/tensorflow-deepface

# -----------------------------------
# create required folder
RUN mkdir -p /opt/app/notebooks

# -----------------------------------
# switch to application directory
WORKDIR /opt/app/notebooks

# -----------------------------------
# update image os
RUN apt-get update
RUN apt-get install ffmpeg libsm6 libxext6 tini -y

# -----------------------------------
# install dependencies - deepface with these dependency versions is working
RUN python -m pip install --upgrade pip
# install deepface from source code (always up-to-date)
# RUN pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host=files.pythonhosted.org -e .
RUN pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host=files.pythonhosted.org cmake==3.24.1.1
RUN pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host=files.pythonhosted.org tf-keras
RUN pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host=files.pythonhosted.org jupyter
RUN pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host=files.pythonhosted.org ultralytics Cython>=0.29.32 lapx>=0.5.5
RUN pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host=files.pythonhosted.org --ignore-installed deepface

# -----------------------------------
# environment variables
ENV PYTHONUNBUFFERED=1

# -----------------------------------
# run the app (re-configure port if necessary)
# WORKDIR /app/deepface/api/src
EXPOSE 8888

# Start the notebook
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"]
