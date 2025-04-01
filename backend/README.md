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
POST /api/recovery                  {email}                     Wysłanie tokenu\
POST /api/recovery/verifyToken      {email, token}              Zweryfikowanie tokenu\
POST /api/recovery/resetPassword    {email, token, password}    Ustawienie nowego hasła

### Znajomi
GET  /api/friends/all                       Lista wszystkich znajomych\
GET  /api/friends/allof/{username}                       Lista wszystkich zaakceptowanych znajomych użytkownika o nicku\
POST /api/friends/add       {username}      Dodanie znajomego\
POST /api/friends/remove    {username}      Usunięcie znajomego
FriendDTO:
        UUID friend_id,
        boolean is_accepted,
        boolean is_sender

Kody odpowiedzi: 
        SENT_FRIEND_REQUEST,
        ACCEPTED_FRIEND_REQUEST,
        TRIED_TO_ADD_YOURSELF,
        FRIENDSHIP_EXISTS,
        FRIENDSHIP_ALREADY_ACCEPTED,
        ALREADY_SENT_FRIEND_REQUEST,
        FRIEND_REMOVED,
        NO_FRIENDSHIP_TO_REMOVE,

# TODO:
- (Marcin): Zabezpieczenie kafka wiadomości przed awarią systemu