# API Docs

## V1

- The API is available at `https://api.exercism.io/api/v1`
- The API uses the Bearer Authentication header to identify a user

### Ping

**Endpoint:** `/ping`

Check the API is up. Should return `200`.

### Get Latest Solution

**Endpoint:** `/solutions/latest`

#### Params

| param | optional | info | example|
| -- | -- | -- | -- |
| exercise_id | no | Specifies the exercise to return | "hello-world" |
| track_id | yes | Specifies the track that the exercise is on. | "ruby" |

#### Possible errors

| status | code | extra | 
| -- | -- | -- |
| 404 | track_not_found | `fallback_url` for all tracks |
| 404 | exercise_not_found | `fallback_url` for the track |
| 404 | solution_not_found | |


