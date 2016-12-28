# ZNC

this repo contains terraform scripts to setup a ZNC bouncer on Scaleway, with a configurable DNS routed via R53 as well as
data synchronization & backups via AWS S3.

## architecture overview

The setup will utilize containers, mostly for portability. We'll be using a AWS Route 53 domain to route requests to an Scaleway instance,
as well as AWS S3 to persistence configuration and logs of the ZNC.
