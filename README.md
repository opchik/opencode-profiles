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
2. Создать файлы с адресом и ключом своего vLLM-хоста (один раз, общие для всех профилей):
```bash
echo "http://<host>:8000/v1" > ~/.opencode.url
echo "<api-key>" > ~/.opencode.key
chmod 600 ~/.opencode.url ~/.opencode.key
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

`oc-use <профиль>` при первом переключении создаёт `profiles/<профиль>/opencode.local.json` из `shared/opencode.local.example.json`. Отредактируйте его под свой хост: имя провайдера, ID и название модели, лимиты контекста. Адрес и ключ читаются из `~/.opencode.url` / `~/.opencode.key` (подстановка `{file:...}`), в самом конфиге секретов нет.

Файл можно переиспользовать между профилями: содержимое `opencode.local.json` у всех профилей одинаковое, если хост один.

## Новый профиль

1. `mkdir profiles/<name>`
2. Создать `opencode.profile.json` (агенты, MCP, permission — всё, что не зависит от машины)
3. При необходимости `AGENTS.md` и `prompts/*.md`
4. `oc-use <name>` — личный конфиг подхватится автоматически
