# Используем официальный образ Python 3.9 с минимальным размером
FROM python:3.9-slim

# Устанавливаем основные зависимости системы
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    gnupg \
    ca-certificates \
    libnss3 \
    libatk-bridge2.0-0 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm-dev \
    libgtk-3-0 \
    libasound2 \
    fonts-liberation \
    libappindicator3-1 \
    xdg-utils && \
    rm -rf /var/lib/apt/lists/*

# Устанавливаем Playwright
RUN pip install --no-cache-dir playwright

# Устанавливаем браузеры для Playwright
RUN playwright install

# Устанавливаем необходимые Python-зависимости (если есть файл requirements.txt)
# COPY requirements.txt /app/requirements.txt
# WORKDIR /app
# RUN pip install --no-cache-dir -r requirements.txt

# Копируем исходный код сервиса
COPY . /app

# Устанавливаем команду для автообновления при изменении файлов
RUN pip install watchdog[watchmedo]

# Указываем команду для запуска с автообновлением
CMD ["sh", "-c", "watchmedo auto-restart --patterns='*.py' --recursive -- python script.py"]
