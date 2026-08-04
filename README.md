# Travela — Property Search

A Flutter take-home project that implements a property search screen with real-time SSE (Server-Sent Events) streaming.

---

## How to run

**Requirements:** Flutter 3.44+ stable, Dart 3.12+

```bash
# Install dependencies
flutter pub get

# Generate files (only if needed)
dart run build_runner build

# Run the app
flutter run
```

The project uses the live API:

`https://search.travela.xyz`

No API key or `.env` file is required.

---

## Project Structure

I followed a simple Clean Architecture approach.

```
View
 ↓
ViewModel
 ↓
Repository
 ↓
API
```

- **core/** – common utilities, network setup, theme
- **feature/** – models, repository, view model, and UI
- **widgets/** – reusable widgets

---

## State Management

I used **Riverpod** because it's simple, easy to manage, and keeps the UI separate from the business logic.

The search state is handled in one place, making it easy to manage loading, errors, and results.

When a new search starts or the screen is closed, the previous stream is cancelled to avoid duplicate data and memory leaks.

---

## SSE Streaming

The search API returns data using Server-Sent Events (SSE).

Instead of waiting for the whole response, the app listens to the stream and updates the UI as events arrive.

- `meta` → shows the total number of stays
- `item` → adds each property card immediately
- `done` → marks the search as finished
- `error` → shows an error message with a retry button

This allows the results to appear one by one instead of waiting for the entire response.

---

## Features

- Location autocomplete with debounce
- Date range picker
- Guest selection
- Price range filter
- Real-time streaming search results
- Loading, empty, error, and completed states
- Retry button
- Cached property images
- Pull-to-refresh
- Pagination support

---

## Packages Used

- flutter_riverpod
- dio
- retrofit
- json_serializable
- cached_network_image
- go_router
- flutter_screenutil
- skeletonizer
- custom_refresh_indicator

---

## What I'd Improve

If I had more time, I would add:

- More widget tests
- Dynamic filters from `filter_meta`
- Better offline support
- Better error handling

---