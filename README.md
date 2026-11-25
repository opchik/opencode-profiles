# opencode-profiles

Профили конфигурации [opencode](https://opencode.ai): переключение набора агентов, MCP-серверов и разрешений одной командой.

## Структура

| Файл | В git | Назначение |
|---|---|---|
| `shared/base.json` | да | Общее для всех профилей: permission, MCP context7 |
| `shared/opencode.local.example.json` | да | Шаблон личного конфига |
| `profiles/<name>/opencode.profile.json` | да | Обобщённый конфиг профиля: агенты, MCP, permission |
| `profiles/<name>/AGENTS.md`, `prompts/` | да | Правила и промпты профиля |
| `profiles/<name>/opencode.local.json` | **нет** | Личное: провайдер, модель, url/key. Создаётся автоматически из шаблона при первом `oc-use` |
| `profiles/<name>/opencode.json` | **нет** | Итоговый конфиг, собирается автоматически: `base + profile + local` |
| `node_modules/`, `package*.json`, `bun.lock` | **нет** | Runtime-артефакты opencode (зависимости плагинов), создаются при запуске |

## Настройка

1. Склонировать в `~/.config`:
```bash
git clone <url> ~/.config/opencode-profiles
```
2. Создать файлы с адресом и ключом DeepSeek-эндпоинта (один раз, общие для всех профилей):
```bash
echo "https://api.deepseek.com/v1" > ~/.deepseek.url
echo "<api-key>" > ~/.deepseek.key
chmod 600 ~/.deepseek.url ~/.deepseek.key
```
3. Добавить alias в `~/.bashrc`:
```bash
alias oc-use="$HOME/.config/opencode-profiles/switch.sh"
```
4. Перезапустить shell. Требуется установленный `jq`.

## Использование

1. Настройка окружения (на примере микросервисов):
```bash
oc-use microservices
```
2. Запуск в папке текущего проекта:
```bash
opencode
```
3. В правом нижнем углу можно выбрать агента
4. После работы переключить на обычный режим для других задач:
```bash
oc-use default
```

## Личный конфиг

`oc-use <профиль>` при первом переключении создаёт `profiles/<профиль>/opencode.local.json` из `shared/opencode.local.example.json`. Отредактируйте его под свой эндпоинт: имя провайдера, ID и название модели, лимиты контекста. Адрес и ключ читаются из `~/.deepseek.url` / `~/.deepseek.key` (подстановка `{file:...}`), в самом конфиге секретов нет.

Файл можно переиспользовать между профилями: содержимое `opencode.local.json` у всех профилей одинаковое, если эндпоинт один.

## Профиль microservices

Профиль для разработки fullstack-приложения на микросервисах (FastAPI + PostgreSQL + Keycloak + Svelte 5). Все агенты используют единую модель из `opencode.local.json` (`deepseek/deepseek-flash`, отображаемое имя — `DeepSeek-V4.1-Flash-1017`).

Пайплайн с двумя контрольными точками:

1. `@orchestrator` (по умолчанию) изучает идею и пишет подробное ТЗ в `SPEC.md`. Код и конфиги он не пишет — только документы.
2. **Контрольная точка 1:** вы читаете и одобряете `SPEC.md`. До одобрения работа не продолжается.
3. После одобрения последовательно запускаются:
   - `@architect` — `docker-compose.yml`, `infra/keycloak/realm-export.json`, init БД, `.env.example`, OpenAPI-контракты;
   - `@backend` — микросервисы в `services/**`;
   - `@frontend` — клиент в `frontend/**`.
4. **Контрольная точка 2:** вы запускаете и тестируете дизайн.
5. После согласия `@qa-devops` пишет тесты, проверяет стек в Docker, настраивает `docker-compose.prod.yml`, скрипт деплоя на боевой сервер и CI/CD.

Промпты агентов — в `profiles/microservices/prompts/`, правила стека — в `profiles/microservices/AGENTS.md`.

## Новый профиль

1. `mkdir profiles/<name>`
2. Создать `opencode.profile.json` (агенты, MCP, permission — всё, что не зависит от машины)
3. При необходимости `AGENTS.md` и `prompts/*.md`
4. `oc-use <name>` — личный конфиг подхватится автоматически
