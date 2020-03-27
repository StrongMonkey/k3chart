## K3charts

This is an example repo to store all upstream charts and corresponding patches.

Each chart lives under its own folder `package/${chart-name}/charts-modified`.

For each chart there is a `package.yaml` defined under its repo, containing metadata like upstream chart url, image mirroring information.

Any modifications or patches should be made into `package/${chart-name}/charts-modified`. Once patches have been made. Run 

    `make generate-patch` 
    
to generate the correct patch files.

To rebase patch based on the latest upstream chart, modified the package.yaml and points to the latest url. Then run

    `make rebase`
    
To generete index.yaml and charts tarball, run

    `make generate-charts`
    
CI will automatically upload patch files and tarball of charts. Commit will only need to update `charts-modified` and make sure patches are 
up-to-date with the latest chart.