FROM amazonlinux

COPY hospitalmanagement /app
RUN yum -y install git
RUN yum -y install gcc openssl-devel bzip2-devel libffi-devel zlib-devel sqlite-devel

RUN yum -y install wget tar
RUN cd /opt
RUN wget https://www.python.org/ftp/python/3.7.6/Python-3.7.6.tgz
RUN tar xzf Python-3.7.6.tgz
RUN cd Python-3.7.6 &&\ 
    ./configure --enable-optimizations --enable-loadable-sqlite-extensions &&\
    make altinstall &&\
    rm /opt/Python-3.7.6.tgz

COPY hospitalmanagement/requirement.txt /tmp/requirement.txt 
RUN python3.7 -m pip install --upgrade pip setuptools wheel &&\
    python3.7 -m pip install -r /tmp/requirement.txt

WORKDIR /app
RUN python3.7 manage.py makemigrations &&\
    python3.7 manage.py migrate

EXPOSE 8000
CMD ["python3.7", "manage.py", "runserver", "0.0.0.0:8000"]
