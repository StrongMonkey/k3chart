## K3charts

This is an experimental project to automate system charts and overlays that added on top of them.

Charts will have two categories: Charts that Rancher created(We call `Rancher original` in here) and Charts that Rancher modified from upstream(We call `Rancher modified`). 

`Rancher original` means the chart is created and maintained from internal Rancher Team, such as `rancher-cis-benchmark`, `rancher-k3s-upgrader`. 

`Rancher modified` means that the chart is modified from upstream chart, while there are 
some modifications made to the upstream chart from rancher side.

For `Rancher original` charts, it should have the following tree structure

```text
packages/${CHART_NAME}/
  charts/                   # regular helm chart directory
    templates/
    Chart.yaml
    values.yaml
  sha256sum.txt             # sha256 checksum of all files in helm directory
```

For `Rancher modified` charts, it should have the following tree structure

```text
package/${CHART_NAME}/
  package.yaml              # metadata manifest containing upstream chart location, package version
  ${CHART_NAME}.patch       # patch file containing the diff between modified chart and upstream
  overlay/*                 # overlay files that needs to added on top of upstream, for example, questions.yaml
  sha256sum.txt             # sha256 checksum for all files included in the modified helm chart
```

A regular `package.yaml` will have the following content:

```yaml
url: https://charts.bitnami.com/bitnami/external-dns-2.20.10.tgz # url to fetch upstream chart
packageVersion: 00 # packageVersion of modified charts, producing a $version-$packageVersion chart. For example, if istio 1.4.7 is modified with changes, rancher produces a 1.4.7-00 chart version that includes the modification rancher made on top of upstream charts.
```

Here is an example of upstream chart based on git repository

```yaml
url: https://github.com/open-policy-agent/gatekeeper.git  # Url to fetch upstream chart from git
subdirectory: chart/gatekeeper-operator # Sub directory for helm charts in git repo
type: git # optinal, indicate that upstream chart is from git
commit: v3.1.0-beta.8 # the revision of git repo
packageVersion: 00 # package version
``` 

### Workflow

Modifying `Rancher original` charts is the same workflow as modifying helm charts. First make the changes inside `charts/` and commit changes. CI will automatically uploads artifacts if file contents have been changed.

Modifying `Rancher modified` takes extra steps, as it requires modifications to be saved into patch files so that later it can retrieve the chart based on upstream chart and patch files.

The step includes:

1. Run `make CHART={CHART_NAME} prepare`. This prepares `charts` with the current upstream chart and current patch. 
2. Change the version in `package.yaml`. If upstream chart needs to be updated, update url to point the latest chart. `packageVersion` also needs to updated.
3. Make modification to your charts. 
4. Run `make CHART={CHART_NAME} patch`. This will compare your current chart with upstream chart and generate the correct patch. 
5. Run `make CHART={CHART_NAME} clean`. This will clean up the `charts` directory so that it won't committed.

This repo provides a [workflow](./.github/workflows) that automatically uploads patch files and tarball of charts. Commit will only need to update `package/${chart-name}/charts` and make sure patches are 
up-to-date with the latest chart. It also automatically build github pages to serve `index.yaml` and artifacts of charts.

To add this repo as a helm repo, run

```text
helm repo add https://strongmonkey.github.com/k3chart
```

### Makefile

`make bootstrap`: Download binaries that are needed for ci scripts.

`make prepare`: Prepare the chart for modification. This will apply the upstream chart with the current patch. Use `CHART=${NAME}` for specific chart.

`make charts`: Generate tarball for each charts. Use `CHART=${NAME}` for specific chart.

`make patch`: Compare the current chart with upstream and generate patch file. Use `CHART=${NAME}` for specific chart. 

`make validate`: Validate if patch file can be applied.

`make mirror`: Run image mirroring scripts.(Experimental)
