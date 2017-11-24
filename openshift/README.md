# Deploying worker scaler

First make sure you're logged in to the right cluster and on the right project:

```bash
$ oc project
```

Note this guide assumes that secrets and config maps have already been deployed.

To deploy worker scaler simply run

```bash
./deploy.sh
```
