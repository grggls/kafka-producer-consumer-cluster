FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1

RUN pip3 install kafka-python
RUN pip3 install faker

COPY . .

CMD ["python3", "-u", "producer.py"]