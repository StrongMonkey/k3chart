## K3charts

This is an experimental project to automate system charts and overlays that added on top of them.

Each chart lives under its own folder `package/${chart-name}/charts`. Overlay files live under `package/${chart-name}/overlay`.

For each chart there should be a `package.yaml` defined under its repo, containing metadata like upstream chart url, image mirroring information.

Here is an example of `package.yaml`:

```yaml
url: https://github.com/istio/istio/releases/download/1.5.1/istio-1.5.1-linux.tar.gz
subdirectory: istio-1.5.1/install/kubernetes/operator/operator-chart
```


Any modifications or patches should be made into `package/${chart-name}/charts`. Once patches have been made. Run 

    `make patch` 
    
to generate the correct patch files.

Any overlay files can be added into `package/${chart-name}/overlays`. This can include `questions.yaml` and other files you want to add on top of upstream chart.

To rebase patch based on the latest upstream chart, modified the package.yaml and points to the latest url. Then run

    `make rebase`
    
To generete index.yaml and charts tarball, run

    `make charts`
    
CI will automatically upload patch files and tarball of charts. Commit will only need to update `package/${chart-name}/charts` and make sure patches are 
up-to-date with the latest chart.