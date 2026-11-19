# opencode-profiles

## Настройка
1. Склонировать в ```~/.config```
2. Добавить alias в ```~/.bashrc```:
```bash
alias oc-use="$HOME/.config/opencode-profiles/switch.sh"
```
3. Сделать файл исполняемым:
```bash
chmod +x switch.sh
```

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
4. После работы переключить на обычный режим для других задач
```bash
oc-use default
```