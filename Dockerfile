FROM ubuntu
MAINTAINER armen
RUN apt-get update -y && apt-get install -y python3-pip python-dev
COPY ./requirements.txt /app/requirements.txt
WORKDIR /notejam
RUN pip install -r requirements.txt
COPY ./ . /notejam/
EXPOSE 80
ENTRYPOINT ["python"]
CMD ["runserver.py"]

