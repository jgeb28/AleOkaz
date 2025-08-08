# AleOkaz Backend

Backend aplikacji dla wędkarzy AleOkaz.

## Użycie

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

### Development

```sh
docker compose -f compose.yaml -f compose.development.yaml up --detach
./mvnw spring-boot:run
```

### Produkcja

```sh
docker compose -f compose.yaml -f compose.production.yaml up --detach
```

## Endpointy

### Reset hasła

| Metoda | Endpoint                | Body / Parametry                | Opis                        |
|--------|-------------------------|---------------------------------|-----------------------------|
| POST   | /api/recovery           | {email}                         | Wysłanie tokenu             |
| POST   | /api/recovery/reset     | {email, token, password}        | Ustawienie nowego hasła     |

### Znajomi

| Metoda  | Endpoint                                 | Opis                                 |
|---------|------------------------------------------|--------------------------------------|
| GET     | /api/friends/my                          | Lista wszystkich znajomych           |
| GET     | /api/friends/username/{username}         | Lista znajomych użytkownika o nicku  |
| POST    | /api/friends/requests/send/{username}    | Wysłanie zaproszenia                 |
| DELETE  | /api/friends/requests/cancel/{username}  | Usunięcie zaproszenia                |
| POST    | /api/friends/requests/accept/{username}  | Akceptacja zaproszenia               |
| POST    | /api/friends/requests/decline/{username} | Odrzucenie zaproszenia               |
| GET     | /api/friends/requests/received           | Otrzymane zaproszenia                |
| GET     | /api/friends/requests/sent               | Wysłane zaproszenia                  |
| DELETE  | /api/friends/{username}                  | Usunięcie znajomego                  |

### Powiadomienia

| Metoda | Endpoint                  | Opis                                             |
|--------|---------------------------|--------------------------------------------------|
| GET    | /api/sse/notifications    | Otwiera połączenie SSE do odbierania powiadomień |

### Użytkownik

| Metoda | Endpoint                  | Body / Parametry                  | Opis                                      |
|--------|---------------------------|-----------------------------------|-------------------------------------------|
| GET    | /api/users/info/{id}      |                                   | AUTH, info o użytkowniku                  |
| GET    | /api/users/info           |                                   | AUTH, info o zalogowanym użytkowniku      |
| POST   | /api/users/register       | {username, password}              | Rejestracja nowego użytkownika            |
| POST   | /api/users/login          | {username, password}              | Logowanie użytkownika                     |
| POST   | /api/users/refresh        | {refreshToken}                    | Uzyskaj nowy access token                 |
| PUT    | /api/users/info           | FORM DATA: userInfo, image        | AUTH, aktualizuje nazwę/profilowe         |

### Posty

| Metoda | Endpoint                                | Body / Parametry                       | Opis                                      |
|--------|-----------------------------------------|----------------------------------------|-------------------------------------------|
| GET    | /api/posts/all?userId={userId}          |                                        | Wszystkie posty (opcjonalnie autora)      |
| GET    | /api/posts/id/{postId}                  |                                        | Dany post                                 |
| POST   | /api/posts                              | FORM DATA: post, image                 | AUTH, tworzy nowy post                    |
| PUT    | /api/posts/{postId}                     | {content}                              | AUTH, aktualizuje treść posta             |
| DELETE | /api/posts/{postId}                     |                                        | AUTH, usuwa post                          |
| GET    | /api/posts/fishing-spot/{fishingSpotId} |                                        | Posty z danego łowiska                    |

### Reakcje

| Metoda | Endpoint                        | Body / Parametry | Opis                        |
|--------|---------------------------------|------------------|-----------------------------|
| PUT    | /api/reactions/{interactionId}  |                  | Dodanie reakcji do posta    |
| DELETE | /api/reactions/{interactionId}  |                  | Usunięcie reakcji do posta  |

### Komentarze

| Metoda | Endpoint                      | Body / Parametry | Opis                        |
|--------|-------------------------------|------------------|-----------------------------|
| POST   | /api/comments/{parentId}      | {content}        | Tworzenie komentarza        |
| PUT    | /api/comments/{commentId}     | {content}        | Aktualizacja komentarza     |
| DELETE | /api/comments/{commentId}     |                  | Usunięcie komentarza        |

### Łowiska

| Metoda | Endpoint                          | Body / Parametry                        | Opis                                         |
|--------|-----------------------------------|-----------------------------------------|----------------------------------------------|
| GET    | /api/fishingspots/all             |                                         | Wszystkie łowiska                            |
| GET    | /api/fishingspots/sorted          | {latitude, longitude}                   | Wszystkie łowiska posortowane wg pozycji     |
| GET    | /api/fishingspots/closest         | {latitude, longitude}                   | Najbliższe łowisko                           |
| GET    | /api/fishingspots/postedIn        |                                         | AUTH, łowiska gdzie użytkownik ma posta      |
| GET    | /api/fishingspots/id/{id}         |                                         | Łowisko o podanym ID                         |
| POST   | /api/fishingspots                 | {name, description, latitude, longitude}| AUTH, tworzy łowisko                         |
| PUT    | /api/fishingspots/{id}            | {name, description, latitude, longitude}| AUTH, edytuje łowisko
