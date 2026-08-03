import '../model/featured_badge.dart';
import '../model/search_item.dart';
import '../model/search_item_image.dart';

class MockItems {
  static const List<SearchItem> all = [
    SearchItem(
      id: 501,
      title: 'Sea View Studio',
      address: "Kolatoli, Cox's Bazar",
      price: 3200,
      offerPrice: 2800,
      reviewsAvg: 4.7,
      reviewsCount: 38,
      images: [
        SearchItemImage(
          id: 9,
          url: 'https://picsum.photos/seed/sea-view-studio/400/300',
        ),
      ],
      featuredBadge: FeaturedBadge(
        id: null,
        name: 'Sponsored',
        slug: 'sponsored',
        icon: null,
      ),
      bedroom: 1,
      beds: 2,
      bathroom: 1,
      maxGuest: 3,
    ),
    SearchItem(
      id: 502,
      title: 'Beachfront Resort & Spa',
      address: "Sugandha Beach, Cox's Bazar",
      price: 9500,
      reviewsAvg: 4.9,
      reviewsCount: 124,
      isHotel: true,
      images: [
        SearchItemImage(
          id: 11,
          url: 'https://picsum.photos/seed/beachfront-resort/400/300',
        ),
      ],
      featuredBadge: FeaturedBadge(
        id: null,
        name: 'Top Rated',
        slug: 'top_rated',
        icon: null,
      ),
      bedroom: 2,
      beds: 3,
      bathroom: 2,
      maxGuest: 5,
    ),
    SearchItem(
      id: 503,
      title: 'Cozy Family Cottage',
      address: "Himchari, Cox's Bazar",
      price: 1800,
      offerPrice: 1500,
      images: [
        SearchItemImage(
          id: 13,
          url: 'https://picsum.photos/seed/cozy-cottage/400/300',
        ),
      ],
      bedroom: 2,
      beds: 2,
      bathroom: 1,
      maxGuest: 4,
    ),
    SearchItem(
      id: 504,
      title: 'Lagoon View Villa',
      address: 'Inani Beach Road',
      price: 6800,
      reviewsAvg: 4.5,
      reviewsCount: 21,
      images: [
        SearchItemImage(
          id: 15,
          url: 'https://picsum.photos/seed/lagoon-villa/400/300',
        ),
      ],
      featuredBadge: FeaturedBadge(
        id: null,
        name: 'Trending',
        slug: 'trending',
        icon: null,
      ),
      bedroom: 3,
      beds: 4,
      bathroom: 2,
      maxGuest: 6,
    ),
    SearchItem(
      id: 505,
      title: 'Sunset Guest House',
      address: 'Laboni Point',
      price: 1400,
      reviewsAvg: 4.2,
      reviewsCount: 57,
      isHotel: true,
      images: [
        SearchItemImage(
          id: 17,
          url: 'https://picsum.photos/seed/sunset-guest/400/300',
        ),
      ],
      bedroom: 1,
      beds: 1,
      bathroom: 1,
      maxGuest: 2,
    ),
    SearchItem(
      id: 506,
      title: 'Ocean Breeze Apartment',
      address: 'Marine Drive Road',
      price: 4200,
      offerPrice: 3900,
      reviewsAvg: 4.6,
      reviewsCount: 45,
      images: [
        SearchItemImage(
          id: 19,
          url: 'https://picsum.photos/seed/ocean-breeze/400/300',
        ),
      ],
      bedroom: 2,
      beds: 2,
      bathroom: 2,
      maxGuest: 4,
    ),
  ];
}
