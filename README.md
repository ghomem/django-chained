This repository generates a Hello World Django application automating some annoying, and otherwise manual, steps explained in the Django documentation. It can serve as a way to speed up Django onboardings. It is called Django chained because the manual creation of a Django application has too many degress of freedom.

Steps to execute:

* clone the repository
* edit the configuration present at conf/vars.env
* execute `sudo ./django-chained.sh`
* review the output and iterate
* package the applications with `sudo ./package.sh`
* bring the content to a new git repository, etc..

Generated application features:

* project name and app name you chose
* Hello World text protected by authentication
* decent looks if PRETTIFY=yes (uses pico.css), ugly looks otherwise
* acceptable logout behaviour differentiating between the normal app and /admin

The generated application can be used as a starting point for a real application.

The process has been tested on Ubuntu 24.04 with packages from the Ubuntu repositories.

References:

* https://docs.djangoproject.com/en/4.2/
* https://learndjango.com/tutorials/django-login-and-logout-tutorial
