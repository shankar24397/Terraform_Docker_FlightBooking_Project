FROM python:3.9-slim

ENV PYTHONUNBUFFERED 1

WORKDIR /app

COPY . /app/

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000

# Run app.py when the container launches
CMD ["python", "manage.py", "runserver", "127.0.0.1:8000"]