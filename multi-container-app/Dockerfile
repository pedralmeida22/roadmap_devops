FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
COPY app.py .
RUN pip3 install -r requirements.txt
CMD ["python", "app.py"]
