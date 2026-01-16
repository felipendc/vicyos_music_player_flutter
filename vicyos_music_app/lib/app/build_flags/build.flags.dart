// Flags for enabling and disabling features from the app

/// The app version has Online Radio?
final bool vicyosMusicAppHasRadio = true;

/// Navigation buttons (song routes) behaves the same as MIUI app music?
/// If it's set as false, the bar under (All songs, Favorites, Playlists)
/// Will show route where the current playing queue song came from
/// And it will be updated for every song in the playing queue
final bool navigationButtonsHasMiuiBehavior = false;

/// What to do when the user removes a song from the favorite screen
final bool removeSongFromFavoritesAndPlayingQueueToo = false;

/// What to do when the user removes a song from the playlist screen
final bool removeSongFromPlaylistAndPlayingQueueToo = false;
