# Вибираємо базовий образ Python
FROM python:3.11-slim

# Встановлюємо робочу директорію
WORKDIR /app

# Створюємо мінімальний requirements.txt
RUN echo "Flask" > requirements.txt

# Встановлюємо залежності
RUN pip install --no-cache-dir -r requirements.txt

# Створюємо простий Flask додаток
RUN echo "from flask import Flask\napp = Flask(__name__)\n\n@app.route('/')\ndef hello():\n    return 'Hello from Docker!'\n\nif __name__ == '__main__':\n    app.run(host='0.0.0.0', port=8000)" > app.py

# Відкриваємо порт
EXPOSE 8000

# Команда для запуску контейнера
CMD ["python", "app.py"]
