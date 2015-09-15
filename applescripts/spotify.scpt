if application "Spotify" is running then
  tell application "Spotify"
    set theName to name of current track
    set theArtist to artist of current track
    set theAlbum to album of current track
    set theUrl to spotify url of current track
    try
      return "♫  " & theName & " - " & theArtist
    on error err
    end try
  end tell
end if
