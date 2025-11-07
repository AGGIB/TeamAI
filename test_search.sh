#!/bin/bash

# Получить токен
TOKEN=$(curl -s -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"ivan@gmail.com","password":"password123"}' | \
  python3 -c "import sys, json; print(json.load(sys.stdin)['data']['accessToken'])")

echo "=== Тест 1: Поиск по 'gmail' ==="
curl -s "http://localhost:8080/api/users/search?email=gmail" \
  -H "Authorization: Bearer $TOKEN" | python3 -m json.tool

echo -e "\n=== Тест 2: Поиск по 'maria' ==="
curl -s "http://localhost:8080/api/users/search?email=maria" \
  -H "Authorization: Bearer $TOKEN" | python3 -m json.tool

echo -e "\n=== Тест 3: Поиск по 'ivan' ==="
curl -s "http://localhost:8080/api/users/search?email=ivan" \
  -H "Authorization: Bearer $TOKEN" | python3 -m json.tool

echo -e "\n=== Тест 4: Поиск по '@gmail.com' ==="
curl -s "http://localhost:8080/api/users/search?email=@gmail.com" \
  -H "Authorization: Bearer $TOKEN" | python3 -m json.tool
