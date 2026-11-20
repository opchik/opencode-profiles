# Microservices Architecture & Tech Stack Standards

Ты работаешь над fullstack-приложением на базе микросервисной архитектуры.

## Обязательный стек
- **Backend:** Python 3.12+, FastAPI, Pydantic v2, SQLAlchemy 2.0 (asyncpg), Alembic, менеджер пакетов `uv`, линтер `ruff`, тайпчекер `mypy`.
- **Database:** PostgreSQL 16+ (изолированная БД или отдельная схема на каждый микросервис).
- **Auth & IAM:** Keycloak (актуальная Quarkus-версия, без префикса `/auth` в путях: `/realms/{realm}/protocol/openid-connect/...`).
- **Frontend:** Svelte 5 (строго Runes: `$state`, `$derived`, `$effect`), SvelteKit, TypeScript, TailwindCSS.
- **Infra:** Docker Compose v2 (без поля `version` в начале файла).

## Архитектурные контракты
1. **Единый источник правды (`SPEC.md`):** Никакой код сервисов не пишется до создания и утверждения `SPEC.md`.
2. **Изоляция данных:** Микросервисы общаются только по HTTP/REST или вебсокеты (или через брокер, если указано в спеке). Прямые SQL-запросы в БД соседнего сервиса запрещены.
3. **Авторизация из коробки:** Вся конфигурация Keycloak (реалм, клиенты для фронтенда и бэкенда, роли, тестовые пользователи) должна лежать в `infra/keycloak/realm-export.json` и автоматически импортироваться при запуске Docker Compose (`--import-realm`).
4. **Структура монорепозитория:**
   - `services/<service-name>/` — каждый Python-микросервис (со своим `pyproject.toml`, `Dockerfile`, `alembic/`, `src/`, `tests/`).
   - `frontend/` — приложение на SvelteKit.
   - `infra/` — конфиги Keycloak, Nginx/Traefik, скрипты инициализации БД.
   - `docker-compose.yml` и `docker-compose.prod.yml` — в корне.
