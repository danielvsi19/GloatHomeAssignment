FROM python:3.12
WORKDIR /code
RUN pip install kubernetes
COPY create_tsunami.py .
CMD [ "python", "./create_tsunami.py" ]