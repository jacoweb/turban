COMPOSE_FILE_PATH := -f docker-compose.yml

target:
	@sh ./bin/help -d

build:
	$(info Building Turban environment images.)
	docker-compose build --no-cache
	@make -s clean
 
start:
	$(info Starting Turban environment containers.)
	docker-compose $(COMPOSE_FILE_PATH) up -d
 
stop:
	$(info Stopping Turban environment containers.)
	@docker-compose stop
 
restart:
	$(info Restarting Turban environment containers.)
	@make -s stop
	@make -s start

restart-php:
	$(info Restarting php Turban environment containers.)
	docker-compose restart php

restart-mysql:
	$(info Restarting db Turban environment containers.)
	docker-compose restart db

restart-nginx:
	$(info Restarting nginx Turban environment containers.)
	@docker-compose restart webserver

shell:
	docker exec -t -i Turban-php /bin/bash

wordpress:
	$(info Downloading and installing latest Wordpress.)
	cd ./public && rm -rf *
	curl -O https://wordpress.org/latest.zip
	unzip latest.zip
	mv wordpress/* ./public;
	rm -rf latest.zip wordpress

gravcms:
	$(info Downloading and installing latest Grav CMS.)
	cd ./public && rm -rf *
	wget -O grav.zip https://getgrav.org/download/core/grav-admin/1.6.17
	unzip grav.zip
	mv grav-admin/* ./public;
	rm -rf grav.zip grav-admin

reset:
	$(info Reset public folder to default.)
	cd ./public && rm -rf *
	cp ./docker/php/init.php ./public/index.php

clean:
	$(info DONE! )

login:
	$(info Make: Login to Docker Hub.)
	@docker login -u $(DOCKER_USER) -p $(DOCKER_PASS)