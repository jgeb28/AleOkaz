# AleOkaz Backend

Backend aplikacji dla wędkarzy **AleOkaz**.

---

## Użycie

### Development

Uruchomienie środowiska developerskiego:

```sh
docker compose -f compose.yaml -f compose.development.yaml up --detach
./mvnw spring-boot:run
```

### Produkcja

Uruchomienie środowiska produkcyjnego:

```sh
docker compose -f compose.yaml -f compose.production.yaml up --detach
```

---

## Instalacja

### Prerekwizyty

Przed instalacją upewnij się, że masz zainstalowane:  

- Git
- Docker
- Java 21

### Instrukcja instalacji

```sh
git clone https://github.com/jgeb28/AleOkaz
cd AleOkaz/backend
cp .env.example .env
```

## Endpointy

### Reset hasła  **`/api/recoevery`**

Metoda  | Endpoint        | Dane                     | Zwracane | Działanie                 
--------|-----------------|--------------------------|----------|----------------
POST    | /               | {email}                  |          | Wysłanie tokenu          
POST    | /verifyToken    | {email, token}           |          | Zweryfikowanie tokenu    
POST    | /resetPassword  | {email, token, password} |          | Ustawienie nowego hasła  

### Znajomi **`/api/firends`**
Metoda | Endpoint           | Dane       | Zwracane                           | Działanie
-------|--------------------|------------|------------------------------------|--------------
GET    | /all               |            | {firend_id, is_accepted, is_sender}| Wszyscy znajomi zalogowanego
GET    | /allof/{username}  |            | {firend_id, is_accepted, is_sender}| Wszyscy zaakceptowani użytkownika
POST   | /add               | {username} |                                    |Dodanie znajomego  
POST   | /remove            | {username} |                                    |Usunięcie znajomego

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

### Powiadomienia **`/api/sse`**
Metoda  | Endpoint        | Dane                     | Zwracane | Działanie                 
--------|-----------------|--------------------------|----------|----------------
GET     | /notifications  |                          | message  | Otwiera połączenie sse do odbierania powiadomień

#### Wysyłanie powiadomień z backendu:
```java
@Autowired
private KafkaTemplate<String, String> kafkaTemplate;

...
kafkaTemplate.send(uuid_odbiorcy, tresc_powiadomienia);
```

### Użytkownik **`/api/users`**
Metoda  | Endpoint        | Dane                        | Zwracane | Działanie                 
--------|-----------------|-----------------------------|----------|----------------
GET     | /info/{id}      |                             |          | AUTH, Zwraca informacje o użytkowniku
POST    | /               | {username, email, password} |          |  Rejestracja nowego użytkownika\
POST    | /login          | {username, password}        |          |  Logowanie użytkownika\
POST    | /refresh        | {refreshToken}              |          |  Uzyskaj nowy access token
PUT     | /info           | FORM DATA:                  |          |  AUTH, Aktualizuje nazwę lub profilowe użytkownika
                                    userInfo {username},
                                    image

### Posty **`/api/posts`**
Metoda  | Endpoint         | Dane                        | Zwracane | Działanie                 
--------|------------------|-----------------------------|----------|----------------
GET     | ?userId={userId} |                             |          | Zwraca wszystkie posty z możliwością wybrania konkretnego autora opcją ?userId
GET     | /{postId}        |                             |          | Zwraca dany post
POST    | /                | FORM DATA:  AUTH,           |          | Tworzy nowy post
                                    post {content},
                                    image

PUT     | /{postId}           | {content}                |          |        AUTH, Aktualizuje treść posta
DELETE  | /{postId}           |                          |          | AUTH, Usuwa post
PUT     | /{postId}/reactions |                          |          | Dodanie reakcji do posta.
DELETE  | /{postId}/reactions |                          |          | Usunięcie reakcji do posta.

### Komentarze **`/api/comments`**
Metoda  | Endpoint               | Dane                        | Zwracane | Działanie                 
--------|------------------------|-----------------------------|----------|----------------
POST    | /                      | {parentId,content}          |          | Tworzenie komentarza.
PUT     | /{commentId}           | {content}                   |          | Aktualizacja komentarza.
DELETE  | /{commentId}           |                             |          | Usunięcie komentarza.
PUT     | /{commentId}/reactions |                             |          | Dodanie reakcji do komentarza.
DELETE  | /{commentId}/reactions |                             |          | Usunięcie reakcji do komentarza.
