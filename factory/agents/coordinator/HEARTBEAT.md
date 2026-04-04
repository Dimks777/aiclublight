# HEARTBEAT.md

## Every heartbeat
1. Check context (session_status)
2. If context > 80% — save important data to memory/
3. If brand/ was updated — note in memory/active-context.md

## Pre-compaction (MANDATORY — before ANY /compact)
Before compaction — automatically save to MEMORY.md:
- Key decisions and agreements from current session
- Owner corrections and new preferences
- Active tasks and their status
- Important context that must survive compaction

Steps:
1. Read current MEMORY.md
2. Append new decisions/agreements under today's date
3. Update memory/active-context.md
4. Only then proceed with /compact

## After every conversation
After each session with SD — record key decisions and agreements in MEMORY.md automatically, without being asked.

## Rules
- Quiet hours: 23:00-07:00 — do not suggest tasks
- If nothing to do → HEARTBEAT_OK
