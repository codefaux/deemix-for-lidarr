# Lidarr/Deemix Integration Setup Guide

DEPRECATED AND NO LONGER REQUIRED, SEE ISSUE [#12](https://github.com/codefaux/deemix-for-lidarr/issues/12)

Kept for archival purposes only. I'll probably remove the containers or something at some point to cue people into the new options.

## Introduction
This guide provides instructions for setting up Deemix integration with Lidarr, allowing for seamless downloading of music from Deezer. This setup is based on the work of several projects, including Deemix GUI by RemixDev, Lidarr.Plugin.Deemix by ta264, and the hotio/lidarr Docker image with plugin support, as well as Docker-on-steroids.

### Relevant Projects
- [Deemix GUI by RemixDev](https://gitlab.com/RemixDev/deemix-gui)
- [Lidarr.Plugin.Deemix by ta264](https://github.com/ta264/Lidarr.Plugin.Deemix)
- [hotio/lidarr Docker image with plugin support](https://ghcr.io/hotio/lidarr:pr-plugins)
- Extracted from [Docker-on-steroids](https://github.com/youegraillot/lidarr-on-steroids/)

## Links of Note
- Issue #92 ([Origin, initial discussion](youegraillot#92))
- Issue #63 ([Patch during docker build](youegraillot#63))

## NOTES:
- This expects a Lidarr branch that supports Plugins. I'm using Docker; ghcr.io/hotio/lidarr:pr-plugins.
- My work here is solely rewriting [Dockerfile](https://github.com/youegraillot/lidarr-on-steroids/blob/main/Dockerfile) and documenting things. The Dockerfile downloads and builds [Deemix GUI](https://gitlab.com/RemixDev/deemix-gui) with a patch as suggested in youegraillot#63.

## Docker-compose 
- Example provided; https://github.com/codefaux/deemix-for-lidarr/blob/main/docker-compose.yaml
- Adjust PID/GID as necessary.
- You must provide `/deemix-gui/config` via Docker mountpoint or volume.

## Quick Setup Info

### In Deemix
To configure Deemix for integration with Lidarr, follow these steps:

1. Go to Settings in Deemix.
2. Enable "Create Folder Structure for" on Artists, Albums, and Singles.
3. Set the download folder where albums will be stored for import. Typically, `/downloads` is used. Ensure Lidarr uses the same volume/path. 
4. Log into Deezer.

### In Lidarr
To set up Deemix integration in Lidarr, follow these steps:

1. Install the Deemix plugin via URL: [Lidarr.Plugin.Deemix](https://github.com/ta264/Lidarr.Plugin.Deemix).
2. Configure a Deemix download client under Settings / Download Clients.
3. Use Docker's container name resolution feature for intra-container connections. Regardless of methodology, Docker will resolve a container name to its most accessible IP when referenced from inside a Docker environment. IE, name your containers `deemix` and `lidarr` and use `deemix:6595` instead of `<ip>:6595` when configuring both Download Client -and- Indexer. (Also useful for other containers, such as those requiring external database containers, regardless of whether or not they're in a docker-compose.yaml service group together.)
4. Add and configure a Deemix indexer under Settings / Indexers. Disable RSS feeds.
5. In Settings / Profiles, enable the Deemix protocol for Default or custom profiles under Delay Profiles.

## Important Notes
- This setup guide may require adjustments based on individual preferences or system configurations.
- Despite appearances, I don't claim to fully know what I'm doing.
- I don't anticipate changes unless issues are raised, but I don't intend to abandon it.
- Contributors to this guide welcome feedback, suggestions, or contributions via issues or pull requests.
- The project does not undertake fixing issues in upstream projects beyond its scope.
- For any missing information, attribution, or other, please let the maintainers know.
