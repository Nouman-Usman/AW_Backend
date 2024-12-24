# syntax=docker/dockerfile:1.4

FROM python:3.12.6-slim as builder

# Essential build environment variables
ENV PIP_DEFAULT_TIMEOUT=500 \
    PIP_NO_CACHE_DIR=0 \
    MAKEFLAGS="-j$(nproc)"

WORKDIR /wheels

# Install build dependencies
RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    pkg-config \
    libssl-dev \
    unixodbc-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and upgrade pip
COPY requirements.txt .
RUN pip install --upgrade pip setuptools wheel

# Build PyTorch wheels first (updated versions)
RUN --mount=type=cache,target=/root/.cache/pip \
    pip wheel torch==2.4.1 \
    torchvision==0.19.1 \ 
    torchaudio==2.4.1\
     --index-url https://download.pytorch.org/whl/cpu\
    -w /wheels/ 
# Build remaining requirements
RUN --mount=type=cache,target=/root/.cache/pip \
    pip wheel --no-deps -r requirements.txt -w /wheels/

# Final stage
FROM python:3.12.6-slim

WORKDIR /app

# Install runtime dependencies and wheels
COPY --from=builder /wheels /wheels
RUN apt-get update && apt-get install -y \
    unixodbc-dev \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-index --find-links=/wheels/ torch==2.4.1 \
    torchvision==0.19.1 \ 
    torchaudio==2.4.1\
    && pip install --no-index --find-links=/wheels/ /wheels/*.whl \
    && rm -rf /wheels

# Copy application code and create upload directory
COPY . .
RUN mkdir -p uploads/profile_images

# Set runtime environment
ENV PYTHONUNBUFFERED=1 \
    PYTHONPATH=/app

EXPOSE 5000

CMD ["waitress-serve", "--host=0.0.0.0", "--port=5000", "app:app"]
