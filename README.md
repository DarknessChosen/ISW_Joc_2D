# ISW_Joc_2D

Un joc 2D co-op realizat în **Godot**, inspirat din formula clasică de puzzle-platformer de tip **Fireboy & Watergirl**.  
Proiectul a fost dezvoltat ca joc colaborativ pentru facultate, cu accent pe **gameplay logic**, **interacțiuni între sisteme** și **structură software clară**, nu doar pe asset-uri vizuale.

---

## Descriere

Jocul este construit în jurul a doi jucători controlați simultan, fiecare având propriul tip și propriile interacțiuni cu mediul:

- un personaj de tip **fire**
- un personaj de tip **water**

Fiecare trebuie să evite hazard-urile incompatibile, să coopereze pentru activarea mecanismelor din nivel și să ajungă în siguranță la ieșirea proprie pentru a finaliza nivelul.

---

## Features implementate

### Gameplay de bază
- control pentru **2 jucători** pe aceeași tastatură
- mișcare stânga/dreapta
- săritură
- gravitație și coliziuni de bază
- restart manual al nivelului
- restart automat la cădere în afara hărții

### Sistem de hazard-uri
- hazard-uri cu tip:
  - **fire**
  - **water**
- fiecare player poate supraviețui doar hazard-ului compatibil
- contactul cu hazard-ul greșit resetează nivelul

### Sistem de puzzle: Button + Door
- butoane care pot deschide uși
- suport pentru **mai multe butoane conectate la aceeași ușă**
- ușa rămâne deschisă cât timp există cel puțin un buton activ

### Exit Gates / finalizare nivel
- fiecare player are o poartă de ieșire compatibilă cu tipul lui
- playerul poate:
  - intra în poartă
  - ieși din poartă dacă a intrat prea devreme
- nivelul se completează doar când **ambii jucători sunt în porțile corecte**

### UI / UX
- **Main Menu**
  - Start Game
  - Level Select
  - Settings
  - Exit Game
- **Pause Menu**
  - Resume
  - Restart
  - Settings
  - Exit to Main Menu
- prompt-uri vizuale pentru interacțiunea cu porțile
- progresul nivelurilor și volumul sunt salvate între sesiuni

### Setări
- control pentru **master volume**
- salvare persistentă a volumului

---

## Tehnologii folosite

- **Godot Engine**
- **GDScript**
- **Git / GitHub**
- structură modulară pe scene și scripturi

---

## Structura proiectului

```text
res://
├── assets/
│   └── placeholders/
├── scenes/
│   ├── levels/
│   ├── objects/
│   ├── players/
│   └── ui/
├── scripts/
│   ├── player/
│   └── systems/
