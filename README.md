# gift-api

API REST du projet Gift — application de liste de cadeaux pour couple.

## Stack technique

- **PHP** 8.4 / **Symfony** 8.0
- **API Platform** 4.x (OpenAPI auto-généré sur `/api/v1/docs`)
- **Doctrine ORM** + PostgreSQL 16
- **FrankenPHP** (PHP + Caddy, SSL Let's Encrypt automatique)
- **Tests** : PHPUnit 13

## Prérequis

- PHP 8.3+
- Composer 2.x
- Docker & Docker Compose (pour l'environnement local — Story 1.2)

## Démarrage rapide

```bash
# Installer les dépendances
composer install

# Copier et configurer les variables d'environnement
cp .env .env.local
# Éditer .env.local avec vos valeurs locales

# Vider le cache
php bin/console cache:clear

# Démarrer avec Docker Compose (Story 1.2)
docker compose up
```

## Structure

```
src/
  Entity/          # Entités Doctrine
  Repository/      # Repositories
  Service/         # Logique métier (ReservationService, EmailService, TokenService)
  Security/        # Voters Symfony (anti-spoil)
  EventSubscriber/ # Événements email, logging
  Serializer/      # Contexte anti-spoil
config/
  packages/        # Configuration Symfony (api_platform, doctrine, security…)
tests/
  Unit/            # Tests unitaires
  Functional/Api/  # Tests endpoints API
```

## Variables d'environnement clés

| Variable | Description |
|---|---|
| `DATABASE_URL` | URL PostgreSQL |
| `CORS_ALLOW_ORIGIN` | Origines autorisées (regex) |
| `RESEND_API_KEY` | Clé API Resend pour l'envoi d'emails |
| `RESEND_WEBHOOK_SECRET` | Secret HMAC webhook Resend |
| `APP_SECRET` | Secret Symfony (32+ caractères) |

## Lancer les tests

```bash
php bin/phpunit
```
