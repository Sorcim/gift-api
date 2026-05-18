# gift-api

API REST du projet Gift — application de liste de cadeaux pour couple.

## Stack technique

- **PHP** 8.4 / **Symfony** 8.0
- **API Platform** 4.x (OpenAPI auto-généré sur `/api/v1/docs`)
- **Doctrine ORM** + PostgreSQL 16
- **FrankenPHP** (PHP + Caddy, SSL Let's Encrypt automatique)
- **Tests** : PHPUnit 13

## Prérequis

- Docker Desktop 4.x+ et Docker Compose v2
- Les deux repos `gift-api` et `gift-frontend` doivent être dans des répertoires frères :
  ```
  ~/dev/
    gift-api/       ← ce repo
    gift-frontend/  ← frontend (référencé via ../gift-frontend)
  ```

## Démarrage rapide avec Docker

```bash
# 1. Copier et configurer les variables d'environnement locales
cp .env.local.example .env.local
# Éditer .env.local avec vos valeurs (optionnel — les défauts suffisent pour démarrer)

# 2. Démarrer tous les services (api, frontend, db)
make up
# ou : docker compose up --build -d

# 3. Faire confiance au certificat Caddy (premier démarrage, macOS uniquement)
# La commande suivante exporte le CA local de Caddy et l'ajoute au Keychain macOS :
docker compose cp api:/data/caddy/pki/authorities/local/root.crt ./caddy-local-ca.crt
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ./caddy-local-ca.crt
# ℹ️  `docker compose exec api caddy trust` ne fait confiance que dans le conteneur, pas sur l'hôte.

# Services disponibles :
# - API Symfony : https://localhost (HTTPS auto-signé)
# - Frontend Next.js : http://localhost:3000
# - PostgreSQL : localhost:5432 (via compose.override.yaml)
```

## Commandes Make

| Commande | Description |
|---|---|
| `make up` | Démarrer tous les services (`--build -d`) |
| `make down` | Arrêter les services |
| `make logs` | Suivre les logs en temps réel |
| `make shell` | Ouvrir un shell dans le conteneur `api` |
| `make migrate` | Lancer les migrations Doctrine |
| `make console c="cache:clear"` | Exécuter une commande Symfony |
| `make reset` | ⚠️ Détruire **tous les volumes** (données BDD perdues) et redémarrer |

## Variables d'environnement

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
