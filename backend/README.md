# AleOkaz Backend

Backend aplikacji dla wędkarzy AleOkaz.

## Użycie

### Development

```sh
docker compose -f compose.yaml -f compose.development.yaml up --detach
./mvnw spring-boot:run
```

### Produkcja

```sh
docker compose -f compose.yaml -f compose.production.yaml up --detach
```

## Instalacja

### Prerekwizyty

- Git
- Docker
- Java 21

### Przepis

```sh
git clone https://github.com/jgeb28/AleOkaz
cd AleOkaz/backend
cp .env.example .env
```

## Endpointy

### Reset hasła
POST /api/recovery email, Wysłanie tokenu\
POST /api/recovery/verifyToken   email, token   Zweryfikowanie tokenu\
POST /api/recovery/resetPassword email, token, password    Ustawienie nowego hasła