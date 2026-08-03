# Travela — Flutter Take-Home Task

**Role:** Mid-Level Flutter Developer
**Submit:** Public Git repo link + a short screen recording (30–60s) of it running.

---

## The task

Build a **property search screen** for the Travela app.

The user picks a location, sets a couple of filters, and hits search. From there, results stream in one card at a time over Server-Sent Events (SSE). Each card shows up the moment it's ready instead of everything landing at once. That streaming behaviour is the main thing we're evaluating. A search that only paints after the whole response arrives doesn't meet the bar.

Two live endpoints are described below. Your job is the Flutter side that talks to them: the screen, the networking, and the state handling.

---

## What to build (functional requirements)

1. **Location search field** with autocomplete.
   - As the user types, call the locations endpoint and show suggestions in a dropdown/list.
   - Debounce input (don't fire a request per keystroke).
   - Selecting a suggestion fills the field and captures its `id` / `lat` / `lng`.

2. **A small filter row.** Just enough to show you can pass params through. Include at least:
   - Check-in / check-out dates (`from` / `to`).
   - Guests (`guest`).
   - Price range (`price`, formatted `min-max`).

3. **Streaming results list.**
   - On "Search", open the SSE stream and render each `item` event as a card **the moment it arrives**.
   - Show the total count from the `meta` event (e.g. "42 stays") before/while cards fill in.
   - A card shows at minimum: first image, `title`, `address`, `price`, and review score (`reviews_avg`) when present.

4. **All the states.** Loading (stream open, still receiving), empty (`done` with zero items), error (`error` event or network failure with a retry affordance), and a clear "finished" state when `done` arrives.

5. **Clean state management.** Use whatever you're strongest in (Bloc, Riverpod, Provider, `ChangeNotifier`…). We care that state is predictable and the stream is cancelled/closed correctly when the user searches again or leaves the screen.

You don't need a details screen, auth, or offline persistence. Put your effort into getting this one screen right.

---

## The APIs

Base URL: `https://search.travela.xyz`
All endpoints are under `/api`. No auth required for these two.

### 1. Location autocomplete

```
GET https://search.travela.xyz/api/popular-locations?q=cox
```

Returns popular locations, optionally filtered by the `q` substring.

```json
{
  "data": [
    {
      "id": 42,
      "name": "Cox's Bazar",
      "name_bn": "কক্সবাজার",
      "order": 1,
      "lat": 21.4272,
      "lng": 92.0058,
      "within": 15.0,
      "tier_1": 5.0,
      "tier_2": 10.0
    }
  ]
}
```

Use the selected location's `id` as `location_id`, **or** its `lat,lng` as `location` in the search call below.

### 2. Search — SSE stream

```
GET https://search.travela.xyz/api/search/stream?location_id=1&location=90.3588734%2C+23.7661639&address_name=mohammadpur&within=10&tier_1=1.066&tier_2=2.892&from=2026-09-26&to=2026-09-28&guest=2&rooms=1&page=1&per_page=20
```

(`location`, `address_name`, `within`, `tier_1`, `tier_2` all come from the location object you got back in endpoint #1. `location` is just its `lat,lng`, URL-encoded.)

Response type is `text/event-stream`. Read it as a stream and parse the SSE frames. In order, you'll get:

- **one** `meta` event,
- **many** `item` events (one per result card),
- **one** `done` event,
- or an `error` event if something fails.

Wire format (each frame is `event: <name>` + `data: <json>` separated by a blank line):

```
event: meta
data: {"total_count": 42, "pagination": {"page": 1, "limit": 20, "total_count": 42, "next": 2, "total_page": 3}, "filter_meta": {...}}

event: item
data: {"id": 501, "title": "Sea View Studio", "address": "Kolatoli, Cox's Bazar", "price": 3200, "offer_price": 2800, "reviews_avg": 4.7, "reviews_count": 38, "is_hotel": false, "images": [{"id": 9, "url": "https://.../a.jpg"}], "featured_badge": {"id": null, "name": "Sponsored", "slug": "sponsored", "icon": null}, "bedroom": 1, "beds": 2, "bathroom": 1, "max_guest": 3}

event: item
data: { ...next card... }

event: done
data: {}
```

**Item fields you can rely on:** `id`, `title`, `address`, `price`, `offer_price` (nullable), `reviews_avg` (nullable), `reviews_count`, `images` (list of `{id, url}`, may be empty), `is_hotel`, `featured_badge` (nullable object), `bedroom`, `beds`, `bathroom`, `max_guest`. Treat anything else as optional.

**Query params.** You need a location (either `location_id` **or** `location`); everything else is optional. In practice you pass the whole location object through — `location`, `address_name`, `within`, `tier_1`, `tier_2` all come from the object returned by endpoint #1.

_Location:_

| Param | Meaning | Example |
|---|---|---|
| `location_id` | location id from endpoint #1 | `1` |
| `location` | location's `lat,lng`, URL-encoded (alternative to `location_id`) | `90.3588734, 23.7661639` |
| `address_name` | selected location's name | `mohammadpur` |
| `within` | search radius in km | `10` |
| `tier_1` / `tier_2` | ranking distance boundaries (km) | `1.066` / `2.892` |

_Dates & occupancy:_

| Param | Meaning | Example |
|---|---|---|
| `from` / `to` | check-in / check-out, `YYYY-MM-DD` | `2026-09-26` / `2026-09-28` |
| `guest`, `child`, `infant` | occupancy | `2` |
| `rooms` | number of rooms (default 1) | `1` |

_Filters (all optional — bonus territory):_

| Param | Meaning | Example |
|---|---|---|
| `price` | `min-max` | `1000-5000` |
| `q` | free-text query | `sea view` |
| `bedroom`, `beds`, `bathroom` | minimum counts | `2` |
| `min_rating` | minimum review score, `0`–`5` | `4.5` |
| `instant_booking` | instant-book only | `true` |
| `hotel` | hotels only | `true` |
| `property_type_ids` | JSON array of property-type ids | `[1,5]` |
| `place_types` | comma-separated place types | `Entire Place,Private Room` |
| `filters` | JSON array of filter ids (see `filter_meta` in the `meta` event) | `["fac_1","instant_booking"]` |
| `ranks` | comma-separated rank ids | `1,3` |

_Pagination:_

| Param | Meaning | Example |
|---|---|---|
| `page` | page number (1-based) | `1` |
| `per_page` | items per page, ≤ 50 (default 20) | `20` |

> The valid values for `price`, `filters`, `place_types`, `property_type_ids`, etc. arrive in the `meta` event's `filter_meta` — so a full app would build its filter UI from that. You only need the basic filters from the requirements; the rest is optional.

Quick check from your terminal (`-N` disables buffering so you actually see it stream):

```bash
curl -N "https://search.travela.xyz/api/search/stream?location_id=42&guest=2&per_page=20"
```

> Tip: the `http` package's `Client().send(Request(...))` gives you a streamed body you can read line by line. Don't buffer the whole response first, or you've lost the point of streaming.

---

## What we evaluate

- **Progressive rendering actually works** — cards appear incrementally, not in one dump.
- **State handling** — loading / empty / error / done are all real, and a second search cleanly cancels the first stream (no leaks, no mixed results).
- **Networking correctness** — SSE parsed properly, params encoded correctly, debounced autocomplete.
- **Code quality** — readable widget tree, sensible separation (UI vs. state vs. data), predictable state management. We read your code more than we count features.
- **UX polish** — reasonable layout, images with placeholders/fallbacks, no jank while streaming.

## Nice to have (only if time permits)

- Cancel/close the stream on back-navigation and on a new search.
- Image caching (`cached_network_image`).
- Pull-to-refresh or a "load more" using `pagination.next`.
- A couple of widget tests, or a documented approach to testing the stream parser.

## Deliverables

1. Git repo (Flutter project) with a short **README**: how to run, which state management you chose and why, and anything you'd improve with more time.
2. A 30–60s screen recording of the search working end to end.
3. Note any assumptions or shortcuts in the README — we'd rather see honest trade-offs than hidden ones.

> **Write the README yourself, in your own words — not with an AI.** It's short on purpose: a few honest sentences about your choices tell us more than a polished essay. AI-generated READMEs are easy to spot, and in the interview we'll ask you to walk through exactly what you wrote and why. Using AI to help *write code* is fine; the README has to be your own understanding.

Good luck — build the one screen you'd be proud to ship.
