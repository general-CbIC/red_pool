# Implementation roadmap

## First iteration (MVP)

- [ ] Describe main library worker
- [ ] Launch a pool for each given redis worker
  - [ ] Configure registry for pool names
  - [ ] Add posibility to configure pool's size
  - [ ] Set up redis connections
  - [ ] Identify RW/RO nodes
- [ ] Proxy commands to cluster
  - [ ] Research: Is it better to send read commands only to RO nodes?
  - [ ] ...

## Enhancements

- [ ] Dynamically get info about nodes on initialization
- [ ] ...
