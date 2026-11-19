# opencode-profiles

## Настройка
1. Склонировать в ~/.config
2. Добавить alias в ```~/.bashrc```:
```bash
alias oc-use="$HOME/.config/opencode-profiles/switch.sh"
```
3. Сделать файл исполняемым:
```bash
chmod +x switch.sh
```
4. Использование конкретной настройки opencode:
```bash
oc-use microservices   # Включил команду под микросервисы
```
```bash
opencode               # Запустил
```
```bash
oc-use default         # Вернул обычный режим для других задач
```