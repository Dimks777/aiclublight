---
name: prompt-engineer
description: "Создание и оптимизация промптов для Claude, GPT и других LLM. Активируется на: промпт, prompt, системный промпт, инструкция для агента, create prompt, улучши промпт, напиши промпт, промпт для агента, промпт для задачи."
triggers:
  - промпт
  - prompt
  - оптимизация промпта
  - промпт инженерия
  - system prompt
---



# Prompt Engineer — Мастер промптов

Универсальный инженер промптов для создания production-ready инструкций для любых языковых моделей.

**Ключевой принцип:** Ясность > Сложность. Неопределённость — главная причина провала промптов.

---

## Параметры по модели

| Модель | Особенности | Оптимизация |
|--------|-------------|-------------|
| **Claude** | XML теги, thinking | Структурированность |
| **GPT** | Function calling, JSON | Точные форматы |
| **Gemini** | Многомодальность | Контекст + медиа |
| **o1/o3** | Reasoning models | Минимальные промпты |

---

## Workflow

### 1. Анализ задачи
- Определение типа задачи
- Выбор подходящих техник
- Планирование структуры

### 2. Создание основы
- Роль и контекст
- Чёткие инструкции
- Примеры (few-shot)

### 3. Оптимизация
- Тестирование на крайних случаях
- Добавление ограничений
- Проверка форматирования

### 4. Валидация
- A/B тест вариантов
- Метрики качества
- Итерационные улучшения

---

## Ключевые техники

### 1. Chain of Thought (CoT)
```
Think step by step:
1. Analyze the problem
2. Identify key factors
3. Apply reasoning
4. Provide conclusion
```

### 2. Few-Shot Learning
```
Examples:
Input: [пример 1] → Output: [результат 1]
Input: [пример 2] → Output: [результат 2]

Now process: [новый input]
```

### 3. Role Prompting
```
You are an expert [РОЛЬ] with [ОПЫТ].
Your task is to [ЗАДАЧА] using your expertise in [ОБЛАСТЬ].
```

### 4. XML Structure (Claude)
```
<task>
[описание задачи]
</task>

<examples>
[примеры]
</examples>

<output_format>
[формат ответа]
</output_format>
```

### 5. ReAct (Reasoning + Acting)
```
Thought: [что думаю]
Action: [что делаю]
Observation: [что получил]
... repeat until done
Final Answer: [итоговый ответ]
```

### 6. Tree of Thoughts (ToT)
```
Generate 3 different approaches to solve this:
Approach 1: [решение 1]
Approach 2: [решение 2]
Approach 3: [решение 3]

Evaluate each approach and select the best one.
```

---

## Шаблоны промптов

### Классификация
```
Classify the following [ОБЪЕКТ] into one of these categories: [КАТЕГОРИИ]

[ОБЪЕКТ]: [INPUT]

Category: [ВЫБОР ИЗ КАТЕГОРИЙ]
Confidence: [0-100%]
Reasoning: [ОБОСНОВАНИЕ]
```

### Анализ
```
Analyze the following [ДАННЫЕ] and provide insights on:
1. [АСПЕКТ 1]
2. [АСПЕКТ 2]
3. [АСПЕКТ 3]

Format as structured analysis with recommendations.
```

### Агент с инструментами
```
You have access to these tools:
- search(query): Search information
- calculate(expression): Perform calculations
- generate_image(prompt): Create images

Use tools when needed to complete the user's request.
```

---

## Оптимизация под модели

**Claude (Anthropic):**
- XML теги для структуры
- Thinking теги для рассуждений
- Чёткие role definitions

**GPT (OpenAI):**
- JSON форматы
- Function calling
- System/User/Assistant разделение

**Gemini (Google):**
- Мультимодальные промпты
- Длинные контексты
- Код + объяснения

---

## Отладка промптов

| Симптом | Возможная причина | Решение |
|---------|-------------------|---------|
| Неточные результаты | Нет примеров | Добавить few-shot |
| Разный формат ответов | Нет чёткой структуры | Задать output_format |
| Галлюцинации | Слишком творческая задача | Добавить ограничения |
| Медленная работа | Перегруженный промпт | Упростить инструкции |
| Не понимает контекст | Недостаточно контекста | Добавить background |

---

## Метрики качества

| Метрика | Что измеряет |
|---------|-------------|
| **Точность** | Правильность результатов |
| **Консистентность** | Стабильность ответов |
| **Релевантность** | Соответствие задаче |
| **Полнота** | Охват всех аспектов |
| **Ясность** | Понятность результата |

---

## Частые ошибки

❌ **Неясные инструкции** — "сделай хорошо" вместо конкретики
❌ **Отсутствие примеров** — модель не понимает ожидания
❌ **Перегруженность** — слишком много задач в одном промпте
❌ **Игнорирование формата** — нет чёткой структуры ответа
❌ **Амбивалентность** — противоречивые требования
❌ **Отсутствие контекста** — модель не знает предметную область
❌ **Нет обработки крайних случаев** — промпт падает на исключениях
