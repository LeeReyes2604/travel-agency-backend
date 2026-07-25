# Docker Setup

## 1. Clone the Repository

```bash
git clone <repository-url>
cd <project-directory>
```

---

## 2. Create the Environment File

Copy the environment template:

```bash
cp .env.template .env
```

Update the required values in `.env`.

### Google reCAPTCHA v2

Create a **Google reCAPTCHA v2 ("I'm not a robot" Checkbox)** site by following the instructions at:

https://cloud.google.com/security/products/recaptcha

Obtain the **Site Key** and **Secret Key**, then add them to your `.env` file:

```env
RECAPTCHA_SITE_KEY=your-site-key
RECAPTCHA_SECRET_KEY=your-secret-key
```

Also configure your frontend to use the same **Site Key** for Google reCAPTCHA.

### JWT Secret

Generate a secure JWT secret:

```bash
openssl rand -hex 64
```

Add it to your `.env` file:

```env
JWT_SECRET=your-generated-secret
```

### CORS Origins

Configure the frontend URLs that are allowed to access the API.

For local React development, this is typically:

```env
CORS_ORIGINS=http://localhost:5173
```

If multiple frontend URLs need access, separate them with commas:

```env
CORS_ORIGINS=http://localhost:5173,http://localhost:4173,https://example.com
```

> For Vite development, the default frontend URL is usually `http://localhost:5173`.

---

## 3. Create the Settings File

```bash
cp config/settings.example.yml config/settings.yml
```

Update `config/settings.yml` as needed.

---

## 4. Build the Docker Images

```bash
docker compose build
```

---

## 5. Start the Application

```bash
docker compose up
```

Or run in the background:

```bash
docker compose up -d
```

The application will be available at:

```text
http://localhost:3000
```

---

# Common Commands

## Open a Bash Shell

```bash
docker compose exec web bash
```

## Rails Console

```bash
bundle exec rails console
```

## Generate Files

```bash
bundle exec rails g model User name:string email:string
```

## Run Migrations

```bash
bundle exec rails db:migrate
```

## Stop the Application

```bash
docker compose down
```