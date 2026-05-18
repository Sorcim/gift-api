.PHONY: up down logs console migrate shell reset

up:
	docker compose up --build -d

down:
	docker compose down

logs:
	docker compose logs -f

console:
	docker compose exec api php bin/console $(c)

migrate:
	docker compose exec api php bin/console doctrine:migrations:migrate --no-interaction

shell:
	docker compose exec api sh

reset:  ## ⚠️  DESTRUCTIF — supprime TOUS les volumes dont la base de données locale
	@printf "\033[0;31m⚠️  ATTENTION : Cette commande supprime toutes les données de la base de données locale.\033[0m\n"
	@printf "Continuer ? [y/N] " && read ans && [ "$$ans" = "y" ] || exit 1
	docker compose down -v
	docker compose up --build -d

.DEFAULT_GOAL := up
