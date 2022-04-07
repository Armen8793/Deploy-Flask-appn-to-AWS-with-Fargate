FROM ubuntu:latest
MAINTAINER Armen Petrosyan
RUN apt-get update -y 
RUN apt-get install -y python3-pip python-dev build-essential
COPY ./app
WORKDIR /app
RUN pip install -r requirements.txt
EXPOSE 80
ENTRYPOINT ["python"]
CMD ["app.py"]

