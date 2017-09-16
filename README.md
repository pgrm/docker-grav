# [GRAV](https://getgrav.org/) dockerized

Folders with only version numbers contain the bare CMS, others are named based on the skeleton packages. Each CMS comes with the [admin](https://github.com/getgrav/grav-plugin-admin) and [git-sync](https://github.com/trilbymedia/grav-plugin-git-sync) plugin.

If you, like me, want to easily modify the themes and other assets, without the need of direct access to the server, you can change the default configuration of the git-sync plugin, based on the comments described in [trilbymedia/grav-plugin-git-sync#21](https://github.com/trilbymedia/grav-plugin-git-sync/issues/21). Here is the TL;DR; version:

- After starting the docker container on a server go the the admin plugin page and configure git-sync
- Connect via SSH and change to the directory where you mounted the `/var/www/html` volume to modify 3 files
- Make sure the `user/.gitignore` contains the following lines:

````
/*
!/pages
!/accounts
!/config
!/data
!/plugins
!/themes
````

- Make sure `user/config/plugins/git-sync.yaml` contains the following lines:

````
enabled: true
text_var: 'Custom Text added by the **Git Sync** plugin (disable plugin to remove)'
folders:
  - pages
  - accounts
  - config
  - data
  - plugins
  - themes
... REST STAYS THE SAME ...
````

- Make sure `user/.git/info/sparse-checkout` contains the following lines:

````
pages/
pages/*
accounts/
accounts/*
config/
config/*
data/
data/*
plugins/
plugins/*
themes/
themes/*
````

- Use git on your server or through the container in the `user` sub folder, to commit the new changes
- Congratulations, now you can modify plugins, data, themes and accounts from a different machine, and just sync via git back to your grav CMS instance

### The above modifications converted into a bash script:

````
#Add gitignore
echo '' >> user/.gitignore
echo '!/accounts' >> user/.gitignore
echo '!/config' >> user/.gitignore
echo '!/data' >> user/.gitignore
echo '!/plugins' >> user/.gitignore
echo '!/themes' >> user/.gitignore

#Add config/git-sync file
sed -i '5i \ \ - accounts' user/config/plugins/git-sync.yaml
sed -i '5i \ \ - config' user/config/plugins/git-sync.yaml
sed -i '5i \ \ - data' user/config/plugins/git-sync.yaml
sed -i '5i \ \ - plugins' user/config/plugins/git-sync.yaml
sed -i '5i \ \ - themes' user/config/plugins/git-sync.yaml

#Add to git checkout
echo '' >> user/.git/info/sparse-checkout
echo 'accounts/' >> user/.git/info/sparse-checkout
echo 'accounts/*' >> user/.git/info/sparse-checkout
echo 'config/' >> user/.git/info/sparse-checkout
echo 'config/*' >> user/.git/info/sparse-checkout
echo 'data/' >> user/.git/info/sparse-checkout
echo 'data/*' >> user/.git/info/sparse-checkout
echo 'plugins/' >> user/.git/info/sparse-checkout
echo 'plugins/*' >> user/.git/info/sparse-checkout
echo 'themes/' >> user/.git/info/sparse-checkout
echo 'themes/*' >> user/.git/info/sparse-checkout
````
