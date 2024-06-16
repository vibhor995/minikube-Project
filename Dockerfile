FROM python:3.9-slim

WORKDIR /appvibhor

COPY ping_pong_vibhor.py /appvibhor

RUN pip install Flask

CMD ["python", "ping_pong_vibhor.py"]

