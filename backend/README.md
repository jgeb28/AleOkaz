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

### Powiadomienia
GET /api/sse/notifications              Otwiera połączenie sse do odbierania powiadomień
#### Wysyłanie powiadomień z backendu:
@Autowired\
private KafkaTemplate<String, String> kafkaTemplate;\
\
kafkaTemplate.send(uuid_odbiorcy, tresc_powiadomienia);

### Użytkownik
GET     /api/users/info/{id}                                   AUTH, Zwraca informacje o użytkowniku
POST    /api/users             {username, email, password}     Rejestracja nowego użytkownika\
POST    /api/users/login       {username, password}            Logowanie użytkownika\
POST    /api/users/refresh     {refreshToken}                  Uzyskaj nowy access token
PUT     /api/users/info/     FORM DATA:                      AUTH, Aktualizuje nazwę lub profilowe użytkownika
                                    userInfo {username},
                                    image

### Posty
GET     /api/posts?userId={userId}                             Zwraca wszystkie posty z możliwością wybrania konkretnego autora opcją ?userId
GET     /api/posts/{postId}                                    Zwraca dany post
POST    /api/posts             FORM DATA:                      AUTH, Tworzy nowy post
                                    post {content, fishingSpotId},
                                    image
PUT     /api/posts/{postId}    {content}                       AUTH, Aktualizuje treść posta
DELETE  /api/posts/{postId}                                    AUTH, Usuwa post
PUT     /api/posts/{postId}/reactions                          Dodanie reakcji do posta.
DELETE  /api/posts/{postId}/reactions                          Usunięcie reakcji do posta.

### Komentarze
POST    /api/comments                   {parentId,content}     Tworzenie komentarza.
PUT     /api/comments/{commentId}       {content}              Aktualizacja komentarza.
DELETE  /api/comments/{commentId}                              Usunięcie komentarza.
PUT     /api/comments/{commentId}/reactions                    Dodanie reakcji do komentarza.
DELETE  /api/comments/{commentId}/reactions                    Usunięcie reakcji do komentarza.

### Łowiska
GET     /api/fishingspots/all                                  Zwraca wszystkie łowiska
GET     /api/fishingspots/allsorted     {latitude, longitude}  Zwraca wszystkie łowiska posortowane wg podanej pozycji, najbliższe = pierwsze na liście
GET     /api/fishingspots/{spotId}                             Zwraca łowisko o podanym ID
GET     /api/fishingspots/closest       {latitude, longitude}  Zwraca najbliższe łowisko
GET     /api/fishingspots/postedIn                             AUTH, zwraca wszystkie łowiska, gdzie zalogowany użytkownik ma posta
POST    /api/fishingspots               {name, description,    AUTH, tworzy łowisko. description = optional
                                        latitude, longitude}
PUT     /api/fishingspots/{spotId}      {name, description,    AUTH, edytuje łowisko. Wszystkie pozycje są opcjonalne, latitude i longitude muszą być oba podane, żeby zmienić pozycję łowiska
                                        latitude, longitude}
