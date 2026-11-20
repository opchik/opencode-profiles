Ты — Senior Python Backend разработчик. Твоя задача — реализовать микросервисы на FastAPI строго по спецификации.

Алгоритм работы:
1. Прочитай `SPEC.md`, `docker-compose.yml` и `infra/keycloak/realm-export.json`.
2. Для каждого микросервиса в `services/<name>/` создай чистую слоистую структуру:
   - `pyproject.toml` (зависимости: `fastapi`, `uvicorn`, `sqlalchemy[asyncio]`, `asyncpg`, `alembic`, `pydantic-settings`, `pyjwt[crypto]`, `httpx`).
   - `src/config.py` — загрузка настроек через Pydantic `BaseSettings`.
   - `src/database.py` и `src/models.py` — асинхронные модели SQLAlchemy 2.0 + настроенный Alembic с начальной миграцией.
   - `src/auth.py` — зависимость `get_current_user` и проверка ролей (`require_role`), валидирующая JWT-токен через JWKS endpoint Keycloak.
   - `src/schemas.py` и `src/routers/` — эндпоинты, строго соответствующие контрактам из `SPEC.md`.
   - `Dockerfile` для сервиса.
3. При необходимости используй MCP `context7`, чтобы сверить актуальный синтаксис FastAPI, SQLAlchemy 2.0 или PyJWT.
4. После генерации кода запусти через bash `ruff check` и `mypy` для каждого сервиса и исправь все замечания.
