## Configuration management

You are required to write an Ansible playbook called setup.yml and create the following roles:

- base — basic server setup (installs utilities, updates the server, installs fail2ban, etc.)
- nginx — installs and configures nginx
- app — uploads the given tarball of a static HTML website to the server and unzips it.
- ssh - adds the given public key to the server

Set up the inventory file inventory.ini to include the server you are going to configure. When you run the playbook, it should run the roles above in sequence. You should also assign proper tags to the roles so that you can run only specific roles.

### Run all the roles
```
ansible-playbook setup.yml
```

### Run only the app role
```
ansible-playbook setup.yml --tags "app"
```

### Stretch goal
Modify the app role to pull the repository from GitHub and deploy it.

----

## Solution

Use ansible-galaxy to create roles.

Inside the roles directory:
```
ansible-galaxy init <rolename>
```

Run playbook:
````
ansible-playbook setup.yml -i inventory/hosts.yml --ask-pass --ask-become-pass
````


Run app role "v2" where the website content is downloaded from github:
````
ansible-playbook setup.yml --skip-tags v1 -i inventory/hosts.yml --ask-pass --ask-become-pass
````
