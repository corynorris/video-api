# Todo

## Server

- Add types for error level and status [DONE]
- Add pagination [DONE]
- Let a user create & change an api key, require api key for external access [DONE]
- Add sites [DONE]
- Capture better errors from porcelain (maybe save a file) [DONE]
- Allow auth_token management from sites view [DONE]
- Allow videos to be published against sites (if transcoded)
- Setup HEROKU and deploy to dokku [DONE]
- JSON API should require auth_token not login [DONE]
- JSON API should show only published videos [DONE]
- JSON API should have url for individual videos [DONE]
- Fix publication since JSON endpoint was changed [DONE]
- Create endpoint to play videos after transcoding [DONE]

## UI

- Colour code errors [DONE]
- Pull in relevent metrics for Dashboard [DONE]
- Update `documentation` to be actually useful [DONE]

## Backlog

- Test with real video
- Allow tracking of view count
- Allow tracking of video progress
- Allow generation of thumbnails
- Show cards instead of ugly list in video index view
- Include logs in show video view
- Create a branch that can be used for prod that disallows sign-up
- Create a branch that can be used for demos with very small upload size (or disallowed uploads)
- Load published videos into memory and give them an identifier so file system isn't accessed directly via guid (vidoes that aren't yet published are vulnerable to brute force)
