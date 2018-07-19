# Project: __KITKAT__

## Problem statement
There is no convenient way for event attendees to suggest music to the DJ.

## Epics
- User can join a session specific to their party
- User can add songs to a pool
- DJ can select songs from the pool and move them into a queue
- Users can express their opinions on songs in the pool
- The queue can be played

## Timeline
### Week 1
- __Grab users' spotify api key__
- Join/host flow (placeholder)
- __Backend model/endpoints (except voting)__
- Users can search Spotify songs
### Week 2
- Users can add searched songs to pool
- DJ can move songs from pool to queue
- Join/host flow (real, location based)
  - DJ can pick name
  - Store the name
  - Parties have a location property
  - Users can join a specific party based on their location and the party name
### Week 3
- DJ can manipulate queue
  - DJ can add songs to the queue
  - DJ can edit the order of the queue.
- Voting/sorting
  - Sort by age and popularity
  - Upvoting and downvoting like reddit
- Push queue to Spotify playlist
   - When the song playing finishes we push the first song in the queue to spotify
- A e s t h e t i c
