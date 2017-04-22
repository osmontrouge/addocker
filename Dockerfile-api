FROM python:3.5

RUN apt-get update
RUN apt-get install --yes redis-tools

WORKDIR /app

RUN pip install cython
RUN pip install addok
RUN pip install addok-fr
RUN pip install addok-france
RUN pip install addok-csv
RUN pip install gunicorn

COPY local.py /app
COPY startup.sh /bin
COPY import.sh /bin

ENV ADDOK_CONFIG_MODULE /app/local.py
ENV REDIS_HOST redis

EXPOSE 7878

CMD startup.sh
