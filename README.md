# Project: __KITKAT__

KitKat is a collaborative DJing platform for iOS that allows partygoers to nominate and vote on songs for a DJ to play. Users interact in real time and the DJ is able to play music in-app. KitKat uses a [custom backend](https://github.com/KewlKits/kk-backend) as well as a combination of both the Spotify SDK and web API to make this possible.

## Joining a Party
Upon launch users are greeted with a map of their current area populated with pins repesenting local parties. A user can tap a pin to view information about the event (host, address, etc.) as well as the current _Queue_. A user may also host a party with the _Create_ button, which will spawn a new party at their current location of which they are the DJ.
<img src='https://i.imgur.com/wVyP9rW.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

## The Pool
When a user enters a party they are sent to the _Pool_, a collection of songs other partygoers have nominated. Here users are able to upvote and downvote songs, as well as add songs of there own through the search flow, who's results are pulled directly from Spotify. If the user is the party's DJ, a plus button appears next to each song and they are able to add songs from the _Pool_ to the _Queue_. The _Pool_ is live updated so any change a user makes is immediately reflected on all other user's apps.
<img src='https://i.imgur.com/qcMZWsH.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

## The Queue
The _Queue_ tab shows a list of all songs that will be played. If the user is the party's DJ, an edit button is visible and the user can move and delete songs. The _Queue_ is also mirrored in the DJ's Spotify account as a playlist bearing the same name as the party so the DJ can review the songs played after the party has finished. Like the _Pool_, the _Queue_ is live updated.
<img src='https://i.imgur.com/ifQJ4e3.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

## Now Playing
The now playing tab shows information about the currently playing track, as well as allows the DJ to pause, go back, and skip through the _Queue_.
<img src='https://i.imgur.com/b9pG8X2.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

## User
The user tab shows all songs a user has added throughout the party as well as counts how many remain in the pool and how many have been selected to move into the queue. These heuristics, along with the number of upvotes each song accrued, are combined to generate a score for the user.
<img src='https://i.imgur.com/skugyMb.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
