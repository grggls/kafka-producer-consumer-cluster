FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1

RUN pip3 install kafka-python


COPY . .

CMD ["python3", "-u", "consumer.py"]