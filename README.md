# Описание скриптов проекта CPU_TASK

## `asm_to_mem.py`

Скрипт переводит ассемблерный файл из `data/` в машинный код `.mem`.

Запускать из папки `scripts/`:

```bash
cd scripts
python3 asm_to_mem.py test1
```

На вход передаётся имя файла без расширения.

Например:

```bash
python3 asm_to_mem.py test1
```

Поддерживаемые инструкции:

```asm
add  r3, r1, r2
sub  r3, r1, r2
and  r3, r1, r2
or   r3, r1, r2
slt  r3, r1, r2

addi r1, r0, 5
lw   r1, 0(r0)
sw   r3, 0(r0)
beq  r1, r3, label
j    label
```

---

## `load_mem.sh`

Скрипт копирует выбранный `.mem`-файл в `data/program.mem`.

Т.к. память инструкций процессора загружает именно `program.mem`.

Запускать из папки `scripts/`:

```bash
cd scripts
./load_mem.sh ../data/test1.mem
```


---

## `run.sh`

Скрипт компилирует RTL и выбранный тестбенч, запускает симуляцию и открывает VCD-файл в GTKWave.

Запускать из папки `scripts/`:

```bash
cd scripts
./run.sh tb_cpu1
```

или:

```bash
./run.sh tb_cpu2
```

На вход передаётся имя тестбенча без расширения `.sv`.
